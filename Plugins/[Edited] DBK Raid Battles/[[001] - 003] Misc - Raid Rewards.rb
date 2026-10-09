#-------------------------------------------------------------------------------
# Generates a rewards list for this Raid Den.
#-------------------------------------------------------------------------------
# REMINDER:
# Rank 1 raids start through to Chapter 4 (Anomaly Swalot)
# Rank 2 raids start thereafter to Chapter 6 (Sienna)
# Rank 3 raids start thereafter to Chapter 10 (Anomaly Hoopa)
# Rank 4 raids start thereafter to Chapter 12 (Simulacrum Ezreal)
# Rank 5 raids start thereafter to Postgame.

def pbGenerateRaidRewards(pokemon, style = :Basic, rank = nil, loot = nil, weather = nil, terrain = nil, environ = nil)
  rewards = []
  rank = pbDefaultRaidProperty(pokemon, :rank, {}) if rank.nil?
  #-----------------------------------------------------------------------------
  # Adds Exp. Candy rewards.
  #-----------------------------------------------------------------------------
  case rank
    when 3; qty = rand(0..1)
    when 4; qty = rand(0..2)
    when 5..7; qty = rand(0..3)
    else; qty = 1
  end
  rewards.push([:RARECANDY, qty]) if rank > 2 && qty > 0
  rewards.push([:RARESTCANDY, qty]) if rank > 3 && qty > 0
  #-----------------------------------------------------------------------------
  # Adds rewards related to raid type.
  #-----------------------------------------------------------------------------
  case style
  when :Ultra
    rewards.push([:ZBOOSTER, 1]) if pokemon.isSpecies?(:NECROZMA)
  when :Max
    rewards.push([:DYNAMAXCANDY, qty + rand(-1..2)]) if rank > 2
    rewards.push([:MAXSOUP, 1]) if pokemon.gmax_factor? && rand(2) == 0
    case pokemon.species
    when :VESPIQUEN
      rewards.push([:MAXHONEY, 1])
    when :PARASECT, :BRELOOM, :AMOONGUS, :SHIINOTIC, :TOEDSCRUEL
      rewards.push([:MAXMUSHROOMS, 1])
    when :ETERNATUS
      rewards.push([:WISHINGSTAR, 1])
    end
  when :Tera
    shardQty = qty + rand(-1..2)
    shard = GameData::Item.get_shard_from_type(pokemon.tera_type)
    if $bag.has?(:GLIMMERINGCHARM)
      case rank
      when 3 then shardQty += 2
      when 4 then shardQty += 5
      when 5 then shardQty += 10
      when 6 then shardQty += 12
      when 7 then shardQty += 20
      end
    end
    rewards.push([shard, shardQty]) if shard
    rewards.push([:MYSTERYTERAJEWEL, 1]) if rand(10) < 2
    rewards.push([:RADIANTTERAJEWEL, 1]) if pokemon.isSpecies?(:TERAPAGOS)
  end
  #-----------------------------------------------------------------------------
  # Adds general rewards.
  #-----------------------------------------------------------------------------
  itemQty = [1, (qty / 2 + rand(-1..2)).round].max
  berries = [:OCCABERRY, :PASSHOBERRY, :WACANBERRY, :RINDOBERRY, :YACHEBERRY, :CHOPLEBERRY, :KEBIABERRY, :SHUCABERRY, :COBABERRY, :PAYAPABERRY, :TANGABERRY, :CHARTIBERRY, :KASIBBERRY, :HABANBERRY, :COLBURBERRY, :BABIRIBERRY, :ROSELIBERRY, :CHILANBERRY, :OLIBERRY, :PATOTOBERRY, :AVOCABERRY]
  rewards.push([berries.sample, itemQty])
  itemQty = [1, (qty / 2 + rand(-1..2)).round].max
  typegem = [:FIREGEM, :WATERGEM, :ELECTRICGEM, :GRASSGEM, :ICEGEM, :FIGHTINGGEM, :POISONGEM, :GROUNDGEM, :FLYINGGEM, :PSYCHICGEM, :BUGGEM, :ROCKGEM, :GHOSTGEM, :DRAGONGEM, :DARKGEM, :STEELGEM, :FAIRYGEM, :NORMALGEM, :COSMICGEM, :LIGHTGEM, :SOUNDGEM]
  rewards.push([typegem.sample, itemQty])
  stones = []
  GameData::Species.each do |data|
    next if data.form == 0
    next if data.mega_stone == nil
    stones.push(data.mega_stone)
  end
  stones.sort!
  rewards.push([stones.sample, 1]) if rand(5) < 1 && rank >= 3 # Mega Stones only appear on rank 3 above
  if rank > 3
    mints = [
      :SERIOUSMINT,                                          # - Neutral
      :LONELYMINT, :ADAMANTMINT, :NAUGHTYMINT, :BRAVEMINT,   # + Attack
      :BOLDMINT,   :IMPISHMINT,  :LAXMINT,     :RELAXEDMINT, # + Defense
      :MODESTMINT, :MILDMINT,    :RASHMINT,    :QUIETMINT,   # + Sp.Atk
      :CALMMINT,   :GENTLEMINT,  :CAREFULMINT, :SASSYMINT,   # + Sp.Def
      :TIMIDMINT,  :HASTYMINT,   :JOLLYMINT,   :NAIVEMINT    # + Speed
    ]
    rewards.push([mints.sample, 1])
  end
  if rank > 2
    val = (rank > 5) ? 2 : 4
    itemQty = [1, (qty / val + rand(-1..2)).round].max
    maxvitamins = [:HPMAX, :PROTEINMAX, :IRONMAX, :CALCIUMMAX, :ZINCMAX, :CARBOSMAX]
    minfeathers = [:HEALTHFEATHERMIN, :MUSCLEFEATHERMIN, :RESISTFEATHERMIN, :GENIUSFEATHERMIN, :CLEVERFEATHERMIN, :SWIFTFEATHERMIN]
    rewards.push([maxvitamins.sample, itemQty])
    rewards.push([minfeathers.sample, itemQty])
    if rand(10) < 2
      case rank
      when 3    then treasure = [:TINYMUSHROOM, :NUGGET, :PEARL, :RELICCOPPER, :RELICVASE]
      when 4, 5 then treasure = [:BIGMUSHROOM, :BIGNUGGET, :BIGPEARL, :RELICSILVER, :RELICBAND]
      when 6, 7 then treasure = [:BALMMUSHROOM, :PEARLSTRING, :RELICGOLD, :RELICSTATUE, :RELICCROWN]
      end
      rewards.push([treasure.sample, 1])
    end
  end
  if rank > 1
    vitamins = [:HPUP, :PROTEIN, :IRON, :CALCIUM, :ZINC, :CARBOS]
    feathers = [:HEALTHFEATHER, :MUSCLEFEATHER, :RESISTFEATHER, :GENIUSFEATHER, :CLEVERFEATHER, :SWIFTFEATHER]
    rewards.push([vitamins.sample, itemQty])
    rewards.push([feathers.sample, itemQty])
  end
  # Changed by Jos 2025-09-13: Ball Rewards
  case rank
    when 1; ballreward = [:POKEBALL]
    when 2; ballreward = [:POKEBALL, :GREATBALL]
    when 3; ballreward = [:POKEBALL, :GREATBALL, :SUPERBALL]
    when 4; ballreward = [:GREATBALL, :SUPERBALL, :ULTRABALL]
    when 5; ballreward = [:SUPERBALL, :ULTRABALL, :QUICKBALL, :PREMIERBALL]
    when 6; ballreward = [:ULTRABALL, :QUICKBALL, :PREMIERBALL]
    when 7; ballreward = [:ULTRABALL, :QUICKBALL, :PREMIERBALL, :MASTERBALL]
  end
  rewards.push([ballreward.sample,1]) if rand(20) < 1
# Changed by Jos 2025-09-13: Potion, Ether/Elixir and Revive Rewards
  case rank
    when 1; potionreward = [:POTION, :ANTIDOTE, :BURNHEAL, :PARALYZEHEAL, :ICEHEAL, :ETHER]
    when 2; potionreward = [:POTION, :SUPERPOTION, :ANTIDOTE, :BURNHEAL, :PARALYZEHEAL, :ICEHEAL, :ETHER, :ELIXIR, :REVIVE]
    when 3; potionreward = [:SUPERPOTION, :HYPERPOTION, :ANTIDOTE, :BURNHEAL, :PARALYZEHEAL, :ICEHEAL, :ELIXIR, :MAXETHER, :REVIVE]
    when 4; potionreward = [:HYPERPOTION, :ULTRAPOTION, :GIGAPOTION, :FULLHEAL, :MAXETHER, :MAXELIXIR, :REVIVE, :MAXREVIVE]
    when 5; potionreward = [:ULTRAPOTION, :GIGAPOTION, :TETRAPOTION, :FULLHEAL, :MAXETHER, :MAXELIXIR, :REVIVE, :MAXREVIVE]
    when 6; potionreward = [:GIGAPOTION, :TETRAPOTION, :ALPHAPOTION, :OMEGAPOTION, :MAXPOTION, :FULLHEAL, :MAXETHER, :MAXELIXIR, :REVIVE, :MAXREVIVE]
    when 7; potionreward = [:TETRAPOTION, :ALPHAPOTION, :OMEGAPOTION, :MAXPOTION, :FULLRESTORE, :FULLHEAL, :MAXETHER, :MAXELIXIR, :REVIVE, :MAXREVIVE]
  end
  rewards.push([potionreward.sample,1]) if rand(30) < 1
# Changed by Jos 2025-09-13: Repel and Escape Ropes
  case rank
    when 1; repelreward = [:REPEL, :ESCAPEROPE]
    when 2; repelreward = [:REPEL, :SUPERREPEL, :ESCAPEROPE]
    when 3; repelreward = [:SUPERREPEL, :HYPERREPEL, :ULTRAREPEL, :ESCAPEROPE]
    when 4; repelreward = [:HYPERREPEL, :ULTRAREPEL, :GIGAREPEL, :ESCAPEROPE]
    when 5; repelreward = [:ULTRAREPEL, :GIGAREPEL, :TETRAREPEL, :ESCAPEROPE]
    when 6; repelreward = [:GIGAREPEL, :TETRAREPEL, :ALPHAREPEL, :MAXREPEL, :ESCAPEROPE]
    when 7; repelreward = [:TETRAREPEL, :ALPHAREPEL, :MAXREPEL, :ESCAPEROPE]
  end
  rewards.push([repelreward.sample,1]) if rand(20) < 1
# Changed by Jos 2025-09-13: X-Items and Vials
  case rank
    when 1; xitemreward = []
    when 2; xitemreward = [:XATTACK, :XDEFENSE, :XSPEED, :XSPATK, :XSPDEF, :XACCURACY, :DIREHIT, :GUARDSPEC]
    when 3; xitemreward = [:XATTACK, :XDEFENSE, :XSPEED, :XSPATK, :XSPDEF, :XACCURACY, :DIREHIT, :GUARDSPEC, :OFFENSEVIAL, :INTELLECTVIAL, :PROTECTIONVIAL, :WISDOMVIAL, :TOUGHNESSVIAL, :ABILITYCAPSULE, :ABILITYPATCH]
    when 4,5,6,7; xitemreward = [:XATTACK2, :XDEFENSE2, :XSPEED2, :XSPATK2, :XSPDEF2, :XACCURACY2, :DIREHIT2, :GUARDSPEC, :OFFENSEVIAL, :INTELLECTVIAL, :PROTECTIONVIAL, :WISDOMVIAL, :TOUGHNESSVIAL, :ABILITYCAPSULE, :ABILITYPATCH]
  end
  rewards.push([xitemreward.sample,1]) if rand(15) < 1 && xitemreward != []
  if rand(6) <= rank
    apriballs = [:DUSKBALL, :FASTBALL, :LEVELBALL, :LUREBALL, :HEAVYBALL, :LOVEBALL, :FRIENDBALL, :MOONBALL, :DREAMBALL]
    rewards.push([apriballs.sample, 1])
  end
  #-----------------------------------------------------------------------------
  # Adds environmental rewards.
  #-----------------------------------------------------------------------------
  if rand(10) < 1
    case weather
    when :Sun         then rewards.push([:HEATROCK,      1])
    when :Rain        then rewards.push([:DAMPROCK,      1])
    when :Sandstorm   then rewards.push([:SMOOTHROCK,    1])
    when :Hail        then rewards.push([:ICYROCK,       1])
    when :ShadowSky   then rewards.push([:LIFEORB,       1])
    when :Fog         then rewards.push([:SMOKEBALL,     1])
    end
  end
  if rand(10) < 1
    case terrain              
    when :Electric    then rewards.push([:ELECTRICSEED,  1])
    when :Grassy      then rewards.push([:GRASSYSEED,    1])
    when :Misty       then rewards.push([:MISTYSEED,     1])
    when :Psychic     then rewards.push([:PSYCHICSEED,   1])
    end
  end
  if rand(10) < 1
    case environ
    when :None        then rewards.push([:CELLBATTERY,   1])    
    when :Grass       then rewards.push([:MIRACLESEED,   1])
    when :TallGrass   then rewards.push([:ABSORBBULB,    1])
    when :MovingWater then rewards.push([:MYSTICWATER,   1])
    when :StillWater  then rewards.push([:FRESHWATER,    1])
    when :Puddle      then rewards.push([:LIGHTCLAY,     1])
    when :Underwater  then rewards.push([:SHOALSHELL,    1])    
    when :Cave        then rewards.push([:LUMINOUSMOSS,  1])
    when :Rock        then rewards.push([:HARDSTONE,     1])
    when :Sand        then rewards.push([:SOFTSAND,      1])
    when :Forest      then rewards.push([:SHEDSHELL,     1])
    when :ForestGrass then rewards.push([:SILVERPOWDER,  1])
    when :Snow        then rewards.push([:SNOWBALL,      1])
    when :Ice         then rewards.push([:NEVERMELTICE,  1])
    when :Volcano     then rewards.push([:CHARCOAL,      1])
    when :Graveyard   then rewards.push([:RAREBONE,      1])
    when :Sky         then rewards.push([:PRETTYFEATHER, 1])
    when :Space       then rewards.push([:STARDUST,      1])
    when :UltraSpace  then rewards.push([:COMETSHARD,    1])
    end
  end
  #-----------------------------------------------------------------------------
  # Adds manually entered rewards.
  #-----------------------------------------------------------------------------
  if loot
    if loot.is_a?(Array)
      loot.each do |itm|
        case itm
        when Array
          rewards.push(itm)
        when Symbol
          rewards.push([itm, 1])
        end
      end
    else 
      rewards.push([loot, 1])
    end
  end
  #-----------------------------------------------------------------------------
  # Finalizes all rewards.
  #-----------------------------------------------------------------------------
  final_rewards = {}
  rewards.each do |reward|
    next if !GameData::Item.exists?(reward[0])
    if final_rewards.has_key?(reward[0])
      final_rewards[reward[0]] += reward[1]
    else
      final_rewards[reward[0]] = reward[1]
    end
  end
  return final_rewards
end