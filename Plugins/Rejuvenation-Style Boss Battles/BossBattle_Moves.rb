class Battle::Move::SwitchOutTargetStatusMove < Battle::Move
  def pbFailsAgainstTarget?(user, target, show_message)
    if target.hasActiveAbility?(:SUCTIONCUPS) && !@battle.moldBreaker
      if show_message
        @battle.pbShowAbilitySplash(target)
        if Battle::Scene::USE_ABILITY_SPLASH
          @battle.pbDisplay(_INTL("{1} anchors itself!", target.pbThis))
        else
          @battle.pbDisplay(_INTL("{1} anchors itself with {2}!", target.pbThis, target.abilityName))
        end
        @battle.pbHideAbilitySplash(target)
      end
      return true
    end
    if target.effects[PBEffects::Ingrain]
      @battle.pbDisplay(_INTL("{1} anchored itself with its roots!", target.pbThis)) if show_message
      return true
    end
    if !@battle.canRun
      @battle.pbDisplay(_INTL("But it failed!")) if show_message
      return true
    end
    if @battle.wildBattle? && target.level > user.level
      @battle.pbDisplay(_INTL("But it failed!")) if show_message
      return true
    end
    if @battle.trainerBattle?
      canSwitch = false
      @battle.eachInTeamFromBattlerIndex(target.index) do |_pkmn, i|
        next if !@battle.pbCanSwitchLax?(target.index, i)
        canSwitch = true
        break
      end
      if !canSwitch
        @battle.pbDisplay(_INTL("But it failed!")) if show_message
        return true
      end
    end
    if target.isbossmon
      @battle.pbDisplay(_INTL("{1} is immovable!", target.pbThis)) if show_message
      return true
    end
    return false
  end

  def pbSwitchOutTargetEffect(user, targets, numHits, switched_battlers)
    return if @battle.wildBattle? || !switched_battlers.empty?
    return if user.fainted? || numHits == 0
    targets.each do |b|
      next if b.fainted? || b.damageState.unaffected
      next if b.effects[PBEffects::Ingrain]
      next if b.hasActiveAbility?(:SUCTIONCUPS) && !@battle.moldBreaker
      next if b.isbossmon
      newPkmn = @battle.pbGetReplacementPokemonIndex(b.index, true)   # Random
      next if newPkmn < 0
      @battle.pbRecallAndReplace(b.index, newPkmn, true)
      @battle.pbDisplay(_INTL("{1} was dragged out!", b.pbThis))
      @battle.pbClearChoice(b.index)   # Replacement Pokémon does nothing this round
      @battle.pbOnBattlerEnteringBattle(b.index)
      switched_battlers.push(b.index)
      break
    end
  end
end

class Battle::Move::SwitchOutTargetDamagingMove < Battle::Move
  def pbEffectAgainstTarget(user, target)
    if @battle.wildBattle? && target.level <= user.level && @battle.canRun &&
       (target.effects[PBEffects::Substitute] == 0 || ignoresSubstitute?(user)) && !target.isbossmon
      @battle.decision = 3
    end
  end

  def pbSwitchOutTargetEffect(user, targets, numHits, switched_battlers)
    return if @battle.wildBattle? || !switched_battlers.empty?
    return if user.fainted? || numHits == 0
    targets.each do |b|
      next if b.fainted? || b.damageState.unaffected || b.damageState.substitute
      next if b.effects[PBEffects::Ingrain]
      next if b.hasActiveAbility?([:SUCTIONCUPS,:GUARDDOG]) && !@battle.moldBreaker
      next if b.isbossmon
      newPkmn = @battle.pbGetReplacementPokemonIndex(b.index, true)   # Random
      next if newPkmn < 0
      @battle.pbRecallAndReplace(b.index, newPkmn, true)
      @battle.pbDisplay(_INTL("{1} was dragged out!", b.pbThis))
      @battle.pbClearChoice(b.index)   # Replacement Pokémon does nothing this round
      @battle.pbOnBattlerEnteringBattle(b.index)
      switched_battlers.push(b.index)
      break
    end
  end
end


class Battle::Move::UserTakesTargetItem < Battle::Move
  def pbEffectAfterAllHits(user, target)
    return if user.wild?   # Wild Pokémon can't thieve
    return if user.fainted?
    return if target.damageState.unaffected || target.damageState.substitute
    return if !target.item
    return if target.unlosableItem?(target.item)
    return if user.unlosableItem?(target.item)
    return if target.hasActiveAbility?(:STICKYHOLD) && !@battle.moldBreaker
    return if target.isbossmon
    itemName = target.itemName
    user.item = target.item
    # Permanently steal the item from wild Pokémon
    if target.wild? && user.initialItem == nil && target.item == target.initialItem
      user.setInitialItem(target.item)
      target.pbRemoveItem
      @battle.pbDisplay(_INTL("{1} stole {2}'s {3}!", user.pbThis, target.pbThis(true), itemName))
    elsif target.wild? && user.initialItem != nil && target.item == target.initialItem
      $bag.add(target.item)
      target.pbRemoveItem
      @battle.pbDisplay(_INTL("{1} stole {2}'s {3} and sent it to {4}'s bag.", user.pbThis, target.pbThis(true), itemName, $player.name))
    else
      target.pbRemoveItem(false)
    end
    @battle.pbDisplay(_INTL("{1} stole {2}'s {3}!", user.pbThis, target.pbThis(true), itemName))
    user.pbHeldItemTriggerCheck
  end
end

class Battle::Move::TargetTakesUserItem < Battle::Move
  def pbFailsAgainstTarget?(user, target, show_message)
    if target.item || target.unlosableItem?(user.item)
      @battle.pbDisplay(_INTL("But it failed!")) if show_message
      return true
    end
    if target.isbossmon
      @battle.pbDisplay(_INTL("{1}'s aura doesn't let it's item changed!", target.pbThis)) if show_message
      return true
    end
    return false
  end
end

class Battle::Move::UserTargetSwapItems < Battle::Move
  def pbFailsAgainstTarget?(user, target, show_message)
    if !user.item && !target.item
      @battle.pbDisplay(_INTL("But it failed!")) if show_message
      return true
    end
    if target.unlosableItem?(target.item) ||
       target.unlosableItem?(user.item) ||
       user.unlosableItem?(user.item) ||
       user.unlosableItem?(target.item)
      @battle.pbDisplay(_INTL("But it failed!")) if show_message
      return true
    end
    if target.isbossmon
      @battle.pbDisplay(_INTL("The {1}'s aura doesnt allow it to lose it's item!", target.pbThis))
      return true
    end
    if target.hasActiveAbility?(:STICKYHOLD) && !@battle.moldBreaker
      if show_message
        @battle.pbShowAbilitySplash(target)
        if Battle::Scene::USE_ABILITY_SPLASH
          @battle.pbDisplay(_INTL("But it failed to affect {1}!", target.pbThis(true)))
        else
          @battle.pbDisplay(_INTL("But it failed to affect {1} because of its {2}!",
                                  target.pbThis(true), target.abilityName))
        end
        @battle.pbHideAbilitySplash(target)
      end
      return true
    end
    return false
  end
end
