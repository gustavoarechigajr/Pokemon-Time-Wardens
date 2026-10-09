# Changed by DemICE 27-Sep-2023 Implementing difficulty modes.
class Player < Trainer
  attr_accessor :difficulty_mode

  alias difficulty_modes_initialize initialize
  def initialize(name, trainer_type)
    difficulty_modes_initialize(name, trainer_type) 
    @difficulty_mode=0
  end
end

# class Battle::Battler   # DemICE alas, this didn't work.
#   #=============================================================================
#   # Change HP
#   #=============================================================================
#   alias unfair_mode_pbReduceHP pbReduceHP
#   def pbReduceHP(amt, anim = true, registerDamage = true, anyAnim = true)
#   amt *= 1 - @level/500.00 if !pbOwnedByPlayer? && $Trainer.difficulty_mode==2  # Changed by DemICE 27-Sep-2023 Unfair difficulty
#   return unfair_mode_pbReduceHP(amt, anim, registerDamage, anyAnim)
#   end
# end

class Battle::Move
  alias unfair_mode_pbCalcDamageMultipliers pbCalcDamageMultipliers
  def pbCalcDamageMultipliers(user, target, numTargets, type, baseDmg, multipliers)
    unfair_mode_pbCalcDamageMultipliers(user, target, numTargets, type, baseDmg, multipliers)
    # Changed by DemICE 27-Sep-2023 Unfair difficulty
    if $Trainer.difficulty_mode==2
      if user.pbOwnedByPlayer?
        multipliers[:final_damage_multiplier] *= 1 - 0.1 - target.level/500.00
      else
        multipliers[:final_damage_multiplier] *= 1 + 0.1 + user.level/500.00 
      end
    elsif $Trainer.difficulty_mode==0 && !user.pbOwnedByPlayer?
      strd_mult = ($PokemonSystem.standard_mode_damage_mult.is_a?(Integer)) ? ($PokemonSystem.standard_mode_damage_mult.to_f / 100) : 0
      multipliers[:final_damage_multiplier] /= (1.1 - strd_mult) if strd_mult > 0
      Console.echoln("Final Damage Multiplier: #{multipliers[:final_damage_multiplier]}")
      Console.echoln("Standard Mode Multiplier: #{strd_mult}")
      Console.echoln("$PokemonSystem.standard_mode_damage_mult = (#{$PokemonSystem.standard_mode_damage_mult})")
    end
  end

  alias unfair_mode_pbCalcAccuracyModifiers pbCalcAccuracyModifiers
  def pbCalcAccuracyModifiers(user, target, modifiers)
    unfair_mode_pbCalcAccuracyModifiers(user, target, modifiers)
    if ["demicesun","demiceblackhole","demiceasteroids","demiceouterspace"].include?(@battle.backdrop)
      modifiers[:accuracy_multiplier] *= 1.3 if !user.pbOwnedByPlayer?
    else
      # Changed by DemICE 27-Sep-2023 Adept difficulty
      modifiers[:accuracy_multiplier] *= 1.15 if !user.pbOwnedByPlayer? && $Trainer.difficulty_mode==1
      # Changed by DemICE 27-Sep-2023 Unfair difficulty
      modifiers[:accuracy_multiplier] *= 1.3 if !user.pbOwnedByPlayer? && $Trainer.difficulty_mode==2
    end  
  end

  alias unfair_mode_pbAdditionalEffectChance pbAdditionalEffectChance
  def pbAdditionalEffectChance(user, target, effectChance = 0)
    ret = unfair_mode_pbAdditionalEffectChance(user, target, effectChance)
    ret *= 1.2 if !user.pbOwnedByPlayer? && $Trainer.difficulty_mode==2
    return ret
  end

  def pbIsCritical?(user, target)
    return false if target.pbOwnSide.effects[PBEffects::LuckyChant] > 0
    # Set up the critical hit ratios
    if !user.pbOwnedByPlayer? && $Trainer.difficulty_mode==2 && (target.stages[:DEFENSE] || target.stages[:SPECIAL_DEFENSE]) > 0
      ratios = (Settings::NEW_CRITICAL_HIT_RATE_MECHANICS) ? [8, 3, 2, 1] : [16, 8, 4, 3, 2]
    else
      ratios = (Settings::NEW_CRITICAL_HIT_RATE_MECHANICS) ? [24, 8, 2, 1] : [16, 8, 4, 3, 2]
    end
    c = 0
    # Ability effects that alter critical hit rate
    if c >= 0 && user.abilityActive?
      c = Battle::AbilityEffects.triggerCriticalCalcFromUser(user.ability, user, target, c)
    end
    if c >= 0 && target.abilityActive? && !@battle.moldBreaker
      c = Battle::AbilityEffects.triggerCriticalCalcFromTarget(target.ability, user, target, c)
    end
    # Item effects that alter critical hit rate
    if c >= 0 && user.itemActive?
      c = Battle::ItemEffects.triggerCriticalCalcFromUser(user.item, user, target, c)
    end
    if c >= 0 && target.itemActive?
      c = Battle::ItemEffects.triggerCriticalCalcFromTarget(target.item, user, target, c)
    end
    return false if c < 0
    # Move-specific "always/never a critical hit" effects
    case pbCritialOverride(user, target)
    when 1  then return true
    when -1 then return false
    end
    # Other effects
    return true if c > 50   # Merciless
    return true if user.effects[PBEffects::LaserFocus] > 0
    c += 1 if highCriticalRate?
    c += user.effects[PBEffects::FocusEnergy]
    c += 1 if user.inHyperMode? && @type == :SHADOW
    c = ratios.length - 1 if c >= ratios.length
    # Calculation
    return true if ratios[c] == 1
    r = @battle.pbRandom(ratios[c])
    return true if r == 0
    if r == 1 && Settings::AFFECTION_EFFECTS && @battle.internalBattle &&
       user.pbOwnedByPlayer? && user.affection_level == 5 && !target.mega?
      target.damageState.affection_critical = true
      return true
    end
    return false
  end
end

class Battle::AI
  alias unfair_mode_pbCalcAccuracyModifiers pbCalcAccuracyModifiers
  def pbCalcAccuracyModifiers(user, target, modifiers, move, type, skill)
    # Changed by DemICE 27-Sep-2023 Adept difficulty
    modifiers[:accuracy_multiplier] *= 1.15 if !user.pbOwnedByPlayer? && $Trainer.difficulty_mode==1
    # Changed by DemICE 27-Sep-2023 Unfair difficulty
    modifiers[:accuracy_multiplier] *= 1.3 if !user.pbOwnedByPlayer? && $Trainer.difficulty_mode==2
  end
end

class Battle::Battler
  alias unfair_mode_pbInitPokemon pbInitPokemon
  def pbInitPokemon(pkmn,idxParty)
    unfair_mode_pbInitPokemon(pkmn,idxParty)
    if !pbOwnedByPlayer?
      @moves.each { |move| move.pp*=1.6 } if $Trainer.difficulty_mode==1
      @moves.each { |move| move.pp*=2 }   if $Trainer.difficulty_mode==2
    end
  end

  def pbSleepDuration(duration = -1)
    duration = 2 + @battle.pbRandom(3) if duration <= 0
    duration -=1 if duration >2 && !pbOwnedByPlayer? && $Trainer.difficulty_mode==2
    duration = (duration / 2).floor if hasActiveAbility?(:EARLYBIRD)
    return duration
  end

  def pbTryUseMove(choice, move, specialUsage, skipAccuracyCheck)
    # Check whether it's possible for self to use the given move
    # NOTE: Encore has already changed the move being used, no need to have a
    #     check for it here.
    if !pbCanChooseMove?(move, false, true, specialUsage)
      @lastMoveFailed = true
      return false
    end
    # Check whether it's possible for self to do anything at all
    if @effects[PBEffects::SkyDrop] >= 0   # Intentionally no message here
      PBDebug.log("[Move failed] #{pbThis} can't use #{move.name} because of being Sky Dropped")
      return false
    end
    if @effects[PBEffects::HyperBeam] > 0 && move.function != "AttackTwoTurnsLater"  # Intentionally before Truant
      @battle.pbDisplay(_INTL("{1} must recharge!", pbThis))
      return false
    end
    if choice[1] == -2   # Battle Palace
      @battle.pbDisplay(_INTL("{1} appears incapable of using its power!", pbThis))
      return false
    end
    # Skip checking all applied effects that could make self fail doing something
    return true if skipAccuracyCheck
    # Check status problems and continue their effects/cure them
    case @status
    when :SLEEP
      self.statusCount -= 1
      if @statusCount <= 0
      pbCureStatus
      else
      pbContinueStatus
      if !move.usableWhenAsleep?   # Snore/Sleep Talk
        @lastMoveFailed = true
        return false
      end
      end
    when :FROZEN
      if !move.thawsUser?
      chance=20
      chance=50 if !pbOwnedByPlayer? && $Trainer.difficulty_mode==2
      if @battle.pbRandom(100) < chance
        pbCureStatus
      else
        pbContinueStatus
        @lastMoveFailed = true
        return false
      end
      end
    end
    # Obedience check
    return false if !pbObedienceCheck?(choice)
    # Truant
    if hasActiveAbility?(:TRUANT)
      @effects[PBEffects::Truant] = !@effects[PBEffects::Truant]
      if !@effects[PBEffects::Truant]   # True means loafing, but was just inverted
      @battle.pbShowAbilitySplash(self)
      @battle.pbDisplay(_INTL("{1} is loafing around!", pbThis))
      @lastMoveFailed = true
      @battle.pbHideAbilitySplash(self)
      return false
      end
    end
    # Flinching
    if @effects[PBEffects::Flinch]
      @battle.pbDisplay(_INTL("{1} flinched and couldn't move!", pbThis))
      if abilityActive?
    Battle::AbilityEffects.triggerOnFlinch(self.ability, self, @battle)
      end
      @lastMoveFailed = true
      return false
    end
    # Confusion
    if @effects[PBEffects::Confusion] > 0
      @effects[PBEffects::Confusion] -= 1
      if @effects[PBEffects::Confusion] <= 0
      pbCureConfusion
      @battle.pbDisplay(_INTL("{1} snapped out of its confusion.", pbThis))
      else
      @battle.pbCommonAnimation("Confusion", self)
      @battle.pbDisplay(_INTL("{1} is confused!", pbThis))
      threshold = (Settings::MECHANICS_GENERATION >= 7) ? 33 : 50   # % chance
      if @battle.pbRandom(100) < threshold
        pbConfusionDamage(_INTL("It hurt itself in its confusion!"))
        @lastMoveFailed = true
        return false
      end
      end
    end
    # Paralysis
      chance=25
      chance=10 if !pbOwnedByPlayer? && $Trainer.difficulty_mode==2
    if @status == :PARALYSIS && @battle.pbRandom(100) < 25
      pbContinueStatus
      @lastMoveFailed = true
      return false
    end
    # Infatuation
    if @effects[PBEffects::Attract] >= 0
      @battle.pbCommonAnimation("Attract", self)
      @battle.pbDisplay(_INTL("{1} is in love with {2}!", pbThis,
                  @battle.battlers[@effects[PBEffects::Attract]].pbThis(true)))
      if @battle.pbRandom(100) < 50
      @battle.pbDisplay(_INTL("{1} is immobilized by love!", pbThis))
      @lastMoveFailed = true
      return false
      end
    end
    return true
  end
end

class Battle::Move::RandomPowerDoublePowerIfTargetUnderground < Battle::Move
  def pbOnStartUse(user, targets)
    baseDmg = [10, 30, 50, 70, 90, 110, 150]
    if user.pbOwnedByPlayer?
      magnitudes = [4, 5, 5, 6, 6, 6, 6, 7, 7, 7, 7, 7, 7, 8, 8, 8, 8, 9, 9, 10]
    else
    case $Trainer.difficulty_mode
      when 2; magnitudes = [7, 7, 7, 7, 7, 7, 7, 8, 8, 8, 8, 8, 8, 9, 9, 9, 9, 10, 10, 10]
      when 1; magnitudes = [6, 6, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8, 8, 8, 8, 9, 9, 10]
      else; magnitudes = [4, 5, 5, 6, 6, 6, 6, 7, 7, 7, 7, 7, 7, 8, 8, 8, 8, 9, 9, 10]
      end
    end
    magni = magnitudes[@battle.pbRandom(magnitudes.length)]
    @magnitudeDmg = baseDmg[magni - 4]
    @battle.pbDisplay(_INTL("Magnitude {1}!", magni))
  end
end

#===============================================================================
# Hits 2-5 times.
#===============================================================================
class Battle::Move::HitTwoToFiveTimes < Battle::Move
  def pbNumHits(user, targets)
    if user.pbOwnedByPlayer?
      hitChances = [
        2, 2, 2, 2, 2, 2, 2,
        3, 3, 3, 3, 3, 3, 3,
        4, 4, 4,
        5, 5, 5
      ]
    else
      case $Trainer.difficulty_mode
      when 2
        hitChances = [
          3, 3, 3, 3, 3, 3, 3,
          4, 4, 4, 4, 4, 4, 4,
          5, 5, 5,
          5, 5, 5
        ]
      when 1
        hitChances = [
          3, 3, 3, 3, 3, 3, 3,
          3, 3, 3, 3, 3, 3, 3,
          4, 4, 4,
          5, 5, 5
        ]
      else
        hitChances = [
          2, 2, 2, 2, 2, 2, 2,
          3, 3, 3, 3, 3, 3, 3,
          4, 4, 4,
          5, 5, 5
        ]
      end
    end
    r = @battle.pbRandom(hitChances.length)
    r = hitChances.length - 1 if user.hasActiveAbility?(:SKILLLINK)
    chances = hitChances[r]
    chances = 5 - rand(2) if user.hasActiveItem?(:LOADEDDICE)
    return chances
  end
end
#===============================================================================
# Hits 2-5 times in a row. If the move does not fail, increases the user's Speed
# by 1 stage and decreases the user's Defense by 1 stage. (Scale Shot)
#===============================================================================
class Battle::Move::HitTwoToFiveTimesRaiseUserSpd1LowerUserDef1 < Battle::Move
  def pbNumHits(user, targets)
    if user.pbOwnedByPlayer?
      hitChances = [2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 5, 5, 5]
    else
      case $Trainer.difficulty_mode
        when 2; hitChances = [3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5 ]
        when 1; hitChances = [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 5, 5, 5 ]
        else; hitChances = [2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 5, 5, 5 ]
      end
    end
    r = @battle.pbRandom(hitChances.length)
    r = hitChances.length - 1 if user.hasActiveAbility?(:SKILLLINK)
    chances = hitChances[r]
    chances = 5 - rand(2) if user.hasActiveItem?(:LOADEDDICE)
    return chances
  end
end

Battle::AbilityEffects::EndOfRoundHealing.add(:SHEDSKIN,
  proc { |ability, battler, battle|
    next if battler.status == :NONE
    chance=30
    chance=50 if !battler.pbOwnedByPlayer? && $Trainer.difficulty_mode==2
    next unless battle.pbRandom(100) < chance
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
    end
    end
    battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::OnBeingHit.add(:CURSEDBODY,
  proc { |ability, user, target, move, battle|
    next if user.fainted?
    next if user.effects[PBEffects::Disable] > 0
    regularMove = nil
    user.eachMove do |m|
    next if m.id != user.lastRegularMoveUsed
    regularMove = m
    break
    end
    next if !regularMove || (regularMove.pp == 0 && regularMove.total_pp > 0)
    chance=30
    chance=50 if !target.pbOwnedByPlayer? && $Trainer.difficulty_mode==2
    next if battle.pbRandom(100) >= chance
    battle.pbShowAbilitySplash(target)
    if !move.pbMoveFailedAromaVeil?(target, user, Battle::Scene::USE_ABILITY_SPLASH)
    user.effects[PBEffects::Disable]   = 3
    user.effects[PBEffects::DisableMove] = regularMove.id
    if Battle::Scene::USE_ABILITY_SPLASH
      battle.pbDisplay(_INTL("{1}'s {2} was disabled!", user.pbThis, regularMove.name))
    else
      battle.pbDisplay(_INTL("{1}'s {2} was disabled by {3}'s {4}!",
       user.pbThis, regularMove.name, target.pbThis(true), target.abilityName))
    end
    battle.pbHideAbilitySplash(target)
    user.pbItemStatusCureCheck
    end
    battle.pbHideAbilitySplash(target)
  }
)

Battle::AbilityEffects::OnDealingHit.add(:POISONTOUCH,
  proc { |ability, user, target, move, battle|
    next if !move.contactMove?
    chance=30
    chance=50 if !user.pbOwnedByPlayer? && $Trainer.difficulty_mode==2
    next if battle.pbRandom(100) >= chance
    battle.pbShowAbilitySplash(user)
    if target.hasActiveAbility?(:SHIELDDUST) && !battle.moldBreaker
    battle.pbShowAbilitySplash(target)
    if !Battle::Scene::USE_ABILITY_SPLASH
      battle.pbDisplay(_INTL("{1} is unaffected!", target.pbThis))
    end
    battle.pbHideAbilitySplash(target)
    elsif target.pbCanPoison?(user, Battle::Scene::USE_ABILITY_SPLASH)
    msg = nil
    if !Battle::Scene::USE_ABILITY_SPLASH
      msg = _INTL("{1}'s {2} poisoned {3}!", user.pbThis, user.abilityName, target.pbThis(true))
    end
    target.pbPoison(user, msg)
    end
    battle.pbHideAbilitySplash(user)
  }
)

Battle::AbilityEffects::OnBeingHit.add(:EFFECTSPORE,
  proc { |ability, user, target, move, battle|
    # NOTE: This ability has a 30% chance of triggering, not a 30% chance of
    #     inflicting a status condition. It can try (and fail) to inflict a
    #     status condition that the user is immune to.
    next if !move.pbContactMove?(user)
    chance=30
    chance=50 if !target.pbOwnedByPlayer? && $Trainer.difficulty_mode==2
    next if battle.pbRandom(100) >= chance
    r = battle.pbRandom(3)
    next if r == 0 && user.asleep?
    next if r == 1 && user.poisoned?
    next if r == 2 && user.paralyzed?
    battle.pbShowAbilitySplash(target)
    if user.affectedByPowder?(Battle::Scene::USE_ABILITY_SPLASH) &&
     user.affectedByContactEffect?(Battle::Scene::USE_ABILITY_SPLASH)
    case r
    when 0
      if user.pbCanSleep?(target, Battle::Scene::USE_ABILITY_SPLASH)
      msg = nil
      if !Battle::Scene::USE_ABILITY_SPLASH
        msg = _INTL("{1}'s {2} made {3} fall asleep!", target.pbThis,
         target.abilityName, user.pbThis(true))
      end
      user.pbSleep(msg)
      end
    when 1
      if user.pbCanPoison?(target, Battle::Scene::USE_ABILITY_SPLASH)
      msg = nil
      if !Battle::Scene::USE_ABILITY_SPLASH
        msg = _INTL("{1}'s {2} poisoned {3}!", target.pbThis,
         target.abilityName, user.pbThis(true))
      end
      user.pbPoison(target, msg)
      end
    when 2
      if user.pbCanParalyze?(target, Battle::Scene::USE_ABILITY_SPLASH)
      msg = nil
      if !Battle::Scene::USE_ABILITY_SPLASH
        msg = _INTL("{1}'s {2} paralyzed {3}! It may be unable to move!",
         target.pbThis, target.abilityName, user.pbThis(true))
      end
      user.pbParalyze(target, msg)
      end
    end
    end
    battle.pbHideAbilitySplash(target)
  }
)

Battle::AbilityEffects::OnBeingHit.add(:POISONPOINT,
  proc { |ability, user, target, move, battle|
    next if !move.pbContactMove?(user)
    chance=30
    chance=50 if !target.pbOwnedByPlayer? && $Trainer.difficulty_mode==2
    next if user.poisoned? || battle.pbRandom(100) >= chance
    battle.pbShowAbilitySplash(target)
    if user.pbCanPoison?(target, Battle::Scene::USE_ABILITY_SPLASH) &&
      user.affectedByContactEffect?(Battle::Scene::USE_ABILITY_SPLASH)
      msg = nil
      if !Battle::Scene::USE_ABILITY_SPLASH
        msg = _INTL("{1}'s {2} poisoned {3}!", target.pbThis, target.abilityName, user.pbThis(true))
      end
      user.pbPoison(target, msg)
    end
    battle.pbHideAbilitySplash(target)
  }
)

Battle::AbilityEffects::OnBeingHit.add(:FLAMEBODY,
  proc { |ability, user, target, move, battle|
    next if !move.physicalMove?
    # next if !move.pbContactMove?(user)
    chance=30
    chance=50 if !target.pbOwnedByPlayer? && $Trainer.difficulty_mode==2
    next if user.burned? || battle.pbRandom(100) >= chance
    battle.pbShowAbilitySplash(target)
    if user.pbCanBurn?(target, Battle::Scene::USE_ABILITY_SPLASH) &&
      user.affectedByContactEffect?(Battle::Scene::USE_ABILITY_SPLASH)
      msg = nil
      if !Battle::Scene::USE_ABILITY_SPLASH
        msg = _INTL("{1}'s {2} burned {3}!", target.pbThis, target.abilityName, user.pbThis(true))
      end
      user.pbBurn(target, msg)
    end
    battle.pbHideAbilitySplash(target)
  }
)

Battle::AbilityEffects::OnBeingHit.add(:STATIC,
  proc { |ability, user, target, move, battle|
    next if !move.pbContactMove?(user)
    chance=30
    chance=50 if !target.pbOwnedByPlayer? && $Trainer.difficulty_mode==2
    next if user.paralyzed? || battle.pbRandom(100) >= chance
    battle.pbShowAbilitySplash(target)
    if user.pbCanParalyze?(target, Battle::Scene::USE_ABILITY_SPLASH) &&
      user.affectedByContactEffect?(Battle::Scene::USE_ABILITY_SPLASH)
      msg = nil
      if !Battle::Scene::USE_ABILITY_SPLASH
        msg = _INTL("{1}'s {2} paralyzed {3}! It may be unable to move!",
        target.pbThis, target.abilityName, user.pbThis(true))
      end
      user.pbParalyze(target, msg)
    end
    battle.pbHideAbilitySplash(target)
  }
)

Battle::AbilityEffects::OnBeingHit.add(:DEEPCHILL,
  proc { |ability, user, target, move, battle|
    next if !move.specialMove?
    # next if !move.pbContactMove?(user)
    chance=30
    chance=50 if !target.pbOwnedByPlayer? && $Trainer.difficulty_mode==2
    next if user.frozen? || battle.pbRandom(100) >= chance
    battle.pbShowAbilitySplash(target)
    if user.pbCanFreeze?(target, Battle::Scene::USE_ABILITY_SPLASH) &&
      user.affectedByContactEffect?(Battle::Scene::USE_ABILITY_SPLASH)
      msg = nil
      if !Battle::Scene::USE_ABILITY_SPLASH
        msg = _INTL("{1}'s {2} froze {3}! It may be unable to move!",
        target.pbThis, target.abilityName, user.pbThis(true))
      end
      user.pbFreeze(user, msg)
    end
    battle.pbHideAbilitySplash(target)
  }
)

Battle::AbilityEffects::OnBeingHit.add(:HIVEBODY,
  proc { |ability, user, target, move, battle|
    next if !move.pbContactMove?(user)
    chance=50
    chance=80 if !target.pbOwnedByPlayer? && $Trainer.difficulty_mode==2
    next if user.effects[PBEffects::Trapping] > 0 || battle.pbRandom(100) >= chance
    battle.pbShowAbilitySplash(target)
    if user.affectedByContactEffect?(Battle::Scene::USE_ABILITY_SPLASH)
    msg = nil
    if !Battle::Scene::USE_ABILITY_SPLASH
      msg = _INTL("{1}'s {2} has infested {3}!", target.pbThis, target.abilityName, user.pbThis(true))
    end
    # Set trapping effect duration and info
    if target.hasActiveItem?(:GRIPCLAW)
      user.effects[PBEffects::Trapping] = (Settings::MECHANICS_GENERATION >= 5) ? 8 : 6
    else
      user.effects[PBEffects::Trapping] = 5 + battle.pbRandom(2)
      user.effects[PBEffects::Trapping] = 6 if !target.pbOwnedByPlayer? && $Trainer.difficulty_mode==2
    end
    user.effects[PBEffects::TrappingMove] = :INFESTATION
    user.effects[PBEffects::TrappingUser] = target.index
    battle.pbDisplay(_INTL("{1} has been infested!", user.pbThis))
    end
    battle.pbHideAbilitySplash(target)
  }
)

# Changed by DemICE 01-Oct-2023 to add new custom ability for Mega Sandaconda
Battle::AbilityEffects::OnBeingHit.add(:MAELSTROM,
  proc { |ability, user, target, move, battle|
  next if !move.pbContactMove?(user)
  chance=50
  chance=80 if !target.pbOwnedByPlayer? && $Trainer.difficulty_mode==2
  next if user.effects[PBEffects::Trapping] > 0 || battle.pbRandom(100) >= chance
  battle.pbShowAbilitySplash(target)
  if user.affectedByContactEffect?(Battle::Scene::USE_ABILITY_SPLASH)
    msg = nil
    if !Battle::Scene::USE_ABILITY_SPLASH
    msg = _INTL("{1}'s {2} trapped {3} in the vortex!", target.pbThis, target.abilityName, user.pbThis(true))
    end
    # Set trapping effect duration and info
    if target.hasActiveItem?(:GRIPCLAW)
    user.effects[PBEffects::Trapping] = (Settings::MECHANICS_GENERATION >= 5) ? 8 : 6
    else
    user.effects[PBEffects::Trapping] = 5 + battle.pbRandom(2)
    user.effects[PBEffects::Trapping] = 6 if !target.pbOwnedByPlayer? && $Trainer.difficulty_mode==2
    end
    user.effects[PBEffects::TrappingMove] = :WHIRLPOOL
    user.effects[PBEffects::TrappingUser] = target.index
    battle.pbDisplay(_INTL("{1} became trapped in the vortex!", user.pbThis))
  end
  battle.pbHideAbilitySplash(target)
  }
)  

Battle::AbilityEffects::EndOfRoundHealing.add(:HEALER,
  proc { |ability, battler, battle|
    chance=50
    chance=80 if !battler.pbOwnedByPlayer? && $Trainer.difficulty_mode==2
    next unless battle.pbRandom(100) < chance
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
      end
    end
    battle.pbHideAbilitySplash(battler)
    end
  }
)  

Battle::AbilityEffects::EndOfRoundGainItem.add(:HARVEST,
  proc { |ability, battler, battle|
    next if battler.item
    next if !battler.recycleItem || !GameData::Item.get(battler.recycleItem).is_berry?
    chance=50
    chance=80 if !battler.pbOwnedByPlayer? && $Trainer.difficulty_mode==2
    if ![:Sun, :HarshSun].include?(battler.effectiveWeather)
    next unless battle.pbRandom(100) < chance
    end
    battle.pbShowAbilitySplash(battler)
    battler.item = battler.recycleItem
    battler.setRecycleItem(nil)
    battler.setInitialItem(battler.item) if !battler.initialItem
    battle.pbDisplay(_INTL("{1} harvested one {2}!", battler.pbThis, battler.itemName))
    battle.pbHideAbilitySplash(battler)
    battler.pbHeldItemTriggerCheck
  }
)

Battle::AbilityEffects::PriorityBracketChange.add(:QUICKDRAW,
  proc { |ability, battler, battle|
    chance=30
    chance=50 if !battler.pbOwnedByPlayer? && $Trainer.difficulty_mode==2
    next 1 if battle.pbRandom(100) < chance
  }
)

class Battle::Move::MultiTurnAttackConfuseUserAtEnd < Battle::Move
  def pbEffectAfterAllHits(user, target)
    if !target.damageState.unaffected && user.effects[PBEffects::Outrage] == 0
      user.effects[PBEffects::Outrage] = 2 + @battle.pbRandom(2)
      user.effects[PBEffects::Outrage] = 3 if !user.pbOwnedByPlayer? && $Trainer.difficulty_mode==2
      user.currentMove = @id
    end
    if user.effects[PBEffects::Outrage] > 0
      user.effects[PBEffects::Outrage] -= 1
      if user.effects[PBEffects::Outrage] == 0 && user.pbCanConfuseSelf?(false)
        user.pbConfuse(_INTL("{1} became confused due to fatigue!", user.pbThis))
      end
    end
  end
end

class Battle::Move::BindTarget < Battle::Move
  def pbEffectAgainstTarget(user, target)
    return if target.fainted? || target.damageState.substitute
    return if target.effects[PBEffects::Trapping] > 0
    # Set trapping effect duration and info
    if user.hasActiveItem?(:GRIPCLAW)
      target.effects[PBEffects::Trapping] = (Settings::MECHANICS_GENERATION >= 5) ? 8 : 6
    else
      target.effects[PBEffects::Trapping] = 5 + @battle.pbRandom(2)
      target.effects[PBEffects::Trapping] = 6 if !user.pbOwnedByPlayer? && $Trainer.difficulty_mode==2
    end
    target.effects[PBEffects::TrappingMove] = @id
    target.effects[PBEffects::TrappingUser] = user.index
    # Message
    msg = _INTL("{1} was trapped in the vortex!", target.pbThis)
    case @id
      when :BIND; msg = _INTL("{1} was squeezed by {2}!", target.pbThis, user.pbThis(true))
      when :CLAMP; msg = _INTL("{1} clamped {2}!", user.pbThis, target.pbThis(true))
      when :FIRESPIN; msg = _INTL("{1} was trapped in the fiery vortex!", target.pbThis)
      when :INFESTATION; msg = _INTL("{1} has been afflicted with an infestation by {2}!", target.pbThis, user.pbThis(true))
      # Changed by Jos 2022-10-02
      when :BACKSTABBING; msg = _INTL("{1} was trapped by {2}!", target.pbThis, user.pbThis(true))
      when :HAUNT; msg = _INTL("{1} was haunted by {2}!", target.pbThis, user.pbThis(true))
      when :GALEHOLD; msg = _INTL("{1} became trapped by fierce winds!", target.pbThis)
      when :THORNPRISON; msg = _INTL("{1} was encased in thorns!", target.pbThis)
      when :ICEVORTEX; msg = _INTL("{1} was trapped in a vortex of ice!", target.pbThis)
      when :THUNDERCAGE; msg = _INTL("{1} was electrocuted by the cage!", target.pbThis)
      when :FAIRYRING; msg = _INTL("{1} was trapped by fairies!", target.pbThis)
      when :REVERB; msg = _INTL("{1} was trapped in a sound barrier!", target.pbThis)
      when :SNAPTRAP; msg = _INTL("{1} clamped {2}!", user.pbThis, target.pbThis(true))
      # End of addition
      when :MAGMASTORM; msg = _INTL("{1} became trapped by Magma Storm!", target.pbThis)
      when :SANDSNARE; msg = _INTL("{1} became trapped by Sand Snare!", target.pbThis)
      when :SANDTOMB; msg = _INTL("{1} became trapped by Sand Tomb!", target.pbThis)
      when :WHIRLPOOL; msg = _INTL("{1} became trapped in the vortex!", target.pbThis)
      when :WRAP; msg = _INTL("{1} was wrapped by {2}!", target.pbThis, user.pbThis(true))
    end
    @battle.pbDisplay(msg)
  end
end

module ItemHandlers
  def self.hasBattleUseOnPokemon(item) # Changed by DemICE 08-Oct-2023 Can't put revival items in the battle belt on higher difficulties
    return false if [:REVIVE,:MAXREVIVE,:REVIVALHERB].include?(item) && $Trainer.difficulty_mode>0
    return !BattleUseOnPokemon[item].nil?
  end
end
