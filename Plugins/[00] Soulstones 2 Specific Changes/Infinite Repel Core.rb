class PokemonSystem
  attr_accessor :wild_toggle
  alias _WT_initialize initialize
  def initialize
    _WT_initialize
	@wild_toggle = false
  end
  
  def resetWildToggle
    if @wild_toggle == nil
	@wild_toggle = false
	end
  end
end

ItemHandlers::UseInField.add(:INFINITEREPELTOGGLE, proc { |item|
  toggled = !$PokemonSystem.wild_toggle
  $PokemonSystem.wild_toggle = toggled
  pbMessage(_INTL("The Infinite Repel has been turned on!")) if toggled != false
  pbMessage(_INTL("The Infinite Repel has been turned off!")) if toggled != true
  next true
})

ItemHandlers::UseFromBag.add(:INFINITEREPELTOGGLE, proc { |item|
  toggled = !$PokemonSystem.wild_toggle
  $PokemonSystem.wild_toggle = toggled
  pbMessage(_INTL("The Infinite Repel has been turned on!")) if toggled != false
  pbMessage(_INTL("The Infinite Repel has been turned off!")) if toggled != true
  next 0
})

ItemHandlers::UseInField.add(:RAIDSENSOR, proc { |item|
  map = load_data(sprintf("Data/Map%03d.rxdata", $game_map.map_id))
  raid_portal = false
  for i in map.events.keys.sort
    next if map.events[i].name != "BasicRaidDen"
    raid_portal = true
  end
  msg = (raid_portal) ? "Raid Portal Detected!" : "No Raid Portal found."
  pbMessage(msg)
  next true
})

ItemHandlers::UseFromBag.add(:RAIDSENSOR, proc { |item|
  map = load_data(sprintf("Data/Map%03d.rxdata", $game_map.map_id))
  raid_portal = false
  for i in map.events.keys.sort
    next if map.events[i].name != "BasicRaidDen"
    raid_portal = true
  end
  msg = (raid_portal) ? "Raid Portal Detected!" : "No Raid Portal found."
  pbMessage(msg)
  next 0
})
