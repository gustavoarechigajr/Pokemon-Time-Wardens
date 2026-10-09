module Battle::AbilityEffects
  EndOfRoundTerrain = AbilityHandlerHash.new
  
  def self.triggerEndOfRoundTerrain(ability, battler, battle)
    EndOfRoundTerrain.trigger(ability, battler, battle)
  end
end

Battle::AbilityEffects::EndOfRoundTerrain.add(:TELEFACE,
  proc { |ability, battler, battle|
    next if battle.field.terrain != :Electric
    next if !battler.canRestoreTeleFace || battler.form != 1
    battle.pbShowAbilitySplash(battler)
    if !Battle::Scene::USE_ABILITY_SPLASH
      battle.pbDisplay(_INTL("{1}'s {2} activated!", battler.pbThis, battler.abilityName))
    end
    battler.pbChangeForm(0, _INTL("{1} transformed!", battler.pbThis))
    battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:TELEFACE,
  proc { |ability, battler, battle, switch_in|
    next if !battler.isSpecies?(:EISCUE) || battler.form != 1
    next if battle.field.terrain != :Electric
    battle.pbShowAbilitySplash(battler)
    if !Battle::Scene::USE_ABILITY_SPLASH
      battle.pbDisplay(_INTL("{1}'s {2} activated!", battler.pbThis, battler.abilityName))
    end
    battler.pbChangeForm(0, _INTL("{1} transformed!", battler.pbThis))
    battle.pbHideAbilitySplash(battler)
  }
)

class Battle::Move
  def pbReduceDamage(user, target)
    damage = target.damageState.calcDamage
    # Substitute takes the damage
    if target.damageState.substitute
      damage = target.effects[PBEffects::Substitute] if damage > target.effects[PBEffects::Substitute]
      target.damageState.hpLost       = damage
      target.damageState.totalHPLost += damage
      return
    end
    # Disguise/Ice Face takes the damage
    return if target.damageState.disguise || target.damageState.iceFace || target.damageState.teleFace
    # Target takes the damage
    if damage >= target.hp
      damage = target.hp
      # Survive a lethal hit with 1 HP effects
      if nonLethal?(user, target)
        damage -= 1
      elsif target.effects[PBEffects::Endure]
        target.damageState.endured = true
        damage -= 1
      elsif damage == target.totalhp
        if target.hasActiveAbility?(:STURDY) && !@battle.moldBreaker
          target.damageState.sturdy = true
          damage -= 1
        elsif target.hasActiveItem?(:FOCUSSASH) && target.hp == target.totalhp
          target.damageState.focusSash = true
          damage -= 1
        elsif target.hasActiveItem?(:FOCUSBAND) && @battle.pbRandom(100) < 10
          target.damageState.focusBand = true
          damage -= 1
        elsif Settings::AFFECTION_EFFECTS && @battle.internalBattle &&
              target.pbOwnedByPlayer? && !target.mega?
          chance = [0, 0, 0, 10, 15, 25][target.affection_level]
          if chance > 0 && @battle.pbRandom(100) < chance
            target.damageState.affection_endured = true
            damage -= 1
          end
        end
      end
    end
    damage = 0 if damage < 0
    target.damageState.hpLost       = damage
    target.damageState.totalHPLost += damage
  end

  #=============================================================================
  # Messages upon being hit
  #=============================================================================
  def pbEndureKOMessage(target)
    if target.damageState.disguise
      @battle.pbShowAbilitySplash(target)
      if Battle::Scene::USE_ABILITY_SPLASH
        @battle.pbDisplay(_INTL("Its disguise served it as a decoy!"))
      else
        @battle.pbDisplay(_INTL("{1}'s disguise served it as a decoy!", target.pbThis))
      end
      @battle.pbHideAbilitySplash(target)
      target.pbChangeForm(1, _INTL("{1}'s disguise was busted!", target.pbThis))
      target.pbReduceHP(target.totalhp / 8, false) if Settings::MECHANICS_GENERATION >= 8
    elsif target.damageState.iceFace
      @battle.pbShowAbilitySplash(target)
      if !Battle::Scene::USE_ABILITY_SPLASH
        @battle.pbDisplay(_INTL("{1}'s {2} activated!", target.pbThis, target.abilityName))
      end
      target.pbChangeForm(1, _INTL("{1} transformed!", target.pbThis))
      @battle.pbHideAbilitySplash(target)
    elsif target.damageState.teleFace
      @battle.pbShowAbilitySplash(target)
      if !Battle::Scene::USE_ABILITY_SPLASH
        @battle.pbDisplay(_INTL("{1}'s {2} activated!", target.pbThis, target.abilityName))
      end
      target.pbChangeForm(1, _INTL("{1} transformed!", target.pbThis))
      @battle.pbHideAbilitySplash(target)
    elsif target.damageState.endured
      @battle.pbDisplay(_INTL("{1} endured the hit!", target.pbThis))
    elsif target.damageState.sturdy
      @battle.pbShowAbilitySplash(target)
      if Battle::Scene::USE_ABILITY_SPLASH
        @battle.pbDisplay(_INTL("{1} endured the hit!", target.pbThis))
      else
        @battle.pbDisplay(_INTL("{1} hung on with Sturdy!", target.pbThis))
      end
      @battle.pbHideAbilitySplash(target)
    elsif target.damageState.focusSash
      @battle.pbCommonAnimation("UseItem", target)
      @battle.pbDisplay(_INTL("{1} hung on using its Focus Sash!", target.pbThis))
      target.pbConsumeItem
    elsif target.damageState.focusBand
      @battle.pbCommonAnimation("UseItem", target)
      @battle.pbDisplay(_INTL("{1} hung on using its Focus Band!", target.pbThis))
    elsif target.damageState.affection_endured
      @battle.pbDisplay(_INTL("{1} toughed it out so you wouldn't feel sad!", target.pbThis))
    end
  end

  #=============================================================================
  # Weaken the damage dealt (doesn't actually change a battler's HP)
  #=============================================================================
  def pbCheckDamageAbsorption(user, target)
    # Substitute will take the damage
    if target.effects[PBEffects::Substitute] > 0 && !ignoresSubstitute?(user) &&
       (!user || user.index != target.index)
      target.damageState.substitute = true
      return
    end
    # Ice Face will take the damage
    if !@battle.moldBreaker && target.isSpecies?(:EISCUE) &&
       target.form == 0 && target.ability == :TELEFACE && physicalMove?
      target.damageState.teleFace = true
      return
    end
    # Disguise will take the damage
    if !@battle.moldBreaker && (target.isSpecies?(:MIMIKYU) || target.isSpecies?(:MIMIKYU2)) &&
       target.form == 0 && target.ability == :DISGUISE
      target.damageState.disguise = true
      return
    end
  end
end
