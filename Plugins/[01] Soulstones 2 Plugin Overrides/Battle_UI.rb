class Battle::Scene
#===============================================================================
# Move Info UI
#===============================================================================

  #-----------------------------------------------------------------------------
  # Draws the Move Info UI.
  #-----------------------------------------------------------------------------
  def pbUpdateMoveInfoWindow(battler, index)
    @moveUIOverlay.clear
    return if !@moveUIToggle
    xpos = 0
    ypos = 94
    move = battler.moves[index]
    type = move.pbCalcType(battler)
    type_og = GameData::Move.get(move.id).type
    if PluginManager.installed?("Terastal Phenomenon") && 
       battler.power_trigger && move.function == "CategoryDependsOnHigherDamageTera"
      type = battler.tera_type
    end
    #---------------------------------------------------------------------------
    # Draws images.
    typenumber = GameData::Type.get(type).icon_position
    imagePos = [
      [@path + "Move Info/bg",       xpos, ypos],
      ["Graphics/Pictures/types",    xpos + 272, ypos + 4, 0, typenumber * 28, 64, 28],
      ["Graphics/Pictures/category", xpos + 336, ypos + 4, 0, move.category * 28, 64, 28]
    ]
    imagePos += pbDrawMoveFlagIcons(xpos, ypos, move)
    imagePos += pbDrawTypeEffectiveness(xpos, ypos, move, type, battler)
    pbDrawImagePositions(@moveUIOverlay, imagePos)
    #---------------------------------------------------------------------------
    # Move damage calculations (for display purposes).
    @dmg_base   = @acc_base   = @eff_base   = BASE_LIGHT
    @dmg_shadow = @acc_shadow = @eff_shadow = SHADOW_LIGHT
    damage = base_dmg = calc_dmg = move.baseDamage
    stab = 1
    if PluginManager.installed?("Terastal Phenomenon") && 
       (battler.tera? || (battler.power_trigger && @sprites["fightWindow"].teraType > 0))
      if battler.tera_type == type && (battler.pokemon.types.include?(type) || battler.hasActiveAbility?(:PROTEAN))
        stab = 2
        stab = 2.66 if battler.hasActiveAbility?(:ADAPTABILITY)
      elsif battler.tera_type == type || (battler.pokemon.types.include?(type) || battler.hasActiveAbility?(:PROTEAN))
        stab = 1.5
        stab = 2 if battler.hasActiveAbility?(:ADAPTABILITY)
      end
    else
      if battler.pbHasType?(type) || battler.hasActiveAbility?(:PROTEAN)
        stab = 1.5 
        stab = 2 if battler.hasActiveAbility?(:ADAPTABILITY)
      end  
    end
    stab*=1.5 if battler.hasActiveAbility?(:STEELWORKER) && type == :STEEL
    stab*=1.5 if battler.hasActiveAbility?(:REQUIEM) && type == :DARK # Changed by DemICE 2023-05-27 for new ability
    stab*=1.5 if battler.hasActiveAbility?(:AFFECTION) && type == :FAIRY # Changed by DemICE 2023-05-27 for new ability
    stab*=1.5 if battler.hasActiveAbility?(:ARSONIST) && type == :FIRE # Changed by Jos 2024-07-07 for new ability
    stab*=1.5 if battler.hasActiveAbility?(:VIRTUOSO) && type == :SOUND
    stab*=1.5 if battler.hasActiveAbility?(:HIVEMIND) && type == :BUG
    stab*=1.5 if battler.hasActiveAbility?(:BONECOLLECTOR) && type == :GROUND
    stab*=1.5 if battler.hasActiveAbility?(:ROCKYPAYLOAD) && type == :ROCK
    stab*=1.5 if battler.hasActiveAbility?(:HAUNTED) && type == :GHOST # Changed by Jos 2024-07-07 for new ability
    stab*=1.5 if battler.hasActiveAbility?(:STEELYSPIRIT) && type == :STEEL
    stab*=1.5 if battler.hasActiveAbility?(:DRAGONSMAW) && type == :DRAGON
    stab*=1.5 if battler.hasActiveAbility?(:TRANSISTOR) && type == :ELECTRIC
    stab*=2.0 if battler.hasActiveAbility?(:WATERBUBBLE) && type == :WATER
    stab*=2.0 if battler.hasActiveAbility?(:TERRORIZE) && type == :PSYCHIC
    stab*=2.0 if battler.hasActiveAbility?(:LIGHTBULB) && type == :LIGHT
    stab*=2.0 if battler.hasActiveAbility?(:FUNERALPYRE) && [:FIRE, :GHOST].include?(type) # Changed by PDM20 2024-07-07 for new ability

    # Type1 -> Type2 Abils
    stab*=1.2 if battler.hasActiveAbility?(:AERILATE) && type_og == :NORMAL
    stab*=1.2 if battler.hasActiveAbility?(:GALVANIZE) && type_og == :NORMAL
    stab*=1.2 if battler.hasActiveAbility?(:LIQUIDVOICE) && move.soundMove?
    stab*=1.2 if battler.hasActiveAbility?(:NORMALIZE)
    stab*=1.2 if battler.hasActiveAbility?(:PIXILATE) && type_og == :NORMAL
    stab*=1.2 if battler.hasActiveAbility?(:ILLUMINATE) && type_og == :NORMAL
    stab*=1.2 if battler.hasActiveAbility?(:BLACKLIGHT) && type_og == :LIGHT
    stab*=1.2 if battler.hasActiveAbility?(:WHITEOUT) && type_og == :DARK
    stab*=1.2 if battler.hasActiveAbility?(:DARKMATTER) && type_og == :NORMAL
    stab*=1.2 if battler.hasActiveAbility?(:REFRIGERATE) && type_og == :NORMAL

    if move.damagingMove?
      if pbVariablePowerFunctions.include?(move.function) ||
         # Natural Gift called here specifically to check for a berry first.
         move.function == "TypeAndPowerDependOnUserBerry" && battler.item
        calc_dmg = move.pbBaseDamage(move.baseDamage, battler, battler.pbDirectOpposing)
        # Changed by DemICE 11-Oct-2023 fixing incorect showing of power of fury cutter.
        calc_dmg += calc_dmg if move.function=="PowerHigherWithConsecutiveUse" #&& battler.effects[PBEffects::FuryCutter] == 0 
      # Earthquake weakened in Grassy Terrain.
      elsif move.function == "DoublePowerIfTargetUnderground"
        calc_dmg /= 2 if @battle.field.terrain == :Grassy
      end
      range = base_dmg - calc_dmg
      # Calc is inverted for Eruption/Water Spout.
      range = -range if move.function == "PowerHigherWithUserHP"
      real_dmg = (calc_dmg * stab).floor
      damage = (real_dmg >= range) ? real_dmg : (base_dmg * stab).floor
      calc_dmg = damage if damage > base_dmg
      if damage > 1
        if calc_dmg > base_dmg
          @dmg_base, @dmg_shadow = BASE_RAISED, SHADOW_RAISED
        elsif damage < (base_dmg * stab).floor
          @dmg_base, @dmg_shadow = BASE_LOWERED, SHADOW_LOWERED
        end
      end
    end
    #---------------------------------------------------------------------------
    # Draws text.
    textPos = []
    textPos += pbAddPluginText(xpos, ypos, move, battler)
    power = (damage == 0) ? "---" : (damage == 1) ? "???" : damage.to_s
    accuracy = (move.accuracy == 0) ? "---" : move.accuracy.to_s
    fangmove = ["ParalyzeFlinchTarget", "BurnFlinchTarget", "FreezeFlinchTarget"].include?(move.function)
    effectrate = (move.addlEffect == 0) ? "---" : fangmove ? "10%" : move.addlEffect.to_s + "%"
    textPos.push(
      [move.name,       xpos + 10,            ypos + 8,  0, BASE_LIGHT, SHADOW_LIGHT],
      [_INTL("Pow:"),   Graphics.width - 86,  ypos + 10, 2, BASE_LIGHT, SHADOW_LIGHT],
      [_INTL("Acc:"),   Graphics.width - 86,  ypos + 39, 2, BASE_LIGHT, SHADOW_LIGHT],
      [_INTL("Effct:"), xpos + 287,           ypos + 39, 0, BASE_LIGHT, SHADOW_LIGHT],
      [power,           Graphics.width - 34,  ypos + 10, 2, @dmg_base, @dmg_shadow],
      [accuracy,        Graphics.width - 34,  ypos + 39, 2, @acc_base, @acc_shadow],
      [effectrate,      Graphics.width - 146, ypos + 39, 2, @eff_base, @eff_shadow]
    )
    pbDrawTextPositions(@moveUIOverlay, textPos)
    drawTextEx(@moveUIOverlay, xpos + 10, ypos + 70, Graphics.width - 10, 2, GameData::Move.get(move.id).description, BASE_LIGHT, SHADOW_LIGHT)
  end


  #-----------------------------------------------------------------------------
  # Draws the type effectiveness display for each opponent in the Move Info UI.
  #-----------------------------------------------------------------------------
  def pbDrawTypeEffectiveness(xpos, ypos, move, type, user)
    images = []
    idx = 0
    @battle.allBattlers.each do |b|
      next if b.index.even?
      if b && !b.fainted? && move.category < 2
        poke = b.displayPokemon
        unknown_species = ($player.pokedex.battled_count(poke.species) == 0 && !$player.pokedex.owned?(poke.species))
        unknown_species = false if Settings::ALWAYS_DISPLAY_TYPES
        unknown_species = true if b.celestial?
        value = move.pbCalcTypeModUI(type, user, b)#Effectiveness.calculate(type, poke.types[0], poke.types[1])

        # Known Abil QOL
        if $RevealedAbility[b.index][0] != {:pkmn=>nil,:abil=>nil}
          known_abil = $RevealedAbility[b.index][0][:abil]
          known_pkmn = $RevealedAbility[b.index][0][:pkmn]
          if known_pkmn == b && known_pkmn.hasActiveAbility?(known_abil)
            is_immune = false
            #Flag Based Immunity
            is_immune = true if move.bombMove? && known_abil == :BULLETPROOF
            is_immune = true if move.soundMove? && known_abil == :SOUNDPROOF
            is_immune = true if move.windMove? && known_abil == :WINDRIDER
            is_immune = true if value>32 && known_abil == :WONDERGUARD
            #Type Based Immunity
            is_immune = true if type == :FIRE && known_abil == :FLASHFIRE
            is_immune = true if type == :ELECTRIC && known_abil == :LIGHTNINGROD
            is_immune = true if type == :ELECTRIC && known_abil == :MOTORDRIVE
            is_immune = true if type == :ELECTRIC && known_abil == :VOLTABSORB
            is_immune = true if type == :GRASS && known_abil == :SAPSIPPER
            is_immune = true if type == :WATER && known_abil == :STORMDRAIN
            is_immune = true if type == :WATER && known_abil == :WATERABSORB
            is_immune = true if type == :WATER && known_abil == :DRYSKIN
            is_immune = true if type == :ROCK && known_abil == :COMETSTORM
            is_immune = true if type == :SOUND && known_abil == :CACOPHONY
            is_immune = true if type == :POISON && known_abil == :IMMUNITY
            is_immune = true if type == :LIGHT && known_abil == :OPAQUENESS
            is_immune = true if type == :GROUND && known_abil == :EARTHEATER
            is_immune = true if type == :GROUND && known_abil == :LEVITATE
            value = 0 if is_immune
          end
        end

        if unknown_species                              then effct = 0
          elsif Effectiveness.immune?(value)              then effct = 1
          elsif Effectiveness.not_so_effective?(value)    then effct = 2
          elsif Effectiveness.pretty_effective?(value)    then effct = 3
          elsif Effectiveness.hyper_effective?(value)     then effct = 5
          elsif Effectiveness.barely_effective?(value)    then effct = 6
        else effct = 4
        end
        #Console.echo_h2(effct)
        images.push([@path + "Move Info/effectiveness_ss2", Graphics.width - 64 - (idx * 64), ypos - 76, effct * 64, 0, 64, 76])
        @sprites["battler_icon#{b.index}"].visible = true
      else
        @sprites["battler_icon#{b.index}"].visible = false
      end
      idx += 1
    end
    return images
  end

  #-----------------------------------------------------------------------------
  # Draws the battle effects in play affecting each Pokemon in the Battle Info UI.
  #-----------------------------------------------------------------------------
  def pbAddEffectsDisplay(xpos, ypos, panelX, battler)
    images = []
    addText = []
    effects = []
    # Effects that apply to the whole field.
    field_effects = {
      PBEffects::MudSportField   => [_INTL("Mud Sport"),    5],
      PBEffects::WaterSportField => [_INTL("Water Sport"),  5],
      PBEffects::TrickRoom       => [_INTL("Trick Room"),   5], 
      PBEffects::MagicRoom       => [_INTL("Magic Room"),   5],
      PBEffects::WonderRoom      => [_INTL("Wonder Room"),  5],
      PBEffects::Gravity         => [_INTL("Gravity"),      5],
      PBEffects::FairyLock       => [_INTL("Fairy Lock"),   2]
    }
    # Effects that apply to one side of the field.
    team_effects = { 
      PBEffects::ToxicSpikes     => [_INTL("Toxic Spikes"), 2],
      PBEffects::Spikes          => [_INTL("Spikes"),       3],
      PBEffects::AuroraVeil      => [_INTL("Aurora Veil"),  5], 
      PBEffects::Reflect         => [_INTL("Reflect"),      5],
      PBEffects::LightScreen     => [_INTL("Light Screen"), 5],
      PBEffects::Mist            => [_INTL("Mist"),         5],
      PBEffects::Safeguard       => [_INTL("Safeguard"),    5],
      PBEffects::LuckyChant      => [_INTL("Lucky Chant"),  5],
      PBEffects::Tailwind        => [_INTL("Tailwind"),     4],
      PBEffects::Rainbow         => [_INTL("Rainbow"),      4],
      PBEffects::SeaOfFire       => [_INTL("Sea of Fire"),  4],
      PBEffects::Swamp           => [_INTL("Swamp"),        4]
    }
    if battler.pbOwnSide.effects[PBEffects::StealthRock]
      effects.push([_INTL("Stealth Rocks"), ""])
    end
    # Effects that apply to an individual battler.
    battler_effects = {
      PBEffects::Disable         => [_INTL("Disable"),      5],
      PBEffects::Embargo         => [_INTL("Embargo"),      5],
      PBEffects::HealBlock       => [_INTL("Heal Block"),   5],
      PBEffects::MagnetRise      => [_INTL("Magnet Rise"),  5],
      PBEffects::Encore          => [_INTL("Encore"),       4],
      PBEffects::Taunt           => [_INTL("Taunt"),        4],
      PBEffects::PerishSong      => [_INTL("Perish Song"),  3],
      PBEffects::Telekinesis     => [_INTL("Telekinesis"),  3],
      #PBEffects::Moxie           => [_INTL("Moxie"),  5], # Changed by DemICE 26-Nov-2024 Moxie/Charisma rework
      #PBEffects::Charisma        => [_INTL("Charisma"),  5], # Changed by DemICE 26-Nov-2024 Moxie/Charisma rework
      PBEffects::ThroatChop      => [_INTL("Throat Chop"),  2]
    }
    if battler.effects[PBEffects::Trapping] > 0
      moveName = GameData::Move.get(battler.effects[PBEffects::TrappingMove]).name
      battler_effects[PBEffects::Trapping]  = [_INTL("{1}", moveName),   5]
    end
    # Adds plugin-specific effects.
    if PluginManager.installed?("ZUD Mechanics")
      team_effects[PBEffects::VineLash]     = [_INTL("G-Max Vine Lash"), 4]
      team_effects[PBEffects::Wildfire]     = [_INTL("G-Max Wildfire"),  4]
      team_effects[PBEffects::Cannonade]    = [_INTL("G-Max Cannonade"), 4]
      team_effects[PBEffects::Volcalith]    = [_INTL("G-Max Volcalith"), 4]
      if battler.effects[PBEffects::Dynamax] > 0
        count = (battler.effects[PBEffects::MaxRaidBoss]) ? "---" : "#{battler.effects[PBEffects::Dynamax]}/#{Settings::DYNAMAX_TURNS}"
        effects.push([_INTL("Dynamax"), count])
      end
    end
    if PluginManager.installed?("Focus Meter System")
      team_effects[PBEffects::FocusedGuard] = [_INTL("Focused Guard"),   4]
      battler_effects[PBEffects::FocusLock] = [_INTL("Focus Lock"),      4]
    end
    # Weather
    if @battle.field.weather != :None
      count = @battle.field.weatherDuration
      count = (count > 0) ? "#{count}/5" : "---"
      effects.push([GameData::BattleWeather.get(@battle.field.weather).name, count])
    end
    # Terrain
    if @battle.field.terrain != :None
      count = @battle.field.terrainDuration
      count = (count > 0) ? "#{count}/5" : "---"
      effects.push([GameData::BattleTerrain.get(@battle.field.terrain).name + " " + _INTL("Terrain"), count])
    end
    # Draws a list of each of the above effects currently in play.
    field_effects.each do |key, value|
      next if @battle.field.effects[key] == 0
      count = @battle.field.effects[key]
      count = (count > 0) ? "#{count}/#{value[1]}" : "---"
      effects.push([value[0], count])
    end
    team_effects.each do |key, value|
      next if battler.pbOwnSide.effects[key] == 0
      count = battler.pbOwnSide.effects[key]
      count = (count > 0) ? "#{count}/#{value[1]}" : "---"
      effects.push([value[0], count])
    end
    battler_effects.each do |key, value|
      next if battler.effects[key] == 0
      count = battler.effects[key]
      count = (count > 0) ? "#{count}/#{value[1]}" : "---"
      effects.push([value[0], count])
    end
    # Draws panels and text for all relevant battle effects affecting the battler.
    effects.each_with_index do |effect, i|
      break if i == 8
      images.push([@path + "Battle Info/panel_effects", panelX, ypos + 136 + (i * 24), 0, 24, 218, 24])
      addText.push([effect[0], xpos + 321, ypos + 140 + (i * 24), 2, BASE_DARK, SHADOW_DARK],
                   [effect[1], xpos + 425, ypos + 140 + (i * 24), 2, BASE_LIGHT, SHADOW_LIGHT])
    end
    return images, addText
  end
end  

class Battle::Move

  #=============================================================================
  # Type effectiveness calculation
  #=============================================================================
  def pbCalcTypeModSingleUI(moveType, defType, user, target)
    ret = Effectiveness.calculate_one(moveType, defType)
    if Effectiveness.ineffective_type?(moveType, defType)
      # Ring Target
      if target.hasActiveItem?(:RINGTARGET)
        ret = Effectiveness::NORMAL_EFFECTIVE_ONE
      end
      # Foresight
      if (user.hasActiveAbility?(:SCRAPPY)) &&
         defType == :GHOST
        ret = Effectiveness::NORMAL_EFFECTIVE_ONE
      end
      # Super Conductor # Changed by Jos 2022-09-28
      if (user.hasActiveAbility?(:CONDUCTOR)) && (defType == :GROUND)
        ret = Effectiveness::NORMAL_EFFECTIVE_ONE
      end
      # Corrosion # Changed by Jos 2023-09-25
      if (user.hasActiveAbility?(:CORROSION)) && (defType == :STEEL)
        ret = Effectiveness::NORMAL_EFFECTIVE_ONE
      end
      # Anti-Gravity # Changed by Jos 2022-10-29
      if (user.hasActiveAbility?(:ANTIGRAVITY)) && defType == :COSMIC
        ret = Effectiveness::NORMAL_EFFECTIVE_ONE
      end
      # Miracle Eye
      if target.effects[PBEffects::MiracleEye] && defType == :DARK
        ret = Effectiveness::NORMAL_EFFECTIVE_ONE
      end
    elsif Effectiveness.not_very_effective_type?(moveType, defType)
	  # Super Conductor # Changed by Jos 2022-09-28
      if (user.hasActiveAbility?(:CONDUCTOR)) && (defType == :ELECTRIC)
        ret = Effectiveness::NORMAL_EFFECTIVE_ONE
      end
      # Corrosion # Changed by Jos 2023-09-25
      if (user.hasActiveAbility?(:CORROSION)) && (defType == :POISON)
        ret = Effectiveness::NORMAL_EFFECTIVE_ONE
      end
    elsif Effectiveness.super_effective_type?(moveType, defType)
      # Delta Stream's weather
      if @battle.field.weather == :StrongWinds && defType == :FLYING
        ret = Effectiveness::NORMAL_EFFECTIVE_ONE
      end
    end
    user_item = (user.item != nil) ? user.item.id : nil
    case [user_item, moveType, defType]
      when [:SWORDNORMAL, :NORMAL, :DRAGON]; sword_redir = true
      when [:SWORDFIRE, :FIRE, :DARK]; sword_redir = true
      when [:SWORDWATER, :WATER, :COSMIC]; sword_redir = true
      when [:SWORDGRASS, :GRASS, :FAIRY]; sword_redir = true
      when [:SWORDELECTRIC, :ELECTRIC, :PSYCHIC]; sword_redir = true
      when [:SWORDICE, :ICE, :BUG]; sword_redir = true
      when [:SWORDPOISON, :POISON, :FIGHTING]; sword_redir = true
      when [:SWORDFIGHTING, :FIGHTING, :FIRE]; sword_redir = true
      when [:SWORDGROUND, :GROUND, :SOUND]; sword_redir = true
      when [:SWORDFLYING, :FLYING, :GHOST]; sword_redir = true
      when [:SWORDPSYCHIC, :PSYCHIC, :NORMAL]; sword_redir = true
      when [:SWORDBUG, :BUG, :ELECTRIC]; sword_redir = true
      when [:SWORDROCK, :ROCK, :LIGHT]; sword_redir = true
      when [:SWORDGHOST, :GHOST, :STEEL]; sword_redir = true
      when [:SWORDDRAGON, :DRAGON, :FLYING]; sword_redir = true
      when [:SWORDSTEEL, :STEEL, :POISON]; sword_redir = true
      when [:SWORDDARK, :DARK, :GRASS]; sword_redir = true
      when [:SWORDFAIRY, :FAIRY, :WATER]; sword_redir = true
      when [:SWORDCOSMIC, :COSMIC, :GROUND]; sword_redir = true
      when [:SWORDLIGHT, :LIGHT, :ICE]; sword_redir = true
      when [:SWORDSOUND, :SOUND, :ROCK]; sword_redir = true
      else; sword_redir = false
    end
    if sword_redir
      ret = Effectiveness::SUPER_EFFECTIVE_ONE
    end
    # # Grounded Flying-type Pokémon become susceptible to Ground moves
    # if !target.airborne? && defType == :FLYING && moveType == :GROUND
    #   ret = Effectiveness::NORMAL_EFFECTIVE_ONE
    # end
    return ret
  end

  def pbCalcTypeModUI(moveType, user, target)
    return Effectiveness::NORMAL_EFFECTIVE if !moveType
    # Determine types
    tTypes = target.pbTypes(true)
    # Get effectivenesses
    typeMods = [Effectiveness::NORMAL_EFFECTIVE_ONE] * 3   # 3 types max
    if moveType == :SHADOW
      if target.shadowPokemon?
        typeMods[0] = Effectiveness::NOT_VERY_EFFECTIVE_ONE
      else
        typeMods[0] = Effectiveness::SUPER_EFFECTIVE_ONE
      end
    else
      tTypes.each_with_index do |type, i|
        typeMods[i] = pbCalcTypeModSingleUI(moveType, type, user, target)
      end
    end
    # Multiply all effectivenesses together
    ret = 1
    typeMods.each { |m| ret *= m }
    ret *= 2 if target.effects[PBEffects::TarShot] && moveType == :FIRE
    return ret
  end

end  