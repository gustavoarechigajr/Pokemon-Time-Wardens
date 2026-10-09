#===============================================================================
# * Random Egg Generator - by FL (Credits will be apreciated)
#                          Updated by PDM20
#                          Addition code by TechSkylander1518
#===============================================================================
#
# This script is for Pokémon Essentials. It random generates an egg with all
# possible pokémon that can hatch from an eggs (excluding some species like
# Ditto, Mewtwo and Unown) with same probability.
#
#===============================================================================
#
# To this scripts works, put it above main and use in script command 
# 'randomEggGenerator'. This only gives to player an egg if the player has
# a empty party slot. You can also calls the method with an array with the
# exceptions that cannot be random generated. Example:
# randomEggGenerator([:DRATINI,:LARVITAR]) won't generates
# Dratini or Larvitar.
# 
# This script also doesn't generate eggs for pokémon than can incense breed
# like Marill, but generate for pokémon than are incense babies like Azurill. 
# If you wish to enable the both cases in eggs, both counting as different
# pokémon call the script using 'randomEggGenerator([],true)'.
# 
#===============================================================================
#PDM Edit 5/19/2023, Ver 2
def randomEggGenerator(exceptions=[],enableIncenseEvos=false,type=-1)
  pbMessage("removed, use randomEggGenerator2 instead")
end

#Changed by DemICE  29-May-2023 to fix egg forms 
module GameData
  class Species
    def get_baby_species(check_items = false, item1 = nil, item2 = nil,bullshit=false)
      if !bullshit
        ret = @species
      else  
        ret = bullshit
      end
      return ret if @evolutions.length == 0
      @evolutions.each do |evo|
        next if !evo[3]   # Not the prevolution
        if check_items
          incense = GameData::Species.get(evo[0]).incense
          ret = evo[0] if !incense || item1 == incense || item2 == incense
        else
          ret = evo[0]   # Species of prevolution
        end
        break
      end
      if !bullshit
      ret = GameData::Species.get(ret).get_baby_species(check_items, item1, item2,ret) if ret != @species
      else 
      ret = GameData::Species.get(ret).get_baby_species(check_items, item1, item2,ret) if ret != bullshit
      end
      return ret
    end
  end
end

def randomEggGenerator2(type=-1)
  # Define allowable Pokémon species for each type
  egg_species = []
  GameData::Type.each do |data|
    next if data.id==:QMARKS
    egg_species.push([data.id,[]])
  end
  GameData::Species.each do |data|
    for i in 0...egg_species.length
      next if data.real_form_name == "Anomaly"
      next if Settings::LEGEND_LIST.include?(data.species)
      baby = GameData::Species.get(data.id).get_baby_species
      baby_form = ("#{baby}_#{data.form}").to_sym
      if data.form != 0 && GameData::Species.exists?(baby_form)
        baby = ("#{baby}_#{data.form}").to_sym 
      end
      next if GameData::Species.get(baby).mega_stone != nil
      next if GameData::Species.get(baby).real_form_name == "Anomaly"
      next if Settings::LEGEND_LIST.include?(baby)
      next if GameData::Species.get(baby).flags.include?("BattleOnly")
      baby_type = GameData::Species.get(baby).types
      type_array = egg_species[i][0]
      in_group = (egg_species[i][1].include?(baby)) ? false : true
      conds = [in_group, baby_type, type_array]
      egg_species[i][1].push(baby) if in_group && baby_type.include?(type_array)
    end
  end
  allowed_species = {
    egg_species[0][0] => egg_species[0][1],
    egg_species[1][0] => egg_species[1][1],
    egg_species[2][0] => egg_species[2][1],
    egg_species[3][0] => egg_species[3][1],
    egg_species[4][0] => egg_species[4][1],
    egg_species[5][0] => egg_species[5][1],
    egg_species[6][0] => egg_species[6][1],
    egg_species[7][0] => egg_species[7][1],
    egg_species[8][0] => egg_species[8][1],
    egg_species[9][0] => egg_species[9][1],
    egg_species[10][0] => egg_species[10][1],
    egg_species[11][0] => egg_species[11][1],
    egg_species[12][0] => egg_species[12][1],
    egg_species[13][0] => egg_species[13][1],
    egg_species[14][0] => egg_species[14][1],
    egg_species[15][0] => egg_species[15][1],
    egg_species[16][0] => egg_species[16][1],
    egg_species[17][0] => egg_species[17][1],
    egg_species[18][0] => egg_species[18][1],
    egg_species[19][0] => egg_species[19][1],
    egg_species[20][0] => egg_species[20][1],
  }
  # Get the allowable species array for the given type
  allowable_array = allowed_species[type]
  if allowable_array.nil? || allowable_array.empty?
    puts "No allowable species found for type #{type}."
    return false
  end
  # Print the list of allowable species
  puts "Allowable species for type #{type}:"
  allowable_array.each { |species| puts species }
  # Randomly select a species from the allowable array
  selected_species = allowable_array.sample
  # Create a Pokémon with the selected species
  species_data = GameData::Species.get(selected_species)
  species = Pokemon.new(species_data, 1)
  species.name = _INTL("Egg")
  species.steps_to_hatch = species_data.hatch_steps
  species.obtain_text = _INTL("Dr. Eggman")
  species.happiness = 120
  # Add egg to Egg Hatcher
  ret = Kernel.pbConfirmMessage("Do you want to add the egg to the incubator?")
  if ret == true
    ret = addEgg(species)
    if ret == true
      return true
    end
  end
  # Store the Pokémon in the player's party or storage
  if $player.party_full?
    $PokemonStorage.pbStoreCaught(species)
  else
    $player.party[$player.party.length] = species
  end
  return true
end