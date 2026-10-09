################################################################################
# 
# New PBEffects.
# 
################################################################################

module PBEffects
  # AllySwitch      = 400 # Used to determine if Ally Switch should fail.
  BoosterEnergy   = 401 # Used to flag whether or not ParadoxStat should persist due to Booster Energy.
  # Commander       = 402 # Used for storing data related to Commander.
  # CudChew         = 403 # Used to count the remaining rounds until Cud Chew triggers.
  # DoubleShock     = 404 # Used for removing the user's Electric typing after using Double Shock.
  # GlaiveRush      = 405 # Used to count the remaining rounds until vulnerability from Glaive Rush wares off.
  ParadoxStat     = 406 # Used to reference which stat is being boosted by Protosynthesis/Quark Drive.
  # OneUseAbility   = 407 # Used to flag a battler's ability to only trigger once per switch-in.
  # SaltCure        = 408 # Used to flag a battler as under the effects of Salt Cure.
  # SilkTrap        = 409 # Used to flag a battler as under the protection effects of Silk Trap.
  # Splinters       = 410 # Used to flag a battler as under the splinters effect.
  # SplintersType   = 411 # Used to determine the type effectiveness of splinters damage.
  # SuccessiveMove  = 412 # Used to flag a move as unselectable by a battler on consecutive turns.
  # SupremeOverlord = 413 # Used to trigger the effects of the Supreme Overlord ability.
  # Syrupy          = 414 # Used to track the remaining number of turns until Syrup Bomb's effect wares off.
  # SyrupyUser      = 415 # Used to track the Syrup Bomb user so the effect ends if they leave the field.
  BurningBulwark  = 416 # Used for the effect of Burning Bulwark.
end

#-------------------------------------------------------------------------------
# New effects and values to be added to the debug menu.
#-------------------------------------------------------------------------------
module Battle::DebugVariables
  BATTLER_EFFECTS[PBEffects::ParadoxStat]     = { name: "Protosynthesis/Quark Drive stat boosted",       default: nil, type: :stat }
  # BATTLER_EFFECTS[PBEffects::AllySwitch]      = { name: "Ally Switch applies this round",                default: false }
  # BATTLER_EFFECTS[PBEffects::CudChew]         = { name: "Cud Chew number of rounds until active",        default: 0 }
  # BATTLER_EFFECTS[PBEffects::DoubleShock]     = { name: "Double Shock has removed self's Electric type", default: false }
  # BATTLER_EFFECTS[PBEffects::GlaiveRush]      = { name: "Glaive Rush vulnerability rounds remaining",    default: 0 }
  BATTLER_EFFECTS[PBEffects::BoosterEnergy]   = { name: "Booster Energy applies",                        default: false }
  # BATTLER_EFFECTS[PBEffects::SaltCure]        = { name: "Salt Cure applies",                             default: false }
  # BATTLER_EFFECTS[PBEffects::SilkTrap]        = { name: "Silk Trap applies this round",                  default: false }
  # BATTLER_EFFECTS[PBEffects::Splinters]       = { name: "Splinters number of rounds remaining",          default: 0 }
  # BATTLER_EFFECTS[PBEffects::SplintersType]   = { name: "Splinters damage typing",                       default: nil, type: :type }
  # BATTLER_EFFECTS[PBEffects::SupremeOverlord] = { name: "Supreme Overlord multiplier 1 + 0.1*x (0-5)",   default: 0, max: 5 }
  # BATTLER_EFFECTS[PBEffects::Syrupy]          = { name: "Syrupy turns remaining",                        default: 0 }
  # BATTLER_EFFECTS[PBEffects::SyrupyUser]      = { name: "Battler syruped self",                          default: -1 }
  BATTLER_EFFECTS[PBEffects::BurningBulwark]  = { name: "Burning Bulwark applies this round",            default: false }
  BATTLER_EFFECTS[PBEffects::BitterBastion]   = { name: "Bitter Bastion applies this round",            default: false }
end

################################################################################
# 
# Battle::Battler class changes.
# 
################################################################################

class Battle::Battler
  #-----------------------------------------------------------------------------
  # Aliased for Protosynthesis checks whenever weather is changed.
  #-----------------------------------------------------------------------------
  alias paldea_pbCheckFormOnWeatherChange pbCheckFormOnWeatherChange
  def pbCheckFormOnWeatherChange(ability_changed = false)
    if hasActiveAbility?(:PROTOSYNTHESIS)
      Battle::AbilityEffects.triggerOnSwitchIn(self.ability, self, @battle, false)
    end
    paldea_pbCheckFormOnWeatherChange(ability_changed)
  end
  alias paldea_pbInitEffects pbInitEffects
  def pbInitEffects(batonPass)
    paldea_pbInitEffects(batonPass)
    # @effects[PBEffects::AllySwitch]      = false
    @effects[PBEffects::BoosterEnergy]   = false
    @effects[PBEffects::BurningBulwark]  = false
    # @effects[PBEffects::Commander]       = nil
    # @effects[PBEffects::CudChew]         = 0
    # @effects[PBEffects::DoubleShock]     = false
    # @effects[PBEffects::GlaiveRush]      = 0
    @effects[PBEffects::ParadoxStat]     = nil
    # @effects[PBEffects::OneUseAbility]   = nil
    # @effects[PBEffects::SaltCure]        = false
    # @effects[PBEffects::Splinters]       = 0
    # @effects[PBEffects::SplintersType]   = nil
    # @effects[PBEffects::SilkTrap]        = false
    # @effects[PBEffects::SuccessiveMove]  = nil
    # @effects[PBEffects::SupremeOverlord] = 0
    # @effects[PBEffects::Syrupy]          = 0
    # @effects[PBEffects::SyrupyUser]      = -1
    # @battle.allBattlers.each do |b|
      # next if b.effects[PBEffects::SyrupyUser] != @index
      # b.effects[PBEffects::Syrupy] = 0
      # b.effects[PBEffects::SyrupyUser] = -1
    # end
    # @proteanTrigger  = false
    @mirrorHerbUsed  = false
    # @legendPlateType = nil
  end

  #-----------------------------------------------------------------------------
  # -Aliased to add Silk Trap to move success check.
  # -Rechecks for effects that ignore abilities before running success check.
  #-----------------------------------------------------------------------------
  alias paldea_pbSuccessCheckAgainstTarget pbSuccessCheckAgainstTarget
  def pbSuccessCheckAgainstTarget(move, user, target, targets)
    @battle.moldBreaker = user.hasMoldBreaker? || (move.statusMove? && user.hasActiveAbility?(:MYCELIUMMIGHT)) if !@battle.moldBreaker
    @battle.moldBreaker = false if target.hasActiveItem?(:ABILITYSHIELD)
    if !(user.hasActiveAbility?(:UNSEENFIST) && move.contactMove?)
      if move.canProtectAgainst? && !user.effects[PBEffects::TwoTurnAttack]
        # Silk Trap
        # if target.effects[PBEffects::SilkTrap] && move.damagingMove?
          # if move.pbShowFailMessages?(targets)
            # @battle.pbCommonAnimation("SilkTrap", target)
            # @battle.pbDisplay(_INTL("{1} protected itself!", target.pbThis))
          # end
          # target.damageState.protected = true
          # @battle.successStates[user.index].protected = true
          # if move.pbContactMove?(user) && user.affectedByContactEffect? &&
             # user.pbCanLowerStatStage?(:SPEED, target)
            # user.pbLowerStatStage(:SPEED, 1, target)
          # end
          # return false
        # end
        # Burning Bulwark
        if target.effects[PBEffects::BurningBulwark] && move.damagingMove?
          if move.pbShowFailMessages?(targets)
            @battle.pbCommonAnimation("BurningBulwark", target)
            @battle.pbDisplay(_INTL("{1} protected itself!", target.pbThis))
          end
          target.damageState.protected = true
          @battle.successStates[user.index].protected = true
          #if move.pbContactMove?(user) && user.affectedByContactEffect? &&
          if move.physicalMove? && user.affectedByContactEffect? && user.pbCanBurn?(target, false) # Is now all Physical Moves
            user.pbBurn(target)
          end
          return false
        end
      end
    end
    ret = paldea_pbSuccessCheckAgainstTarget(move, user, target, targets)
    if ret
      Battle::AbilityEffects.triggerOnMoveSuccessCheck(
        target.ability, user, target, move, @battle)
    end
    return ret
  end
end

class Battle
  
  #-----------------------------------------------------------------------------
  # Resets various effects at the end of round.
  #-----------------------------------------------------------------------------
  alias paldea_pbEndOfRoundPhase pbEndOfRoundPhase
  def pbEndOfRoundPhase
    paldea_pbEndOfRoundPhase
    allBattlers.each_with_index do |battler, i|
      # battler.effects[PBEffects::AllySwitch]     = false
      battler.effects[PBEffects::BurningBulwark] = false
      # if Settings::MECHANICS_GENERATION >= 9
        # battler.effects[PBEffects::Charge]   += 1 if battler.effects[PBEffects::Charge]     > 0
      # end
      # battler.effects[PBEffects::GlaiveRush] -= 1 if battler.effects[PBEffects::GlaiveRush] > 0
    end
  end
end

#===============================================================================
# Protosynthesis, Quark Drive
#===============================================================================
Battle::AbilityEffects::OnSwitchIn.add(:PROTOSYNTHESIS,
  proc { |ability, battler, battle, switch_in|
    next if battler.effects[PBEffects::Transform]
    case ability
    when :PROTOSYNTHESIS then field_check = [:Sun, :HarshSun].include?(battle.field.weather)
    when :QUARKDRIVE     then field_check = battle.field.terrain == :Electric
    end
    if !field_check && !battler.effects[PBEffects::BoosterEnergy] && battler.effects[PBEffects::ParadoxStat]
      battle.pbDisplay(_INTL("The effects of {1}'s {2} wore off!", battler.pbThis(true), battler.abilityName))
      battler.effects[PBEffects::ParadoxStat] = nil
    end
    next if battler.effects[PBEffects::ParadoxStat]
    next if !field_check && battler.item != :BOOSTERENERGY
    highestStat = nil
    highestStatVal = 0
    stageMul = [2, 2, 2, 2, 2, 2, 2, 3, 4, 5, 6, 7, 8]
    stageDiv = [8, 7, 6, 5, 4, 3, 2, 2, 2, 2, 2, 2, 2]
    battler.plainStats.each do |stat, val|
      stage = battler.stages[stat] + 6
      realStat = (val.to_f * stageMul[stage] / stageDiv[stage]).floor
      if realStat > highestStatVal
        highestStatVal = realStat 
        highestStat = stat
      end
    end
    if highestStat
      battle.pbShowAbilitySplash(battler)
      if field_check
        case ability
        when :PROTOSYNTHESIS then cause = "harsh sunlight"
        when :QUARKDRIVE     then cause = "Electric Terrain"
        end
        battle.pbDisplay(_INTL("The #{cause} activated {1}'s {2}!", battler.pbThis(true), battler.abilityName))
      elsif battler.item_id == :BOOSTERENERGY
        battler.effects[PBEffects::BoosterEnergy] = true
        battle.pbDisplay(_INTL("{1} used its {2} to activate its {3}!", battler.pbThis, battler.itemName, battler.abilityName))
        battler.pbHeldItemTriggered(battler.item)
      end
      battler.effects[PBEffects::ParadoxStat] = highestStat
      battle.pbDisplay(_INTL("{1}'s {2} was heightened!", battler.pbThis, GameData::Stat.get(highestStat).name))
      battle.pbHideAbilitySplash(battler)
    end
  }
)

Battle::AbilityEffects::OnSwitchIn.copy(:PROTOSYNTHESIS, :QUARKDRIVE)

Battle::AbilityEffects::OnTerrainChange.add(:QUARKDRIVE,
  proc { |ability, battler, battle, switch_in|
    Battle::AbilityEffects.triggerOnSwitchIn(ability, battler, battle, switch_in)
  }
)

#-------------------------------------------------------------------------------
# Damage calcs (User).
Battle::AbilityEffects::DamageCalcFromUser.add(:PROTOSYNTHESIS,
  proc { |ability, user, target, move, mults, baseDmg, type|
    next if user.effects[PBEffects::Transform]
    stat = user.effects[PBEffects::ParadoxStat]
    mults[:attack_multiplier] *= 1.3 if move.physicalMove? && stat == :ATTACK
    mults[:attack_multiplier] *= 1.3 if move.specialMove?  && stat == :SPECIAL_ATTACK
  }
)

Battle::AbilityEffects::DamageCalcFromUser.copy(:PROTOSYNTHESIS, :QUARKDRIVE)

#-------------------------------------------------------------------------------
# Damage calcs (Target).
Battle::AbilityEffects::DamageCalcFromTarget.add(:PROTOSYNTHESIS,
  proc { |ability, user, target, move, mults, baseDmg, type|
    next if target.effects[PBEffects::Transform]
    stat = target.effects[PBEffects::ParadoxStat]
    mults[:defense_multiplier] *= 1.3 if move.physicalMove? && stat == :DEFENSE
    mults[:defense_multiplier] *= 1.3 if move.specialMove?  && stat == :SPECIAL_DEFENSE
  }
)

Battle::AbilityEffects::DamageCalcFromTarget.copy(:PROTOSYNTHESIS, :QUARKDRIVE)

#-------------------------------------------------------------------------------
# Speed calcs.
Battle::AbilityEffects::SpeedCalc.add(:PROTOSYNTHESIS,
  proc { |ability, battler, mult, ret|
    next mult if battler.effects[PBEffects::Transform]
    next mult * 1.5 if battler.effects[PBEffects::ParadoxStat] == :SPEED
  }
)

Battle::AbilityEffects::SpeedCalc.copy(:PROTOSYNTHESIS, :QUARKDRIVE)

#===============================================================================
# Orichalcum Pulse
#===============================================================================
Battle::AbilityEffects::OnSwitchIn.add(:ORICHALCUMPULSE,
  proc { |ability, battler, battle, switch_in|
    if [:Sun, :HarshSun].include?(battler.effectiveWeather)
      battle.pbShowAbilitySplash(battler)
      battle.pbDisplay(_INTL("{1} basked in the sunlight, sending its ancient pulse into a frenzy!", battler.pbThis))
      battle.pbHideAbilitySplash(battler)
    else
      battle.pbStartWeatherAbility(:Sun, battler)
      battle.pbDisplay(_INTL("{1} turned the sunlight harsh, sending its ancient pulse into a frenzy!", battler.pbThis))
    end
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:ORICHALCUMPULSE,
  proc { |ability, user, target, move, mults, baseDmg, type|
    mults[:attack_multiplier] *= 4 / 3.0 if [:Sun, :HarshSun].include?(user.effectiveWeather)
  }
)

#===============================================================================
# Changed by DemICE 04-Oct-2023 Implementing Hadron Engine
#===============================================================================
Battle::AbilityEffects::OnSwitchIn.add(:HADRONENGINE,
  proc { |ability, battler, battle, switch_in|
    battle.pbShowAbilitySplash(battler)
    case ability
      when :FORESTKING; terrain, flavor_text = :Grassy,   ["{1} used the Grassy Terrain to become one with nature!", "{1} turned the ground into Grassy Terrain, becoming one with nature!"]
      else;             terrain, flavor_text = :Electric, ["{1} used the Electric Terrain to energize its futuristic engine!", "{1} turned the ground into Electric Terrain, energizing its futuristic engine!"]
    end
    if battle.field.terrain == terrain
      battle.pbDisplay(_INTL(flavor_text[0], battler.pbThis))
      battle.pbHideAbilitySplash(battler)
      next
    end
    battle.pbDisplay(_INTL(flavor_text[0], battler.pbThis))
    battle.pbStartTerrain(battler, terrain)
    # NOTE: The ability splash is hidden again in def pbStartTerrain.
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:HADRONENGINE,
  proc { |ability, user, target, move, mults, baseDmg, type|
    case ability
      when :FORESTKING; terrain = :Grassy
      else;             terrain = :Electric
    end
    mults[:attack_multiplier] *= 1.33 if user.battle.field.terrain == terrain
  }
)

Battle::AbilityEffects::OnSwitchIn.copy(:HADRONENGINE, :FORESTKING)
Battle::AbilityEffects::DamageCalcFromUser.copy(:HADRONENGINE, :FORESTKING)

#===============================================================================
# Feint
#===============================================================================
# Also negates the effects of Burning Bulwark.
#-------------------------------------------------------------------------------
class Battle::Move::RemoveProtections < Battle::Move
  def pbEffectAgainstTarget(user, target)
    target.effects[PBEffects::BurningBulwark]         = false
    target.effects[PBEffects::BanefulBunker]          = false
    target.effects[PBEffects::BitterBastion]          = false
    target.effects[PBEffects::KingsShield]            = false
    target.effects[PBEffects::Obstruct]               = false
    target.effects[PBEffects::Protect]                = false
    target.effects[PBEffects::SpikyShield]            = false
    target.pbOwnSide.effects[PBEffects::CraftyShield] = false
    target.pbOwnSide.effects[PBEffects::MatBlock]     = false
    target.pbOwnSide.effects[PBEffects::QuickGuard]   = false
    target.pbOwnSide.effects[PBEffects::WideGuard]    = false
  end
end

#===============================================================================
# Hyperspace Fury
#===============================================================================
# Also negates the effects of Burning Bulwark.
#-------------------------------------------------------------------------------
class Battle::Move::HoopaRemoveProtectionsBypassSubstituteLowerUserDef1 < Battle::Move::StatDownMove
  def pbEffectAgainstTarget(user, target)
    target.effects[PBEffects::BurningBulwark]         = false
    target.effects[PBEffects::BanefulBunker]          = false
    target.effects[PBEffects::BitterBastion]          = false
    target.effects[PBEffects::KingsShield]            = false
    target.effects[PBEffects::Obstruct]               = false
    target.effects[PBEffects::Protect]                = false
    target.effects[PBEffects::SpikyShield]            = false
    target.pbOwnSide.effects[PBEffects::CraftyShield] = false
    target.pbOwnSide.effects[PBEffects::MatBlock]     = false
    target.pbOwnSide.effects[PBEffects::QuickGuard]   = false
    target.pbOwnSide.effects[PBEffects::WideGuard]    = false
  end
end

#===============================================================================
# Shadow Force, Phantom Force
#===============================================================================
# Also negates the effects of Burning Bulwark.
#-------------------------------------------------------------------------------
class Battle::Move::TwoTurnAttackInvulnerableRemoveProtections < Battle::Move::TwoTurnMove
  def pbAttackingTurnEffect(user, target)
    target.effects[PBEffects::BurningBulwark]         = false
    target.effects[PBEffects::BanefulBunker]          = false
    target.effects[PBEffects::BitterBastion]          = false
    target.effects[PBEffects::KingsShield]            = false
    target.effects[PBEffects::Obstruct]               = false
    target.effects[PBEffects::Protect]                = false
    target.effects[PBEffects::SpikyShield]            = false
    target.pbOwnSide.effects[PBEffects::CraftyShield] = false
    target.pbOwnSide.effects[PBEffects::MatBlock]     = false
    target.pbOwnSide.effects[PBEffects::QuickGuard]   = false
    target.pbOwnSide.effects[PBEffects::WideGuard]    = false
  end
end

#===============================================================================
# Copycat
#===============================================================================
# Added several Gen 9 moves to blacklist.
#-------------------------------------------------------------------------------
class Battle::Move::UseLastMoveUsed < Battle::Move
  alias paldea_initialize initialize
  def initialize(battle, move)
    paldea_initialize(battle, move)
    @moveBlacklist.push(
      "StarmobileBurnTarget",                  # Blazing Torque
      "StarmobileParalyzeTarget",              # Combat Torque
      "StarmobileConfuseTarget",               # Magical Torque
      "StarmobilePoisonTarget",                # Noxious Torque
      "StarmobileSleepTarget",                 # Wicked Torque
      "ProtectUserBurningBulwark",             # Burning Bulwark
      "TerapagosCategoryDependsOnHigherDamage" # Tera Starstorm
    )
  end
end

#===============================================================================
# Assist
#===============================================================================
# Added several Gen 9 moves to blacklist.
#-------------------------------------------------------------------------------
class Battle::Move::UseRandomMoveFromUserParty < Battle::Move
  alias paldea_initialize initialize
  def initialize(battle, move)
    paldea_initialize(battle, move)
    @moveBlacklist.push(
      "StarmobileBurnTarget",                  # Blazing Torque
      "StarmobileParalyzeTarget",              # Combat Torque
      "StarmobileConfuseTarget",               # Magical Torque
      "StarmobilePoisonTarget",                # Noxious Torque
      "StarmobileSleepTarget",                 # Wicked Torque
      "ProtectUserBurningBulwark",             # Burning Bulwark
      "TerapagosCategoryDependsOnHigherDamage" # Tera Starstorm
    )
  end
end

#===============================================================================
# Burning Bulwark
#===============================================================================
# The user protects itself. Foes who make contact will become burned.
#-------------------------------------------------------------------------------
class Battle::Move::ProtectUserBurningBulwark < Battle::Move::ProtectMove
  def initialize(battle, move)
    super
    @effect = PBEffects::BurningBulwark
  end
end

class Battle::Move
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
  alias paldea_pbCalcDamageMultipliers pbCalcDamageMultipliers
  def pbCalcDamageMultipliers(user, target, numTargets, type, baseDmg, multipliers)
    # "of Ruin" abilities
    # [:TABLETSOFRUIN, :SWORDOFRUIN, :VESSELOFRUIN, :BEADSOFRUIN].each_with_index do |abil, i|
      # category = (i < 2) ? physicalMove? : specialMove?
      # category = !category if i.odd? && @battle.field.effects[PBEffects::WonderRoom] > 0
      # mult = (i.even?) ? multipliers[:attack_multiplier] : multipliers[:defense_multiplier]
      # mult *= 0.75 if @battle.pbCheckGlobalAbility(abil) && !user.hasActiveAbility?(abil) && category
    # end
    if @battle.field.terrain == :Electric && user.affectedByTerrain? &&
       @function == "IncreasePowerInElectricTerrain"
      multipliers[:base_damage_multiplier] *= 1.5 if type != :ELECTRIC
    end
    case user.effectiveWeather
    when :Sun, :HarshSun
      if @function == "IncreasePowerInSunWeather"
        multipliers[:final_damage_multiplier] *= (type == :FIRE) ? 1 : (type == :WATER) ? 3 : 1.5
      end
    # when :Hail
      # if Settings::HAIL_WEATHER_TYPE > 0 && target.pbHasType?(:ICE) && 
         # (physicalMove? || @function == "UseTargetDefenseInsteadOfTargetSpDef")
        # multipliers[:defense_multiplier] *= 1.5
      # end
    end
    # Frostbite
    # if user.status == :FROSTBITE && specialMove?
      # multipliers[:final_damage_multiplier] /= 2
    # end
    # Drowsy
    # if target.status == :DROWSY
      # multipliers[:final_damage_multiplier] *= 4 / 3.0
    # end
    # Glaive Rush
    # multipliers[:final_damage_multiplier] *= 2 if target.effects[PBEffects::GlaiveRush] > 0
    paldea_pbCalcDamageMultipliers(user, target, numTargets, type, baseDmg, multipliers)
  end
end
