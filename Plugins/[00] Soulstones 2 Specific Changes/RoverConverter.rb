def make_rover
  File.open("dist/PokeRover/PBS/moves.txt", "wb") {|f|
    GameData::Move.each do |move|
      f.write("\#-------------------------------\r\n")
      f.write("[#{move.id}]\r\n")
      f.write("Name = #{move.real_name}\r\n")
      f.write("Type = #{move.type}\r\n")
      category = GameData::Move::SCHEMA["Category"][2][move.category]
      f.write("Category = #{category}\r\n")
      f.write("Power = #{move.base_damage}\r\n") if move.base_damage > 0
      f.write("Accuracy = #{move.accuracy}\r\n")
      f.write("TotalPP = #{move.total_pp}\r\n")
      f.write("Target = #{move.target}\r\n")
      f.write("Priority = #{move.priority}\r\n") if move.priority != 0
      f.write("FunctionCode = #{move.function_code}\r\n")
      f.write("Flags = #{move.flags.join(',')}\r\n") if move.flags.length > 0
      f.write("EffectChance = #{move.effect_chance}\r\n") if move.effect_chance > 0
      f.write("Description = #{move.real_description}\r\n")
    end
  }
  File.open("dist/PokeRover/PBS/abilities.txt", "wb") {|f|
    GameData::Ability.each do |ability|
      f.write("\#-------------------------------\r\n")
      f.write("[#{ability.id}]\r\n")
      f.write("Name = #{ability.real_name}\r\n")
      f.write("Description = #{ability.real_description}\r\n")
      f.write("FullDesc = #{ability.full_description}\r\n")
      f.write(sprintf("Flags = %s\r\n", ability.flags.join(","))) if ability.flags.length > 0
    end
  }
  File.open("dist/PokeRover/PBS/encounters.txt", "wb") {|f|
    map_infos = pbLoadMapInfos
    GameData::Encounter.each do |encounter_data|
      f.write("\#-------------------------------\r\n")
      map_name = (map_infos[encounter_data.map]) ? " # #{map_infos[encounter_data.map].name}" : ""
      if encounter_data.version > 0
        f.write(sprintf("[%03d,%d]   %s\r\n", encounter_data.map, encounter_data.version, map_name))
      else
        f.write(sprintf("[%03d]   %s\r\n", encounter_data.map, map_name))
      end
      encounter_data.types.each do |type, slots|
        next if !slots || slots.length == 0
        if encounter_data.step_chances[type] && encounter_data.step_chances[type] > 0
          f.write(sprintf("%s,%d\r\n", type.to_s, encounter_data.step_chances[type]))
        else
          f.write(sprintf("%s\r\n", type.to_s))
        end
        slots.each do |slot|
          if slot[2] == slot[3]
            f.write(sprintf("    %d,%s,%d,%d\r\n", slot[0], slot[1], slot[2], slot[2]))
          else
            f.write(sprintf("    %d,%s,%d,%d\r\n", slot[0], slot[1], slot[2], slot[3]))
          end
        end
      end
    end
  }
  legends = Settings::LEGEND_LIST
  File.open("dist/PokeRover/PBS/pokemon.txt", "wb") { |f|
    idx = 0
    black_list = []
    for l in 0...legends.length
      add_to_blacklist = ($player.pokedex.owned?(legends[l])) ? false : true
      black_list.push(legends[l]) if add_to_blacklist
    end
    GameData::Species.each do |species|
      next if black_list.include?(species.species)
      next if species.real_form_name == "Anomaly"
      echo "." if idx % 50 == 0
      idx += 1
      Graphics.update if idx % 250 == 0
      f.write("\#-------------------------------\r\n")
      f.write(sprintf("Name = %s\r\n", species.real_name))
      nameID = (species.form != 0) ? sprintf("%s_%d",species.species.to_s, species.form) : species.species.to_s
      f.write(sprintf("InternalName = %s\r\n", nameID))
      f.write(sprintf("Type1 = %s\r\n", species.types[0]))
      f.write(sprintf("Type2 = %s\r\n", species.types[1])) if species.types.length != 1
      stats_array = []
      evs_array = []
      GameData::Stat.each_main do |s|
        next if s.pbs_order < 0
        stats_array[s.pbs_order] = species.base_stats[s.id]
        evs_array.concat([s.id.to_s, species.evs[s.id]]) if species.evs[s.id] > 0
      end
      f.write(sprintf("BaseStats = %s\r\n", stats_array.join(",")))
      f.write(sprintf("GenderRatio = %s\r\n", species.gender_ratio))
      f.write(sprintf("GrowthRate = %s\r\n", species.growth_rate))
      f.write(sprintf("BaseEXP = %d\r\n", species.base_exp))
      f.write(sprintf("EffortPoints = %s\r\n", evs_array.join(",")))
      f.write(sprintf("Rareness = %d\r\n", species.catch_rate))
      f.write(sprintf("Happiness = %d\r\n", species.happiness))
      if species.abilities.length > 0
        f.write(sprintf("Abilities = %s\r\n", species.abilities.join(",")))
      end
      if species.hidden_abilities.length > 0
        f.write(sprintf("HiddenAbility = %s\r\n", species.hidden_abilities.join(",")))
      end
      if species.moves.length > 0
        f.write(sprintf("Moves = %s\r\n", species.moves.join(",")))
      end
      if species.tutor_moves.length > 0
        f.write(sprintf("TutorMoves = %s\r\n", species.tutor_moves.join(",")))
      end
      if species.egg_moves.length > 0
        f.write(sprintf("EggMoves = %s\r\n", species.egg_moves.join(",")))
      end
      if species.egg_groups.length > 0
        f.write(sprintf("Compatibility = %s\r\n", species.egg_groups.join(",")))
      end
      f.write(sprintf("StepsToHatch = %d\r\n", species.hatch_steps))
      f.write(sprintf("Incense = %s\r\n", species.incense)) if species.incense
      if species.offspring.length > 0
        f.write(sprintf("Offspring = %s\r\n", species.offspring.join(",")))
      end
      f.write(sprintf("Height = %.1f\r\n", species.height / 10.0))
      f.write(sprintf("Weight = %.1f\r\n", species.weight / 10.0))
      f.write(sprintf("Color = %s\r\n", species.color))
      f.write(sprintf("Shape = %s\r\n", species.shape))
      f.write(sprintf("Habitat = %s\r\n", species.habitat)) if species.habitat != :None
      f.write(sprintf("Kind = %s\r\n", species.real_category))
      f.write(sprintf("Pokedex = %s\r\n", species.real_pokedex_entry))
      f.write(sprintf("FormName = %s\r\n", species.real_form_name)) if species.real_form_name && !species.real_form_name.empty?
      f.write(sprintf("Generation = %d\r\n", species.generation)) if species.generation != 0
      f.write(sprintf("Flags = %s\r\n", species.flags.join(","))) if species.flags.length > 0
      f.write(sprintf("WildItemCommon = %s\r\n", species.wild_item_common.join(","))) if species.wild_item_common.length > 0
      f.write(sprintf("WildItemUncommon = %s\r\n", species.wild_item_uncommon.join(","))) if species.wild_item_uncommon.length > 0
      f.write(sprintf("WildItemRare = %s\r\n", species.wild_item_rare.join(","))) if species.wild_item_rare.length > 0
      if species.evolutions.any? { |evo| !evo[3] }
        f.write("Evolutions = ")
        need_comma = false
        species.evolutions.each do |evo|
          next if evo[3]   # Skip prevolution entries
          f.write(",") if need_comma
          need_comma = true
          evo_type_data = GameData::Evolution.get(evo[1])
          param_type = evo_type_data.parameter
          form_num = (species.form!=0) ? "_#{species.form}" : ""
          f.write(sprintf("%s%s,%s,", evo[0], form_num, evo_type_data.id.to_s))
          if !param_type.nil?
            if param_type.is_a?(Symbol) && !GameData.const_defined?(param_type)
              f.write(getConstantName(param_type, evo[2]))
            else
              f.write(evo[2].to_s)
            end
          end
        end
        f.write("\r\n")
      end
    end
    f.write("\#-------------------------------\r\n")
  }
  spreadsheet = "dist/PokeRover/pokedexCEL.xlsx"
  File.delete(spreadsheet) if File.exists?(spreadsheet)
end

def pbChooseFromGameDataList(game_data, default = nil)
  if !GameData.const_defined?(game_data.to_sym)
    raise _INTL("Couldn't find class {1} in module GameData.", game_data.to_s)
  end
  game_data_module = GameData.const_get(game_data.to_sym)
  commands = []
  blacklist = Settings::LEGEND_LIST
  blacklist.uniq!
  game_data_module.each do |data|
    name = data.real_name
    name = yield(data) if block_given?
    next if !name
    next if blacklist.length != 250
    next if blacklist.include?(data.id) && !$player.pokedex.owned?(data.id)
    commands.push([commands.length + 1, name, data.id])
  end
  return pbChooseList(commands, default, nil, -1)
end

module Settings
  LEGEND_LIST = [
    :ARTICUNO, :ZAPDOS, :MOLTRES, :MEWTWO, :MEW, 
    :RAIKOU, :ENTEI, :SUICUNE, :LUGIA, :HOOH, :CELEBI, 
    :REGIROCK, :REGICE, :REGISTEEL, :LATIAS, :LATIOS, :KYOGRE, :GROUDON, :RAYQUAZA, :JIRACHI, :DEOXYS, 
    :UXIE, :MESPRIT, :AZELF, :DIALGA, :PALKIA, :HEATRAN, :REGIGIGAS, :GIRATINA, :CRESSELIA, :PHIONE, :MANAPHY, :DARKRAI, :SHAYMIN, :ARCEUS, 
    :VICTINI, :COBALION, :TERRAKION, :VIRIZION, :TORNADUS, :THUNDURUS, :RESHIRAM, :ZEKROM, :LANDORUS, :KYUREM, :KELDEO, :MELOETTA, :GENESECT, 
    :XERNEAS, :YVELTAL, :ZYGARDE, :DIANCIE, :HOOPA, :VOLCANION, :TYPENULL, :SILVALLY,
    :TAPUKOKO, :TAPULELE, :TAPUBULU, :TAPUFINI, :COSMOG, :COSMOEM, :SOLGALEO, :LUNALA, :NIHILEGO, :BUZZWOLE, :PHEROMOSA, :XURKITREE, :CELESTEELA, :KARTANA, :GUZZLORD, :NECROZMA, :MAGEARNA, :MARSHADOW, :POIPOLE, :NAGANADEL, :STAKATAKA, :BLACEPHALON, :ZERAORA, :MELTAN, :MELMETAL, 
    :ZACIAN, :ZAMAZENTA, :ETERNATUS, :KUBFU, :URSHIFU, :ZARUDE, :REGIELEKI, :REGIDRAGO, :GLASTRIER, :SPECTRIER, :CALYREX, :ENAMORUS, 
    :GREATTUSK, :SCREAMTAIL, :BRUTEBONNET, :FLUTTERMANE, :SLITHERWING, :SANDYSHOCKS, :IRONTREADS, :IRONBUNDLE, :IRONHANDS, :IRONJUGULIS, :IRONMOTH, :IRONTHORNS, :WOCHIEN, :CHIENPAO, :TINGLU, :CHIYU, :ROARINGMOON, :IRONVALIANT, :KORAIDON, :MIRAIDON, :WALKINGWAKE, :IRONLEAVES, :OKIDOGI, :MUNKIDORI, :FEZANDIPITI, :OGERPON, :GOUGINGFIRE, :RAGINGBOLT, :IRONBOULDER, :IRONCROWN, :TERAPAGOS, :PECHARUNT, 

    :ARTICUNO2, :ZAPDOS2, :MOLTRES2, :MEWTWO2, :MEW2, 
    :RAIKOU2, :ENTEI2, :SUICUNE2, :LUGIA2, :HOOH2, :CELEBI2, :REGIROCK2, :REGICE2, :REGISTEEL2, :LATIAS2, :LATIOS2, :KYOGRE2, :GROUDON2, :RAYQUAZA2, :JIRACHI2, :DEOXYS2, 
    :UXIE2, :MESPRIT2, :AZELF2, :DIALGA2, :PALKIA2, :HEATRAN2, :REGIGIGAS2, :GIRATINA2, :CRESSELIA2, :PHIONE2, :MANAPHY2, :DARKRAI2, :SHAYMIN2, :ARCEUS2, 
    :VICTINI2, :COBALION2, :TERRAKION2, :VIRIZION2, :TORNADUS2, :THUNDURUS2, :RESHIRAM2, :ZEKROM2, :LANDORUS2, :KYUREM2, :KELDEO2, :MELOETTA2, :GENESECT2, 
    :XERNEAS2, :YVELTAL2, :ZYGARDE2, :DIANCIE2, :HOOPA2, :VOLCANION2, :TYPENULL2, :SILVALLY2,
    :TAPUKOKO2, :TAPULELE2, :TAPUBULU2, :TAPUFINI2, :COSMOG2, :COSMOEM2, :SOLGALEO2, :LUNALA2, :NIHILEGO2, :BUZZWOLE2, :PHEROMOSA2, :XURKITREE2, :CELESTEELA2, :KARTANA2, :GUZZLORD2, :NECROZMA2, :MAGEARNA2, :MARSHADOW2, :POIPOLE2, :NAGANADEL2, :STAKATAKA2, :BLACEPHALON2, :ZERAORA2, :MELTAN2, :MELMETAL2, 
    :ZACIAN2, :ZAMAZENTA2, :ETERNATUS2, :KUBFU2, :URSHIFU2, :ZARUDE2, :REGIELEKI2, :REGIDRAGO2, :GLASTRIER2, :SPECTRIER2, :CALYREX2, :ENAMORUS2, 
    :GREATTUSK2, :SCREAMTAIL2, :BRUTEBONNET2, :FLUTTERMANE2, :SLITHERWING2, :SANDYSHOCKS2, :IRONTREADS2, :IRONBUNDLE2, :IRONHANDS2, :IRONJUGULIS2, :IRONMOTH2, :IRONTHORNS2, :WOCHIEN2, :CHIENPAO2, :TINGLU2, :CHIYU2, :ROARINGMOON2, :IRONVALIANT2, :KORAIDON2, :MIRAIDON2, :WALKINGWAKE2, :IRONLEAVES2, :OKIDOGI2, :MUNKIDORI2, :FEZANDIPITI2, :OGERPON2, :GOUGINGFIRE2, :RAGINGBOLT2, :IRONBOULDER2, :IRONCROWN2, :TERAPAGOS2, :PECHARUNT2
 ]
end

MenuHandlers.add(:pc_menu, :build_rover, {
  "name"      => proc { next _INTL("Gen Rover") },
  "order"     => 25,
  "effect"    => proc { |menu|
    pbMessage(_INTL("\\se[PC access]Generating Files for PokeRover"))
    make_rover
    pbMessage(_INTL("\\me[GUI save game]Files Generated!"))
    next false
  }
})
