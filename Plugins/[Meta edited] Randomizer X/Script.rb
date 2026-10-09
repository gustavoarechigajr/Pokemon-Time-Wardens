#===============================================================================
#  Randomizer Functionality for vanilla Essentials
#-------------------------------------------------------------------------------
#  Randomizes compiled data instead of generating random battlers on the fly
#===============================================================================
module Randomizer
  @@randomizer = false
  @@rules = []
  #-----------------------------------------------------------------------------
  #  check if randomizer is on
  #-----------------------------------------------------------------------------
  def self.running?
    return $PokemonGlobal && $PokemonGlobal.isRandomizer
  end
  def self.on?
    return self.running? && @@randomizer
  end
  #-----------------------------------------------------------------------------
  #  get nuzlocke rules
  #-----------------------------------------------------------------------------
  def self.rules; return @@rules; end
  def self.set_rules(rules); @@rules = rules; end
  #-----------------------------------------------------------------------------
  #  toggle randomizer state
  #-----------------------------------------------------------------------------
  def self.toggle(force = nil)
    @@randomizer = force.nil? ? !@@randomizer : force
    # refresh encounter tables
    $PokemonEncounters.setup($game_map.map_id) if $PokemonEncounters
  end
  #-----------------------------------------------------------------------------
  # get all species keys
  #-----------------------------------------------------------------------------
  def self.all_species(ignore_mega = true)
    keys = []
    GameData::Species.each { |species| 
      next if species.mega_stone != nil && ignore_mega
      next if species.real_form_name == "Anomaly"
      next if Settings::LEGEND_LIST.include?(species.species)
      next if GameData::Species.get(species).flags.include?("BattleOnly")
      keys.push(species.id)
    }
    return keys
  end
  #-----------------------------------------------------------------------------
  # get all item keys
  #-----------------------------------------------------------------------------
  def self.all_items
    keys = []
    GameData::Item.each { |item| keys.push(item.id) }
    return keys
  end
  #-----------------------------------------------------------------------------
  # get all ability keys
  #-----------------------------------------------------------------------------
  def self.all_abils
    keys = []
    ignore_abil = [:CARTOGRAPHER, :DESTRUCTIVECORE, :SYMPHONY, :DARKSWARM, :TELEFACE, :DISGUISE, :WINTERGIFT, :LIGHTSWITCH]
    GameData::Ability.each { |abil| next if ignore_abil.include?(abil.id); keys.push(abil.id) }
    return keys
  end
  #-----------------------------------------------------------------------------
  # get all move keys
  #-----------------------------------------------------------------------------
  def self.all_moves
    keys = []
    GameData::Move.each { |move| next if move.id == :BALANCERCHANGEREQUIRED; keys.push(move.id) }
    return keys
  end
  #-----------------------------------------------------------------------------
  #  command selection
  #-----------------------------------------------------------------------------
  def self.commandWindow(commands, index = 0, msgwindow = nil)
    ret = -1
    # creates command window
    cmdwindow = Window_CommandPokemonColor.new(commands)
    cmdwindow.index = index
    cmdwindow.x = Graphics.width - cmdwindow.width
    cmdwindow.z = 99999
    # main loop
    loop do
      # updates graphics, input and OW
      Graphics.update
      Input.update
      pbUpdateSceneMap
      # updates the two windows
      cmdwindow.update
      msgwindow.update if !msgwindow.nil?
      # updates command output
      if Input.trigger?(Input::B)
        pbPlayCancelSE
        ret = -1
        break
      elsif Input.trigger?(Input::C)
        pbPlayDecisionSE
        ret = cmdwindow.index
        break
      end
    end
    # returns command output
    cmdwindow.dispose
    return ret
  end
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
  #-----------------------------------------------------------------------------
  #  randomizes map encounters
  #-----------------------------------------------------------------------------
  def self.randomizeEncounters
    # loads map encounters
    data = load_data("Data/encounters.dat")
    species_exclusions = Randomizer::EXCLUSIONS_SPECIES
    return if !data.is_a?(Hash) # failsafe
    # iterates through each map point
    pbSetWindowText("Setting up Randomized Encounters")
    Console.echoln("Setting up Randomized Encounters.")
    idx = 0
    for key in data.keys
      idx += 1
      echo "." if idx%20 == 0
      # go through each encounter type
      for type in data[key].types.keys
        # cycle each definition
        for i in 0...data[key].types[type].length
          # set randomized species
          # Changed by DemICE 04-Sep-2023 fixing this to actually properly exclude the species in EXCLUSIONS_SPECIES
          loop do
            data[key].types[type][i][1] = self.all_species.sample
            break if species_exclusions.nil?
            break if !species_exclusions.include?(data[key].types[type][i][1])
          end  
        end
      end
    end
    pbSetWindowText(System.game_title + " | Speed: x" + ($GameSpeed+1).to_s)
    return data
  end
  #-----------------------------------------------------------------------------
  #  randomizes static battles called through events
  #-----------------------------------------------------------------------------
  def self.randomizeStatic
    # species_exclusions = Randomizer::EXCLUSIONS_SPECIES
    # array=[]
    pbSetWindowText("Setting up Randomized Static Encounters")
    new = {}
    idx = 0
    for m in 0...999
      idx += 1
      echo "." if idx%20 == 0
      map_name = sprintf("Data/Map%03d.rxdata", m)
      next if !File.exist?(map_name)
      map = load_data(map_name)
      create_hash = true
      for i in map.events.keys.sort
        pbSetWindowText("Setting up Random Event Pokemon for Map #{m}, Event #{i}")
        event_pkmn_list = []
        for p in 0...map.events[i].pages.length
          events = map.events[i].pages[p].list
          index = 0
          while index < events.length - 1
            command = events[index]
            params = command.parameters
            case command.code
              when 355, 111
              parm_index = (command.code == 355) ? 0 : 1
              code_text, pkmn_text = "", ""
              add_base_text, add_pkmn_text = true, false
              if params[parm_index].is_a?(String)
                updating = true
                for c in 0...params[parm_index].length
                  add_base_text = false if "#{params[parm_index][c]}" == "("
                  add_pkmn_text = true if "#{params[parm_index][c-1]}" == ":"
                  add_pkmn_text = false if [",",")"].include?("#{params[parm_index][c]}")
                  code_text += "#{params[parm_index][c]}" if add_base_text
                  pkmn_text += "#{params[parm_index][c]}" if add_pkmn_text && updating
                  updating = false if [",",")"].include?("#{params[parm_index][c]}")
                end
                if ["WildBattle.dx_start","WildBattle.start","pkmn = Pokemon.new"].include?(code_text)
                  event_pkmn_list.push(pkmn_text.to_sym) if !Randomizer::EXCLUSIONS_SPECIES.include?(pkmn_text.to_sym)
                end
              end
            end
            index += 1
          end
        end
        event_pkmn = {}
        if event_pkmn_list != []
          for e in 0...event_pkmn_list.length
            event_pkmn[event_pkmn_list[e].to_sym] = self.all_species.sample
          end
        end
        if event_pkmn != {}
          new["MapID_#{m}"] = {} if create_hash
          new["MapID_#{m}"]["EventID_#{i}"] = event_pkmn
          create_hash = false
        end
      end
    end
    pbSetWindowText(System.game_title + " | Speed: x" + ($GameSpeed+1).to_s)
    return new
  end
  #-----------------------------------------------------------------------------
  #  randomizes items received through events
  #-----------------------------------------------------------------------------
  def self.randomizeItems
    all_items = []
    blacklist = pbRandoEXItemBlacklist
    GameData::Item.each { |item| 
      next if blacklist.include?(item.id)
      all_items.push(item.id)
    }
    new = {}
    Console.echoln("Setting up Random Items.")
    idx = 0
    for m in 0...999
      idx += 1
      echo "." if idx%20 == 0
      map_name = sprintf("Data/Map%03d.rxdata", m)
      next if !File.exist?(map_name)
      map = load_data(map_name)
      create_hash = true
      for i in map.events.keys.sort
        pbSetWindowText("Setting up Random Items for Map #{m}, Event #{i}")
        if map.events[i].name == "BerryPlant"
          berries = {:CHERIBERRY => all_items.sample, :CHESTOBERRY => all_items.sample, :PECHABERRY => all_items.sample, :RAWSTBERRY => all_items.sample, :ASPEARBERRY => all_items.sample, :LEPPABERRY => all_items.sample, :ORANBERRY => all_items.sample, :PERSIMBERRY => all_items.sample, :LUMBERRY => all_items.sample, :SITRUSBERRY => all_items.sample, :FIGYBERRY => all_items.sample, :WIKIBERRY => all_items.sample, :MAGOBERRY => all_items.sample, :AGUAVBERRY => all_items.sample, :IAPAPABERRY => all_items.sample, :RAZZBERRY => all_items.sample, :BLUKBERRY => all_items.sample, :NANABBERRY => all_items.sample, :WEPEARBERRY => all_items.sample, :PINAPBERRY => all_items.sample, :POMEGBERRY => all_items.sample, :KELPSYBERRY => all_items.sample, :QUALOTBERRY => all_items.sample, :HONDEWBERRY => all_items.sample, :GREPABERRY => all_items.sample, :TAMATOBERRY => all_items.sample, :CORNNBERRY => all_items.sample, :MAGOSTBERRY => all_items.sample, :RABUTABERRY => all_items.sample, :NOMELBERRY => all_items.sample, :SPELONBERRY => all_items.sample, :PAMTREBERRY => all_items.sample, :WATMELBERRY => all_items.sample, :DURINBERRY => all_items.sample, :BELUEBERRY => all_items.sample, :OCCABERRY => all_items.sample, :PASSHOBERRY => all_items.sample, :WACANBERRY => all_items.sample, :RINDOBERRY => all_items.sample, :YACHEBERRY => all_items.sample, :CHOPLEBERRY => all_items.sample, :KEBIABERRY => all_items.sample, :SHUCABERRY => all_items.sample, :COBABERRY => all_items.sample, :PAYAPABERRY => all_items.sample, :TANGABERRY => all_items.sample, :CHARTIBERRY => all_items.sample, :KASIBBERRY => all_items.sample, :HABANBERRY => all_items.sample, :COLBURBERRY => all_items.sample, :BABIRIBERRY => all_items.sample, :ROSELIBERRY => all_items.sample, :CHILANBERRY => all_items.sample, :LIECHIBERRY => all_items.sample, :GANLONBERRY => all_items.sample, :SALACBERRY => all_items.sample, :PETAYABERRY => all_items.sample, :APICOTBERRY => all_items.sample, :LANSATBERRY => all_items.sample, :STARFBERRY => all_items.sample, :ENIGMABERRY => all_items.sample, :MICLEBERRY => all_items.sample, :CUSTAPBERRY => all_items.sample, :JABOCABERRY => all_items.sample, :ROWAPBERRY => all_items.sample, :KEEBERRY => all_items.sample, :MARANGABERRY => all_items.sample, :OLIBERRY => all_items.sample, :PATOTOBERRY => all_items.sample, :AVOCABERRY => all_items.sample}
          new["MapID_#{m}"] = {} if create_hash
          new["MapID_#{m}"]["EventID_#{i}"] = berries
          create_hash = false
        else
          event_item_list = []
          for p in 0...map.events[i].pages.length
            events = map.events[i].pages[p].list
            index = 0
            while index < events.length - 1
              command = events[index]
              params = command.parameters
              case command.code
                when 355, 111
                parm_index = (command.code == 355) ? 0 : 1
                code_text, item_text = "", ""
                add_base_text, add_item_text = true, false
                if params[parm_index].is_a?(String)
                  for c in 0...params[parm_index].length
                    add_base_text = false if "#{params[parm_index][c]}" == "("
                    add_item_text = true if "#{params[parm_index][c-1]}" == ":"
                    add_item_text = false if [",",")"].include?("#{params[parm_index][c]}")
                    code_text += "#{params[parm_index][c]}" if add_base_text
                    item_text += "#{params[parm_index][c]}" if add_item_text
                  end
                  if ["pbItemBall","pbReceiveItem"].include?(code_text)
				    Console.echo_warn(code_text) if m == 120
                    event_item_list.push(item_text.to_sym) if !blacklist.include?(item_text.to_sym)
                  end
                end
              end
              index += 1
            end
          end
          event_items = {}
          if event_item_list != []
            for e in 0...event_item_list.length
              event_items[event_item_list[e].to_sym] = all_items.sample
            end
          end
          if event_items != {}
            new["MapID_#{m}"] = {} if create_hash
            new["MapID_#{m}"]["EventID_#{i}"] = event_items if event_items != {}
            create_hash = false
          end
          # new["MapID_#{m}"]["EventID_#{i}"] = all_items.sample if event_items == {}
        end
      end
    end
    pbSetWindowText(System.game_title + " | Speed: x" + ($GameSpeed+1).to_s)
    return new
  end
  #-----------------------------------------------------------------------------
  #  randomizes abilities for all pokemon
  #-----------------------------------------------------------------------------
  def self.randomizeAbilities
    new = {}
    idx = 0
    Console.echoln("Setting up Random Ability Data.")
    GameData::Species.each do |data|
      pbSetWindowText("Setting up Random Ability Data for #{data.real_name}") if data.form == 0
      pbSetWindowText("Setting up Random Ability Data for #{data.real_name} Form #{data.form}") if data.form != 0
      idx += 1
      echo "." if idx%20 == 0
      ability, hidabil, new[data.id] = [], [], {}
      if data.abilities != []
        for a in 0...data.abilities.length
          abil_id = self.all_abils.sample
          ability.push(abil_id)
        end
      end
      if data.hidden_abilities != []
        for h in 0...data.hidden_abilities.length
          abil_id = self.all_abils.sample
          hidabil.push(abil_id)
        end
      end
      new[data.id][:abilities] = ability
      new[data.id][:hidden_abilities] = hidabil
    end
    pbSetWindowText(System.game_title + " | Speed: x" + ($GameSpeed+1).to_s)
    return new
  end
  #-----------------------------------------------------------------------------
  #  randomizes learnable moves for all pokemon
  #-----------------------------------------------------------------------------
  def self.randomizeMoveSets
    new = {}
    Console.echoln("Setting up Random Move Data.")
    idx = 0
    GameData::Species.each do |data|
      pbSetWindowText("Setting up Random Move Data for #{data.real_name}") if data.form == 0
      pbSetWindowText("Setting up Random Move Data for #{data.real_name} Form #{data.form}") if data.form != 0
      idx += 1
      echo "." if idx%20 == 0
      moveset, egg_move, tutor_move, new[data.id] = data.moves, data.egg_moves, data.tutor_moves, {}
      for s in 0...moveset.length
        move_id = self.all_moves.sample
        moveset[s][1] = move_id
      end
      for e in 0...egg_move.length
        move_id = self.all_moves.sample
        egg_move[e] = move_id
      end
      for t in 0...tutor_move.length
        move_id = self.all_moves.sample
        tutor_move[t] = move_id
      end
      new[data.id][:moves] = moveset
      new[data.id][:egg_moves] = egg_move
      new[data.id][:tutor_moves] = tutor_move
    end
    pbSetWindowText(System.game_title + " | Speed: x" + ($GameSpeed+1).to_s)
    return new
  end
  #-----------------------------------------------------------------------------
  #  begins the process of randomizing all data
  #-----------------------------------------------------------------------------
  def self.randomizeData
    data = {}
    # compiles hashtable with randomized values
    randomized = {
      :TRAINERS => proc{ next Randomizer.randomizeTrainers },
      :ENCOUNTERS => proc{ next Randomizer.randomizeEncounters },
      :STATIC => proc{ next Randomizer.randomizeStatic },
      :GIFTS => proc{ next Randomizer.randomizeStatic },
      :ITEMS => proc{ next Randomizer.randomizeItems },
      :ABILITY => proc{ next Randomizer.randomizeAbilities },
      :MOVESET => proc{ next Randomizer.randomizeMoveSets }
    }
    # applies randomized data for specified rule sets
    for key in @@rules
      data[key] = randomized[key].call if randomized.has_key?(key)
    end
    # return randomized data
    return data
  end
  #-----------------------------------------------------------------------------
  #  returns randomized data for specific entry
  #-----------------------------------------------------------------------------
  def self.getRandomizedData(data, symbol, index = nil)
    return data if !self.on?
    return data if pbRandoEXItemBlacklist.include?(data) && symbol == :ITEMS
    if $PokemonGlobal && $PokemonGlobal.randomizedData && $PokemonGlobal.randomizedData.has_key?(symbol)
      return $PokemonGlobal.randomizedData[symbol][index] if !index.nil?
      return $PokemonGlobal.randomizedData[symbol]
    end
    return data
  end
  #-----------------------------------------------------------------------------
  #  returns randomized data for specific entry
  #-----------------------------------------------------------------------------
  def self.getRandomizedEXData(data, symbol, index, sub_index)
    return data if !self.on?
    return data if pbRandoEXItemBlacklist.include?(data) && symbol == :ITEMS
    if $PokemonGlobal && $PokemonGlobal.randomizedData && $PokemonGlobal.randomizedData.has_key?(symbol)
      rand_data = $PokemonGlobal.randomizedData[symbol][index][sub_index]
      if rand_data.is_a?(Hash)
        return rand_data[data]
      else
        return rand_data
      end
    end
    return data
  end
  #-----------------------------------------------------------------------------
  # randomizes all data and toggles on randomizer
  #-----------------------------------------------------------------------------
  def self.start(skip = false)
    ret = $PokemonGlobal && $PokemonGlobal.isRandomizer
    ret, cmd = self.randomizerSelection unless skip
    @@randomizer = true
    # randomize data and cache it
    $PokemonGlobal.randomizedData = self.randomizeData if $PokemonGlobal.randomizedData.nil?
    $PokemonGlobal.isRandomizer = ret
    # refresh encounter tables
    $PokemonEncounters.setup($game_map.map_id) if $PokemonEncounters
    # display confirmation message
    return if skip
    msg = _INTL("Your selected Randomizer rules have been applied.")
    msg = _INTL("No Randomizer rules have been applied.") if @@rules.length < 1
    msg = _INTL("Your selection has been cancelled.") if cmd < 0
    pbMessage(msg)
  end
  #-----------------------------------------------------------------------------
  #  creates an UI to select the randomizer options
  #-----------------------------------------------------------------------------
  def self.randomizerSelection
    # list of all possible rules
    modifiers = [:TRAINERS, :ENCOUNTERS, :STATIC, :GIFTS, :ITEMS, :ABILITY, :MOVESET]
    # list of rule descriptions
    desc = [
      _INTL("Randomize Trainer parties"),
      _INTL("Randomize Wild encounters"),
      _INTL("Randomize Static encounters"),
      _INTL("Randomize Gifted Pokémon"),
      _INTL("Randomize Overworld Items"),
      _INTL("Randomize Pkmn Abilities"),
      _INTL("Randomize Pkmn Move")
    ]
    # default
    added = []; cmd = 0
    # creates help text message window
    msgwindow = pbCreateMessageWindow(nil, "choice 1")
    msgwindow.text = _INTL("Select the Randomizer Modes you wish to apply.")
    # main loop
    loop do
      # generates all commands
      commands = []
      for i in 0...modifiers.length
        commands.push(_INTL("{1} {2}", (added.include?(modifiers[i])) ? "[X]" : "[  ]", desc[i]))
      end
      commands.push(_INTL("Done"))
      # goes to command window
      cmd = self.commandWindow(commands, cmd, msgwindow)
      # processes return
      if cmd < 0
        clear = pbConfirmMessage("Do you wish to cancel the Randomizer selection?")
        added.clear if clear
        next unless clear
      end
      break if cmd < 0 || cmd >= (commands.length - 1)
      if cmd >= 0 && cmd < (commands.length - 1)
        if added.include?(modifiers[cmd])
          added.delete(modifiers[cmd])
        else
          added.push(modifiers[cmd])
        end
      end
    end
    # disposes of message window
    pbDisposeMessageWindow(msgwindow)
    # adds randomizer rules
    $PokemonGlobal.randomizerRules = added
    @@rules = added
    Input.update
    return (added.length > 0), cmd
  end
  #-----------------------------------------------------------------------------
  #  clear the randomizer content
  #-----------------------------------------------------------------------------
  def self.reset
    @@randomizer = false
    if $PokemonGlobal
      $PokemonGlobal.randomizedData = nil
      $PokemonGlobal.isRandomizer = nil
      $PokemonGlobal.randomizerRules = nil
    end
    $PokemonEncounters.setup($game_map.map_id) if $PokemonEncounters
  end
  #-----------------------------------------------------------------------------
end
#===============================================================================
#  helper functions to return randomized battlers and items
#===============================================================================
def randomizeSpecies(species, static = false, gift = false)
  return species if !Randomizer.on?
  pokemon = nil
  if species.is_a?(Pokemon)
    pokemon = species.clone
    species = pokemon.species
  end
  # if defined as an exclusion rule, species will not be randomized
  excl = Randomizer::EXCLUSIONS_SPECIES
  if !excl.nil? && excl.is_a?(Array)
    for ent in excl
      return (pokemon.nil? ? species : pokemon) if species == ent
    end
  end
  # randomizes static encounters
  key = :STATIC if static
  key = :GIFTS if gift
  event_id = (@event_id.is_a?(Numeric)) ? @event_id : pbMapInterpreter.get_self.id
  species = Randomizer.getRandomizedEXData(species, key, "MapID_#{$game_map.map_id}", "EventID_#{event_id}")
  if !pokemon.nil?
    pokemon.species = species
    pokemon.reset_moves # Changed by Jos 2023-08-27 because there was a typo
    pokemon.calc_stats # Changed by Jos 2023-08-27
  end
  return pokemon.nil? ? species : pokemon
end

def randomizeItem(item)
  return item if !Randomizer.on?
  return item if GameData::Item.get(item).is_key_item?
  # if defined as an exclusion rule, species will not be randomized
  excl = Randomizer::EXCLUSIONS_ITEMS
  if !excl.nil? && excl.is_a?(Array)
    for ent in excl
      return item if item == ent
    end
  end
  return Randomizer.getRandomizedData(item, :ITEMS, item)
end
#===============================================================================
#  aliasing to return randomized battlers
#===============================================================================
alias pbBattleOnStepTaken_randomizer_x pbBattleOnStepTaken unless defined?(pbBattleOnStepTaken_randomizer_x)
def pbBattleOnStepTaken(*args)
  $rndx_non_static = true
  pbBattleOnStepTaken_randomizer_x(*args)
  $rndx_non_static = false
end
#===============================================================================
#  aliasing to randomize static battles
#===============================================================================
alias pbWildBattle_randomizer_x pbWildBattle unless defined?(pbWildBattle_randomizer_x)
def pbWildBattle(*args)
  # randomizer
  for i in [0]
    args[i] = randomizeSpecies(args[i], !$rndx_non_static)
  end
  # starts battle processing
  return pbWildBattle_randomizer_x(*args)
end

alias pbDoubleWildBattle_randomizer_x pbDoubleWildBattle unless defined?(pbDoubleWildBattle_randomizer_x)
def pbDoubleWildBattle(*args)
  # randomizer
  for i in [0, 2]
    args[i] = randomizeSpecies(args[i], !$rndx_non_static)
  end
  # starts battle processing
  return pbDoubleWildBattle_randomizer_x(*args)
end

alias pbTripleWildBattle_randomizer_x pbTripleWildBattle unless defined?(pbTripleWildBattle_randomizer_x)
def pbTripleWildBattle(*args)
  # randomizer
  for i in [0, 2, 4]
    args[i] = randomizeSpecies(args[i], !$rndx_non_static)
  end
  # starts battle processing
  return pbTripleWildBattle_randomizer_x(*args)
end
#===============================================================================
#  aliasing to randomize gifted Pokemon
#===============================================================================
alias pbAddPokemon_randomizer_x pbAddPokemon unless defined?(pbAddPokemon_randomizer_x)
def pbAddPokemon(*args)
  og_mon = args[0]
  # randomizer
  args[0] = randomizeSpecies(args[0], false, true)
  if args[0] == nil
    args[0] = og_mon  
  end
  # gives Pokemon
  return pbAddPokemon_randomizer_x(*args)
end

alias pbAddPokemonSilent_randomizer_x pbAddPokemonSilent unless defined?(pbAddPokemonSilent_randomizer_x)
def pbAddPokemonSilent(*args)
  og_mon = args[0]
  # randomizer
  args[0] = randomizeSpecies(args[0], false, true)
  if args[0] == nil
    args[0] = og_mon  
  end
  # gives Pokemon
  return pbAddPokemonSilent_randomizer_x(*args)
end
#===============================================================================
#  snipped of code used to alias the item receiving
#===============================================================================
#-----------------------------------------------------------------------------
#  item find
alias randoEX_pbReceiveItem pbReceiveItem
alias randoEX_pbItemBall pbItemBall
def pbRandoEXItemBlacklist
  ret = []
  blacklist = Randomizer::EXCLUSIONS_ITEMS
  GameData::Item.each do |data|
    add_to_blacklist = data.is_key_item? || data.is_rune? || data.is_mail? || data.is_machine? || blacklist.include?(data.id)
    ret.push(data.id) if add_to_blacklist
  end
  return ret
end
#-----------------------------------------------------------------------------
#  item find
def pbReceiveItem(item, quantity = 1)
  exclude = pbRandoEXItemBlacklist
  item_randomEX = (Randomizer.on? && $PokemonGlobal.randomizedData[:ITEMS] != nil)
  rand_item = Randomizer.getRandomizedEXData(item, :ITEMS, "MapID_#{$game_map.map_id}", "EventID_#{@event_id}") if item_randomEX
  new_item = (item_randomEX && !exclude.include?(item)) ? rand_item : item
  randoEX_pbReceiveItem(new_item, quantity)
end
#-----------------------------------------------------------------------------
#  item ball
def pbItemBall(item, quantity = 1)
  exclude = pbRandoEXItemBlacklist
  item_randomEX = (Randomizer.on? && $PokemonGlobal.randomizedData[:ITEMS] != nil)
  rand_item = Randomizer.getRandomizedEXData(item, :ITEMS, "MapID_#{$game_map.map_id}", "EventID_#{@event_id}") if item_randomEX
  new_item = (item_randomEX && !exclude.include?(item)) ? rand_item : item
  randoEX_pbItemBall(new_item, quantity)  
end
#-----------------------------------------------------------------------------
#  berry item
def pbPickBerry(berry, qty = 1)
  qty *= 2 if $bag.has?(:BERRYCHARM)
  item_randomEX = (Randomizer.on? && $PokemonGlobal.randomizedData[:ITEMS] != nil)
  core_berry = GameData::Item.get(berry)
  new_berry = (item_randomEX) ? Randomizer.getRandomizedEXData(berry, :ITEMS, "MapID_#{$game_map.map_id}", "EventID_#{@event_id}") : berry
  berry = GameData::Item.get(new_berry)
  berry_name = (qty > 1) ? berry.name_plural : berry.name
  if qty > 1
    message = _INTL("There are {1} \\c[1]{2}\\c[0]!\nWant to pick them?", qty, berry_name)
  else
    message = _INTL("There is 1 \\c[1]{1}\\c[0]!\nWant to pick it?", berry_name)
  end
  return false if !pbConfirmMessage(message)
  if !$bag.can_add?(berry, qty)
    pbMessage(_INTL("Too bad...\nThe Bag is full..."))
    return false
  end
  $stats.berry_plants_picked += 1
  if qty >= GameData::BerryPlant.get(core_berry.id).maximum_yield
    $stats.max_yield_berry_plants += 1
  end
  $bag.add(berry, qty)
  if qty > 1
    pbMessage(_INTL("\\me[Berry get]You picked the {1} \\c[1]{2}\\c[0].\\wtnp[30]", qty, berry_name))
  else
    pbMessage(_INTL("\\me[Berry get]You picked the \\c[1]{1}\\c[0].\\wtnp[30]", berry_name))
  end
  pocket = berry.pocket
  pbMessage(_INTL("{1} put the \\c[1]{2}\\c[0] in the <icon=bagPocket{3}>\\c[1]{4}\\c[0] Pocket.\1",
                  $player.name, berry_name, pocket, PokemonBag.pocket_names[pocket - 1]))
  if Settings::NEW_BERRY_PLANTS
    pbMessage(_INTL("The soil returned to its soft and earthy state."))
  else
    pbMessage(_INTL("The soil returned to its soft and loamy state."))
  end
  this_event = pbMapInterpreter.get_self
  pbSetSelfSwitch(this_event.id, "A", true)
  return true
end
#===============================================================================
#  additional entry to Global Metadata for randomized data storage
#===============================================================================
class PokemonGlobalMetadata
  attr_accessor :randomizedData
  attr_accessor :isRandomizer
  attr_accessor :randomizerRules
end
#===============================================================================
#  refresh cache on load
#===============================================================================
class PokemonLoadScreen
  alias pbStartLoadScreen_randomizer_x pbStartLoadScreen unless self.method_defined?(:pbStartLoadScreen_randomizer_x)
  def pbStartLoadScreen
    ret = pbStartLoadScreen_randomizer_x
    # refresh current cache
    if $PokemonGlobal && $PokemonGlobal.isRandomizer
      Randomizer.start(true)
      Randomizer.set_rules($PokemonGlobal.randomizerRules) if !$PokemonGlobal.randomizerRules.nil?
    end
    return ret
  end
end
#===============================================================================
#  randomize trainer data if possible
#===============================================================================
def pbLoadTrainer(tr_type, tr_name, tr_version = 0)
  # handle trainer type process
  tr_type_data = GameData::TrainerType.try_get(tr_type)
  raise _INTL("Trainer type {1} does not exist.", tr_type) if !tr_type_data
  tr_type = tr_type_data.id
  # handle actual trainer data
  trainer_data = GameData::Trainer.try_get(tr_type, tr_name, tr_version)
  key = [tr_type.to_sym, tr_name, tr_version]
  # attempt to randomize
  trainer_data = Randomizer.getRandomizedData(trainer_data, :TRAINERS, key)
  return (trainer_data) ? trainer_data.to_trainer : nil
end
#===============================================================================
#  randomize encounter data if possible
#===============================================================================
module GameData
  #---------------------------------------------------------------------------
  class Species
    def move_randomEX; return (Randomizer.on? && $PokemonGlobal.randomizedData[:MOVESET] != nil); end
    def abil_randomEX; return (Randomizer.on? && $PokemonGlobal.randomizedData[:ABILITY] != nil); end

    def abilities
      abil_set = (abil_randomEX) ? Randomizer.getRandomizedEXData(@abilities, :ABILITY, @id, :abilities) : @abilities
      return abil_set
    end

    def hidden_abilities
      abil_set = (abil_randomEX) ? Randomizer.getRandomizedEXData(@hidden_abilities, :ABILITY, @id, :hidden_abilities) : @hidden_abilities
      return abil_set
    end

    def moves
      move_set = (move_randomEX) ? Randomizer.getRandomizedEXData(@moves, :MOVESET, @id, :moves) : @moves
      return move_set
    end

    def tutor_moves
      move_set = (move_randomEX) ? Randomizer.getRandomizedEXData(@tutor_moves, :MOVESET, @id, :tutor_moves) : @tutor_moves
      return move_set
    end

    def get_egg_moves
      move_set = (move_randomEX) ? Randomizer.getRandomizedEXData(@egg_moves, :MOVESET, @id, :egg_moves) : @egg_moves
      return move_set if !move_set.empty?
      return GameData::Species.get_species_form(get_previous_species, @form).get_egg_moves if get_previous_species != @species
      return move_set
    end
  end
  #---------------------------------------------------------------------------
  class Trainer
    def move_randomEX; return (Randomizer.on? && $PokemonGlobal.randomizedData[:MOVESET] != nil); end
    def abil_randomEX; return (Randomizer.on? && $PokemonGlobal.randomizedData[:ABILITY] != nil); end

    alias randoEX_to_trainer to_trainer
    def to_trainer
      trainer = randoEX_to_trainer
      trainer.party.each_with_index do |pkmn, i|
        pkmn_data = @pokemon[i]
        if pkmn_data[:moves] != nil && move_randomEX
          pkmn.reset_moves
        end
      end
      return trainer
    end
  end
  #---------------------------------------------------------------------------
  class Encounter
    #---------------------------------------------------------------------------
    def self.each_of_version(version = 0)
      enc_rando = (Randomizer.on? && $PokemonGlobal.randomizedData[:ENCOUNTERS] != nil) ? true : false
      self.each do |data|
        data = GameData::Encounter.get(data.map) if enc_rando
        yield data if data.version == version
        if version > 0 && data.version == 0 && !self::DATA.has_key?([data.map, version])
          yield data
        end
      end
    end
    #---------------------------------------------------------------------------
    class << self
      alias get_rndx get unless self.method_defined?(:get_rndx)
    end
    #---------------------------------------------------------------------------
    def self.get(map_id, map_version = 0)
      validate map_id => Integer
      validate map_version => Integer
      trial_key = sprintf("%s_%d", map_id, map_version).to_sym
      key = (self::DATA.has_key?(trial_key)) ? trial_key : sprintf("%s_0", map_id).to_sym
      data = get_rndx(map_id, map_version)
      return Randomizer.getRandomizedData(data, :ENCOUNTERS, key)
    end
    #---------------------------------------------------------------------------
  end
end
