module Battle::AbilityEffects
  OnTypeChange            = AbilityHandlerHash.new  # Protean, Libero
  OnOpposingStatGain      = AbilityHandlerHash.new  # Opportunist
  ModifyTypeEffectiveness = AbilityHandlerHash.new  # Tera Shell (damage)
  OnMoveSuccessCheck      = AbilityHandlerHash.new  # Tera Shell (display)
  OnInflictingStatus      = AbilityHandlerHash.new  # Poison Puppeteer

  def self.triggerOnStatusInflicted(ability, battler, user, status)
    OnInflictingStatus.trigger(user.ability, user, battler, status) if user && user.abilityActive? # Poison Puppeteer
    OnStatusInflicted.trigger(ability, battler, user, status)
  end
  
  def self.triggerOnSwitchIn(ability, battler, battle, switch_in = false)
    OnSwitchIn.trigger(ability, battler, battle, switch_in)
    battle.allSameSideBattlers(battler.index).each do |b|
      next if !b.hasActiveAbility?(:COMMANDER)
      next if b.effects[PBEffects::Commander]
      OnSwitchIn.trigger(b.ability, b, battle, switch_in)      
    end
  end

  def self.triggerOnTypeChange(ability, battler, type)
    OnTypeChange.trigger(ability, battler, type)
  end

  def self.triggerOnOpposingStatGain(ability, battler, battle, statUps)
    OnOpposingStatGain.trigger(ability, battler, battle, statUps)
  end
  
  def self.triggerModifyTypeEffectiveness(ability, user, target, move, battle, effectiveness)
    return trigger(ModifyTypeEffectiveness, ability, user, target, move, battle, effectiveness, ret: effectiveness)
  end
  
  def self.triggerOnMoveSuccessCheck(ability, user, target, move, battle)
    OnMoveSuccessCheck.trigger(ability, user, target, move, battle)
  end

  def self.triggerOnInflictingStatus(ability, battler, user, status)
    OnInflictingStatus.trigger(ability, battler, user, status)
  end
end

module Battle::ItemEffects
  OnOpposingStatGain = ItemHandlerHash.new # Mirror Herb
  StatLossImmunity   = ItemHandlerHash.new # Clear Amulet
  
  def self.triggerOnOpposingStatGain(item, battler, battle, statUps, forced)
    return trigger(OnOpposingStatGain, item, battler, battle, statUps, forced)
  end

  def self.triggerStatLossImmunity(item, battler, stat, battle, show_message)
    return trigger(StatLossImmunity, item, battler, stat, battle, show_message)
  end
end

#===============================================================================
# Opportunist
#===============================================================================
Battle::AbilityEffects::OnOpposingStatGain.add(:OPPORTUNIST,
  proc { |ability, battler, battle, statUps|
    showAnim = true
    battle.pbShowAbilitySplash(battler)
    statUps.each do |stat, increment|
      next if !battler.pbCanRaiseStatStage?(stat, battler)
      if battler.pbRaiseStatStage(stat, increment, battler, showAnim)
        showAnim = false
      end
    end
    battle.pbDisplay(_INTL("{1}'s stats won't go any higher!", battler.pbThis)) if showAnim
    battle.pbHideAbilitySplash(battler)
    battler.pbItemOpposingStatGainCheck(statUps)
    # Mirror Herb can trigger off this ability.
    if !showAnim 
      opposingStatUps = battle.sideStatUps[battler.idxOwnSide]
      battle.allOtherSideBattlers(battler.index).each do |b|
        next if !b || b.fainted?
        if b.itemActive?
          b.pbItemOpposingStatGainCheck(opposingStatUps)
        end
      end
      opposingStatUps.clear
    end
  }
)