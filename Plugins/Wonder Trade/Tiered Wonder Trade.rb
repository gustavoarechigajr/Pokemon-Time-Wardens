#==============================================================================#
# Neo Wonder-Trading ~By PDM20, Original by Black Eternity                     #
#==============================================================================#
RandTN = [
"Aaron","Adam","Albert","Alex","Alexa","Alexandra","Ali","Alice","Amber","Amy","Andrea",
"Andrew","Anne","Annie","Anthony","Ariel","Arthur","Ashley","Aurora","Ben","Betty","Beverly",
"Bill","Blake","Bobby","Brandon","Brian","Brigitte","Bruno","Carl","Carolyn","Catherine","Charles",
"Cheryl","Chloe","Christina","Christine","Christopher","Clarence","Cody","Craig","Darren","David",
"Deborah","Denise","Dennis","Diane","Divya","Donald","Donna","Dorist","Dorothy","Douglas","Ella","Elsa",
"Emily","Ernest","Evelyn","Farah","Fiona","Frances","Fred","Galen","Gary","Geeta","George",
"Gita","Grace","Greg","Harold","Harry","Helen","Henrietta","Henry","Howard","Irene","Jack",
"Jacqueline","James","Janice","Jasmine","Jayesh","Jean","Jeffrey","Jeremy","Jesse","Joan","Joe",
"Joel","Joseph","Josh","Juan","Julia","Kaitlyn","Karen","Karina","Karthik","Katherine","Kathleen",
"Kathryn","Kathy","Katie","Keith","Kenneth","Kevin","Larry","Laura","Linda","Lisa","Lois",
"Lori","Lorraine","Louis","Louisel","Luc","Luke","Maria","Marie","Marina","Marissa","Martin",
"Matt","Matthew","Melissa","Merlyn","Michael","Michelle","Mildred","Nancy","Nathan","Nerissa","Ophelia",
"Patricia","Patrick","Paul","Peter","Phillip","Phyllis","Rachaita","Rachel","Raj","Ralph","Randy",
"Raymond","Rhea","Rick","Roger","Ronald","Rose","Rowan","Russell","Sandra","Sara","Scott",
"Sean","Shae","Sharon","Shirley","Shoban","Spencer","Stephanie","Stephen","Steve","Steven","Susan",
"Tara","Taylor","Ted","Teresa","Theresa","Tia","Todd","Tyler","Tyson","Vanessa","Victoria",
"Virginia","Wanda","Wesley","Weston","William","Zoey"]

RandPN = [
"Ami","Amore","Anvil","Ash","Bambam","Babs","Backbone","Baldie","Bambino","Bandit","Beetle","Big",
"Boomhauer","Braveheart","Brown","Bubble","Bumpkin","BunnyRabbit","Butt","Captain","Carrot","Cheddar","Chewbacca",
"Coach","Coke","Conductor","Crunch","Cyber","Dear","Dingo","Doctor","Dolly","Doofus","Double","Dracula",
"Dragon","Dragonfly","Drake","Dropout","Dulce","Fiesta","Foxy","Frauline","Frogger","Genius","Giant",
"Goblin","Goose","Green","Heisenberg","Jackrabbit","Jet","Kitten","Kitty","Lobster","MacLady","Mama",
"Matey","MissPiggy","Mistress","Mouse","Munchkin","Nocturnal","Oreo","PBJ","Pearl","Pebbles","Pepper","Pinata","Psycho","Punk",
"QueenBee","Rockette","Rosebud","Shuttershy","SickleCell","Silly","Slim","Sugar","Sunny","Tater","Tots","Turkey",
"Turtle","Twig","Twiggy","Wheels","Wilma","Yammer","Zak","Zeke"]

# <= 399 BST
Tier1 = []
# 400 - 484 BST
Tier2 = []
# 485 - 569 BST
Tier3 = []
# banlist > 570 BST and T.Phione
Tier4 = [:CRESSELIA,:DARKRAI,:DRAGAPULT,:DRAGONITE,:ETERNATUS,:GARCHOMP,:GARCHOMP2,:GOODRA,:HOOPA,:HYDREIGON,:KOMMOO,:MANAPHY2,:MELOETTA,:METAGROSS,:PHIONE2,:REGICE,:REGIROCK,:REGISTEEL,:SALAMENCE,:SLAKING,:TAPUBULU,:TAPUFINI,:TAPUKOKO,:TAPULELE,:TYRANITAR,:BAXCALIBUR,:MELMETAL,:MEW,:ARCHALUDON,:HOOPA_1,:WISHIWASHI_1]
# banlist - Canon Legendaries
Tier5 = [:MANAPHY, :DIALGA, :PALKIA, :GIRATINA, :ARCEUS]


def pbStartWonderTrade
  #Select Pokemon
  tier1 = []
  tier2 = []
  tier3 = []
  banlist = []
  for b in 0...Tier4.length; banlist.push(Tier4[b]); end
  for b in 0...Tier5.length; banlist.push(Tier5[b]); end
  GameData::Species.each do |data|
      next if data.real_form_name == "Anomaly"
      next if Settings::LEGEND_LIST.include?(data.species)
      next if banlist.include?(data.id)
	  next if data.mega_stone != nil
	  next if data.flags.include?("BattleOnly")
	  mon_data = GameData::Species.get(data.id)
      stats = mon_data.base_stats
	  bst = stats[:HP] + stats[:ATTACK] + stats[:DEFENSE] + stats[:SPECIAL_ATTACK] + stats[:SPECIAL_DEFENSE] + stats[:SPEED]
	  tier1.push(data.id) if bst <= 399
	  tier2.push(data.id) if bst >= 400 && bst <= 484
	  tier3.push(data.id) if bst >= 485 && bst <= 569
  end
  #lvl = LevelLimit[0] # Not being used anymore
  chosen = 0
  pbChooseTradablePokemon(1, 2,
    proc {
    |poke| !poke.egg? && !(poke.shadowPokemon?) #&& # No Eggs, No Shadow Pokemon
    })
  #Trade Pokemon
  if pbGet(1)==-1
    pbMessage(_INTL("Understandable. Have a nice day!"))
  else
    chap = $player.badge_count
    if chap >= 13
      command = 0
      cmd = [_INTL("Tier 1"),_INTL("Tier 2"),_INTL("Tier 3"),_INTL("Random")]
      command = pbMessage(_INTL("Select a trading tier"),cmd, -1, nil, command)
      case command
       when 0
        push_tier=1
       when 1
        push_tier=2
       when 2
        push_tier=3
       when 3, -1
        push_tier=0
      end
    else
      push_tier = 0
    end
    myPokemon = $player.party[pbGet(1)]
    opponent = NPCTrainer.new(RandTN[rand(RandTN.size)], :YOUNGSTER) # Just used a random trainer because I don't really care
    opponent.id = $player.make_foreign_ID
    yourPokemon = nil
    resetmoves = true
    # Changed by Jos 2023-09-03 for proper wonder trade tiering script
    # Initialize variables to store the selected tier and available Pokémon
    selected_tier = nil
    # Determine Pokémon tier based on badge count
    if push_tier == 0
      if chap < 5
        tier = tier1
      elsif chap >=5 && chap < 8 # 5 to 7 badges, 50% chance for tier 2 and 50% chance for tier 1
        tier = (rand(2)==0) ? tier1 : tier2        
      elsif chap >=8 # More than 8 badges
        chance = rand(10)
        tier = (chance < 2) ? tier3 : ((chance < 5) ? tier2 : tier1) # 20%/30%/50% chance for tier 3/2/1
      end
      selected_tier = (tier==tier3) ? "Tier 3" : ((tier==tier2) ? "Tier 2" : "Tier 1")
    else
      tier = (push_tier==3) ? tier3 : ((push_tier==2) ? tier2 : tier1)
      selected_tier = (tier==tier3) ? "Tier 3" : ((tier==tier2) ? "Tier 2" : "Tier 1")
    end
    # Display the selected tier in a message box
    Kernel.pbMessage("Selected Tier: #{selected_tier}")
    newpoke = tier[rand(tier.size)] #Added by PDM20
    nickname = RandPN[rand(RandPN.size)]
    if newpoke.is_a?(Pokemon)
      newpoke.owner = Pokemon::Owner.new_from_trainer(opponent)
      yourPokemon = newpoke
      resetmoves = false
    else
      species_data = GameData::Species.try_get(newpoke)
      raise _INTL("Species does not exist ({1}).", newpoke) if !species_data
      yourPokemon = Pokemon.new(species_data.id, myPokemon.level, opponent)
    end
    yourPokemon.name          = nickname
    yourPokemon.obtain_method = 2   # traded
    yourPokemon.reset_moves if resetmoves
    yourPokemon.record_first_moves
    $player.pokedex.register(yourPokemon)
    $player.pokedex.set_owned(yourPokemon.species)
    pbFadeOutInWithMusic {
      evo = PokemonTrade_Scene.new
      evo.pbStartScreen(myPokemon,yourPokemon,$player.name,opponent.name)
      evo.pbTrade
      evo.pbEndScreen
    }
    $player.party[pbGet(1)] = yourPokemon
    pbMessage(_INTL("Enjoy your new friend!"))
  end
end
