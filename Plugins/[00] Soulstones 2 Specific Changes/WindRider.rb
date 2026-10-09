class Battle::Move
  def windMove?; return @flags.any? { |f| f[/^Wind$/i] }; end
end

#===============================================================================
# Tailwind
#===============================================================================
# Adds Wind Rider and Wind Power procs.
#-------------------------------------------------------------------------------
class Battle::Move::StartUserSideDoubleSpeed < Battle::Move
  def canSnatch?; return true; end

  def pbMoveFailed?(user, targets)
    if user.pbOwnSide.effects[PBEffects::Tailwind] > 0
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    user.pbOwnSide.effects[PBEffects::Tailwind] = 4
    @battle.pbDisplay(_INTL("The Tailwind blew from behind {1}!", user.pbTeam(true)))
    @battle.allSameSideBattlers.each do |b| 
      next if !b || b.fainted?
      if b.hasActiveAbility?(:WINDRIDER)
        b.pbRaiseStatStageByAbility(:ATTACK, 1, b) if b.pbCanRaiseStatStage?(:ATTACK, b, self)
        b.pbRaiseStatStageByAbility(:SPECIAL_ATTACK, 1, b) if b.pbCanRaiseStatStage?(:SPECIAL_ATTACK, b, self)
      elsif b.hasActiveAbility?(:WINDPOWER) && b.effects[PBEffects::Charge] == 0
        @battle.pbShowAbilitySplash(b)
        b.effects[PBEffects::Charge] = 2
        @battle.pbDisplay(_INTL("Being hit by Tailwind charged {1} with power!", b.pbThis(true)))
        @battle.pbHideAbilitySplash(b)
      end
    end
  end
end

#===============================================================================
# Wind Rider
#===============================================================================
Battle::AbilityEffects::MoveImmunity.add(:WINDRIDER,
  proc { |ability, user, target, move, type, battle, show_message|
    next false if !move.windMove?
    next false if user.index == target.index
    if show_message
      battle.pbShowAbilitySplash(target)
      if target.pbCanRaiseStatStage?(:ATTACK, user, move)
        if Battle::Scene::USE_ABILITY_SPLASH
          target.pbRaiseStatStage(:ATTACK, 1, user)
          target.pbRaiseStatStage(:SPECIAL_ATTACK, 1, user) if target.pbCanRaiseStatStage?(:SPECIAL_ATTACK, user, move)
        else
          target.pbRaiseStatStageByCause(:ATTACK, 1, user, target.abilityName)
          target.pbRaiseStatStageByCause(:SPECIAL_ATTACK, 1, user, target.abilityName) if target.pbCanRaiseStatStage?(:SPECIAL_ATTACK, user, move)
        end
      elsif Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("It doesn't affect {1}...", target.pbThis(true)))
      else
        battle.pbDisplay(_INTL("{1}'s {2} made {3} ineffective!", target.pbThis, target.abilityName, move.name))
      end
      battle.pbHideAbilitySplash(target)
    end
    next true
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:WINDRIDER,
  proc { |ability, battler, battle, switch_in|
    next if battler.pbOwnSide.effects[PBEffects::Tailwind] <= 0
    next if !battler.pbCanRaiseStatStage?(:ATTACK, battler)
    next if !battler.pbCanRaiseStatStage?(:SPECIAL_ATTACK, battler)
    battler.pbRaiseStatStageByAbility(:ATTACK, 1, battler)
    battler.pbRaiseStatStageByAbility(:SPECIAL_ATTACK, 1, battler)
  }
)
