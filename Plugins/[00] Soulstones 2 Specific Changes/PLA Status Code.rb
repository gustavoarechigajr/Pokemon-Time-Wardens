## Settings ##
##==========##
##############
module Settings
  SLEEP_EFFECTS_CAUSE_DROWSY     = false
  FREEZE_EFFECTS_CAUSE_FROSTBITE = true
end



## Battle Classes ##
##================##
####################

GameData::Status.register({
  :id            => :DROWSY,
  :name          => _INTL("Drowsy"),
  :animation     => "Drowsy",
  :icon_position => 5
})

GameData::Status.register({
  :id            => :FROSTBITE,
  :name          => _INTL("Frostbite"),
  :animation     => "Frostbite",
  :icon_position => 6
})

class Battle
  alias plastatus_pbEORStatusProblemDamage pbEORStatusProblemDamage
  def pbEORStatusProblemDamage(priority)
    plastatus_pbEORStatusProblemDamage(priority)
    priority.each do |battler|
      next if battler.status != :FROSTBITE || !battler.takesIndirectDamage?
      battler.droppedBelowHalfHP = false
      dmg = battler.totalhp / 16
      dmg /= 2 if battler.hasActiveAbility?(:SUPERCONDUCTIVE) && battler.status == :FROZEN
      battler.pbContinueStatus { battler.pbReduceHP(dmg, false) }
      battler.pbItemHPHealCheck
      battler.pbAbilitiesOnDamageTaken
      battler.pbFaint if battler.fainted?
      battler.droppedBelowHalfHP = false
    end
  end
end

class Battle::Battler
  #-----------------------------------------------------------------------------
  # Drowsy utilities. 
  #-----------------------------------------------------------------------------
  def drowsy?
    return pbHasStatus?(:DROWSY)
  end

  def pbCanDrowse?(user, showMessages, move = nil, ignoreStatus = false)
    return pbCanInflictStatus?(:DROWSY, user, showMessages, move, ignoreStatus)
  end
  
  def pbCanDrowseSynchronize?(target)
    return pbCanSynchronizeStatus?(:DROWSY, target)
  end

  def pbDrowse(user = nil, msg = nil)
    pbInflictStatus(:DROWSY, pbSleepDuration + 1, msg, user)
  end

  def pbDrowseSelf(msg = nil, duration = -1)
    pbInflictStatus(:DROWSY, pbSleepDuration(duration) + 1, msg)
  end

  #-----------------------------------------------------------------------------
  # Frostbite utilities. 
  #-----------------------------------------------------------------------------
  def frostbite?
    return pbHasStatus?(:FROSTBITE)
  end

  def pbCanFrostbite?(user, showMessages, move = nil)
    return pbCanInflictStatus?(:FROSTBITE, user, showMessages, move)
  end

  def pbCanFrostbiteSynchronize?(target)
    return pbCanSynchronizeStatus?(:FROSTBITE, target)
  end

  def pbFrostbite(user = nil, msg = nil)
    pbInflictStatus(:FROSTBITE, 0, msg, user)
  end

  
  def pbFreeze(user = nil, msg = nil)
    pbInflictStatus(:FROZEN, 0, msg, user)
  end

  #-----------------------------------------------------------------------------
  # Aliased to check for Drowsy/Frostbite. 
  #-----------------------------------------------------------------------------
  alias plastatus_pbHasStatus? pbHasStatus?
  def pbHasStatus?(checkStatus)
    ret = plastatus_pbHasStatus?(checkStatus)
    return ret if ret
    case checkStatus
    when :SLEEP
      return true if @status == :DROWSY && Settings::SLEEP_EFFECTS_CAUSE_DROWSY
    when :FROZEN
      return true if @status == :FROSTBITE && Settings::FREEZE_EFFECTS_CAUSE_FROSTBITE
    end
    return ret
  end

  #-----------------------------------------------------------------------------
  # Aliased to check for Drowsy/Frostbite immunities.
  # -Effects that make a battler immune to Sleep also make them immune to Drowsy.
  # =Effects that make a battler immune to Freeze also make them immune to Frostbite.
  #-----------------------------------------------------------------------------
  alias plastatus_pbCanInflictStatus? pbCanInflictStatus?
  def pbCanInflictStatus?(newStatus, user, showMessages, move = nil, ignoreStatus = false)
    originalStatus = newStatus
    case newStatus
    when :SLEEP  then newStatus = :DROWSY    if Settings::SLEEP_EFFECTS_CAUSE_DROWSY
    when :FROZEN then newStatus = :FROSTBITE if Settings::FREEZE_EFFECTS_CAUSE_FROSTBITE
    end
    if [:DROWSY, :FROSTBITE].include?(newStatus)
      selfInflicted = (user && user.index == @index)
      #-------------------------------------------------------------------------
      # General immunities.
      #-------------------------------------------------------------------------
      if self.status == newStatus && !ignoreStatus
        if showMessages
          @battle.pbDisplay(_INTL("{1} is already drowsy!", pbThis))      if newStatus == :DROWSY
          @battle.pbDisplay(_INTL("{1} is already frostbitten!", pbThis)) if newStatus == :FROSTBITE
        end
        return false
      end
      if (self.status != :NONE && !ignoreStatus && !selfInflicted) ||
         (@effects[PBEffects::Substitute] > 0 && !(move && move.ignoresSubstitute?(user)) && !selfInflicted)
        @battle.pbDisplay(_INTL("It doesn't affect {1}...", pbThis(true))) if showMessages
        return false
      end
      case newStatus
      #-------------------------------------------------------------------------
      # Drowzy immunities.
      #-------------------------------------------------------------------------
      when :DROWSY
        if affectedByTerrain? && @battle.field.terrain == :Electric
          @battle.pbDisplay(_INTL("{1} surrounds itself with electrified terrain!", pbThis(true))) if showMessages
          return false
        end
        if !(hasActiveAbility?(:SOUNDPROOF) && !@battle.moldBreaker)
          @battle.allBattlers.each do |b|
            next if b.effects[PBEffects::Uproar] == 0
            @battle.pbDisplay(_INTL("But the uproar kept {1} alert!", pbThis(true))) if showMessages
            return false
          end
        end
      #-------------------------------------------------------------------------
      # Frostbite immunities.
      #-------------------------------------------------------------------------
      when :FROSTBITE
        if pbHasType?(:ICE) #|| [:Sun, :HarshSun].include?(effectiveWeather)
          @battle.pbDisplay(_INTL("It doesn't affect {1}...", pbThis(true))) if showMessages
          return false
        end
      end
      #-------------------------------------------------------------------------
      # Ability immunities. 
      # Abilities that block Sleep also block Drowsiness.
      # Abilities that block Freeze also block Frostbites.
      #-------------------------------------------------------------------------
      immuneByAbility = false
      immAlly = nil
      if Battle::AbilityEffects.triggerStatusImmunityNonIgnorable(self.ability, self, originalStatus)
        immuneByAbility = true
      elsif selfInflicted || !@battle.moldBreaker
        if abilityActive? && Battle::AbilityEffects.triggerStatusImmunity(self.ability, self, originalStatus)
          immuneByAbility = true
        else
          allAllies.each do |b|
            next if !b.abilityActive?
            next if !Battle::AbilityEffects.triggerStatusImmunityFromAlly(b.ability, self, originalStatus)
            immuneByAbility = true
            immAlly = b
            break
          end
        end
      end
      if immuneByAbility
        if showMessages
          @battle.pbShowAbilitySplash(immAlly || self)
          msg = ""
          if Battle::Scene::USE_ABILITY_SPLASH
            case originalStatus
            when :SLEEP  then msg = _INTL("{1} stays alert!", pbThis)
            when :FROZEN then msg = _INTL("{1} cannot be frostbitten!", pbThis)
            end
          elsif immAlly
            case originalStatus
            when :SLEEP  then msg = _INTL("{1} stays alert because of {2}'s {3}!", pbThis, immAlly.pbThis(true), immAlly.abilityName)
            when :FROZEN then msg = _INTL("{1} cannot be frostbitten because of {2}'s {3}!", pbThis, immAlly.pbThis(true), immAlly.abilityName)
            end
          else
            case originalStatus
            when :SLEEP  then msg = _INTL("{1}'s {2} prevents drowsiness!", pbThis, abilityName)
            when :FROZEN then msg = _INTL("{1}'s {2} prevents frostbites!", pbThis, abilityName)
            end
          end
          @battle.pbDisplay(msg)
          @battle.pbHideAbilitySplash(immAlly || self)
        end
        return false
      end
      #-------------------------------------------------------------------------
      # Safeguard immunity.
      #-------------------------------------------------------------------------
      if pbOwnSide.effects[PBEffects::Safeguard] > 0 && !selfInflicted && move &&
         !(user && user.hasActiveAbility?(:INFILTRATOR))
        @battle.pbDisplay(_INTL("{1}'s team is protected by Safeguard!", pbThis)) if showMessages
        return false
      end
      return true
    else
      return plastatus_pbCanInflictStatus?(originalStatus, user, showMessages, move, ignoreStatus)
    end
  end
  
  #-----------------------------------------------------------------------------
  # Aliased to check if Synchronize should fail to pass Drowsy/Frostbite.
  #-----------------------------------------------------------------------------
  alias plastatus_pbCanSynchronizeStatus? pbCanSynchronizeStatus?
  def pbCanSynchronizeStatus?(newStatus, target)
    ret = plastatus_pbCanSynchronizeStatus?(newStatus, target)
    return false if !ret
    return false if newStatus == :FROSTBITE && pbHasType?(:ICE)
    case newStatus
      when :DROWSY    then newStatus = :SLEEP
      when :FROSTBITE then newStatus = :FROZEN
    end
    return false if Battle::AbilityEffects.triggerStatusImmunityNonIgnorable(self.ability, self, newStatus)
    return false if abilityActive? && Battle::AbilityEffects.triggerStatusImmunity(self.ability, self, newStatus)
    allAllies.each do |b|
      next if !b.abilityActive?
      next if !Battle::AbilityEffects.triggerStatusImmunityFromAlly(b.ability, self, newStatus)
      return false
    end
    return true
  end
  
  #-----------------------------------------------------------------------------
  # Aliased for inflicting the Drowsy/Frostbite status conditions.
  #-----------------------------------------------------------------------------
  alias plastatus_pbInflictStatus pbInflictStatus
  def pbInflictStatus(newStatus, newStatusCount = 0, msg = nil, user = nil)
    case newStatus
    when :SLEEP  then newStatus = :DROWSY    if Settings::SLEEP_EFFECTS_CAUSE_DROWSY
    when :FROZEN then newStatus = :FROSTBITE if Settings::FREEZE_EFFECTS_CAUSE_FROSTBITE
    end
    if [:DROWSY, :FROSTBITE].include?(newStatus)
      self.status      = newStatus
      self.statusCount = newStatusCount
      @effects[PBEffects::Toxic] = 0
      anim_name = GameData::Status.get(newStatus).animation
      @battle.pbCommonAnimation(anim_name, self) if anim_name
      if msg && !msg.empty?
        @battle.pbDisplay(msg)
      else
        case newStatus
        when :DROWSY    then @battle.pbDisplay(_INTL("{1} grew drowsy!\nIt may be too sleepy to move!", pbThis))
        when :FROSTBITE then @battle.pbDisplay(_INTL("{1} was frostbitten!", pbThis))
        end
      end
      PBDebug.log("[Status change] #{pbThis}'s drowsy count is #{newStatusCount}") if newStatus == :DROWSY
      # Form change check
      pbCheckFormOnStatusChange
      # Synchronize
      if abilityActive?
        Battle::AbilityEffects.triggerOnStatusInflicted(self.ability, self, user, newStatus)
      end
      # Status cures
      pbItemStatusCureCheck
      pbAbilityStatusCureCheck
    else
      plastatus_pbInflictStatus(newStatus, newStatusCount, msg, user)
    end
  end

  #-----------------------------------------------------------------------------
  # Aliased for curing the Drowsy/Frostbite status conditions.
  #-----------------------------------------------------------------------------
  alias plastatus_pbCureStatus pbCureStatus
  def pbCureStatus(showMessages = true)
    if [:DROWSY, :FROSTBITE].include?(self.status)
      oldStatus = status
      self.status = :NONE
      if showMessages
        case oldStatus
        when :DROWSY    then @battle.pbDisplay(_INTL("{1} became alert again.", pbThis))
        when :FROSTBITE then @battle.pbDisplay(_INTL("{1}'s frostbite was healed.", pbThis))
        end
      end
      PBDebug.log("[Status change] #{pbThis}'s status was cured") if !showMessages
    else
      plastatus_pbCureStatus(showMessages)
    end
  end
  
  #-----------------------------------------------------------------------------
  # Edited for Drowsy/Frostbite effect messages.
  #-----------------------------------------------------------------------------
  def pbContinueStatus
    if self.status == :POISON && @statusCount > 0
      @battle.pbCommonAnimation("Toxic", self)
    else
      anim_name = GameData::Status.get(self.status).animation
      @battle.pbCommonAnimation(anim_name, self) if anim_name
    end
    yield if block_given?
    case self.status
    when :SLEEP
      @battle.pbDisplay(_INTL("{1} is fast asleep.", pbThis))
	  PBDebug.log("[Status continues] #{pbThis}'s sleep count is #{@statusCount}")
    when :POISON
      @battle.pbDisplay(_INTL("{1} was hurt by poison!", pbThis))
    when :BURN
      @battle.pbDisplay(_INTL("{1} was hurt by its burn!", pbThis))
    when :PARALYSIS
      @battle.pbDisplay(_INTL("{1} is paralyzed! It can't move!", pbThis))
    when :FROZEN
      @battle.pbDisplay(_INTL("{1} is frozen solid!", pbThis))
    when :DROWSY
      @battle.pbDisplay(_INTL("{1} is too drowsy to move!", pbThis))
	  PBDebug.log("[Status continues] #{pbThis}'s drowsy count is #{@statusCount}")
    when :FROSTBITE
      @battle.pbDisplay(_INTL("{1} was hurt by its frostbite!", pbThis))
    end
  end

  #-----------------------------------------------------------------------------
  # Aliased to prevent the use of moves due to being Drowsy.
  #-----------------------------------------------------------------------------
  alias plastatus_pbTryUseMove pbTryUseMove
  def pbTryUseMove(*args)
    ret = plastatus_pbTryUseMove(*args)
    return false if !ret
    if @status == :DROWSY
      self.statusCount -= 1
      if @statusCount <= 0
        pbCureStatus
      else
        if !args[1].electrocuteUser?
          chance = (effectiveWeather == :Hail) ? 66 : 33
          if @battle.pbRandom(100) < chance
            pbContinueStatus
            @lastMoveFailed = true
            return false
          end
        end
      end
    end
    return true
  end

  #-----------------------------------------------------------------------------
  # -Aliased so the Charge effect ends only after using an Electric-type move.
  # -Moves that cause electrocution heals Drowsiness.
  # -Moves that cause thawing heals Frostbite.
  #-----------------------------------------------------------------------------
  alias plastatus_pbEffectsAfterMove pbEffectsAfterMove
  def pbEffectsAfterMove(user, targets, move, numHits)
    if move.damagingMove?
      if user.status == :DROWSY && move.electrocuteUser?
        user.pbCureStatus(false)
        @battle.pbDisplay(_INTL("{1} was shocked wide awake!", user.pbThis))
      end
      if user.status == :FROSTBITE && move.thawsUser?
        user.pbCureStatus(false)
        @battle.pbDisplay(_INTL("{1} warmed up!", user.pbThis))
      end
      targets.each do |b|
        next if b.damageState.unaffected || b.damageState.substitute
        b.pbCureStatus if b.status == :DROWSY && move.electrocuteUser?
        b.pbCureStatus if b.status == :FROSTBITE && move.thawsUser?  
      end
    end
    plastatus_pbEffectsAfterMove(user, targets, move, numHits)
  end  
end

class Battle::Move 
  def electrocuteUser?; return ([:SPARK,:VOLTTACKLE,:WILDCHARGE].include?(self.id) || @flags.any? { |f| f[/^ElectrocuteUser$/i] }); end

  #-----------------------------------------------------------------------------
  # Aliased to add a variety of new effects that affect damage calculation.
  #  -Applies the effects of the various "of Ruin" abilities.
  #  -Calculates the power of Psyblade in Electric Terrain.
  #  -Calculates the power of Hydro Steam in Sun.
  #  -Increases the Defense of Ice-types during Snow weather (Gen 9 version).
  #  -Halves the damage dealt by special attacks if the user has the Frostbite status.
  #  -Increases damage taken if the targer has the Drowsy status.
  #  -Doubles damage taken by a target still vulnerable due to Glaive Rush's effect.
  #-----------------------------------------------------------------------------
  alias plastatus_pbCalcDamageMultipliers pbCalcDamageMultipliers
  def pbCalcDamageMultipliers(user, target, numTargets, type, baseDmg, multipliers)
    # Frostbite
    if user.status == :FROSTBITE && specialMove? && !user.hasActiveAbility?(:ATTUNEMENT)
      multipliers[:final_damage_multiplier] /= 2
    end
    # Drowsy
    if target.status == :DROWSY
      multipliers[:final_damage_multiplier] *= 4 / 3.0
    end
    plastatus_pbCalcDamageMultipliers(user, target, numTargets, type, baseDmg, multipliers)
  end
end



## Fuction Codes ##
##===============##
###################

#===============================================================================
# Psycho Shift / Jungle Healing / Aromatherapy, Heal Bell
#===============================================================================
# Adds messages for Drowsy/Frostbite.
#-------------------------------------------------------------------------------
class Battle::Move::GiveUserStatusToTarget < Battle::Move
  alias plastatus_pbEffectAgainstTarget pbEffectAgainstTarget
  def pbEffectAgainstTarget(user, target)
    if [:DROWSY, :FROSTBITE].include?(user.status)
      case user.status
      when :DROWSY
        target.pbSleep
        user.pbCureStatus(false)
        @battle.pbDisplay(_INTL("{1} became alert again.", user.pbThis))
      when :FROSTBITE
        target.pbFreeze(user)
        user.pbCureStatus(false)
        @battle.pbDisplay(_INTL("{1}'s frostbite was healed.", user.pbThis))
      end
    else
      plastatus_pbEffectAgainstTarget(user,target)
    end
  end
end

class Battle::Move::CureUserPartyStatus < Battle::Move
  def pbAromatherapyHeal(pkmn, battler = nil)
    oldStatus = (battler) ? battler.status : pkmn.status
    curedName = (battler) ? battler.pbThis : pkmn.name
    if battler
      battler.pbCureStatus(false)
    else
      pkmn.status      = :NONE
      pkmn.statusCount = 0
    end
    case oldStatus
    when :SLEEP
      @battle.pbDisplay(_INTL("{1} was woken from sleep.", curedName))
    when :POISON
      @battle.pbDisplay(_INTL("{1} was cured of its poisoning.", curedName))
    when :BURN
      @battle.pbDisplay(_INTL("{1}'s burn was healed.", curedName))
    when :PARALYSIS
      @battle.pbDisplay(_INTL("{1} was cured of paralysis.", curedName))
    when :FROZEN
      @battle.pbDisplay(_INTL("{1} was thawed out.", curedName))
    when :DROWSY
      @battle.pbDisplay(_INTL("{1} became alert again.", curedName))
    when :FROSTBITE
      @battle.pbDisplay(_INTL("{1}'s frostbite was healed.", curedName))
    end
  end
end

class Battle::Move::HealUserAndAlliesQuarterOfTotalHPCureStatus < Battle::Move
  def pbEffectAgainstTarget(user, target)
    if target.canHeal?
      target.pbRecoverHP(target.totalhp / 4)
      @battle.pbDisplay(_INTL("{1}'s HP was restored.", target.pbThis))
    end
    if target.status != :NONE
      old_status = target.status
      target.pbCureStatus(false)
      case old_status
      when :SLEEP
        @battle.pbDisplay(_INTL("{1} was woken from sleep.", target.pbThis))
      when :POISON
        @battle.pbDisplay(_INTL("{1} was cured of its poisoning.", target.pbThis))
      when :BURN
        @battle.pbDisplay(_INTL("{1}'s burn was healed.", target.pbThis))
      when :PARALYSIS
        @battle.pbDisplay(_INTL("{1} was cured of paralysis.", target.pbThis))
      when :FROZEN
        @battle.pbDisplay(_INTL("{1} was thawed out.", target.pbThis))
      when :DROWSY
        @battle.pbDisplay(_INTL("{1} became alert again.", target.pbThis))
      when :FROSTBITE
        @battle.pbDisplay(_INTL("{1}'s frostbite was healed.", target.pbThis))
      end
    end
  end
end

#===============================================================================
# Frostbites the target.
#===============================================================================
class Battle::Move::FrostbiteTarget < Battle::Move
  def canMagicCoat?; return true; end

  def pbFailsAgainstTarget?(user, target, show_message)
    return false if damagingMove?
    return !target.pbCanFrostbite?(user, show_message, self)
  end

  def pbEffectAgainstTarget(user, target)
    return if damagingMove?
    target.pbFrostbite(user)
  end

  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
    target.pbFrostbite(user) if target.pbCanFrostbite?(user, false, self)
  end
end



## Ability Handler Code ##
##======================##
##########################

#===============================================================================
# Insomnia, Vital Spirit
#===============================================================================
# Adds Drowsy as a status that may be healed.
#-------------------------------------------------------------------------------
Battle::AbilityEffects::StatusCure.add(:INSOMNIA,
  proc { |ability, battler|
    next if ![:SLEEP, :DROWSY].include?(battler.status)
    battler.battle.pbShowAbilitySplash(battler)
    battler.pbCureStatus(Battle::Scene::USE_ABILITY_SPLASH)
    if !Battle::Scene::USE_ABILITY_SPLASH
      case battler.status
      when :SLEEP  then msg = _INTL("{1}'s {2} woke it up!", battler.pbThis, battler.abilityName)
      when :DROWSY then msg = _INTL("{1}'s {2} made it alert again!", battler.pbThis, battler.abilityName)
      end
      battler.battle.pbDisplay(msg)
    end
    battler.battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::StatusCure.copy(:INSOMNIA, :VITALSPIRIT)

#===============================================================================
# Magma Armor
#===============================================================================
# Adds Frostbite as a status that may be healed.
#-------------------------------------------------------------------------------
Battle::AbilityEffects::StatusCure.add(:MAGMAARMOR,
  proc { |ability, battler|
    next if ![:FROZEN, :FROSTBITE].include?(battler.status)
    battler.battle.pbShowAbilitySplash(battler)
    battler.pbCureStatus(Battle::Scene::USE_ABILITY_SPLASH)
    if !Battle::Scene::USE_ABILITY_SPLASH
      case battler.status
      when :FROZEN    then msg = _INTL("{1}'s {2} defrosted it!", battler.pbThis, battler.abilityName)
      when :FROSTBITE then msg = _INTL("{1}'s {2} healed its frostbite!", battler.pbThis, battler.abilityName)
      end
      battler.battle.pbDisplay(msg)
    end
    battler.battle.pbHideAbilitySplash(battler)
  }
)

#===============================================================================
# Healer
#===============================================================================
# Adds Drowsy/Frostbite as statuses that may be healed.
#-------------------------------------------------------------------------------
Battle::AbilityEffects::EndOfRoundHealing.add(:HEALER,
  proc { |ability, battler, battle|
    next unless battle.pbRandom(100) < 30
    battler.allAllies.each do |b|
      next if b.status == :NONE
      battle.pbShowAbilitySplash(battler)
      oldStatus = b.status
      b.pbCureStatus(Battle::Scene::USE_ABILITY_SPLASH)
      if !Battle::Scene::USE_ABILITY_SPLASH
        case oldStatus
        when :SLEEP
          battle.pbDisplay(_INTL("{1}'s {2} woke its partner up!", battler.pbThis, battler.abilityName))
        when :POISON
          battle.pbDisplay(_INTL("{1}'s {2} cured its partner's poison!", battler.pbThis, battler.abilityName))
        when :BURN
          battle.pbDisplay(_INTL("{1}'s {2} healed its partner's burn!", battler.pbThis, battler.abilityName))
        when :PARALYSIS
          battle.pbDisplay(_INTL("{1}'s {2} cured its partner's paralysis!", battler.pbThis, battler.abilityName))
        when :FROZEN
          battle.pbDisplay(_INTL("{1}'s {2} defrosted its partner!", battler.pbThis, battler.abilityName))
        when :DROWSY
          battle.pbDisplay(_INTL("{1}'s {2} made its partner alert again!", battler.pbThis, battler.abilityName))
        when :FROSTBITE
          battle.pbDisplay(_INTL("{1}'s {2} healed its partner's frostbite!", battler.pbThis, battler.abilityName))
        end
      end
      battle.pbHideAbilitySplash(battler)
    end
  }
)

#===============================================================================
# Hydration
#===============================================================================
# Adds Drowsy/Frostbite as statuses that may be healed.
#-------------------------------------------------------------------------------
Battle::AbilityEffects::EndOfRoundHealing.add(:HYDRATION,
  proc { |ability, battler, battle|
    next if battler.status == :NONE
    next if ![:Rain, :HeavyRain].include?(battler.effectiveWeather)
    battle.pbShowAbilitySplash(battler)
    oldStatus = battler.status
    battler.pbCureStatus(Battle::Scene::USE_ABILITY_SPLASH)
    if !Battle::Scene::USE_ABILITY_SPLASH
      case oldStatus
      when :SLEEP
        battle.pbDisplay(_INTL("{1}'s {2} woke it up!", battler.pbThis, battler.abilityName))
      when :POISON
        battle.pbDisplay(_INTL("{1}'s {2} cured its poison!", battler.pbThis, battler.abilityName))
      when :BURN
        battle.pbDisplay(_INTL("{1}'s {2} healed its burn!", battler.pbThis, battler.abilityName))
      when :PARALYSIS
        battle.pbDisplay(_INTL("{1}'s {2} cured its paralysis!", battler.pbThis, battler.abilityName))
      when :FROZEN
        battle.pbDisplay(_INTL("{1}'s {2} defrosted it!", battler.pbThis, battler.abilityName))
      when :DROWSY
        battle.pbDisplay(_INTL("{1}'s {2} made it alert again!", battler.pbThis, battler.abilityName))
      when :FROSTBITE
        battle.pbDisplay(_INTL("{1}'s {2} healed its frostbite!", battler.pbThis, battler.abilityName))
      end
    end
    battle.pbHideAbilitySplash(battler)
  }
)

#===============================================================================
# Shed Skin
#===============================================================================
# Adds Drowsy/Frostbite as statuses that may be healed.
#-------------------------------------------------------------------------------
Battle::AbilityEffects::EndOfRoundHealing.add(:SHEDSKIN,
  proc { |ability, battler, battle|
    next if battler.status == :NONE
    next unless battle.pbRandom(100) < 30
    battle.pbShowAbilitySplash(battler)
    oldStatus = battler.status
    battler.pbCureStatus(Battle::Scene::USE_ABILITY_SPLASH)
    if !Battle::Scene::USE_ABILITY_SPLASH
      case oldStatus
      when :SLEEP
        battle.pbDisplay(_INTL("{1}'s {2} woke it up!", battler.pbThis, battler.abilityName))
      when :POISON
        battle.pbDisplay(_INTL("{1}'s {2} cured its poison!", battler.pbThis, battler.abilityName))
      when :BURN
        battle.pbDisplay(_INTL("{1}'s {2} healed its burn!", battler.pbThis, battler.abilityName))
      when :PARALYSIS
        battle.pbDisplay(_INTL("{1}'s {2} cured its paralysis!", battler.pbThis, battler.abilityName))
      when :FROZEN
        battle.pbDisplay(_INTL("{1}'s {2} defrosted it!", battler.pbThis, battler.abilityName))
      when :DROWSY
        battle.pbDisplay(_INTL("{1}'s {2} made it alert again!", battler.pbThis, battler.abilityName))
      when :FROSTBITE
        battle.pbDisplay(_INTL("{1}'s {2} healed its frostbite!", battler.pbThis, battler.abilityName))
      end
    end
    battle.pbHideAbilitySplash(battler)
  }
)

#===============================================================================
# Synchronize
#===============================================================================
# Adds Drowsy/Frostbite as statuses that may be passed.
#-------------------------------------------------------------------------------
Battle::AbilityEffects::OnStatusInflicted.add(:SYNCHRONIZE,
  proc { |ability, battler, user, status|
    Console.echo("#{ability}, #{battler}, #{user}, #{status}")
    next if !user || user.index == battler.index
    case status
    when :POISON
      if user.pbCanPoisonSynchronize?(battler)
        battler.battle.pbShowAbilitySplash(battler)
        msg = nil
        if !Battle::Scene::USE_ABILITY_SPLASH
          msg = _INTL("{1}'s {2} poisoned {3}!", battler.pbThis, battler.abilityName, user.pbThis(true))
        end
        user.pbPoison(nil, msg, (battler.statusCount > 0))
        battler.battle.pbHideAbilitySplash(battler)
      end
    when :BURN
      if user.pbCanBurnSynchronize?(battler)
        battler.battle.pbShowAbilitySplash(battler)
        msg = nil
        if !Battle::Scene::USE_ABILITY_SPLASH
          msg = _INTL("{1}'s {2} burned {3}!", battler.pbThis, battler.abilityName, user.pbThis(true))
        end
        user.pbBurn(nil, msg)
        battler.battle.pbHideAbilitySplash(battler)
      end
    when :PARALYSIS
      if user.pbCanParalyzeSynchronize?(battler)
        battler.battle.pbShowAbilitySplash(battler)
        msg = nil
        if !Battle::Scene::USE_ABILITY_SPLASH
          msg = _INTL("{1}'s {2} paralyzed {3}! It may be unable to move!",
             battler.pbThis, battler.abilityName, user.pbThis(true))
        end
        user.pbParalyze(nil, msg)
        battler.battle.pbHideAbilitySplash(battler)
      end
    when :FROSTBITE
      if user.pbCanFrostbiteSynchronize?(battler)
        battler.battle.pbShowAbilitySplash(battler)
        msg = nil
        if !Battle::Scene::USE_ABILITY_SPLASH
          msg = _INTL("{1}'s {2} caused {3} to become frostbitten!", battler.pbThis, battler.abilityName, user.pbThis(true))
        end
        user.pbFreeze(user, msg)
        battler.battle.pbHideAbilitySplash(battler)
      end
    end
  }
)

#===============================================================================
# Wake-Up Slap
#===============================================================================
# Adds Drowsiness as a status that is removed from the target after being hit.
#-------------------------------------------------------------------------------
class Battle::Move::DoublePowerIfTargetAsleepCureTarget < Battle::Move
  def pbEffectAfterAllHits(user, target)
    return if target.fainted?
    return if target.damageState.unaffected || target.damageState.substitute
    return if ![:SLEEP, :DROWSY].include?(target.status)
    target.pbCureStatus
  end
end

## Item Handler Code ##
##===================##
#######################
################################################################################
# 
# Updates to old item handlers (overworld use).
# 
################################################################################

#===============================================================================
# Awakening, Chesto Berry, Blue Flute
#===============================================================================
# Adds Drowsiness as a status that may be healed.
#-------------------------------------------------------------------------------
ItemHandlers::UseOnPokemon.add(:AWAKENING, proc { |item, qty, pkmn, scene|
  if pkmn.fainted? || ![:SLEEP, :DROWSY].include?(pkmn.status)
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  case pkmn.status
  when :SLEEP  then msg = _INTL("{1} woke up.", pkmn.name)
  when :DROWSY then msg = _INTL("{1} became alert again.", pkmn.name)
  end
  pkmn.heal_status
  scene.pbRefresh
  scene.pbDisplay(msg)
  next true
})

ItemHandlers::UseOnPokemon.copy(:AWAKENING, :CHESTOBERRY, :BLUEFLUTE, :POKEFLUTE)

#===============================================================================
# Ice Heal, Aspear Berry
#===============================================================================
# Adds Frostbite as a status that may be healed.
#-------------------------------------------------------------------------------
ItemHandlers::UseOnPokemon.add(:ICEHEAL, proc { |item, qty, pkmn, scene|
  if pkmn.fainted? || ![:FROZEN, :FROSTBITE].include?(pkmn.status)
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  case pkmn.status
  when :FROZEN    then msg = _INTL("{1} was thawed out.", pkmn.name)
  when :FROSTBITE then msg = _INTL("{1}'s frostbite was healed.", pkmn.name)
  end
  pkmn.heal_status
  scene.pbRefresh
  scene.pbDisplay(msg)
  next true
})

ItemHandlers::UseOnPokemon.copy(:ICEHEAL, :ASPEARBERRY)
################################################################################
# 
# Updates to old battle item handlers (used from the bag).
# 
################################################################################

#===============================================================================
# Awakening, Chesto Berry, Blue Flute
#===============================================================================
# Adds Drowsiness as a status that may be healed.
#-------------------------------------------------------------------------------
ItemHandlers::CanUseInBattle.add(:AWAKENING, proc { |item, pokemon, battler, move, firstAction, battle, scene, showMessages|
  next pbBattleItemCanCureStatus?(:SLEEP, pokemon, scene, showMessages) ||
       pbBattleItemCanCureStatus?(:DROWSY, pokemon, scene, showMessages)
})

ItemHandlers::CanUseInBattle.copy(:AWAKENING, :CHESTOBERRY)

ItemHandlers::CanUseInBattle.add(:BLUEFLUTE, proc { |item, pokemon, battler, move, firstAction, battle, scene, showMessages|
  if battler&.hasActiveAbility?(:SOUNDPROOF)
    scene.pbDisplay(_INTL("It won't have any effect.")) if showMessages
    next false
  end
  next pbBattleItemCanCureStatus?(:SLEEP, pokemon, scene, showMessages) ||
       pbBattleItemCanCureStatus?(:DROWSY, pokemon, scene, showMessages)
})

ItemHandlers::BattleUseOnPokemon.add(:AWAKENING, proc { |item, pokemon, battler, choices, scene|
  oldStatus = pokemon.status
  pokemon.heal_status
  battler&.pbCureStatus(false)
  name = (battler) ? battler.pbThis : pokemon.name
  scene.pbRefresh
  case oldStatus
  when :SLEEP  then scene.pbDisplay(_INTL("{1} woke up.", name))
  when :DROWSY then scene.pbDisplay(_INTL("{1} became alert again.", name))
  end
})

ItemHandlers::BattleUseOnPokemon.copy(:AWAKENING, :CHESTOBERRY, :BLUEFLUTE)

#===============================================================================
# Poke Flute
#===============================================================================
# Adds Drowsiness as a status that may be healed.
#-------------------------------------------------------------------------------
ItemHandlers::CanUseInBattle.add(:POKEFLUTE, proc { |item, pokemon, battler, move, firstAction, battle, scene, showMessages|
  if battle.allBattlers.none? { |b| [:SLEEP, :DROWSY].include?(b.status) && !b.hasActiveAbility?(:SOUNDPROOF) }
    scene.pbDisplay(_INTL("It won't have any effect.")) if showMessages
    next false
  end
  next true
})

ItemHandlers::UseInBattle.add(:POKEFLUTE, proc { |item, battler, battle|
  battle.allBattlers.each do |b|
    b.pbCureStatus(false) if [:SLEEP, :DROWSY].include?(b.status) && !b.hasActiveAbility?(:SOUNDPROOF)
  end
  battle.pbDisplay(_INTL("All Pokémon were roused by the tune!"))
})

#===============================================================================
# Ice Heal, Aspear Berry
#===============================================================================
# Adds Frostbite as a status that may be healed.
#-------------------------------------------------------------------------------
ItemHandlers::CanUseInBattle.add(:ICEHEAL, proc { |item, pokemon, battler, move, firstAction, battle, scene, showMessages|
  next pbBattleItemCanCureStatus?(:FROZEN, pokemon, scene, showMessages) ||
       pbBattleItemCanCureStatus?(:FROSTBITE, pokemon, scene, showMessages)
})

ItemHandlers::CanUseInBattle.copy(:ICEHEAL, :ASPEARBERRY)

ItemHandlers::BattleUseOnPokemon.add(:ICEHEAL, proc { |item, pokemon, battler, choices, scene|
  oldStatus = pokemon.status
  pokemon.heal_status
  battler&.pbCureStatus(false)
  name = (battler) ? battler.pbThis : pokemon.name
  scene.pbRefresh
  case oldStatus
  when :FROZEN    then scene.pbDisplay(_INTL("{1} was thawed out.", name))
  when :FROSTBITE then scene.pbDisplay(_INTL("{1}'s frostbite was healed.", name))
  end
})

ItemHandlers::BattleUseOnPokemon.copy(:ICEHEAL, :ASPEARBERRY)

################################################################################
# 
# Updates to old battle item handlers (held items).
# 
################################################################################

#===============================================================================
# Lum Berry
#===============================================================================
# Adds Drowsy/Frostbite as statuses that may be healed.
#-------------------------------------------------------------------------------
Battle::ItemEffects::StatusCure.add(:LUMBERRY,
  proc { |item, battler, battle, forced|
    next false if !forced && !battler.canConsumeBerry?
    next false if battler.status == :NONE &&
                  battler.effects[PBEffects::Confusion] == 0
    itemName = GameData::Item.get(item).name
    PBDebug.log("[Item triggered] #{battler.pbThis}'s #{itemName}") if forced
    battle.pbCommonAnimation("EatBerry", battler) if !forced
    oldStatus = battler.status
    oldConfusion = (battler.effects[PBEffects::Confusion] > 0)
    battler.pbCureStatus(forced)
    battler.pbCureConfusion
    if forced
      battle.pbDisplay(_INTL("{1} snapped out of its confusion.", battler.pbThis)) if oldConfusion
    else
      case oldStatus
      when :SLEEP
        battle.pbDisplay(_INTL("{1}'s {2} woke it up!", battler.pbThis, itemName))
      when :POISON
        battle.pbDisplay(_INTL("{1}'s {2} cured its poisoning!", battler.pbThis, itemName))
      when :BURN
        battle.pbDisplay(_INTL("{1}'s {2} healed its burn!", battler.pbThis, itemName))
      when :PARALYSIS
        battle.pbDisplay(_INTL("{1}'s {2} cured its paralysis!", battler.pbThis, itemName))
      when :FROZEN
        battle.pbDisplay(_INTL("{1}'s {2} defrosted it!", battler.pbThis, itemName))
      when :DROWSY
        battle.pbDisplay(_INTL("{1}'s {2} made it alert again!", battler.pbThis, itemName))
      when :FROSTBITE
        battle.pbDisplay(_INTL("{1}'s {2} healed its frostbite!", battler.pbThis, itemName))
      end
      if oldConfusion
        battle.pbDisplay(_INTL("{1}'s {2} snapped it out of its confusion!", battler.pbThis, itemName))
      end
    end
    next true
  }
)

#===============================================================================
# Chesto Berry
#===============================================================================
# Adds Drowsiness as a status that may be healed.
#-------------------------------------------------------------------------------
Battle::ItemEffects::StatusCure.add(:CHESTOBERRY,
  proc { |item, battler, battle, forced|
    next false if !forced && !battler.canConsumeBerry?
    next false if ![:SLEEP, :DROWSY].include?(battler.status)
    itemName = GameData::Item.get(item).name
    PBDebug.log("[Item triggered] #{battler.pbThis}'s #{itemName}") if forced
    battle.pbCommonAnimation("EatBerry", battler) if !forced
    case battler.status
    when :SLEEP  then msg = _INTL("{1}'s {2} woke it up!", battler.pbThis, itemName)
    when :DROWSY then msg = _INTL("{1}'s {2} made it alert again!", battler.pbThis, itemName)
    end
    battler.pbCureStatus(forced)
    battle.pbDisplay(msg) if !forced
    next true
  }
)

#===============================================================================
# Aspear Berry
#===============================================================================
# Adds Frostbite as a status that may be healed.
#-------------------------------------------------------------------------------
Battle::ItemEffects::StatusCure.add(:ASPEARBERRY,
  proc { |item, battler, battle, forced|
    next false if !forced && !battler.canConsumeBerry?
    next false if ![:FROZEN, :FROSTBITE].include?(battler.status)
    itemName = GameData::Item.get(item).name
    PBDebug.log("[Item triggered] #{battler.pbThis}'s #{itemName}") if forced
    battle.pbCommonAnimation("EatBerry", battler) if !forced
    case battler.status
    when :FROZEN    then msg = _INTL("{1}'s {2} defrosted it!", battler.pbThis, itemName)
    when :FROSTBITE then msg = _INTL("{1}'s {2} healed its frostbite!", battler.pbThis, itemName)
    end
    battler.pbCureStatus(forced)
    battle.pbDisplay(msg) if !forced
    next true
  }
)



## Debug Commands ##
##================##
####################

#-------------------------------------------------------------------------------
# Allows you to set the status count for a Pokemon's Drowsy status in the party.
#-------------------------------------------------------------------------------
MenuHandlers.add(:pokemon_debug_menu, :set_status, {
  "name"   => _INTL("Set status"),
  "parent" => :hp_status_menu,
  "effect" => proc { |pkmn, pkmnid, heldpoke, settingUpBattle, screen|
    if pkmn.egg?
      screen.pbDisplay(_INTL("{1} is an egg.", pkmn.name))
    elsif pkmn.hp <= 0
      screen.pbDisplay(_INTL("{1} is fainted, can't change status.", pkmn.name))
    else
      cmd = 0
      commands = [_INTL("[Cure]")]
      ids = [:NONE]
      GameData::Status.each do |s|
        next if s.id == :NONE
        commands.push(_INTL("Set {1}", s.name))
        ids.push(s.id)
      end
      loop do
        msg = _INTL("Current status: {1}", GameData::Status.get(pkmn.status).name)
        if pkmn.status == :SLEEP
          msg = _INTL("Current status: {1} (turns: {2})",
                      GameData::Status.get(pkmn.status).name, pkmn.statusCount)
        end
        cmd = screen.pbShowCommands(msg, commands, cmd)
        break if cmd < 0
        case cmd
        when 0
          pkmn.heal_status
          screen.pbRefreshSingle(pkmnid)
        else
          count = 0
          cancel = false
          if [:SLEEP, :DROWSY].include?(ids[cmd]) 
            params = ChooseNumberParams.new
            params.setRange(0, 9)
            params.setDefaultValue(3)
			status = (ids[cmd] == :SLEEP) ? "sleep" : "drowsy"
            count = pbMessageChooseNumber(
              _INTL("Set the Pokémon's #{status} count."), params
            ) { screen.pbUpdate }
            cancel = true if count <= 0
          end
          if !cancel
            pkmn.status      = ids[cmd]
            pkmn.statusCount = count
            screen.pbRefreshSingle(pkmnid)
          end
        end
      end
    end
    next false
  }
})

#-------------------------------------------------------------------------------
# Allows you to set the status count for a Pokemon's Drowsy status in battle.
#-------------------------------------------------------------------------------
MenuHandlers.add(:battle_pokemon_debug_menu, :set_status, {
  "name"   => _INTL("Set status"),
  "parent" => :hp_status_menu,
  "usage"  => :both,
  "effect" => proc { |pkmn, battler, battle|
    if pkmn.egg?
      pbMessage("\\ts[]" + _INTL("{1} is an egg.", pkmn.name))
      next
    elsif pkmn.hp <= 0
      pbMessage("\\ts[]" + _INTL("{1} is fainted, can't change status.", pkmn.name))
      next
    end
    cmd = 0
    commands = [_INTL("[Cure]")]
    ids = [:NONE]
    GameData::Status.each do |s|
      next if s.id == :NONE
      commands.push(_INTL("Set {1}", s.name))
      ids.push(s.id)
    end
    loop do
      msg = _INTL("Current status: {1}", GameData::Status.get(pkmn.status).name)
      if pkmn.status == :SLEEP
        msg += " " + _INTL("(turns: {1})", pkmn.statusCount)
      elsif pkmn.status == :POISON && pkmn.statusCount > 0
        if battler
          msg += " " + _INTL("(toxic, count: {1})", battler.effects[PBEffects::Toxic])
        else
          msg += " " + _INTL("(toxic)")
        end
      end
      cmd = pbMessage("\\ts[]" + msg, commands, -1, nil, cmd)
      break if cmd < 0
      case cmd
      when 0
        if battler
          battler.status = :NONE
        else
          pkmn.heal_status
        end
      else
        pkmn_name = (battler) ? battler.pbThis(true) : pkmn.name
        case ids[cmd]
        when :SLEEP, :DROWSY
          params = ChooseNumberParams.new
          params.setRange(0, 99)
          params.setDefaultValue((pkmn.status == :SLEEP) ? pkmn.statusCount : 3)
          params.setCancelValue(-1)
		  status = (ids[cmd] == :SLEEP) ? "sleep" : "drowsy"
          count = pbMessageChooseNumber("\\ts[]" + _INTL("Set {1}'s #{status} count (0-99).", pkmn_name), params)
          next if count < 0
          (battler || pkmn).statusCount = count
        when :POISON
          if pbConfirmMessage("\\ts[]" + _INTL("Make {1} badly poisoned (toxic)?", pkmn_name))
            if battler
              params = ChooseNumberParams.new
              params.setRange(0, 16)
              params.setDefaultValue(battler.effects[PBEffects::Toxic])
              params.setCancelValue(-1)
              count = pbMessageChooseNumber(
                "\\ts[]" + _INTL("Set {1}'s toxic count (0-16).", pkmn_name), params
              )
              next if count < 0
              battler.statusCount = 1
              battler.effects[PBEffects::Toxic] = count
            else
              pkmn.statusCount = 1
            end
          else
            (battler || pkmn).statusCount = 0
          end
        end
        (battler || pkmn).status = ids[cmd]
      end
    end
  }
})
