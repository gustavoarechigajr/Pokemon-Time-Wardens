#===============================================================================
# Pokemon properties.
#===============================================================================
class Pokemon
  attr_accessor :hp_level, :immunities
  
  #-----------------------------------------------------------------------------
  # HP utilities.
  #-----------------------------------------------------------------------------
  def real_hp;      return (@hp / hp_boost).floor;      end
  def real_totalhp; return (@totalhp / hp_boost).floor; end
  
  #-----------------------------------------------------------------------------
  # Immunities.
  #-----------------------------------------------------------------------------
  def immunities
    return @immunities || []
  end
  
  #-----------------------------------------------------------------------------
  # Used for calculating boosted HP.
  #-----------------------------------------------------------------------------
  def hp_level 
    return @hp_level || 0
  end
  
  def hp_boost
    return [1, self.hp_level].max
  end
  
  def calcHP(base, level, iv, ev)
    return 1 if base == 1
    return ((((base * 2 + iv + (ev / 4)) * level / 100).floor + level + 10) * hp_boost).ceil
  end
end

#===============================================================================
# Battler properties.
#===============================================================================
class Battle::Battler
  #-----------------------------------------------------------------------------
  # HP utilities.
  #-----------------------------------------------------------------------------
  def real_hp;       return @pokemon&.real_hp;       end
  def real_totalhp;  return @pokemon&.real_totalhp;  end
  
  #-----------------------------------------------------------------------------
  # Aliased for calculating the correct HP amounts.
  #-----------------------------------------------------------------------------
  alias dbk_dxpbReduceHP pbReduceHP
  def pbReduceHP(*args)
    if @effects[PBEffects::PerishSongUser] >= 0 && @effects[PBEffects::PerishSong] == 0
      @stopBoostedHPScaling = true
    end
    if !@stopBoostedHPScaling
      if self.dynamax?
        args[0] = (args[0] / self.dynamax_boost).round
      else
        args[0] = (args[0] / @pokemon.hp_boost).round
      end
    end
    ret = dbk_dxpbReduceHP(*args)
    @stopBoostedHPScaling = false
    return ret
  end
  
  alias dbk_dxpbRecoverHP pbRecoverHP
  def pbRecoverHP(*args)
    if !@stopBoostedHPScaling
      if self.dynamax?
        args[0] = (args[0] / self.dynamax_boost).round
      else
        args[0] = (args[0] / @pokemon.hp_boost).round
      end
    end
    ret = dbk_dxpbRecoverHP(*args)
    @stopBoostedHPScaling = false
    return ret
  end
  
  alias dbk_dxpbRecoverHPFromDrain pbRecoverHPFromDrain
  def pbRecoverHPFromDrain(*args)
    @stopBoostedHPScaling = true
    dbk_dxpbRecoverHPFromDrain(*args)
  end
  
  #-----------------------------------------------------------------------------
  # Defines whether the battler is considered a raid boss.
  #-----------------------------------------------------------------------------
  def isRaidBoss?
    return false if self.idxOwnSide == 0
    return false if @battle.pbSideBattlerCount(@index) > 1
    return true if @battle.wildBattleMode == :raid
    return @pokemon&.immunities.include?(:RAIDBOSS)
  end
  
  #-----------------------------------------------------------------------------
  # Defines whether the battler is considered to have special boss immunities.
  #-----------------------------------------------------------------------------
  def hasBossImmunity?(*args)
    return true if isRaidBoss?
    return true if hasRaidShield?
    return false if args.length == 0
    args.each { |arg| return true if @pokemon&.immunities.include?(arg) }
    return false
  end
  
  #-----------------------------------------------------------------------------
  # Aliased to make PP infinite if HP has been boosted.
  #-----------------------------------------------------------------------------
  # alias dbk_dxpbReducePP pbReducePP
  # def pbReducePP(move)
    # return true if @pokemon.immunities.include?(:PPLOSS)
    # if move.powerMove? && @powerMoveIndex >= 0
      # i = @powerMoveIndex
      # pbSetPP(@baseMoves[i], @baseMoves[i].pp - 1)
    # end
    # return dbk_dxpbReducePP(move)
  # end
  
  #-----------------------------------------------------------------------------
  # Aliased for primary status immunities.
  #-----------------------------------------------------------------------------
  alias dbk_dxpbCanInflictStatus? pbCanInflictStatus?
  def pbCanInflictStatus?(newStatus, user, showMessages, move = nil, ignoreStatus = false)
    return false if fainted?
    return false if @battle.raidCaptureMode
    self_inflicted = (user && user.index == @index)
    immunities = @pokemon.immunities
    if (immunities.include?(:ALLSTATUS) || immunities.include?(newStatus)) && !self_inflicted && !ignoreStatus
      case newStatus
      when :SLEEP     then msg = _INTL("{1} is completely immune to being put to sleep!", pbThis)
      when :POISON    then msg = _INTL("{1} is completely immune to poisoning!", pbThis)
      when :BURN      then msg = _INTL("{1} is completely immune to burns!", pbThis)
      when :PARALYSIS then msg = _INTL("{1} is completely immune to paralysis!", pbThis)
      when :FROZEN    then msg = _INTL("{1} is completely immune to being frozen!", pbThis)
      when :FROSTBITE then msg = _INTL("{1} is completely immune to frostbite!", pbThis)
      when :DROWSY    then msg = _INTL("{1} is completely immune to becoming drowsy!", pbThis)
      end
      @battle.pbDisplay(msg) if showMessages
      return false
    end
    return dbk_dxpbCanInflictStatus?(newStatus, user, showMessages, move, ignoreStatus)
  end
  
  alias dbk_dxpbCanSynchronizeStatus? pbCanSynchronizeStatus?
  def pbCanSynchronizeStatus?(newStatus, traget)
    return false if @battle.raidCaptureMode
    return false if @pokemon.immunities.include?(:ALLSTATUS)
    return false if @pokemon.immunities.include?(newStatus)
    return dbk_dxpbCanSynchronizeStatus?(newStatus, traget)
  end
  
  alias dbk_dxpbCanSleepYawn? pbCanSleepYawn?
  def pbCanSleepYawn?
    return false if @battle.raidCaptureMode
    return false if @pokemon.immunities.include?(:ALLSTATUS)
    return false if @pokemon.immunities.include?(:SLEEP)
    return dbk_dxpbCanSleepYawn?
  end
  
  #-----------------------------------------------------------------------------
  # Aliased for secondary status immunities.
  #-----------------------------------------------------------------------------
  alias dbk_dxpbCanConfuse? pbCanConfuse?
  def pbCanConfuse?(*args)
    return false if fainted?
    return false if @battle.raidCaptureMode
    immunities = @pokemon.immunities
    if immunities.include?(:ALLSTATUS) || immunities.include?(:CONFUSED)
      @battle.pbDisplay(_INTL("{1} is completely immune to confusion!", pbThis)) if args[1]
      return false
    end
    return dbk_dxpbCanConfuse?(*args)
  end
  
  alias dbk_dxpbCanAttract? pbCanAttract?
  def pbCanAttract?(user, showMessages = true)
    return false if fainted?
    return false if !user || user.fainted?
    return false if @battle.raidCaptureMode
    immunities = @pokemon.immunities
    if immunities.include?(:ALLSTATUS) || immunities.include?(:ATTRACT)
      @battle.pbDisplay(_INTL("{1} is completely immune to infatuation!", pbThis)) if showMessages
      return false
    end
    return dbk_dxpbCanAttract?(user, showMessages)
  end
  
  #-----------------------------------------------------------------------------
  # Aliased for flinch immunity.
  #-----------------------------------------------------------------------------
  alias dbk_dxpbFlinch pbFlinch
  def pbFlinch(_user = nil)
    return false if dynamax?
    return false if @pokemon && @pokemon.immunities.include?(:FLINCH)
    return dbk_dxpbFlinch(_user)
  end
  
  #-----------------------------------------------------------------------------
  # Aliased for stat drop immunity.
  #-----------------------------------------------------------------------------
  alias dbk_dxpbCanLowerStatStage? pbCanLowerStatStage?
  def pbCanLowerStatStage?(*args)
    return false if fainted?
    return false if @battle.raidCaptureMode
    if (!args[1] || args[1].index != @index) && 
       @pokemon.immunities.include?(:STATDROPS) && !hasActiveAbility?(:CONTRARY)
      @battle.pbDisplay(_INTL("{1} is completely immune to having its stats lowered!", pbThis)) if args[3]
      return false
    end
    return dbk_dxpbCanLowerStatStage?(*args)
  end
  
  #-----------------------------------------------------------------------------
  # Aliased for type changing immunity.
  #-----------------------------------------------------------------------------
  alias dbk_dxcanChangeType? canChangeType?
  def canChangeType?
    return false if tera?
    return false if @battle.raidCaptureMode
    return false if @pokemon.immunities.include?(:TYPECHANGE)
    return dbk_dxcanChangeType?
  end
  
  #-----------------------------------------------------------------------------
  # Aliased for indirect damage immunity.
  #-----------------------------------------------------------------------------
  alias dbk_dxtakesIndirectDamage? takesIndirectDamage?
  def takesIndirectDamage?(showMsg = false)
    return false if fainted?
    return false if @battle.raidCaptureMode
    if @pokemon.immunities.include?(:INDIRECT)
      @battle.pbDisplay(_INTL("{1} is completely immune to indirect damage!", pbThis)) if showMsg
      return false
    end
    return dbk_dxtakesIndirectDamage?(showMsg)
  end
  
  #-----------------------------------------------------------------------------
  # Aliased for Destiny Bond/Grudge immunity.
  #-----------------------------------------------------------------------------
  alias dbk_dxpbEffectsOnMakingHit pbEffectsOnMakingHit
  def pbEffectsOnMakingHit(move, user, target)
    if target.opposes?(user)
      if target.effects[PBEffects::Grudge] && target.fainted? && 
         user.pokemon.immunities.include?(:PPLOSS)
        target.effects[PBEffects::Grudge] = false
      end
      if target.effects[PBEffects::DestinyBond] && target.fainted? &&
         (user.dynamax? || user.hasBossImmunity?(:OHKO))
        target.effects[PBEffects::DestinyBond] = false
      end
    end
    dbk_dxpbEffectsOnMakingHit(move, user, target)
  end
  
  #-----------------------------------------------------------------------------
  # Aliased for item removal immunity.
  #-----------------------------------------------------------------------------
  alias dbk_dxunlosableItem? unlosableItem?
  def unlosableItem?(check_item)
    return true if check_item && @battle.raidCaptureMode
    return true if check_item && @pokemon.immunities.include?(:ITEMREMOVAL)
    return dbk_dxunlosableItem?(check_item)
  end
  
  #-----------------------------------------------------------------------------
  # Aliased for ability negating/replacing immunity.
  #-----------------------------------------------------------------------------
  alias dbk_dxunstoppableAbility? unstoppableAbility?
  def unstoppableAbility?(abil = nil)
    return true if @battle.raidCaptureMode
    return true if @pokemon.immunities.include?(:ABILITYREMOVAL)
    return dbk_dxunstoppableAbility?(abil)
  end
end


#===============================================================================
# Battle properties.
#===============================================================================
class Battle
  #-----------------------------------------------------------------------------
  # Aliased for escape immunity.
  #-----------------------------------------------------------------------------
  alias dbk_dxpbCanRun? pbCanRun?
  def pbCanRun?(idxBattler)
    battler = @battlers[idxBattler]
    return false if battler.hasBossImmunity?(:ESCAPE)
    return dbk_dxpbCanRun?(idxBattler)
  end
  
  #-----------------------------------------------------------------------------
  # Returns true if this battle is a raid battle.
  #-----------------------------------------------------------------------------
  def raidBattle?
    allOtherSideBattlers.each { |b| return true if b.isRaidBoss? }
    return false
  end
end

#===============================================================================
# Battle move properties.
#===============================================================================
class Battle::Move  
  #-----------------------------------------------------------------------------
  # Aliased for immunities to Taunt, Torment, Encore, Disable, & Heal Block.
  #-----------------------------------------------------------------------------
  alias dbk_dxpbMoveFailedAromaVeil? pbMoveFailedAromaVeil?
  def pbMoveFailedAromaVeil?(user, target, showMessage = true)
    if target.pokemon.immunities.include?(:DISABLE)
      @battle.pbDisplay(_INTL("{1} is completely immune to effects that may disable its moves!", target.pbThis)) if showMessage
      return true
    end
    return dbk_dxpbMoveFailedAromaVeil?(user, target, showMessage)
  end
end