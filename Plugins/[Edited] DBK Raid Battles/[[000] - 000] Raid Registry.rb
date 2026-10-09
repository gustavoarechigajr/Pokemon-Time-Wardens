##=============================================================================##
# Add to me when you add a new Raid event to the overworld. acceptable commands #
#  :pokemon     => :EXAMPLEID or [:EXAMPLEID1,:EXAMPLEID2,ect...]
#  :level       => Number
#  :first_clear => :ITEMID
#  :backdrop    => "Image File Name" (Do not add .png)
##=============================================================================##
# if :pokemon is a list of mons inside of a [] it will randomly pick one.
##=============================================================================##
RAID_OUTCOME_VAR = 600
RAID_TMPRIZE_VAR = 600
##=====================================##
#  Acceptable inputs for RAID_REGISTRY
#    :pokemon => :SPECIESID
#    :level => #Number
#    :hp_level => #Number <- Multiplies Actual HP, not Base HP [Overwrites Blanket HP Scaling]
#    :first_clear => :SYMBOL, "String" or [Array with :SYMBOL and "String"]
#    :backdrop => "String"
#    :weather => :Symbol
#    :terrain => :Symbol
#    :environ => :Symbol
##=====================================##
RAID_REGISTRY    = {
  "Europa Cave"      	  		=> {:pokemon => :BULBASAUR2, :level => 7, :first_clear => :TM141, :backdrop => "cave2"}, # TM is Essence Bloom
  "Auriga Coast"     	  		=> {:pokemon => :CLOBBOPUS, :level => 9, :first_clear => :TM209, :backdrop => "beach", :environ => :Sand}, # TM is Overflow
  "Auriga Caverns"   	  		=> {:pokemon => :NIDORANfE, :level => 10, :first_clear => :TM159, :backdrop => "cave3"}, # TM is Flame Charge
  "Epoch Mine"       	  		=> {:pokemon => :TRAPINCH, :level => 12, :first_clear => :TM143, :backdrop => "snow", :weather => :Hail, :environ => :Snow}, # TM is Icicle Strike
  "Triton Cave"      	  		=> {:pokemon => :NIDORANmA, :level => 14, :first_clear => [:TM133, "Rune04"], :backdrop => "icycave"}, # TM is Switcheroo; Rune is Snow Cloak
  "Corona Outskirts"      		=> {:pokemon => :CUFANT, :level => 16, :first_clear => [:TM184, "Rune03"], :backdrop => "reddesert", :weather => :Sandstorm, :environ => :Sand}, # TM is Seismic Chant; Rune is Sand Veil
  "Route 4C"     		  		=> {:pokemon => :TURTWIG2, :level => 17, :first_clear => :TM140, :backdrop => "cliff", :environ => :Rock}, # TM is Soul Rip
  "Telescopium Academy"   		=> {:pokemon => :BOUNSWEET, :level => 18, :first_clear => :TM144, :backdrop => "academy"}, # TM is Cleanse
  "Route 5A"     		  		=> {:pokemon => :PHANTUMP, :level => 20, :first_clear => :TM204, :backdrop => "autumn"}, # TM is Petal Tempest
  "Orion Underground"     		=> {:pokemon => :APPLIN, :level => 21, :first_clear => :TM171, :backdrop => "urbantunnel"}, # TM is Refurbish
  "Orion City (East)"  	  		=> {:pokemon => :VANILLITE, :level => 22, :first_clear => [:TM146, "Rune01"], :backdrop => "cybercityeast", :weather => :Rain, :environ => :None}, # TM is Clear Smog; Rune is Liquid Ooze
  "Orion Docks"     	  		=> {:pokemon => :WAILMER, :level => 23, :first_clear => :TM164, :backdrop => "dockswater", :weather => :Rain, :environ => :MovingWater}, # TM is Chilling Touch
  "Storage Warehouse"  	  		=> {:pokemon => :CUTIEFLY, :level => 23, :first_clear => :TM135, :backdrop => "warehouse"}, # TM is Parabolic Charge
  "Lower Mt. Titania L3"     		=> {:pokemon => :SHINX, :level => 23, :first_clear => :TM197, :backdrop => "reddesertcave"}, # TM is Ender Shock
  "Orion Sewers"     	  		=> {:pokemon => :WYNAUT, :level => 23, :first_clear => [:TM199, "Rune02"], :backdrop => "sewer"}, # TM is Covet; Rune is Aftermath
  "Orion Slums"     	  		=> {:pokemon => :KLINK, :level => 24, :first_clear => :TM157, :backdrop => "slums", :weather => :Rain, :environ => :None}, # TM is Pixie Dust
  "Orion Landfill"     	  		=> {:pokemon => :WIGLETT, :level => 25, :first_clear => :TM173, :backdrop => "landfill", :weather => :Rain, :terrain => :Electric, :environ => :None}, # TM is Bug Bite
  "Route 6A"     	  	  		=> {:pokemon => :BLITZLE, :level => 26, :first_clear => :TM195, :backdrop => "autumn", :terrain => :Grassy, :environ => :Grass}, # TM is Astral Wind
  "Route 6B"     	  	  		=> {:pokemon => :DODUO2, :level => 27, :first_clear => :TM202, :backdrop => "autumnlake", :environ => :MovingWater}, # TM is Aerial Ace
  "Mt. Oberon"     	  	  		=> {:pokemon => :MASCHIFF, :level => 28, :first_clear => :TM180, :backdrop => "cave3", :environ => :Volcano}, # TM is Flame Volley
  "Route 8A"     	  	  		=> {:pokemon => :CETODDLE, :level => 31, :first_clear => :TM190, :backdrop => "water", :environ => :MovingWater}, # TM is Sonic Blast
  "Indus Beach"    	  	  		=> {:pokemon => :HIPPOPOTAS, :level => 33, :first_clear => [:TM158, "Rune09"], :backdrop => "beach", :environ => :Sand}, # TM is Brick Break; Rune is Natural Cure
  "Indus Caverns"  	  	  		=> {:pokemon => :HELIOPTILE, :level => 35, :first_clear => :TM210, :backdrop => "cave5", :environ => :Cave}, # TM is Crystal Shower
  "Indus Temple Grounds"  		=> {:pokemon => :VENOMOTH, :level => 36, :first_clear => [:TM187, "Rune14"], :backdrop => "jungleruins", :weather => :Rain, :environ => :Puddle}, # TM is Venom Drain; Rune is Rain Dish
  "Temple of Time"  	  		=> {:pokemon => :NOSEPASS, :level => 37, :first_clear => :TM188, :backdrop => "jungletemple"}, # TM is Mind Meld
  "Europa Lake Underwater" 		=> {:pokemon => :PONYTA2, :level => 39, :first_clear => :TM132, :backdrop => "underwater", :environ => :Underwater}, # TM is Nebula Strike
  "Route 8A Underwater"			=> {:pokemon => :RHYHORN, :level => 39, :first_clear => :TM145, :backdrop => "underwater", :environ => :Underwater}, # TM is Slash
  "Route 8B Underwater Houses"  => {:pokemon => :PARASECT2, :level => 39, :first_clear => :TM206, :backdrop => "underwaterhouse", :environ => :Underwater}, # TM is Numbing Wind
  "Route 15B"  					=> {:pokemon => :DELCATTY, :level => 40, :first_clear => :TM167, :backdrop => "slums", :weather => :Rain}, # TM is Miasma
  "Route 5B"  					=> {:pokemon => :SWANNA, :level => 40, :first_clear => :TM148, :backdrop => "floating"}, # TM is Draconic Wave
  "Route 7A"					=> {:pokemon => :BEAUTIFLY, :level => 41, :first_clear => [:TM189, "Rune06"], :backdrop => "floating"}, # TM is Hex Bolt; Rune is Synchronize
  "Caverns of Rhea"				=> {:pokemon => :ELECTRODE2, :level => 43, :first_clear => :TM149, :backdrop => "crystalcave", :environ => :Cave}, # TM is Satellite Ray
  "Indus Marsh"  				=> {:pokemon => :CARNIVINE, :level => 44, :first_clear => [:TM194, "Rune08"], :backdrop => "swamp", :weather => :Rain, :environ => :Puddle}, # TM is Defend Order; Rune is Poison Point
  "Route 9A Underwater"			=> {:pokemon => :LAPRAS, :level => 45, :first_clear => :TM151, :backdrop => "underwater", :environ => :Underwater}, # TM is Submerge
  "Route 10A"					=> {:pokemon => :CAMERUPT, :level => 47, :first_clear => [:TM205, "Rune12"], :backdrop => "desert", :weather => :Sandstorm, :environ => :Sand}, # TM is Dust Devils; Rune is Clay Form
  "Undersand Caverns"			=> {:pokemon => :ACCELGOR, :level => 48, :first_clear => :TM170, :backdrop => "cave", :environ => :Sand}, # TM is Bone Chill
  "Temple of Space"			=> {:pokemon => :MANECTRIC, :level => 50, :first_clear => :TM142, :backdrop => "sandytomb"}, # TM is Earthen Lance
  "The In-Between"				=> {:pokemon => :ONIX2, :level => 52, :first_clear => [:TM153, "Rune07"], :backdrop => "inbetween", :environ => :Space}, # TM is Asteroid Belt; Rune is Unnerve
  "Antimatter Temple L4"		=> {:pokemon => :CLEFABLE, :level => 54, :first_clear => :TM161, :backdrop => "antimattertemple"}, # TM is Cursed Touch
  "Mt. Titania"					=> {:pokemon => :PRINPLUP, :level => 54, :first_clear => :TM178, :backdrop => "glacier", :weather => :Hail, :environ => :MovingWater}, # TM is Love Burst
  "Underwater Temple"			=> {:pokemon => :RELICANTH, :level => 55, :first_clear => :TM166, :backdrop => "underwatertomb"}, # TM is Flux Wave
  "Lyra Glacier"				=> {:pokemon => :WALREIN, :level => 56, :first_clear => :TM193, :backdrop => "glacier", :weather => :Hail, :environ => :MovingWater}, # TM is Tidal Wave
  "Route 11A"       	  		=> {:pokemon => :BELLIBOLT, :level => 57, :first_clear => [:TM156, "Rune10"], :backdrop => "snowforest", :weather => :Hail, :environ => :Snow}, # TM is Ball Lightning; Rune is Healer
  "Charon Ice Tunnels"      	=> {:pokemon => :PALOSSAND, :level => 58, :first_clear => :TM165, :backdrop => "cave4", :environ => :Ice}, # TM is Sacred Strike
  "Route 12B"      				=> {:pokemon => :GOGOAT, :level => 59, :first_clear => :TM183, :backdrop => "snowforest", :weather => :Hail, :environ => :Snow}, # TM is Scented Shield
  "Route 13B"      				=> {:pokemon => :ELECTRODE, :level => 61, :first_clear => [:TM174, "Rune11"], :backdrop => "snowforest", :weather => :Hail, :environ => :Snow}, # TM is Antimatter; Rune is Ice Body
  "Callisto Lake"  				=> {:pokemon => :ORBEETLE, :level => 62, :first_clear => :TM162, :backdrop => "autumn", :environ => :Grass}, # TM is Leaf Blade
  "Callisto Caverns"			=> {:pokemon => :DRAGALGE, :level => 62, :first_clear => [:TM203, "Rune05"], :backdrop => "underwater", :environ => :Underwater}, # TM is Ghastly Flood, Rune is Vital Spirit
  "Crew Quarters"				=> {:pokemon => :MARACTUS, :level => 63, :first_clear => :TM138, :backdrop => "submarine", :terrain => :Electric}, # TM is Iron Impact
  "Epoch Corporation HQ"		=> {:pokemon => :HARIYAMA, :level => 64, :first_clear => :SWORDELECTRIC, :backdrop => "sciencelab", :environ => :None}, # Reward is a Sword
  "Route 23C"					=> {:pokemon => :HAXORUS, :level => 64, :first_clear => :TM181, :backdrop => "reddesertmtn", :weather => :Sandstorm, :environ => :Rock}, # TM is Aerial Pulse
  "Route 14B"					=> {:pokemon => :JUMPLUFF2, :level => 65, :first_clear => :TM131, :backdrop => "crater", :environ => :Grass}, # TM is Swarm Attack
  "Route 16B"					=> {:pokemon => :MASQUERAIN, :level => 67, :first_clear => [:TM201, "Rune13"], :backdrop => "fogforest", :environ => :ForestGrass}, # TM is Wildfire, Rune is Synthesize
  "Deimos Caves L3"				=> {:pokemon => :SKARMORY, :level => 68, :first_clear => [:TM192, "Rune16"], :backdrop => "cave7", :environ => :Cave}, # TM is Obsidian Shards; Rune is Flame Body
  "Route 17A"					=> {:pokemon => :ELECTIVIRE, :level => 68, :first_clear => :TM136, :backdrop => "arceusruins", :terrain => :Misty, :environ => :Grass}, # TM is Strange Steam
  "Altar of Space"				=> {:pokemon => :FROSMOTH, :level => 70, :first_clear => [:TM137, "Rune15"], :backdrop => "stonetemple"}, # TM is Kamehameha; Rune is Battle Armor
  "Spire of Time"				=> {:pokemon => :BARBARACLE, :level => 73, :first_clear => :TM154, :backdrop => "spireantimatter", :environ => :Space}, # TM is Ambush
  "Shadowmoon Marsh"			=> {:pokemon => :ZOROARK2, :level => 77, :first_clear => :TM198, :backdrop => "shadowmoonmarsh", :environ => :ForestGrass}, # TM is Energy Surge
  "Eridanus Tunnels L4"			=> {:pokemon => :FORRETRESS, :level => 79, :first_clear => :TM139, :backdrop => "cave6", :environ => :Puddle}, # TM is Drill Peck
  "Libram Dungeons L2"			=> {:pokemon => :GOLURK, :level => 82, :first_clear => :TM176, :backdrop => "arcaneprison", :environ => :None}, # TM is Dragon Hammer
  "Aether Mine L3"				=> {:pokemon => :SCOLIPEDE, :level => 84, :first_clear => :TM152, :backdrop => "aethermine", :environ => :Cave}, # TM is Bug Buzz
  "Power Plant"					=> {:pokemon => :MUSHARNA, :level => 85, :first_clear => :TM169, :backdrop => "powerplant", :terrain => :Electric, :environ => :None}, # TM is Percussion Blast
  "The Arboretum"				=> {:pokemon => :SCOVILLAIN, :level => 86, :first_clear => :TM147, :backdrop => "arboretum", :environ => :ForestGrass}, # TM is Crystalline Beam
  "Libram Port"					=> {:pokemon => :CYCLIZAR, :level => 88, :first_clear => :TM134, :backdrop => "aethermine", :environ => :Sand}, # TM is Dragon Gale
  "Guulrahn Badlands"			=> {:pokemon => :LUXRAY, :level => 90, :first_clear => [:TM175, "Rune22"], :backdrop => "greydesert", :weather => :Sandstorm, :environ => :Sand}, # TM is Eclipse Nova, Rune is Compound Eyes
  "Nesting Grounds"				=> {:pokemon => :LURANTIS, :level => 91, :first_clear => :TM179, :backdrop => "bugnest", :environ => :Sand}, # TM is Weak Spot
  "Guulrahn Wastes"				=> {:pokemon => :GHOLDENGO, :level => 91, :first_clear => :SWORDFIGHTING, :backdrop => "greydesert", :weather => :Sandstorm, :environ => :Sand}, # Reward is a Sword
  "Draco Falls"     	  	  	=> {:pokemon => :GRENINJA, :level => 93, :first_clear => :TM191, :backdrop => "crater", :environ => :MovingWater}, # TM is Iron Tempest
  "Flooded Base"     	  	  	=> {:pokemon => :VIKAVOLT, :level => 94, :first_clear => :TM207, :backdrop => "submarine", :terrain => :Electric, :environ => :None}, # TM is Radiant Lance
  "Route 18B"     	  	  		=> {:pokemon => :SAWSBUCK, :level => 96, :first_clear => :TM185, :backdrop => "redforest", :terrain => :Grassy, :environ => :ForestGrass}, # TM is Ice Hammer
  "Route 22B"     	  	  		=> {:pokemon => :MIENSHAO, :level => 97, :first_clear => :TM168, :backdrop => "charredforest", :weather => :Sunny, :environ => :ForestGrass}, # TM is Boulder Crush
  "Route 22C"					=> {:pokemon => :MABOSSTIFF, :level => 97, :first_clear => :SWORDDRAGON, :backdrop => "charredforest", :weather => :Sunny, :environ => :ForestGrass}, # Reward is a Sword
  "Route 20A"     	  	  		=> {:pokemon => :TENTACRUEL, :level => 99, :first_clear => :TM172, :backdrop => "water", :weather => :Rain, :environ => :MovingWater}, # TM is Water Pressure
  "Abandoned Shipwreck"			=> {:pokemon => :TOGEDEMARU, :level => 99, :first_clear => :SWORDICE, :backdrop => "underwater", :environ => :Underwater}, # Reward is a Sword
  "Tucana Bayou"     	  	  	=> {:pokemon => :SKELEDIRGE, :level => 102, :first_clear => :TM155, :backdrop => "swamp", :weather => :Rain, :environ => :MovingWater}, # TM is Boomburst
  "The Trenches"     	  	  	=> {:pokemon => :GIGALITH2, :level => 104, :first_clear => :TM208, :backdrop => "aethermine", :environ => :Cave}, # TM is Caustic Acid
  "No Man's Land"				=> {:pokemon => :PROBOPASS2, :level => 106, :first_clear => :SWORDROCK, :backdrop => "aethermine", :environ => :Cave}, # Reward is a Sword
  "The Overgrowth"     	  	  	=> {:pokemon => :SHIINOTIC, :level => 109, :first_clear => :TM186, :backdrop => "shadowmoonforest", :weather => :Rain, :environ => :ForestGrass}, # TM is Holy Nova
  "Felfire Canyon" 	  	  		=> {:pokemon => :MILOTIC2, :level => 110, :first_clear => :SWORDSTEEL, :backdrop => "felfirecanyon", :environ => :Rock}, # Reward is a Sword
  "Castle Leviathan - Foyer" 	=> {:pokemon => :TREVENANT2, :level => 113, :first_clear => :SWORDNORMAL, :backdrop => "castledungeon", :environ => :None}, # Reward is a Sword
  "Castle Leviathan - Library" 	=> {:pokemon => :HATTERENE, :level => 114, :first_clear => :TM160, :backdrop => "castledungeon", :environ => :None}, # TM is Tempest Flare
}
ADVENTURE_BACKDROP = {
  0 => nil,
  1 => nil,
  2 => "reddesert",
  3 => "swamp",
  4 => "cave3",
  5 => "snowforest",
}
PROBLEMATIC_FCS = [
  "UserLosesHalfOfTotalHP",
  "UserFaintsExplosive",
  "AttackerFaintsIfUserFaints",
  "UserFaintsFixedDamageUserHP",
  "UserFaintsLowerTargetAtkSpAtk2",
  "UserFaintsHealAndCureReplacement",
  "UserFaintsPowersUpInMistyTerrainExplosive",
  "AttackAndSkipNextTurn",
  "TargetUsesItsLastUsedMoveAgain",
  "TargetUsesItsLastUsedMoveAgain",

  "TargetActsLast",
  "UserTargetSwapItems",
  "RaiseTargetSpDef1",
  "RaiseTargetAtkSpAtk2",
  "TargetActsNext",
  "UseRandomMoveFromUserParty",
  "SwitchOutUserPassOnEffects",
  "TargetTakesUserItem",
  "RedirectAllMovesToUser",
  "DoubleMoneyGainedFromBattle",
  "PowerUpAllyMove",
  "UserTargetAverageHP",
  "UserSwapsPositionsWithAlly",
  "HealTargetHalfOfTotalHP",
  "HealTargetDependingOnGrassyTerrain"
]

def pbRaidRuneReward(rune = "")
  if $game_switches[RAID_OUTCOME_VAR]
    case rune
      when "Rune01"; $game_switches[511] = true # Liquid Ooze
      when "Rune02"; $game_switches[512] = true # Aftermath
      when "Rune03"; $game_switches[513] = true # Sand Veil
      when "Rune04"; $game_switches[514] = true # Snow Cloak
      when "Rune05"; $game_switches[515] = true # Vital Spirit
      when "Rune06"; $game_switches[516] = true # Synchronize
      when "Rune07"; $game_switches[517] = true # Unnerve
      when "Rune08"; $game_switches[518] = true # Poison Point
      when "Rune09"; $game_switches[519] = true # Natural Cure
      when "Rune10"; $game_switches[520] = true # Healer
      when "Rune11"; $game_switches[521] = true # Ice Body
      when "Rune12"; $game_switches[522] = true # Clay Form
      when "Rune13"; $game_switches[523] = true # Synthesize
      when "Rune14"; $game_switches[524] = true # Rain Dish
      when "Rune15"; $game_switches[525] = true # Battle Armor
      when "Rune16"; $game_switches[526] = true # Flame Body
      when "Rune17"; $game_switches[527] = true # Mold Breaker
      when "Rune18"; $game_switches[528] = true # Shield Dust
      when "Rune19"; $game_switches[529] = true # Infiltrator
      when "Rune20"; $game_switches[530] = true # Analytic
      when "Rune21"; $game_switches[531] = true # Static
      when "Rune22"; $game_switches[532] = true # Compound Eyes
      when "Rune23"; $game_switches[533] = true # Tough Claws
      when "Rune24"; $game_switches[534] = true # Rivalry
      when "Rune25"; $game_switches[535] = true # Sniper
      when "Rune26"; $game_switches[536] = true # Impenetrable
      when "Rune27"; $game_switches[537] = true # Telepathy
      when "Rune28"; $game_switches[538] = true # Gooey
      when "Rune29"; $game_switches[539] = true # Inner Focus
      when "Rune30"; $game_switches[540] = true # Prism Armor
      when "Rune31"; $game_switches[541] = true # Arena Trap
      when "Rune32"; $game_switches[542] = true # Clear Body
      when "Rune33"; $game_switches[543] = true # Pastel Veil
    end
  end
end

def pbRaidRuneName(rune = "")
  if $game_switches[RAID_OUTCOME_VAR]
    if rune.is_a?(Array)
      for r in 0...rune.length
        rune = rune[r] if rune[r].is_a?(String)
      end
    end
    case rune
      when "Rune01"; rune_name = "Liquid Ooze"
      when "Rune02"; rune_name = "Aftermath"
      when "Rune03"; rune_name = "Sand Veil"
      when "Rune04"; rune_name = "Snow Cloak"
      when "Rune05"; rune_name = "Vital Spirit"
      when "Rune06"; rune_name = "Synchronize"
      when "Rune07"; rune_name = "Unnerve"
      when "Rune08"; rune_name = "Poison Point"
      when "Rune09"; rune_name = "Natural Cure"
      when "Rune10"; rune_name = "Healer"
      when "Rune11"; rune_name = "Ice Body"
      when "Rune12"; rune_name = "Clay Form"
      when "Rune13"; rune_name = "Synthesize"
      when "Rune14"; rune_name = "Rain Dish"
      when "Rune15"; rune_name = "Battle Armor"
      when "Rune16"; rune_name = "Flame Body"
      when "Rune17"; rune_name = "Mold Breaker"
      when "Rune18"; rune_name = "Shield Dust"
      when "Rune19"; rune_name = "Infiltrator"
      when "Rune20"; rune_name = "Analytic"
      when "Rune21"; rune_name = "Static"
      when "Rune22"; rune_name = "Compound Eyes"
      when "Rune23"; rune_name = "Tough Claws"
      when "Rune24"; rune_name = "Rivalry"
      when "Rune25"; rune_name = "Sniper"
      when "Rune26"; rune_name = "Impenetrable"
      when "Rune27"; rune_name = "Telepathy"
      when "Rune28"; rune_name = "Gooey"
      when "Rune29"; rune_name = "Inner Focus"
      when "Rune30"; rune_name = "Prism Armor"
      when "Rune31"; rune_name = "Arena Trap"
      when "Rune32"; rune_name = "Clear Body"
      when "Rune33"; rune_name = "Pastel Veil"
    end
  end
  return rune_name
end

def pbMultiRaidReward(rewards)
  for r in 0...rewards.length
    pbRaidRuneReward(rewards[r]) if rewards[r].is_a?(String)
    pbReceiveItem(rewards[r]) if rewards[r].is_a?(Symbol)
  end
end

def pbGetSubDenName #Add to me when you want to use a different raid den graphic in the overworld
  case $game_map.name
    when "";    sub_den = " - cave2"   
    # when "Europa Cave";    sub_den = " - cave2"   
    # when "Auriga Caverns"; sub_den = " - cave3"   
    # when "Triton Cave";    sub_den = " - icycave" 
    else; sub_den = ""
  end
  # This sends 'sub_den' to another method that loads a graphic in the character folder
  # ex. if the name of the map is Europa Cave the in game image used will be:
  # "Graphics/Characters/Object Den (Basic) - cave2.png"
  return sub_den
end

def pbLoadRaidDen
  raid = RAID_REGISTRY
  if raid[$game_map.name].is_a?(Hash)
    first = $game_self_switches[[$game_map.map_id, @event_id, "A"]]
    enc_data = []
    raid_data = raid[$game_map.name]
    setBattleRule("weather", raid_data[:weather]) if raid_data[:weather] != nil
    setBattleRule("terrain", raid_data[:terrain]) if raid_data[:terrain] != nil
    setBattleRule("environment", raid_data[:environ]) if raid_data[:environ] != nil
    pokemon = raid_data[:pokemon]
    setBattleRule("backdrop", raid_data[:backdrop]) if raid_data[:backdrop].is_a?(String)
    GameData::Encounter.each do |encounter_data|
      encounter_data.types.each do |type, slots|
        slots.each do |slot|
          enc_data.push(slot[1]) if encounter_data.map == $game_map.map_id
        end
      end
    end
    enc_data.uniq!
    enc_data.push(pokemon) if first && pokemon.is_a?(Symbol)
    if first && pokemon.is_a?(Array)
      for i in 0...pokemon.length
        enc_data.push(pokemon[i])
      end
    end
    case pokemon
      when Array; species = pokemon.sample
      when Symbol; species = pokemon
    end
    pkmn_data = (first) ? enc_data.sample : species
    pkmn = Pokemon.new(pkmn_data,raid_data[:level])
    problematic_moves, allowed_moves = PROBLEMATIC_FCS, []
    species_data = GameData::Species.get_species_form(pkmn.species,pkmn.form)
    prob_move_1, prob_move_2, prob_move_3, prob_move_4 = false, false, false, false 
    for i in 0...pkmn.moves.length
      move_data = GameData::Move.get(pkmn.moves[i].id)
      prob_move_1 = true if problematic_moves.include?(move_data.function_code) && i==0
      prob_move_2 = true if problematic_moves.include?(move_data.function_code) && i==1
      prob_move_3 = true if problematic_moves.include?(move_data.function_code) && i==2
      prob_move_4 = true if problematic_moves.include?(move_data.function_code) && i==3
    end
    if prob_move_1 || prob_move_2 || prob_move_3 || prob_move_4
      new_move_count = 0
      pkmn.forget_move_at_index(3) if prob_move_4
      new_move_count += 1 if prob_move_4
      pkmn.forget_move_at_index(2) if prob_move_3
      new_move_count += 1 if prob_move_3
      pkmn.forget_move_at_index(1) if prob_move_2
      new_move_count += 1 if prob_move_2
      pkmn.forget_move_at_index(0) if prob_move_1
      new_move_count += 1 if prob_move_1
      for t in 0...species_data.tutor_moves.length
        move_data = GameData::Move.get(species_data.tutor_moves[t])
        allowed_moves.push(move_data.id) if !problematic_moves.include?(move_data.function_code)
      end
      for e in 0...species_data.egg_moves.length
        move_data = GameData::Move.get(species_data.egg_moves[e])
        allowed_moves.push(move_data.id) if !problematic_moves.include?(move_data.function_code)
      end
      learn_new_moves = allowed_moves.sample(new_move_count)
      for l in 0...learn_new_moves.length; pkmn.learn_move(learn_new_moves[l]); end
    end
    GameData::Stat.each do |stat|; pkmn.iv[stat.id] = 31; end
    rules = {}
    rules = {:hp_level => raid_data[:hp_level]} if raid_data[:hp_level]
    outcome = pbRaidDen(pkmn, rules) 
    return [outcome, raid_data[:first_clear]]
  else
    pbRaidDen
  end
end

def pbLoadRaidEncData(mapID)
  enc_data, mega_data, new_ranks = [], [], [[],[],[],[],[],[],[]]
  GameData::Encounter.each do |encounter_data|
    encounter_data.types.each do |type, slots|
      slots.each do |slot|
        if $game_map.map_id == 551
          case mapID
            when 2; new_map_id = 275 # Desert Adventure Map [2], calling data from Route 23B (map ID 275)
			when 3; new_map_id = 319 # Jungle Adventure Map [3], calling data from Indus Jungles (map ID 319)
			when 4; new_map_id = 174 # Volcano Adventure Map [4], calling data from Mt. Oberon Level 3 (map ID 174)
			else;   new_map_id = $game_map.map_id # if mapID is not a number, use current maps encounter data
		  end
          enc_data.push(slot[1]) if encounter_data.map == new_map_id
        else
          enc_data.push(slot[1]) if encounter_data.map == $game_map.map_id
        end
      end
    end
  end
  GameData::Species.each do |data|
    next if data.real_form_name == "Anomaly"
    evo = data.evolutions
    if evo != nil
      if evo != []
        for e in 0...evo.length
          enc_data.push(data.id) if enc_data.include?(evo[e][0]) && evo[e][3]
        end
      end
    end
  end
  enc_data.uniq!
  for e in 0...enc_data.length
    mon_rank = GameData::Species.get(enc_data[e]).raid_ranks
    new_ranks[3].push(enc_data[e]) if mon_rank.include?(3)
    new_ranks[4].push(enc_data[e]) if mon_rank.include?(4)
    new_ranks[5].push(enc_data[e]) if mon_rank.include?(5)
  end
  GameData::Species.each do |data|
    next if data.mega_stone == nil
    mega_data.push(data.id) if enc_data.include?(data.species)
  end
  new_ranks[6].push(mega_data.sample) if mega_data != []
  return new_ranks
end
