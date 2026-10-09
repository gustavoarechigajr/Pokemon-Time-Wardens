
#-------------------------------------------------------------------------------
# Battle code for Mega Evolution and Primal Reversion.
#-------------------------------------------------------------------------------
class Battle
  attr_accessor :sideStatUps     # Used to tally up the number of stat boosts to mirror with Opportunist/Mirror Herb.

  alias multimegas_initialize initialize
  def initialize(scene, p1, p2, player, opponent)
    multimegas_initialize(scene, p1, p2, player, opponent)
    @sideStatUps     = [{}, {}] # For Opportunist
    @megaEvoIndex     = [   # Changed by DemICE 04-Nov-2023 2 Megas
      [[]] * (@player ? @player.length : 1),
      [[]] * (@opponent ? @opponent.length : 1)
    ]
    @megaEvoCount     = [  # Changed by DemICE 04-Nov-2023 2 Megas
      [0] * (@player ? @player.length : 1),
      [0] * (@opponent ? @opponent.length : 1)
    ]
  end


  #-----------------------------------------------------------------------------
  # Ensures certain battle mechanics trigger prior to using Pursuit.
  #-----------------------------------------------------------------------------
  def pbPursuit(idxSwitcher)
    @switching = true
    pbPriority.each do |b|
      next if b.fainted? || !b.opposes?(idxSwitcher)
      next if b.movedThisRound? || !pbChoseMoveFunctionCode?(b.index, "PursueSwitchingFoe")
      next unless pbMoveCanTarget?(b.index, idxSwitcher, @choices[b.index][2].pbTarget(b))
      next unless pbCanChooseMove?(b.index, @choices[b.index][1], false)
      next if b.status == :SLEEP || b.status == :FROZEN
      next if b.effects[PBEffects::SkyDrop] >= 0
      next if b.hasActiveAbility?(:TRUANT) && b.effects[PBEffects::Truant]
      owner = pbGetOwnerIndexFromBattlerIndex(b.index)
      #pbMegaEvolve(b.index) if @megaEvolution[b.idxOwnSide][owner] == b.index
      pbMegaEvolve(b.index) if @megaEvoIndex[b.idxOwnSide][owner].include?(b.pokemonIndex)  # Changed by DemICE 04-Nov-2023 2 Megas
      if PluginManager.installed?("ZUD Mechanics")
        pbUltraBurst(b.index) if @ultraBurst[b.idxOwnSide][owner] == b.index
      end
      if PluginManager.installed?("PLA Battle Styles")
        pbBattleStyle(b.index) if @battleStyle[b.idxOwnSide][owner] == b.index
      end
      if PluginManager.installed?("Terastal Phenomenon")
        pbTerastallize(b.index) if @terastallize[b.idxOwnSide][owner] == b.index
      end
      @choices[b.index][3] = idxSwitcher
      b.pbProcessTurn(@choices[b.index], false)
      break if @decision > 0 || @battlers[idxSwitcher].fainted?
    end
    @switching = false
  end

  def pbAttackPhaseMegaEvolution
    pbPriority.each do |b|
      next if b.wild? && !b.ace?
      next unless @choices[b.index][0] == :UseMove && !b.fainted?
      owner = pbGetOwnerIndexFromBattlerIndex(b.index)
      #next if @megaEvolution[b.idxOwnSide][owner] != b.index
      next if !@megaEvoIndex[b.idxOwnSide][owner].include?(b.pokemonIndex) # Changed by DemICE 04-Nov-2023 2 Megas
      pbMegaEvolve(b.index)
    end
  end

  # Changed by DemICE 04-Nov-2023 2 Megas
  def pbRegisterMegaEvolution(idxBattler)
    side  = @battlers[idxBattler].idxOwnSide
    owner = pbGetOwnerIndexFromBattlerIndex(idxBattler)
    #@megaEvolution[side][owner] = idxBattler
    @megaEvoIndex[side][owner].push(@battlers[idxBattler].pokemonIndex)
    @megaEvoCount[side][owner] += 1 if @battlers[idxBattler].pbOwnedByPlayer? # Changed by DemICE 04-Nov-2023 2 Megas
  end

  # Changed by DemICE 04-Nov-2023 2 Megas
  def pbUnregisterMegaEvolution(idxBattler)
    side  = @battlers[idxBattler].idxOwnSide
    owner = pbGetOwnerIndexFromBattlerIndex(idxBattler)
    #@megaEvolution[side][owner] = -1 if @megaEvolution[side][owner] == idxBattler
    for i in 0..@megaEvoIndex[side][owner].length
      if @megaEvoIndex[side][owner][i] == @battlers[idxBattler].pokemonIndex
        @megaEvoIndex[side][owner].delete_at(i) 
        @megaEvoCount[side][owner] -= 1 if @battlers[idxBattler].pbOwnedByPlayer? # Changed by DemICE 04-Nov-2023 2 Megas
      end
    end
  end

  # Changed by DemICE 04-Nov-2023 2 Megas
  def pbToggleRegisteredMegaEvolution(idxBattler)
    side  = @battlers[idxBattler].idxOwnSide
    owner = pbGetOwnerIndexFromBattlerIndex(idxBattler)
    #if @megaEvolution[side][owner] == idxBattler
    if @megaEvoIndex[side][owner].include?(@battlers[idxBattler].pokemonIndex)
      #@megaEvolution[side][owner] = -1
      #@megaEvoCount[side][owner] -= 1 if @battlers[idxBattler].pbOwnedByPlayer? # Changed by DemICE 04-Nov-2023 2 Megas
      for i in 0..@megaEvoIndex[side][owner].length
        if @megaEvoIndex[side][owner][i] == @battlers[idxBattler].pokemonIndex
          @megaEvoIndex[side][owner].delete_at(i) 
          @megaEvoCount[side][owner] -= 1 if @battlers[idxBattler].pbOwnedByPlayer? # Changed by DemICE 04-Nov-2023 2 Megas
        end
      end
    else
      #@megaEvolution[side][owner] = idxBattler
      @megaEvoIndex[side][owner].push(@battlers[idxBattler].pokemonIndex)
      @megaEvoCount[side][owner] += 1 if @battlers[idxBattler].pbOwnedByPlayer? # Changed by DemICE 04-Nov-2023 2 Megas
    end
  end

  # Changed by DemICE 04-Nov-2023 2 Megas
  def pbRegisteredMegaEvolution?(idxBattler)
    side  = @battlers[idxBattler].idxOwnSide
    owner = pbGetOwnerIndexFromBattlerIndex(idxBattler)
    #return @megaEvolution[side][owner] == idxBattler
    return @megaEvoIndex[side][owner].include?(@battlers[idxBattler].pokemonIndex)
  end

  def pbCanMegaEvolve?(idxBattler)
    battler = @battlers[idxBattler]
    return false if $game_switches[Settings::NO_MEGA_EVOLUTION]
    return false if !battler.hasMega?
    return true if ($DEBUG && $BOSSDEV) && Input.press?(Input::CTRL) && !battler.wild?
    return false if battler.effects[PBEffects::SkyDrop] >= 0
    return false if !pbHasMegaRing?(idxBattler)
    side  = battler.idxOwnSide
    owner = pbGetOwnerIndexFromBattlerIndex(idxBattler)
    count = 1
    count += 1 if $game_switches[476] || !battler.pbOwnedByPlayer? # Mega Ring Upgrade
    return @megaEvoCount[side][owner] < count # Changed by DemICE 04-Nov-2023 2 Megas
    return @megaEvolution[side][owner] == -1
  end
  
  def pbMegaEvolve(idxBattler)
    battler = @battlers[idxBattler]
    return if !battler || !battler.pokemon
    return if !battler.hasMega? || battler.mega?
    triggers = ["mega", "mega" + battler.species.to_s]
    battler.pokemon.types.each { |t| triggers.push("mega" + t.to_s) }
    @scene.pbDeluxeTriggers(idxBattler, nil, triggers)
    $stats.mega_evolution_count += 1 if battler.pbOwnedByPlayer?
    old_ability = battler.ability_id
    if battler.hasActiveAbility?(:ILLUSION)
      Battle::AbilityEffects.triggerOnBeingHit(battler.ability, nil, battler, nil, self)
    end
    if battler.wild?
      case battler.pokemon.megaMessage
      when 1
        pbDisplay(_INTL("{1} radiates with Mega energy!", battler.pbThis))
      else
        pbDisplay(_INTL("{1}'s {2} radiates with Mega energy!", battler.pbThis, battler.itemName))
      end
    else
      trainerName = pbGetOwnerName(idxBattler)
      case battler.pokemon.megaMessage
      when 1
        pbDisplay(_INTL("{1}'s fervent wish has reached {2}!", trainerName, battler.pbThis))
      else
        pbDisplay(_INTL("{1}'s {2} is reacting to {3}'s {4}!",
                        battler.pbThis, battler.itemName, trainerName, pbGetMegaRingName(idxBattler)))
      end
    end
    if @scene.pbCommonAnimationExists?("MegaEvolution")
      pbCommonAnimation("MegaEvolution", battler)
      battler.pokemon.makeMega
      battler.form = battler.pokemon.form
      @scene.pbChangePokemon(battler, battler.pokemon)
      pbCommonAnimation("MegaEvolution2", battler)
    else 
      if Settings::SHOW_MEGA_ANIM && $PokemonSystem.battlescene == 0
        @scene.pbShowMegaEvolution(idxBattler)
        battler.pokemon.makeMega
        battler.form = battler.pokemon.form
        @scene.pbChangePokemon(battler, battler.pokemon)
      else
        @scene.pbRevertBattlerStart(idxBattler)
        battler.pokemon.makeMega
        battler.form = battler.pokemon.form
        @scene.pbChangePokemon(battler, battler.pokemon)
        @scene.pbRevertBattlerEnd
      end
    end
    battler.pbUpdate(true)
    @scene.pbRefreshOne(idxBattler)
    megaName = battler.pokemon.megaName
    megaName = _INTL("Mega {1}", battler.pokemon.speciesName) if nil_or_empty?(megaName)
    pbDisplay(_INTL("{1} has Mega Evolved into {2}!", battler.pbThis, megaName))
    side  = battler.idxOwnSide
    owner = pbGetOwnerIndexFromBattlerIndex(idxBattler)
    @megaEvolution[side][owner] = -1 #-2  # Changed by DemICE 04-Nov-2023 2 Megas
    if battler.isSpecies?(:GENGAR) && battler.mega?
      battler.effects[PBEffects::Telekinesis] = 0
    end
    battler.pbOnLosingAbility(old_ability)
    battler.pbTriggerAbilityOnGainingIt
    pbCalculatePriority(false, [idxBattler]) if Settings::RECALCULATE_TURN_ORDER_AFTER_MEGA_EVOLUTION
  end

end
