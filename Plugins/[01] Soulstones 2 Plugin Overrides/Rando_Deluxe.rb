class WildBattle
  def self.dx_start(foes, rules = {}, pokemon = {}, midbattle = {})
    for i in [0]
      foes[i] = randomizeSpecies(foes[i], true)
    end
    $game_temp.dx_rules     = rules
    $game_temp.dx_pokemon   = pokemon
    $game_temp.dx_midbattle = midbattle
    rules[:rank] = nil
    rules[:outcome] = 1 if !rules[:outcome]
    foe_size = 0
    foes.each { |f| foe_size += 1 if f.is_a?(Array) || f.is_a?(Symbol) || f.is_a?(Pokemon) }
    oldTrainer = [$player.name, $player.outfit, $player.party]
    pbApplyBattleRules(foe_size, true)
    pkmn = []
    species = level = nil
    foes.each do |foe|
      case foe
        when Pokemon then pkmn.push(foe)
        when Symbol  then species = foe
        when Integer then level = foe
      end
      if species && level
        next if !GameData::Species.exists?(species)
        next if !(1..Settings::MAXIMUM_LEVEL).include?(level)
        pkmn.push(Pokemon.new(species, level))
        species = level = nil
      end
    end
    pbApplyWildAttributes(pkmn)
    if $game_temp.dx_midbattle.is_a?(Symbol) && hasConst?(EssentialsDeluxe, $game_temp.dx_midbattle)
      hash = getConst(EssentialsDeluxe, $game_temp.dx_midbattle).clone
      $game_temp.dx_midbattle = hash
    end
    outcome = WildBattle.start(*pkmn, can_override: false)
    if rules[:player]
      $player.name = oldTrainer[0]
      $player.outfit = oldTrainer[1]
    end
    if rules[:party]
      $player.party = oldTrainer[2]
    end	  
    $game_temp.dx_clear
    return outcome
  end
end

module Randomizer  
  #-----------------------------------------------------------------------------
  #  randomizes compiled trainer data
  #-----------------------------------------------------------------------------
  def self.randomizeTrainers
    # loads compiled data and creates new array
    data = load_data("Data/trainers.dat")
    trainer_exclusions = Randomizer::EXCLUSIONS_TRAINERS
    species_exclusions = Randomizer::EXCLUSIONS_SPECIES
    return if !data.is_a?(Hash) # failsafe
    # iterate through each trainer
    pbSetWindowText("Setting up Randomized Trainer Battles")
    Console.echoln("Setting up Randomized Trainer Battles.")
    idx = 0
    for key in data.keys
      idx += 1
      echo "." if idx%20 == 0
      # skip numeric trainers
      next if !trainer_exclusions.nil? && trainer_exclusions.include?(data[key].id[0])
      # iterate through party
      for i in 0...data[key].pokemon.length
        # set randomized species
          # Changed by DemICE 04-Sep-2023 fixing this to actually properly exclude the species in EXCLUSIONS_SPECIES
        loop do
          data[key].pokemon[i][:species] = self.all_species(false).sample
          break if species_exclusions.nil?
          break if !species_exclusions.include?(data[key].pokemon[i][:species])
        end  
      end
    end
    pbSetWindowText(System.game_title + " | Speed: x" + ($GameSpeed+1).to_s)
    return data
  end

end