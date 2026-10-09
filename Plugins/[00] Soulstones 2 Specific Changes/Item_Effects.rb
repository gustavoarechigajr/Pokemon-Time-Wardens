#===============================================================================
# UseText handlers
#===============================================================================
ItemHandlers::UseText.add(:BICYCLE, proc { |item|
  next ($PokemonGlobal.bicycle) ? _INTL("Walk") : _INTL("Use")
})

ItemHandlers::UseText.copy(:BICYCLE, :MACHBIKE, :ACROBIKE)

#===============================================================================
# UseFromBag handlers
# Return values: 0 = not used
#                1 = used
#                2 = close the Bag to use
# If there is no UseFromBag handler for an item being used from the Bag (not on
# a Pokémon), calls the UseInField handler for it instead.
#===============================================================================

ItemHandlers::UseFromBag.add(:HONEY, proc { |item|
  next 2
})

ItemHandlers::UseFromBag.add(:CAMPINGGEAR, proc { |item|
  next 2
})

ItemHandlers::UseFromBag.add(:ESCAPEROPE, proc { |item|
  if !$game_player.can_map_transfer_with_follower?
    pbMessage(_INTL("It can't be used when you have someone with you."))
    next 0
  end
  if ($PokemonGlobal.escapePoint rescue false) && $PokemonGlobal.escapePoint.length > 0
    next 2   # End screen and use item
  end
  pbMessage(_INTL("Can't use that here."))
  next 0
})

ItemHandlers::UseFromBag.add(:BICYCLE, proc { |item|
  next (pbBikeCheck) ? 2 : 0
})

ItemHandlers::UseFromBag.copy(:BICYCLE, :MACHBIKE, :ACROBIKE)

ItemHandlers::UseFromBag.add(:OLDROD, proc { |item|
  notCliff = $game_map.passable?($game_player.x, $game_player.y, $game_player.direction, $game_player)
  if Settings::NO_FISHING_MAPS.include?($game_map.map_id)
    pbMessage(_INTL("Can't use that here."))
    next 0
  end
  next 2 if $game_player.pbFacingTerrainTag.can_fish && ($PokemonGlobal.surfing || notCliff)
  pbMessage(_INTL("Can't use that here."))
  next 0
})

ItemHandlers::UseFromBag.copy(:OLDROD, :GOODROD, :SUPERROD)

ItemHandlers::UseFromBag.add(:ITEMFINDER, proc { |item|
  next 2
})

ItemHandlers::UseFromBag.copy(:ITEMFINDER, :DOWSINGMCHN, :DOWSINGMACHINE)

ItemHandlers::UseFromBag.add(:TOWNMAP, proc { |item|
  pbFadeOutIn {
    scene = PokemonRegionMap_Scene.new(-1, false)
    screen = PokemonRegionMapScreen.new(scene)
    ret = screen.pbStartScreen
    $game_temp.fly_destination = ret if ret
    next 99999 if ret   # Ugly hack to make Bag scene not reappear if flying
  }
  next ($game_temp.fly_destination) ? 2 : 0
})

ItemHandlers::UseFromBag.addIf(proc { |item| GameData::Item.get(item).is_machine? },
  proc { |item|
    if $player.pokemon_count == 0
      pbMessage(_INTL("There is no Pokémon."))
      next 0
    end
    item_data = GameData::Item.get(item)
    move = item_data.move
    next 0 if !move
    pbMessage(_INTL("\\se[PC access]You booted up {1}.\1", item_data.name))
    next 0 if !pbConfirmMessage(_INTL("Do you want to teach {1} to a Pokémon?",
                                      GameData::Move.get(move).name))
    next 1 if pbMoveTutorChoose(move, nil, true, item_data.is_TR?)
    next 0
  }
)

#===============================================================================
# ConfirmUseInField handlers
# Return values: true/false
# Called when an item is used from the Ready Menu.
# If an item does not have this handler, it is treated as returning true.
#===============================================================================

ItemHandlers::ConfirmUseInField.add(:ESCAPEROPE, proc { |item|
  escape = ($PokemonGlobal.escapePoint rescue nil)
  if !escape || escape == []
    pbMessage(_INTL("Can't use that here."))
    next false
  end
  if !$game_player.can_map_transfer_with_follower?
    pbMessage(_INTL("It can't be used when you have someone with you."))
    next false
  end
  mapname = pbGetMapNameFromId(escape[0])
  next pbConfirmMessage(_INTL("Want to escape from here and return to {1}?", mapname))
})

#===============================================================================
# UseInField handlers
# Return values: false = not used
#                true = used
# Called if an item is used from the Bag (not on a Pokémon and not a TM/HM) and
# there is no UseFromBag handler above.
# If an item has this handler, it can be registered to the Ready Menu.
#===============================================================================

def pbRepel(item, steps)
  if $PokemonGlobal.repel > 0
    pbMessage(_INTL("But a repellent's effect still lingers from earlier."))
    return false
  end
  $stats.repel_count += 1
  pbUseItemMessage(item)
  $PokemonGlobal.repel = steps
  return true
end

# Changed by Jos 2022-10-04 so repels don't suck
ItemHandlers::UseInField.add(:REPEL, proc { |item|
  next pbRepel(item, 150)
})

ItemHandlers::UseInField.add(:SUPERREPEL, proc { |item|
  next pbRepel(item, 250)
})

ItemHandlers::UseInField.add(:HYPERREPEL, proc { |item|
  next pbRepel(item, 350)
})

ItemHandlers::UseInField.add(:ULTRAREPEL, proc { |item|
  next pbRepel(item, 450)
})

ItemHandlers::UseInField.add(:GIGAREPEL, proc { |item|
  next pbRepel(item, 550)
})

ItemHandlers::UseInField.add(:TETRAREPEL, proc { |item|
  next pbRepel(item, 650)
})

ItemHandlers::UseInField.add(:ALPHAREPEL, proc { |item|
  next pbRepel(item, 750)
})

ItemHandlers::UseInField.add(:MAXREPEL, proc { |item|
  next pbRepel(item, 850)
})
# End of addition

EventHandlers.add(:on_player_step_taken, :repel_counter,
  proc {
    next if $PokemonGlobal.repel <= 0 || $game_player.terrain_tag.ice   # Shouldn't count down if on ice
    $PokemonGlobal.repel -= 1
    next if $PokemonGlobal.repel > 0
    repels = []
    GameData::Item.each { |itm| repels.push(itm.id) if itm.has_flag?("Repel") }
    if repels.none? { |item| $bag.has?(item) }
      pbMessage(_INTL("The repellent's effect wore off!"))
      next
    end
    next if !pbConfirmMessage(_INTL("The repellent's effect wore off! Would you like to use another one?"))
    ret = nil
    pbFadeOutIn {
      scene = PokemonBag_Scene.new
      screen = PokemonBagScreen.new(scene, $bag)
      ret = screen.pbChooseItemScreen(proc { |item| repels.include?(item) })
    }
    pbUseItem($bag, ret) if ret
  }
)

ItemHandlers::UseInField.add(:BLACKFLUTE, proc { |item|
  pbUseItemMessage(item)
  pbMessage(_INTL("Wild Pokémon will be repelled."))
  $PokemonMap.blackFluteUsed = true
  $PokemonMap.whiteFluteUsed = false
  next true
})

ItemHandlers::UseInField.add(:WHITEFLUTE, proc { |item|
  pbUseItemMessage(item)
  pbMessage(_INTL("Wild Pokémon will be lured."))
  $PokemonMap.blackFluteUsed = false
  $PokemonMap.whiteFluteUsed = true
  next true
})

ItemHandlers::UseInField.add(:HONEY, proc { |item|
  pbUseItemMessage(item)
  pbSweetScent
  next true
})

ItemHandlers::UseInField.add(:ESCAPEROPE, proc { |item|
  escape = ($PokemonGlobal.escapePoint rescue nil)
  if !escape || escape == []
    pbMessage(_INTL("Can't use that here."))
    next false
  end
  if !$game_player.can_map_transfer_with_follower?
    pbMessage(_INTL("It can't be used when you have someone with you."))
    next false
  end
  pbUseItemMessage(item)
  pbFadeOutIn {
    $game_temp.player_new_map_id    = escape[0]
    $game_temp.player_new_x         = escape[1]
    $game_temp.player_new_y         = escape[2]
    $game_temp.player_new_direction = escape[3]
    pbCancelVehicles
    $scene.transfer_player
    $game_map.autoplay
    $game_map.refresh
  }
  pbEraseEscapePoint
  next true
})

ItemHandlers::UseInField.add(:CAMPINGGEAR, proc { |item|
  if !$game_player.can_map_transfer_with_follower?
    pbMessage(_INTL("It can't be used when you have someone with you."))
    next false
  end
  if $PokemonGlobal.surfing || $PokemonGlobal.diving
    pbMessage(_INTL("Camping in the water might not be a good idea..."))
    next false    
  end
  if !$game_map.metadata&.outdoor_map
    pbMessage(_INTL("You cannot camp in here."))
    next false    
  end
  if $PokemonGlobal.bridge > 0
    pbMessage(_INTL("Probably not the best idea to camp on a bridge..."))
    next false    
  end
  $game_switches[495]=true
  currentTime = pbGetTimeNow
  command = 0
  cmd = [_INTL("Morning"),_INTL("Day"),_INTL("Night"),_INTL("Specific")]
  command = pbMessage(_INTL("Sleep Until?"),cmd, -1, nil, command)
  case command
    when 3
    params=ChooseNumberParams.new
    params.setRange(0,23)
    params.setDefaultValue(currentTime.hour)
      sleepTime = pbMessageChooseNumber(_INTL("What time do you want to sleep to [Input hour in military time, i.e. 0 - 23]?"), params)
    when 0
      sleepTime = 8
    when 1
      sleepTime = 15
    when 2
      sleepTime = 23
    when -1
      sleepTime = ""
  end
  if sleepTime.is_a?(Numeric)
    pbToneChangeAll(Tone.new(-255, -255, -255), 0)   # Change Screen Color Tone  
    pbWait(48)  # Wait
    pbMessage(_INTL("You set up a camp so that you can sleep..."))
    pbSEPlay("PRSFX- Yawn")
    pbWait(12)  # Wait
    #Saves player's coordinates so they can be returned to the spot where they camped.
    $game_variables[993] = $game_map.map_id
    $game_variables[991] = $game_player.x
    $game_variables[992] = $game_player.y
    $game_temp.player_new_map_id    = 126
    $game_temp.player_new_x         = 16
    $game_temp.player_new_y         = 19
    $scene.transfer_player
    $game_map.refresh
    pbSEPlay("PRSFX- Snore")
    pbWait(12)  # Wait
    #Set time to the time the player chooses.
    UnrealTime.advance_to(sleepTime,0,0)  
    pbWait(12)  # Wait
    pbSEPlay("PRSFX- Snore")
    #Returns player back to where they camped.
    $game_temp.player_new_map_id    = $game_variables[993]
    $game_temp.player_new_x         = $game_variables[991]
    $game_temp.player_new_y         = $game_variables[992]
    $scene.transfer_player
    $game_map.refresh
    pbToneChangeAll(Tone.new(0, 0, 0), 0)
    pbSEPlay("PRSFX- Substitute2")
    pbMessage(_INTL("You wake up from your nap, ready to go!"))
    #To unfreeze time so that the clock starts counting again.
    $game_switches[495]=false
    next true
  else
    next false
  end
})

ItemHandlers::UseInField.add(:SACREDASH, proc { |item|
  if $player.pokemon_count == 0
    pbMessage(_INTL("There is no Pokémon."))
    next false
  end
  canrevive = false
  $player.pokemon_party.each do |i|
    next if !i.fainted?
    canrevive = true
    break
  end
  if !canrevive
    pbMessage(_INTL("It won't have any effect."))
    next false
  end
  revived = 0
  pbFadeOutIn {
    scene = PokemonParty_Scene.new
    screen = PokemonPartyScreen.new(scene, $player.party)
    screen.pbStartScene(_INTL("Using item..."), false)
    $player.party.each_with_index do |pkmn, i|
      next if !pkmn.fainted?
      revived += 1
      pkmn.heal
      screen.pbRefreshSingle(i)
      screen.pbDisplay(_INTL("{1}'s HP was restored.", pkmn.name))
    end
    if revived == 0
      screen.pbDisplay(_INTL("It won't have any effect."))
    end
    screen.pbEndScene
  }
  next (revived > 0)
})

ItemHandlers::UseInField.add(:BICYCLE, proc { |item|
  if pbBikeCheck
    if $PokemonGlobal.bicycle
      pbDismountBike
    else
      pbMountBike
    end
    next true
  end
  next false
})

ItemHandlers::UseInField.copy(:BICYCLE, :MACHBIKE, :ACROBIKE)

ItemHandlers::UseInField.add(:OLDROD, proc { |item|
  notCliff = $game_map.passable?($game_player.x, $game_player.y, $game_player.direction, $game_player)
  if Settings::NO_FISHING_MAPS.include?($game_map.map_id)
    pbMessage(_INTL("Can't use that here."))
    next false
  end
  if !$game_player.pbFacingTerrainTag.can_fish || (!$PokemonGlobal.surfing && !notCliff)
    pbMessage(_INTL("Can't use that here."))
    next false
  end
  encounter = $PokemonEncounters.has_encounter_type?(:OldRod)
  if pbFishing(encounter, 1)
    $stats.fishing_battles += 1
    pbEncounter(:OldRod)
  end
  next true
})

ItemHandlers::UseInField.add(:GOODROD, proc { |item|
  notCliff = $game_map.passable?($game_player.x, $game_player.y, $game_player.direction, $game_player)
  if !$game_player.pbFacingTerrainTag.can_fish || (!$PokemonGlobal.surfing && !notCliff)
    pbMessage(_INTL("Can't use that here."))
    next false
  end
  encounter = $PokemonEncounters.has_encounter_type?(:GoodRod)
  if pbFishing(encounter, 2)
    $stats.fishing_battles += 1
    pbEncounter(:GoodRod)
  end
  next true
})

ItemHandlers::UseInField.add(:SUPERROD, proc { |item|
  notCliff = $game_map.passable?($game_player.x, $game_player.y, $game_player.direction, $game_player)
  if !$game_player.pbFacingTerrainTag.can_fish || (!$PokemonGlobal.surfing && !notCliff)
    pbMessage(_INTL("Can't use that here."))
    next false
  end
  encounter = $PokemonEncounters.has_encounter_type?(:SuperRod)
  if pbFishing(encounter, 3)
    $stats.fishing_battles += 1
    pbEncounter(:SuperRod)
  end
  next true
})

# Changed by Jos 2025-08-25 to comment out conflicting instances of the ITEMFINDER
=begin
ItemHandlers::UseInField.add(:ITEMFINDER, proc { |item|
  $stats.itemfinder_count += 1
  event = pbClosestHiddenItem
  if event
    offsetX = event.x - $game_player.x
    offsetY = event.y - $game_player.y
    if offsetX == 0 && offsetY == 0   # Standing on the item, spin around
      4.times do
        pbWait(Graphics.frame_rate * 2 / 10)
        $game_player.turn_right_90
      end
      pbWait(Graphics.frame_rate * 3 / 10)
      pbMessage(_INTL("The {1}'s indicating something right underfoot!", GameData::Item.get(item).name))
    else   # Item is nearby, face towards it
      direction = $game_player.direction
      if offsetX.abs > offsetY.abs
        direction = (offsetX < 0) ? 4 : 6
      else
        direction = (offsetY < 0) ? 8 : 2
      end
      case direction
      when 2 then $game_player.turn_down
      when 4 then $game_player.turn_left
      when 6 then $game_player.turn_right
      when 8 then $game_player.turn_up
      end
      pbWait(Graphics.frame_rate * 3 / 10)
      pbMessage(_INTL("Huh? The {1}'s responding!\1", GameData::Item.get(item).name))
      pbMessage(_INTL("There's an item buried around here!"))
    end
  else
    pbMessage(_INTL("... \\wt[10]... \\wt[10]... \\wt[10]...\\wt[10]Nope! There's no response."))
  end
  next true
})

ItemHandlers::UseInField.copy(:ITEMFINDER, :DOWSINGMCHN, :DOWSINGMACHINE)
=end

ItemHandlers::UseInField.add(:TOWNMAP, proc { |item|
  pbShowMap(-1, false) if $game_temp.fly_destination.nil?
  pbFlyToNewLocation
  next true
})

ItemHandlers::UseInField.add(:COINCASE, proc { |item|
  pbMessage(_INTL("Coins: {1}", $player.coins.to_s_formatted))
  next true
})

ItemHandlers::UseInField.add(:EXPALL, proc { |item|
  $bag.replace_item(:EXPALL, :EXPALLOFF)
  pbMessage(_INTL("The Exp Share was turned off."))
  next true
})

ItemHandlers::UseInField.add(:EXPALLOFF, proc { |item|
  $bag.replace_item(:EXPALLOFF, :EXPALL)
  pbMessage(_INTL("The Exp Share was turned on."))
  next true
})

#===============================================================================
# UseOnPokemon handlers
#===============================================================================

# Applies to all items defined as an evolution stone.
# No need to add more code for new ones.
ItemHandlers::UseOnPokemon.addIf(proc { |item| GameData::Item.get(item).is_evolution_stone? },
  proc { |item, qty, pkmn, scene|
    if pkmn.shadowPokemon?
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    newspecies = pkmn.check_evolution_on_use_item(item)
    if newspecies
      pbFadeOutInWithMusic {
        evo = PokemonEvolutionScene.new
        evo.pbStartScreen(pkmn, newspecies)
        evo.pbEvolution(false)
        evo.pbEndScreen
        if scene.is_a?(PokemonPartyScreen)
          scene.pbRefreshAnnotations(proc { |p| !p.check_evolution_on_use_item(item).nil? })
          scene.pbRefresh
        end
      }
      next true
    end
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  }
)

ItemHandlers::UseOnPokemon.add(:POTION, proc { |item, qty, pkmn, scene|
  next pbHPItem(pkmn, 20, scene)
})

ItemHandlers::UseOnPokemon.copy(:POTION, :BERRYJUICE, :SWEETHEART)
ItemHandlers::UseOnPokemon.copy(:POTION, :RAGECANDYBAR) if !Settings::RAGE_CANDY_BAR_CURES_STATUS_PROBLEMS

ItemHandlers::UseOnPokemon.add(:SUPERPOTION, proc { |item, qty, pkmn, scene|
  next pbHPItem(pkmn, (Settings::REBALANCED_HEALING_ITEM_AMOUNTS) ? 60 : 50, scene)
})

ItemHandlers::UseOnPokemon.add(:HYPERPOTION, proc { |item, qty, pkmn, scene|
  next pbHPItem(pkmn, (Settings::REBALANCED_HEALING_ITEM_AMOUNTS) ? 120 : 200, scene)
})

# Changed by Jos 2022-10-04 for new potions
ItemHandlers::UseOnPokemon.add(:ULTRAPOTION, proc { |item, qty, pkmn, scene|
  next pbHPItem(pkmn, 180, scene)
})

ItemHandlers::UseOnPokemon.add(:GIGAPOTION, proc { |item, qty, pkmn, scene|
  next pbHPItem(pkmn, 300, scene)
})

ItemHandlers::UseOnPokemon.add(:TETRAPOTION, proc { |item, qty, pkmn, scene|
  next pbHPItem(pkmn, 450, scene)
})

ItemHandlers::UseOnPokemon.add(:ALPHAPOTION, proc { |item, qty, pkmn, scene|
  next pbHPItem(pkmn, 600, scene)
})

ItemHandlers::UseOnPokemon.add(:OMEGAPOTION, proc { |item, qty, pkmn, scene|
  next pbHPItem(pkmn, 750, scene)
})
# End of additions

ItemHandlers::UseOnPokemon.add(:MAXPOTION, proc { |item, qty, pkmn, scene|
  next pbHPItem(pkmn, pkmn.totalhp - pkmn.hp, scene)
})

ItemHandlers::UseOnPokemon.add(:FRESHWATER, proc { |item, qty, pkmn, scene|
  next pbHPItem(pkmn, (Settings::REBALANCED_HEALING_ITEM_AMOUNTS) ? 30 : 50, scene)
})

ItemHandlers::UseOnPokemon.add(:SODAPOP, proc { |item, qty, pkmn, scene|
  next pbHPItem(pkmn, (Settings::REBALANCED_HEALING_ITEM_AMOUNTS) ? 50 : 60, scene)
})

ItemHandlers::UseOnPokemon.add(:LEMONADE, proc { |item, qty, pkmn, scene|
  next pbHPItem(pkmn, (Settings::REBALANCED_HEALING_ITEM_AMOUNTS) ? 70 : 80, scene)
})

ItemHandlers::UseOnPokemon.add(:MOOMOOMILK, proc { |item, qty, pkmn, scene|
  next pbHPItem(pkmn, 100, scene)
})

# Changed by Jos 2022-11-13 for new beverages
ItemHandlers::UseOnPokemon.add(:ROSERADETEA, proc { |item, qty, pkmn, scene|
  next pbHPItem(pkmn, 150, scene)
})

ItemHandlers::UseOnPokemon.add(:REDTAUROS, proc { |item, qty, pkmn, scene|
  next pbHPItem(pkmn, 250, scene)
})

ItemHandlers::UseOnPokemon.add(:CUBICOLA, proc { |item, qty, pkmn, scene|
  next pbHPItem(pkmn, 375, scene)
})

ItemHandlers::UseOnPokemon.add(:SBUXCOFFEE, proc { |item, qty, pkmn, scene|
  next pbHPItem(pkmn, 500, scene)
})

ItemHandlers::UseOnPokemon.add(:ORANBERRY, proc { |item, qty, pkmn, scene|
  next pbHPItem(pkmn, 10, scene)
})

ItemHandlers::UseOnPokemon.add(:SITRUSBERRY, proc { |item, qty, pkmn, scene|
  next pbHPItem(pkmn, pkmn.totalhp / 4, scene)
})

ItemHandlers::UseOnPokemon.add(:AWAKENING, proc { |item, qty, pkmn, scene|
  if pkmn.fainted? || pkmn.status != :SLEEP
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.heal_status
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1} woke up.", pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.copy(:AWAKENING, :CHESTOBERRY, :BLUEFLUTE, :POKEFLUTE)

ItemHandlers::UseOnPokemon.add(:ANTIDOTE, proc { |item, qty, pkmn, scene|
  if pkmn.fainted? || pkmn.status != :POISON
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.heal_status
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1} was cured of its poisoning.", pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.copy(:ANTIDOTE, :PECHABERRY)

ItemHandlers::UseOnPokemon.add(:BURNHEAL, proc { |item, qty, pkmn, scene|
  if pkmn.fainted? || pkmn.status != :BURN
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.heal_status
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1}'s burn was healed.", pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.copy(:BURNHEAL, :RAWSTBERRY)

ItemHandlers::UseOnPokemon.add(:PARALYZEHEAL, proc { |item, qty, pkmn, scene|
  if pkmn.fainted? || pkmn.status != :PARALYSIS
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.heal_status
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1} was cured of paralysis.", pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.copy(:PARALYZEHEAL, :PARLYZHEAL, :CHERIBERRY)

ItemHandlers::UseOnPokemon.add(:ICEHEAL, proc { |item, qty, pkmn, scene|
  if pkmn.fainted? || pkmn.status != :FROZEN
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.heal_status
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1} was thawed out.", pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.copy(:ICEHEAL, :ASPEARBERRY)

ItemHandlers::UseOnPokemon.add(:FULLHEAL, proc { |item, qty, pkmn, scene|
  if pkmn.fainted? || pkmn.status == :NONE
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.heal_status
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1} became healthy.", pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.copy(:FULLHEAL,
   :LAVACOOKIE, :OLDGATEAU, :CASTELIACONE, :LUMIOSEGALETTE, :SHALOURSABLE,
   :BIGMALASADA, :PEWTERCRUNCHIES, :LUMBERRY)
ItemHandlers::UseOnPokemon.copy(:FULLHEAL, :RAGECANDYBAR) if Settings::RAGE_CANDY_BAR_CURES_STATUS_PROBLEMS

ItemHandlers::UseOnPokemon.add(:FULLRESTORE, proc { |item, qty, pkmn, scene|
  if pkmn.fainted? || (pkmn.hp == pkmn.totalhp && pkmn.status == :NONE)
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  hpgain = pbItemRestoreHP(pkmn, pkmn.totalhp - pkmn.hp)
  pkmn.heal_status
  scene.pbRefresh
  if hpgain > 0
    scene.pbDisplay(_INTL("{1}'s HP was restored by {2} points.", pkmn.name, hpgain))
  else
    scene.pbDisplay(_INTL("{1} became healthy.", pkmn.name))
  end
  next true
})

ItemHandlers::UseOnPokemon.add(:REVIVE, proc { |item, qty, pkmn, scene|
  if !pkmn.fainted?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.hp = (pkmn.totalhp / 2).floor
  pkmn.hp = 1 if pkmn.hp <= 0
  pkmn.heal_status
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1}'s HP was restored.", pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:MAXREVIVE, proc { |item, qty, pkmn, scene|
  if !pkmn.fainted?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.heal_HP
  pkmn.heal_status
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1}'s HP was restored.", pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.copy(:MAXREVIVE, :MAXHONEY)

ItemHandlers::UseOnPokemon.add(:ENERGYPOWDER, proc { |item, qty, pkmn, scene|
  if pbHPItem(pkmn, (Settings::REBALANCED_HEALING_ITEM_AMOUNTS) ? 60 : 50, scene)
    pkmn.changeHappiness("powder")
    next true
  end
  next false
})

ItemHandlers::UseOnPokemon.add(:ENERGYROOT, proc { |item, qty, pkmn, scene|
  if pbHPItem(pkmn, (Settings::REBALANCED_HEALING_ITEM_AMOUNTS) ? 120 : 200, scene)
    pkmn.changeHappiness("energyroot")
    next true
  end
  next false
})

ItemHandlers::UseOnPokemon.add(:HEALPOWDER, proc { |item, qty, pkmn, scene|
  if pkmn.fainted? || pkmn.status == :NONE
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.heal_status
  pkmn.changeHappiness("powder")
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1} became healthy.", pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:REVIVALHERB, proc { |item, qty, pkmn, scene|
  if !pkmn.fainted?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.heal_HP
  pkmn.heal_status
  pkmn.changeHappiness("revivalherb")
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1}'s HP was restored.", pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:ETHER, proc { |item, qty, pkmn, scene|
  move = scene.pbChooseMove(pkmn, _INTL("Restore which move?"))
  next false if move < 0
  if pbRestorePP(pkmn, move, 10) == 0
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  scene.pbDisplay(_INTL("PP was restored."))
  next true
})

ItemHandlers::UseOnPokemon.copy(:ETHER, :LEPPABERRY)

ItemHandlers::UseOnPokemon.add(:MAXETHER, proc { |item, qty, pkmn, scene|
  move = scene.pbChooseMove(pkmn, _INTL("Restore which move?"))
  next false if move < 0
  if pbRestorePP(pkmn, move, pkmn.moves[move].total_pp - pkmn.moves[move].pp) == 0
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  scene.pbDisplay(_INTL("PP was restored."))
  next true
})

ItemHandlers::UseOnPokemon.add(:ELIXIR, proc { |item, qty, pkmn, scene|
  pprestored = 0
  pkmn.moves.length.times do |i|
    pprestored += pbRestorePP(pkmn, i, 10)
  end
  if pprestored == 0
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  scene.pbDisplay(_INTL("PP was restored."))
  next true
})

ItemHandlers::UseOnPokemon.add(:MAXELIXIR, proc { |item, qty, pkmn, scene|
  pprestored = 0
  pkmn.moves.length.times do |i|
    pprestored += pbRestorePP(pkmn, i, pkmn.moves[i].total_pp - pkmn.moves[i].pp)
  end
  if pprestored == 0
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  scene.pbDisplay(_INTL("PP was restored."))
  next true
})

ItemHandlers::UseOnPokemon.add(:PPUP, proc { |item, qty, pkmn, scene|
  move = scene.pbChooseMove(pkmn, _INTL("Boost PP of which move?"))
  if move >= 0
    if pkmn.moves[move].total_pp <= 1 || pkmn.moves[move].ppup >= 3
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    pkmn.moves[move].ppup += 1
    movename = pkmn.moves[move].name
    scene.pbDisplay(_INTL("{1}'s PP increased.", movename))
    next true
  end
  next false
})

ItemHandlers::UseOnPokemon.add(:PPMAX, proc { |item, qty, pkmn, scene|
  move = scene.pbChooseMove(pkmn, _INTL("Boost PP of which move?"))
  if move >= 0
    if pkmn.moves[move].total_pp <= 1 || pkmn.moves[move].ppup >= 3
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    pkmn.moves[move].ppup = 3
    movename = pkmn.moves[move].name
    scene.pbDisplay(_INTL("{1}'s PP increased.", movename))
    next true
  end
  next false
})

ItemHandlers::UseOnPokemonMaximum.add(:HPUP, proc { |item, pkmn|
  next pbMaxUsesOfIVRaisingItem(:HP, 1, pkmn)
})

ItemHandlers::UseOnPokemon.add(:HPUP, proc { |item, qty, pkmn, scene|
  next pbUseIVRaisingItem(:HP, 1, qty, pkmn, "vitamin", scene)
})

ItemHandlers::UseOnPokemonMaximum.add(:PROTEIN, proc { |item, pkmn|
  next pbMaxUsesOfIVRaisingItem(:ATTACK, 1, pkmn)
})

ItemHandlers::UseOnPokemon.add(:PROTEIN, proc { |item, qty, pkmn, scene|
  next pbUseIVRaisingItem(:ATTACK, 1, qty, pkmn, "vitamin", scene)
})

ItemHandlers::UseOnPokemonMaximum.add(:IRON, proc { |item, pkmn|
  next pbMaxUsesOfIVRaisingItem(:DEFENSE, 1, pkmn)
})

ItemHandlers::UseOnPokemon.add(:IRON, proc { |item, qty, pkmn, scene|
  next pbUseIVRaisingItem(:DEFENSE, 1, qty, pkmn, "vitamin", scene)
})

ItemHandlers::UseOnPokemonMaximum.add(:CALCIUM, proc { |item, pkmn|
  next pbMaxUsesOfIVRaisingItem(:SPECIAL_ATTACK, 1, pkmn)
})

ItemHandlers::UseOnPokemon.add(:CALCIUM, proc { |item, qty, pkmn, scene|
  next pbUseIVRaisingItem(:SPECIAL_ATTACK, 1, qty, pkmn, "vitamin", scene)
})

ItemHandlers::UseOnPokemonMaximum.add(:ZINC, proc { |item, pkmn|
  next pbMaxUsesOfIVRaisingItem(:SPECIAL_DEFENSE, 1, pkmn)
})

ItemHandlers::UseOnPokemon.add(:ZINC, proc { |item, qty, pkmn, scene|
  next pbUseIVRaisingItem(:SPECIAL_DEFENSE, 1, qty, pkmn, "vitamin", scene)
})

ItemHandlers::UseOnPokemonMaximum.add(:CARBOS, proc { |item, pkmn|
  next pbMaxUsesOfIVRaisingItem(:SPEED, 1, pkmn)
})

ItemHandlers::UseOnPokemon.add(:CARBOS, proc { |item, qty, pkmn, scene|
  next pbUseIVRaisingItem(:SPEED, 1, qty, pkmn, "vitamin", scene)
})

ItemHandlers::UseOnPokemon.add(:HPMAX, proc { |item, qty, pkmn, scene|
  case item
    when :PROTEINMAX; stat = :ATTACK
    when :IRONMAX;    stat = :DEFENSE
    when :CALCIUMMAX; stat = :SPECIAL_ATTACK
    when :ZINCMAX;    stat = :SPECIAL_DEFENSE
    when :CARBOSMAX;  stat = :SPEED
    else;             stat = :HP
  end
  next pbUseMaxIVRaisingItem(stat, pkmn, "vitamin", scene)
})
ItemHandlers::UseOnPokemon.copy(:HPMAX, :PROTEINMAX, :IRONMAX, :CALCIUMMAX, :ZINCMAX, :CARBOSMAX)

ItemHandlers::UseOnPokemon.add(:HEALTHFEATHERMIN, proc { |item, qty, pkmn, scene|
  case item
    when :MUSCLEFEATHERMIN; stat = :ATTACK
    when :RESISTFEATHERMIN; stat = :DEFENSE
    when :GENIUSFEATHERMIN; stat = :SPECIAL_ATTACK
    when :CLEVERFEATHERMIN; stat = :SPECIAL_DEFENSE
    when :SWIFTFEATHERMIN;  stat = :SPEED
    else;                   stat = :HP
  end
  next pbUseMaxIVRaisingItem(stat, pkmn, "wing", scene, true)
})
ItemHandlers::UseOnPokemon.copy(:HEALTHFEATHERMIN, :MUSCLEFEATHERMIN, :RESISTFEATHERMIN, :GENIUSFEATHERMIN, :CLEVERFEATHERMIN, :SWIFTFEATHERMIN)

ItemHandlers::UseOnPokemonMaximum.add(:HEALTHFEATHER, proc { |item, pkmn|
  next pbMaxUsesOfIVRaisingItem(:HP, 1, pkmn, true)
})

ItemHandlers::UseOnPokemonMaximum.copy(:HEALTHFEATHER, :HEALTHWING)

ItemHandlers::UseOnPokemon.add(:HEALTHFEATHER, proc { |item, qty, pkmn, scene|
  next pbUseIVRaisingItem(:HP, 1, qty, pkmn, "wing", scene, true)
})

ItemHandlers::UseOnPokemon.copy(:HEALTHFEATHER, :HEALTHWING)

ItemHandlers::UseOnPokemonMaximum.add(:MUSCLEFEATHER, proc { |item, pkmn|
  next pbMaxUsesOfIVRaisingItem(:ATTACK, 1, pkmn, true)
})

ItemHandlers::UseOnPokemonMaximum.copy(:MUSCLEFEATHER, :MUSCLEWING)

ItemHandlers::UseOnPokemon.add(:MUSCLEFEATHER, proc { |item, qty, pkmn, scene|
  next pbUseIVRaisingItem(:ATTACK, 1, qty, pkmn, "wing", scene, true)
})

ItemHandlers::UseOnPokemon.copy(:MUSCLEFEATHER, :MUSCLEWING)

ItemHandlers::UseOnPokemonMaximum.add(:RESISTFEATHER, proc { |item, pkmn|
  next pbMaxUsesOfIVRaisingItem(:DEFENSE, 1, pkmn, true)
})

ItemHandlers::UseOnPokemonMaximum.copy(:RESISTFEATHER, :RESISTWING)

ItemHandlers::UseOnPokemon.add(:RESISTFEATHER, proc { |item, qty, pkmn, scene|
  next pbUseIVRaisingItem(:DEFENSE, 1, qty, pkmn, "wing", scene, true)
})

ItemHandlers::UseOnPokemon.copy(:RESISTFEATHER, :RESISTWING)

ItemHandlers::UseOnPokemonMaximum.add(:GENIUSFEATHER, proc { |item, pkmn|
  next pbMaxUsesOfIVRaisingItem(:SPECIAL_ATTACK, 1, pkmn, true)
})

ItemHandlers::UseOnPokemonMaximum.copy(:GENIUSFEATHER, :GENIUSWING)

ItemHandlers::UseOnPokemon.add(:GENIUSFEATHER, proc { |item, qty, pkmn, scene|
  next pbUseIVRaisingItem(:SPECIAL_ATTACK, 1, qty, pkmn, "wing", scene, true)
})

ItemHandlers::UseOnPokemon.copy(:GENIUSFEATHER, :GENIUSWING)

ItemHandlers::UseOnPokemonMaximum.add(:CLEVERFEATHER, proc { |item, pkmn|
  next pbMaxUsesOfIVRaisingItem(:SPECIAL_DEFENSE, 1, pkmn, true)
})

ItemHandlers::UseOnPokemonMaximum.copy(:CLEVERFEATHER, :CLEVERWING)

ItemHandlers::UseOnPokemon.add(:CLEVERFEATHER, proc { |item, qty, pkmn, scene|
  next pbUseIVRaisingItem(:SPECIAL_DEFENSE, 1, qty, pkmn, "wing", scene, true)
})

ItemHandlers::UseOnPokemon.copy(:CLEVERFEATHER, :CLEVERWING)

ItemHandlers::UseOnPokemonMaximum.add(:SWIFTFEATHER, proc { |item, pkmn|
  next pbMaxUsesOfIVRaisingItem(:SPEED, 1, pkmn, true)
})

ItemHandlers::UseOnPokemonMaximum.copy(:SWIFTFEATHER, :SWIFTWING)

ItemHandlers::UseOnPokemon.add(:SWIFTFEATHER, proc { |item, qty, pkmn, scene|
  next pbUseIVRaisingItem(:SPEED, 1, qty, pkmn, "wing", scene, true)
})

ItemHandlers::UseOnPokemon.copy(:SWIFTFEATHER, :SWIFTWING)

ItemHandlers::UseOnPokemon.add(:LONELYMINT, proc { |item, qty, pkmn, scene|
  pbNatureChangingMint(:LONELY, item, pkmn, scene)
})

ItemHandlers::UseOnPokemon.add(:ADAMANTMINT, proc { |item, qty, pkmn, scene|
  pbNatureChangingMint(:ADAMANT, item, pkmn, scene)
})

ItemHandlers::UseOnPokemon.add(:NAUGHTYMINT, proc { |item, qty, pkmn, scene|
  pbNatureChangingMint(:NAUGHTY, item, pkmn, scene)
})

ItemHandlers::UseOnPokemon.add(:BRAVEMINT, proc { |item, qty, pkmn, scene|
  pbNatureChangingMint(:BRAVE, item, pkmn, scene)
})

ItemHandlers::UseOnPokemon.add(:BOLDMINT, proc { |item, qty, pkmn, scene|
  pbNatureChangingMint(:BOLD, item, pkmn, scene)
})

ItemHandlers::UseOnPokemon.add(:IMPISHMINT, proc { |item, qty, pkmn, scene|
  pbNatureChangingMint(:IMPISH, item, pkmn, scene)
})

ItemHandlers::UseOnPokemon.add(:LAXMINT, proc { |item, qty, pkmn, scene|
  pbNatureChangingMint(:LAX, item, pkmn, scene)
})

ItemHandlers::UseOnPokemon.add(:RELAXEDMINT, proc { |item, qty, pkmn, scene|
  pbNatureChangingMint(:RELAXED, item, pkmn, scene)
})

ItemHandlers::UseOnPokemon.add(:MODESTMINT, proc { |item, qty, pkmn, scene|
  pbNatureChangingMint(:MODEST, item, pkmn, scene)
})

ItemHandlers::UseOnPokemon.add(:MILDMINT, proc { |item, qty, pkmn, scene|
  pbNatureChangingMint(:MILD, item, pkmn, scene)
})

ItemHandlers::UseOnPokemon.add(:RASHMINT, proc { |item, qty, pkmn, scene|
  pbNatureChangingMint(:RASH, item, pkmn, scene)
})

ItemHandlers::UseOnPokemon.add(:QUIETMINT, proc { |item, qty, pkmn, scene|
  pbNatureChangingMint(:QUIET, item, pkmn, scene)
})

ItemHandlers::UseOnPokemon.add(:CALMMINT, proc { |item, qty, pkmn, scene|
  pbNatureChangingMint(:CALM, item, pkmn, scene)
})

ItemHandlers::UseOnPokemon.add(:GENTLEMINT, proc { |item, qty, pkmn, scene|
  pbNatureChangingMint(:GENTLE, item, pkmn, scene)
})

ItemHandlers::UseOnPokemon.add(:CAREFULMINT, proc { |item, qty, pkmn, scene|
  pbNatureChangingMint(:CAREFUL, item, pkmn, scene)
})

ItemHandlers::UseOnPokemon.add(:SASSYMINT, proc { |item, qty, pkmn, scene|
  pbNatureChangingMint(:SASSY, item, pkmn, scene)
})

ItemHandlers::UseOnPokemon.add(:TIMIDMINT, proc { |item, qty, pkmn, scene|
  pbNatureChangingMint(:TIMID, item, pkmn, scene)
})

ItemHandlers::UseOnPokemon.add(:HASTYMINT, proc { |item, qty, pkmn, scene|
  pbNatureChangingMint(:HASTY, item, pkmn, scene)
})

ItemHandlers::UseOnPokemon.add(:JOLLYMINT, proc { |item, qty, pkmn, scene|
  pbNatureChangingMint(:JOLLY, item, pkmn, scene)
})

ItemHandlers::UseOnPokemon.add(:NAIVEMINT, proc { |item, qty, pkmn, scene|
  pbNatureChangingMint(:NAIVE, item, pkmn, scene)
})

ItemHandlers::UseOnPokemon.add(:SERIOUSMINT, proc { |item, qty, pkmn, scene|
  pbNatureChangingMint(:SERIOUS, item, pkmn, scene)
})

# Changed by Jos 2022-10-23 Commented out to make rare candy hack work
#ItemHandlers::UseOnPokemonMaximum.add(:RARECANDY, proc { |item, pkmn|
#  next GameData::GrowthRate.max_level - pkmn.level
#})

=begin
ItemHandlers::UseOnPokemon.add(:RARECANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level up
  pbChangeLevel(pkmn, pkmn.level + qty, scene)
  scene.pbHardRefresh
  next true
})
=end

# Changed by Jos 2022-10-23 with DemICE's help.
ItemHandlers::UseOnPokemon.add(:RARECANDY, proc { |item, qty, pkmn, scene|
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  proceed=false
  maxlevel=0
  for i in $Trainer.party
      if i.level>maxlevel
          maxlevel=i.level
      end    
  end 
  if pkmn.level>=maxlevel
    scene.pbDisplay(_INTL("This Pokémon already has the highest level in this party."))
    next false  
  end 
  difference = (maxlevel-pkmn.level)
  qtyinitial=qty
  if qty>difference
    qty=difference
  end 
  candyback=qtyinitial-qty
  $bag.add(:RARECANDY, candyback)
  if pkmn.shadowPokemon?
	scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  # Level up
  pbChangeLevel(pkmn, pkmn.level + qty, scene)
  scene.pbHardRefresh
  next true
})

# Added by PDM 2026-04-28 for Riptide's suggestion
ItemHandlers::UseOnPokemon.add(:RARESTCANDY, proc { |item, qty, pkmn, scene|
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  proceed=false
  maxlevel=0
  for i in $Trainer.party
    if i.level>maxlevel
      maxlevel=i.level
    end    
  end 
  if pkmn.level>=maxlevel
    scene.pbDisplay(_INTL("This Pokémon already has the highest level in this party."))
    next false  
  end 
  difference = (maxlevel-pkmn.level)
  if pkmn.shadowPokemon?
	scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  # Level up
  pbChangeLevel(pkmn, pkmn.level + difference, scene)
  scene.pbHardRefresh
  next true
})
# End of addition

ItemHandlers::UseOnPokemonMaximum.add(:EXPCANDYXS, proc { |item, pkmn|
  gain_amount = 100
  next ((pkmn.growth_rate.maximum_exp - pkmn.exp) / gain_amount.to_f).ceil
})

ItemHandlers::UseOnPokemon.add(:EXPCANDYXS, proc { |item, qty, pkmn, scene|
  next pbGainExpFromExpCandy(pkmn, 100, qty, scene)
})

ItemHandlers::UseOnPokemonMaximum.add(:EXPCANDYS, proc { |item, pkmn|
  gain_amount = 800
  next ((pkmn.growth_rate.maximum_exp - pkmn.exp) / gain_amount.to_f).ceil
})

ItemHandlers::UseOnPokemon.add(:EXPCANDYS, proc { |item, qty, pkmn, scene|
  next pbGainExpFromExpCandy(pkmn, 800, qty, scene)
})

ItemHandlers::UseOnPokemonMaximum.add(:EXPCANDYM, proc { |item, pkmn|
  gain_amount = 3_000
  next ((pkmn.growth_rate.maximum_exp - pkmn.exp) / gain_amount.to_f).ceil
})

ItemHandlers::UseOnPokemon.add(:EXPCANDYM, proc { |item, qty, pkmn, scene|
  next pbGainExpFromExpCandy(pkmn, 3_000, qty, scene)
})

ItemHandlers::UseOnPokemonMaximum.add(:EXPCANDYL, proc { |item, pkmn|
  gain_amount = 10_000
  next ((pkmn.growth_rate.maximum_exp - pkmn.exp) / gain_amount.to_f).ceil
})

ItemHandlers::UseOnPokemon.add(:EXPCANDYL, proc { |item, qty, pkmn, scene|
  next pbGainExpFromExpCandy(pkmn, 10_000, qty, scene)
})

ItemHandlers::UseOnPokemonMaximum.add(:EXPCANDYXL, proc { |item, pkmn|
  gain_amount = 30_000
  next ((pkmn.growth_rate.maximum_exp - pkmn.exp) / gain_amount.to_f).ceil
})

ItemHandlers::UseOnPokemon.add(:EXPCANDYXL, proc { |item, qty, pkmn, scene|
  next pbGainExpFromExpCandy(pkmn, 30_000, qty, scene)
})

ItemHandlers::UseOnPokemonMaximum.add(:POMEGBERRY, proc { |item, pkmn|
  next pbMaxUsesOfEVLoweringBerry(:HP, pkmn)
})

ItemHandlers::UseOnPokemon.add(:POMEGBERRY, proc { |item, qty, pkmn, scene|
  next pbRaiseHappinessAndLowerEV(
    pkmn, scene, :HP, qty, [
      _INTL("{1} adores you! Its base HP fell!", pkmn.name),
      _INTL("{1} became more friendly. Its base HP can't go lower.", pkmn.name),
      _INTL("{1} became more friendly. However, its base HP fell!", pkmn.name)
    ]
  )
})

ItemHandlers::UseOnPokemonMaximum.add(:KELPSYBERRY, proc { |item, pkmn|
  next pbMaxUsesOfEVLoweringBerry(:ATTACK, pkmn)
})

ItemHandlers::UseOnPokemon.add(:KELPSYBERRY, proc { |item, qty, pkmn, scene|
  next pbRaiseHappinessAndLowerEV(
    pkmn, scene, :ATTACK, qty, [
      _INTL("{1} adores you! Its base Attack fell!", pkmn.name),
      _INTL("{1} became more friendly. Its base Attack can't go lower.", pkmn.name),
      _INTL("{1} became more friendly. However, its base Attack fell!", pkmn.name)
    ]
  )
})

ItemHandlers::UseOnPokemonMaximum.add(:QUALOTBERRY, proc { |item, pkmn|
  next pbMaxUsesOfEVLoweringBerry(:DEFENSE, pkmn)
})

ItemHandlers::UseOnPokemon.add(:QUALOTBERRY, proc { |item, qty, pkmn, scene|
  next pbRaiseHappinessAndLowerEV(
    pkmn, scene, :DEFENSE, qty, [
      _INTL("{1} adores you! Its base Defense fell!", pkmn.name),
      _INTL("{1} became more friendly. Its base Defense can't go lower.", pkmn.name),
      _INTL("{1} became more friendly. However, its base Defense fell!", pkmn.name)
    ]
  )
})

ItemHandlers::UseOnPokemonMaximum.add(:HONDEWBERRY, proc { |item, pkmn|
  next pbMaxUsesOfEVLoweringBerry(:SPECIAL_ATTACK, pkmn)
})

ItemHandlers::UseOnPokemon.add(:HONDEWBERRY, proc { |item, qty, pkmn, scene|
  next pbRaiseHappinessAndLowerEV(
    pkmn, scene, :SPECIAL_ATTACK, qty, [
      _INTL("{1} adores you! Its base Special Attack fell!", pkmn.name),
      _INTL("{1} became more friendly. Its base Special Attack can't go lower.", pkmn.name),
      _INTL("{1} became more friendly. However, its base Special Attack fell!", pkmn.name)
    ]
  )
})

ItemHandlers::UseOnPokemonMaximum.add(:GREPABERRY, proc { |item, pkmn|
  next pbMaxUsesOfEVLoweringBerry(:SPECIAL_DEFENSE, pkmn)
})

ItemHandlers::UseOnPokemon.add(:GREPABERRY, proc { |item, qty, pkmn, scene|
  next pbRaiseHappinessAndLowerEV(
    pkmn, scene, :SPECIAL_DEFENSE, qty, [
      _INTL("{1} adores you! Its base Special Defense fell!", pkmn.name),
      _INTL("{1} became more friendly. Its base Special Defense can't go lower.", pkmn.name),
      _INTL("{1} became more friendly. However, its base Special Defense fell!", pkmn.name)
    ]
  )
})

ItemHandlers::UseOnPokemonMaximum.add(:TAMATOBERRY, proc { |item, pkmn|
  next pbMaxUsesOfEVLoweringBerry(:SPEED, pkmn)
})

ItemHandlers::UseOnPokemon.add(:TAMATOBERRY, proc { |item, qty, pkmn, scene|
  next pbRaiseHappinessAndLowerEV(
    pkmn, scene, :SPEED, qty, [
      _INTL("{1} adores you! Its base Speed fell!", pkmn.name),
      _INTL("{1} became more friendly. Its base Speed can't go lower.", pkmn.name),
      _INTL("{1} became more friendly. However, its base Speed fell!", pkmn.name)
    ]
  )
})

# Changed by Jos 2022-10-10 for new EV reset discs because otherwise Essentials Deluxe was conflicting.
# This would ordinarily go in Item_Utilities.rb but if I did, the "Use" option was disappearing
def pbResetEVStat(pkmn, scene, stat, messages)
  if pkmn.ev[stat]==0
    scene.pbDisplay(_INTL("It won't have any effect."))
    return false
  else
    pkmn.ev[stat]=0
    pkmn.calc_stats
    scene.pbRefresh
    scene.pbDisplay(messages[0])
    return true
  end
end

# Changed by Jos 2022-10-10 for new EV reset discs
ItemHandlers::UseOnPokemon.add(:HPRESETBAG,proc{ |item, qty, pkmn, scene|
   next pbResetEVStat(
	pkmn, scene, :HP, [
      _INTL("{1} forgot its HP training!\nIts base HP was reset!", pkmn.name),
   ])
})

ItemHandlers::UseOnPokemon.add(:ATKRESETBAG,proc{ |item, qty, pkmn, scene|
   next pbResetEVStat(
	pkmn, scene, :ATTACK, [
      _INTL("{1} forgot its Attack training!\nIts base Attack was reset!", pkmn.name),
   ])
})

ItemHandlers::UseOnPokemon.add(:DEFRESETBAG,proc{ |item, qty, pkmn, scene|
   next pbResetEVStat(
	pkmn, scene, :DEFENSE, [
      _INTL("{1} forgot its Defense training!\nIts base Defense was reset!", pkmn.name),
   ])
})

ItemHandlers::UseOnPokemon.add(:SPDRESETBAG,proc{ |item, qty, pkmn, scene|
   next pbResetEVStat(
	pkmn, scene, :SPEED, [
      _INTL("{1} forgot its Speed training!\nIts base Speed was reset!", pkmn.name),
   ])
})

ItemHandlers::UseOnPokemon.add(:SPATKRESETBAG,proc{ |item, qty, pkmn, scene|
   next pbResetEVStat(
	pkmn, scene, :SPECIAL_ATTACK, [
      _INTL("{1} forgot its Special Attack training!\nIts base Special Attack was reset!", pkmn.name),
   ])
})

ItemHandlers::UseOnPokemon.add(:SPDEFRESETBAG,proc{ |item, qty, pkmn, scene|
   next pbResetEVStat(
	pkmn, scene, :SPECIAL_DEFENSE, [
      _INTL("{1} forgot its Special Defense training!\nIts base Special Defense was reset!", pkmn.name),
   ])
})
# End of addition
=begin
ItemHandlers::UseOnPokemon.add(:ABILITYCAPSULE, proc { |item, qty, pkmn, scene|
  if scene.pbConfirm(_INTL("Do you want to change {1}'s Ability?", pkmn.name))
    abils = pkmn.getAbilityList
    abil1 = nil
    abil2 = nil
    abils.each do |i|
      abil1 = i[0] if i[1] == 0
      abil2 = i[0] if i[1] == 1
    end
    if abil1.nil? || abil2.nil? || pkmn.hasHiddenAbility? || pkmn.isSpecies?(:ZYGARDE)
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    newabil = (pkmn.ability_index + 1) % 2
    newabilname = GameData::Ability.get((newabil == 0) ? abil1 : abil2).name
    pkmn.ability_index = newabil
    pkmn.ability = nil
    scene.pbRefresh
    scene.pbDisplay(_INTL("{1}'s Ability changed! Its Ability is now {2}!", pkmn.name, newabilname))
    next true
  end
  next false
})

ItemHandlers::UseOnPokemon.add(:ABILITYPATCH, proc { |item, qty, pkmn, scene|
  if scene.pbConfirm(_INTL("Do you want to change {1}'s Ability?", pkmn.name))
    abils = pkmn.getAbilityList
    new_ability_id = nil
    abils.each { |a| new_ability_id = a[0] if a[1] == 2 }
    if !new_ability_id || pkmn.hasHiddenAbility? || pkmn.isSpecies?(:ZYGARDE)
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    new_ability_name = GameData::Ability.get(new_ability_id).name
    pkmn.ability_index = 2
    pkmn.ability = nil
    scene.pbRefresh
    scene.pbDisplay(_INTL("{1}'s Ability changed! Its Ability is now {2}!",
       pkmn.name, new_ability_name))
    next true
  end
  next false
})
=end
ItemHandlers::UseOnPokemon.add(:ABILITYCAPSULE, proc { |item, qty, pkmn, scene|
	abils = pkmn.getAbilityList
	cmds = pkmn.ability_index
	command = []
	if abils.length==1
	scene.pbDisplay(_INTL("{1} only has 1 Ability.", pkmn.name, pkmn.ability.name))
	next false
	end
	for a in 0...abils.length; command.push((((abils[a][1]) < 2) ? "" : "(H) ") + GameData::Ability.get(abils[a][0]).name); end
	cmds = scene.pbShowCommands(_INTL("Change {1}'s Ability.", pkmn.name), command, cmds)
	case cmds
	  when -1; next false
	  when cmds
	    if pkmn.ability != abils[cmds][0]
		pkmn.ability=abils[cmds][0]
		pkmn.ability_index=abils[cmds][1]
		scene.pbDisplay(_INTL("{1}'s Ability was changed to {2}.", pkmn.name, pkmn.ability.name))
		next true
		else
		scene.pbDisplay(_INTL("{1}'s Ability is already {2}.", pkmn.name, pkmn.ability.name))
		next false
		end
	end
})
ItemHandlers::UseOnPokemon.copy(:ABILITYCAPSULE, :ABILITYPATCH)

ItemHandlers::UseOnPokemon.add(:GRACIDEA, proc { |item, qty, pkmn, scene|
  if !pkmn.isSpecies?(:SHAYMIN) || pkmn.form != 0 ||
     pkmn.status == :FROZEN || PBDayNight.isNight?
    scene.pbDisplay(_INTL("It had no effect."))
    next false
  elsif pkmn.fainted?
    scene.pbDisplay(_INTL("This can't be used on the fainted Pokémon."))
    next false
  end
  pkmn.setForm(1) {
    scene.pbRefresh
    scene.pbDisplay(_INTL("{1} changed Forme!", pkmn.name))
  }
  next true
})

ItemHandlers::UseOnPokemon.add(:REDNECTAR, proc { |item, qty, pkmn, scene|
  if !pkmn.isSpecies?(:ORICORIO) || pkmn.form == 0
    scene.pbDisplay(_INTL("It had no effect."))
    next false
  elsif pkmn.fainted?
    scene.pbDisplay(_INTL("This can't be used on the fainted Pokémon."))
    next false
  end
  pkmn.setForm(0) {
    scene.pbRefresh
    scene.pbDisplay(_INTL("{1} changed form!", pkmn.name))
  }
  next true
})

ItemHandlers::UseOnPokemon.add(:YELLOWNECTAR, proc { |item, qty, pkmn, scene|
  if !pkmn.isSpecies?(:ORICORIO) || pkmn.form == 1
    scene.pbDisplay(_INTL("It had no effect."))
    next false
  elsif pkmn.fainted?
    scene.pbDisplay(_INTL("This can't be used on the fainted Pokémon."))
    next false
  end
  pkmn.setForm(1) {
    scene.pbRefresh
    scene.pbDisplay(_INTL("{1} changed form!", pkmn.name))
  }
  next true
})

ItemHandlers::UseOnPokemon.add(:PINKNECTAR, proc { |item, qty, pkmn, scene|
  if !pkmn.isSpecies?(:ORICORIO) || pkmn.form == 2
    scene.pbDisplay(_INTL("It had no effect."))
    next false
  elsif pkmn.fainted?
    scene.pbDisplay(_INTL("This can't be used on the fainted Pokémon."))
    next false
  end
  pkmn.setForm(2) {
    scene.pbRefresh
    scene.pbDisplay(_INTL("{1} changed form!", pkmn.name))
  }
  next true
})

ItemHandlers::UseOnPokemon.add(:PURPLENECTAR, proc { |item, qty, pkmn, scene|
  if !pkmn.isSpecies?(:ORICORIO) || pkmn.form == 3
    scene.pbDisplay(_INTL("It had no effect."))
    next false
  elsif pkmn.fainted?
    scene.pbDisplay(_INTL("This can't be used on the fainted Pokémon."))
    next false
  end
  pkmn.setForm(3) {
    scene.pbRefresh
    scene.pbDisplay(_INTL("{1} changed form!", pkmn.name))
  }
  next true
})

# Changed by Jos 2024-05-26 to add new items to change Oricorio forms
ItemHandlers::UseOnPokemon.add(:CDTRANCE, proc { |item, qty, pkmn, scene|
  if !pkmn.isSpecies?(:ORICORIO) || pkmn.form == 0
    scene.pbDisplay(_INTL("It had no effect."))
    next false
  elsif pkmn.fainted?
    scene.pbDisplay(_INTL("This can't be used on the fainted Pokémon."))
    next false
  end
  pkmn.setForm(0) {
    scene.pbRefresh
    scene.pbDisplay(_INTL("{1} changed form!", pkmn.name))
  }
  next true
})

ItemHandlers::UseOnPokemon.add(:CDMETAL, proc { |item, qty, pkmn, scene|
  if !pkmn.isSpecies?(:ORICORIO) || pkmn.form == 1
    scene.pbDisplay(_INTL("It had no effect."))
    next false
  elsif pkmn.fainted?
    scene.pbDisplay(_INTL("This can't be used on the fainted Pokémon."))
    next false
  end
  pkmn.setForm(1) {
    scene.pbRefresh
    scene.pbDisplay(_INTL("{1} changed form!", pkmn.name))
  }
  next true
})

ItemHandlers::UseOnPokemon.add(:CDRAVE, proc { |item, qty, pkmn, scene|
  if !pkmn.isSpecies?(:ORICORIO) || pkmn.form == 2
    scene.pbDisplay(_INTL("It had no effect."))
    next false
  elsif pkmn.fainted?
    scene.pbDisplay(_INTL("This can't be used on the fainted Pokémon."))
    next false
  end
  pkmn.setForm(2) {
    scene.pbRefresh
    scene.pbDisplay(_INTL("{1} changed form!", pkmn.name))
  }
  next true
})

ItemHandlers::UseOnPokemon.add(:CDWORLD, proc { |item, qty, pkmn, scene|
  if !pkmn.isSpecies?(:ORICORIO) || pkmn.form == 3
    scene.pbDisplay(_INTL("It had no effect."))
    next false
  elsif pkmn.fainted?
    scene.pbDisplay(_INTL("This can't be used on the fainted Pokémon."))
    next false
  end
  pkmn.setForm(3) {
    scene.pbRefresh
    scene.pbDisplay(_INTL("{1} changed form!", pkmn.name))
  }
  next true
})
# End of addition

ItemHandlers::UseOnPokemon.add(:REVEALGLASS, proc { |item, qty, pkmn, scene|
  if !pkmn.isSpecies?(:TORNADUS) &&
     !pkmn.isSpecies?(:THUNDURUS) &&
     !pkmn.isSpecies?(:LANDORUS)
    scene.pbDisplay(_INTL("It had no effect."))
    next false
  elsif pkmn.fainted?
    scene.pbDisplay(_INTL("This can't be used on the fainted Pokémon."))
    next false
  end
  newForm = (pkmn.form == 0) ? 1 : 0
  pkmn.setForm(newForm) {
    scene.pbRefresh
    scene.pbDisplay(_INTL("{1} changed Forme!", pkmn.name))
  }
  next true
})

ItemHandlers::UseOnPokemon.add(:PRISONBOTTLE, proc { |item, qty, pkmn, scene|
  if !pkmn.isSpecies?(:HOOPA)
    scene.pbDisplay(_INTL("It had no effect."))
    next false
  elsif pkmn.fainted?
    scene.pbDisplay(_INTL("This can't be used on the fainted Pokémon."))
    next false
  end
  newForm = (pkmn.form == 0) ? 1 : 0
  pkmn.setForm(newForm) {
    scene.pbRefresh
    scene.pbDisplay(_INTL("{1} changed Forme!", pkmn.name))
  }
  next true
})

=begin
# Changed by Jos 2024-12-07 to disable Rotom forms
ItemHandlers::UseOnPokemon.add(:ROTOMCATALOG, proc { |item, qty, pkmn, scene|
  if !pkmn.isSpecies?(:ROTOM)
    scene.pbDisplay(_INTL("It had no effect."))
    next false
  elsif pkmn.fainted?
    scene.pbDisplay(_INTL("This can't be used on the fainted Pokémon."))
    next false
  end
  choices = [
    _INTL("Light bulb"),
    _INTL("Microwave oven"),
    _INTL("Washing machine"),
    _INTL("Refrigerator"),
    _INTL("Electric fan"),
    _INTL("Lawn mower"),
    _INTL("Cancel")
  ]
  new_form = scene.pbShowCommands(_INTL("Which appliance would you like to order?"),
     choices, pkmn.form)
  if new_form == pkmn.form
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  elsif new_form > 0 && new_form < choices.length - 1
    pkmn.setForm(new_form) {
      scene.pbRefresh
      scene.pbDisplay(_INTL("{1} transformed!", pkmn.name))
    }
    next true
  end
  next false
})
=end

ItemHandlers::UseOnPokemon.add(:ZYGARDECUBE, proc { |item, qty, pkmn, scene|
  if !pkmn.isSpecies?(:ZYGARDE)
    scene.pbDisplay(_INTL("It had no effect."))
    next false
  elsif pkmn.fainted?
    scene.pbDisplay(_INTL("This can't be used on the fainted Pokémon."))
    next false
  end
  case scene.pbShowCommands(_INTL("What will you do with {1}?", pkmn.name),
     [_INTL("Change form"), _INTL("Change Ability"), _INTL("Cancel")])
  when 0   # Change form
    newForm = (pkmn.form == 0) ? 1 : 0
    pkmn.setForm(newForm) {
      scene.pbRefresh
      scene.pbDisplay(_INTL("{1} transformed!", pkmn.name))
    }
    next true
  when 1   # Change ability
    new_abil = (pkmn.ability_index + 1) % 2
    pkmn.ability_index = new_abil
    pkmn.ability = nil
    scene.pbRefresh
    scene.pbDisplay(_INTL("{1}'s Ability changed! Its Ability is now {2}!", pkmn.name, pkmn.ability.name))
    next true
  end
  next false
})

ItemHandlers::UseOnPokemon.add(:DNASPLICERS, proc { |item, qty, pkmn, scene|
  if !pkmn.isSpecies?(:KYUREM) || !pkmn.fused.nil?
    scene.pbDisplay(_INTL("It had no effect."))
    next false
  elsif pkmn.fainted?
    scene.pbDisplay(_INTL("This can't be used on the fainted Pokémon."))
    next false
  end
  # Fusing
  chosen = scene.pbChoosePokemon(_INTL("Fuse with which Pokémon?"))
  next false if chosen < 0
  other_pkmn = $player.party[chosen]
  if pkmn == other_pkmn
    scene.pbDisplay(_INTL("It cannot be fused with itself."))
    next false
  elsif other_pkmn.egg?
    scene.pbDisplay(_INTL("It cannot be fused with an Egg."))
    next false
  elsif other_pkmn.fainted?
    scene.pbDisplay(_INTL("It cannot be fused with that fainted Pokémon."))
    next false
  elsif !other_pkmn.isSpecies?(:RESHIRAM) && !other_pkmn.isSpecies?(:ZEKROM)
    scene.pbDisplay(_INTL("It cannot be fused with that Pokémon."))
    next false
  end
  newForm = 0
  newForm = 1 if other_pkmn.isSpecies?(:RESHIRAM)
  newForm = 2 if other_pkmn.isSpecies?(:ZEKROM)
  pkmn.setForm(newForm) {
    pkmn.fused = other_pkmn
    $player.remove_pokemon_at_index(chosen)
    scene.pbHardRefresh
    scene.pbDisplay(_INTL("{1} changed Forme!", pkmn.name))
  }
  $bag.replace_item(:DNASPLICERS, :DNASPLICERSUSED)
  next true
})

ItemHandlers::UseOnPokemon.add(:DNASPLICERSUSED, proc { |item, qty, pkmn, scene|
  if !pkmn.isSpecies?(:KYUREM) || pkmn.fused.nil?
    scene.pbDisplay(_INTL("It had no effect."))
    next false
  elsif pkmn.fainted?
    scene.pbDisplay(_INTL("This can't be used on the fainted Pokémon."))
    next false
  elsif $player.party_full?
    scene.pbDisplay(_INTL("You have no room to separate the Pokémon."))
    next false
  end
  # Unfusing
  pkmn.setForm(0) {
    $player.party[$player.party.length] = pkmn.fused
    pkmn.fused = nil
    scene.pbHardRefresh
    scene.pbDisplay(_INTL("{1} changed Forme!", pkmn.name))
  }
  $bag.replace_item(:DNASPLICERSUSED, :DNASPLICERS)
  next true
})

ItemHandlers::UseOnPokemon.add(:NSOLARIZER, proc { |item, qty, pkmn, scene|
  if !pkmn.isSpecies?(:NECROZMA) || !pkmn.fused.nil?
    scene.pbDisplay(_INTL("It had no effect."))
    next false
  elsif pkmn.fainted?
    scene.pbDisplay(_INTL("This can't be used on the fainted Pokémon."))
    next false
  end
  # Fusing
  chosen = scene.pbChoosePokemon(_INTL("Fuse with which Pokémon?"))
  next false if chosen < 0
  other_pkmn = $player.party[chosen]
  if pkmn == other_pkmn
    scene.pbDisplay(_INTL("It cannot be fused with itself."))
    next false
  elsif other_pkmn.egg?
    scene.pbDisplay(_INTL("It cannot be fused with an Egg."))
    next false
  elsif other_pkmn.fainted?
    scene.pbDisplay(_INTL("It cannot be fused with that fainted Pokémon."))
    next false
  elsif !other_pkmn.isSpecies?(:SOLGALEO)
    scene.pbDisplay(_INTL("It cannot be fused with that Pokémon."))
    next false
  end
  pkmn.setForm(1) {
    pkmn.fused = other_pkmn
    $player.remove_pokemon_at_index(chosen)
    scene.pbHardRefresh
    scene.pbDisplay(_INTL("{1} changed Forme!", pkmn.name))
  }
  $bag.replace_item(:NSOLARIZER, :NSOLARIZERUSED)
  next true
})

ItemHandlers::UseOnPokemon.add(:NSOLARIZERUSED, proc { |item, qty, pkmn, scene|
  if !pkmn.isSpecies?(:NECROZMA) || pkmn.form != 1 || pkmn.fused.nil?
    scene.pbDisplay(_INTL("It had no effect."))
    next false
  elsif pkmn.fainted?
    scene.pbDisplay(_INTL("This can't be used on the fainted Pokémon."))
    next false
  elsif $player.party_full?
    scene.pbDisplay(_INTL("You have no room to separate the Pokémon."))
    next false
  end
  # Unfusing
  pkmn.setForm(0) {
    $player.party[$player.party.length] = pkmn.fused
    pkmn.fused = nil
    scene.pbHardRefresh
    scene.pbDisplay(_INTL("{1} changed Forme!", pkmn.name))
  }
  $bag.replace_item(:NSOLARIZERUSED, :NSOLARIZER)
  next true
})

ItemHandlers::UseOnPokemon.add(:NLUNARIZER, proc { |item, qty, pkmn, scene|
  if !pkmn.isSpecies?(:NECROZMA) || !pkmn.fused.nil?
    scene.pbDisplay(_INTL("It had no effect."))
    next false
  elsif pkmn.fainted?
    scene.pbDisplay(_INTL("This can't be used on the fainted Pokémon."))
    next false
  end
  # Fusing
  chosen = scene.pbChoosePokemon(_INTL("Fuse with which Pokémon?"))
  next false if chosen < 0
  other_pkmn = $player.party[chosen]
  if pkmn == other_pkmn
    scene.pbDisplay(_INTL("It cannot be fused with itself."))
    next false
  elsif other_pkmn.egg?
    scene.pbDisplay(_INTL("It cannot be fused with an Egg."))
    next false
  elsif other_pkmn.fainted?
    scene.pbDisplay(_INTL("It cannot be fused with that fainted Pokémon."))
    next false
  elsif !other_pkmn.isSpecies?(:LUNALA)
    scene.pbDisplay(_INTL("It cannot be fused with that Pokémon."))
    next false
  end
  pkmn.setForm(2) {
    pkmn.fused = other_pkmn
    $player.remove_pokemon_at_index(chosen)
    scene.pbHardRefresh
    scene.pbDisplay(_INTL("{1} changed Forme!", pkmn.name))
  }
  $bag.replace_item(:NLUNARIZER, :NLUNARIZERUSED)
  next true
})

ItemHandlers::UseOnPokemon.add(:NLUNARIZERUSED, proc { |item, qty, pkmn, scene|
  if !pkmn.isSpecies?(:NECROZMA) || pkmn.form != 2 || pkmn.fused.nil?
    scene.pbDisplay(_INTL("It had no effect."))
    next false
  elsif pkmn.fainted?
    scene.pbDisplay(_INTL("This can't be used on the fainted Pokémon."))
    next false
  elsif $player.party_full?
    scene.pbDisplay(_INTL("You have no room to separate the Pokémon."))
    next false
  end
  # Unfusing
  pkmn.setForm(0) {
    $player.party[$player.party.length] = pkmn.fused
    pkmn.fused = nil
    scene.pbHardRefresh
    scene.pbDisplay(_INTL("{1} changed Forme!", pkmn.name))
  }
  $bag.replace_item(:NLUNARIZERUSED, :NLUNARIZER)
  next true
})

ItemHandlers::UseOnPokemon.add(:REINSOFUNITY, proc { |item, qty, pkmn, scene|
  if !pkmn.isSpecies?(:CALYREX) || !pkmn.fused.nil?
    scene.pbDisplay(_INTL("It had no effect."))
    next false
  elsif pkmn.fainted?
    scene.pbDisplay(_INTL("This can't be used on the fainted Pokémon."))
    next false
  end
  # Fusing
  chosen = scene.pbChoosePokemon(_INTL("Fuse with which Pokémon?"))
  next false if chosen < 0
  other_pkmn = $player.party[chosen]
  if pkmn == other_pkmn
    scene.pbDisplay(_INTL("It cannot be fused with itself."))
    next false
  elsif other_pkmn.egg?
    scene.pbDisplay(_INTL("It cannot be fused with an Egg."))
    next false
  elsif other_pkmn.fainted?
    scene.pbDisplay(_INTL("It cannot be fused with that fainted Pokémon."))
    next false
  elsif !other_pkmn.isSpecies?(:GLASTRIER) &&
        !other_pkmn.isSpecies?(:SPECTRIER)
    scene.pbDisplay(_INTL("It cannot be fused with that Pokémon."))
    next false
  end
  newForm = 0
  newForm = 1 if other_pkmn.isSpecies?(:GLASTRIER)
  newForm = 2 if other_pkmn.isSpecies?(:SPECTRIER)
  pkmn.setForm(newForm) {
    pkmn.fused = other_pkmn
    $player.remove_pokemon_at_index(chosen)
    scene.pbHardRefresh
    scene.pbDisplay(_INTL("{1} changed Forme!", pkmn.name))
  }
  $bag.replace_item(:REINSOFUNITY, :REINSOFUNITYUSED)
  next true
})

ItemHandlers::UseOnPokemon.add(:REINSOFUNITYUSED, proc { |item, qty, pkmn, scene|
  if !pkmn.isSpecies?(:CALYREX) || pkmn.fused.nil?
    scene.pbDisplay(_INTL("It had no effect."))
    next false
  elsif pkmn.fainted?
    scene.pbDisplay(_INTL("This can't be used on the fainted Pokémon."))
    next false
  elsif $player.party_full?
    scene.pbDisplay(_INTL("You have no room to separate the Pokémon."))
    next false
  end
  # Unfusing
  pkmn.setForm(0) {
    $player.party[$player.party.length] = pkmn.fused
    pkmn.fused = nil
    scene.pbHardRefresh
    scene.pbDisplay(_INTL("{1} changed Forme!", pkmn.name))
  }
  $bag.replace_item(:REINSOFUNITYUSED, :REINSOFUNITY)
  next true
})


#DemICE changing Vitamins to raise IVs
def pbRaiseIVs(pkmn, stat, ivGain = 1, reduction = false)
  stat = GameData::Stat.get(stat).id
  if reduction
    return 0 if pkmn.iv[stat] == 0
    if pkmn.iv[stat] > 0
      pkmn.iv[stat] -= ivGain
      pkmn.calc_stats
    end
  else
    return 0 if pkmn.iv[stat] >= 31
    ivGain = ivGain.clamp(0, 31 - pkmn.iv[stat])
    if ivGain > 0
      pkmn.iv[stat] += ivGain
      pkmn.calc_stats
    end
  end 
  return ivGain
end

def pbMaxUsesOfIVRaisingItem(stat, amt_per_use, pkmn, reduction = false)
  if reduction
    return pkmn.iv[stat]
  else
    max_per_stat = 31
    amt_can_gain = max_per_stat - pkmn.iv[stat]
    amt_can_gain = [amt_can_gain, 31].min
    return [(amt_can_gain.to_f / amt_per_use).ceil, 1].max 
  end 
end

def pbUseIVRaisingItem(stat, amt_per_use, qty, pkmn, happiness_type, scene, reduction = false)
  ret = true
  qty.times do |i|
    if pbRaiseIVs(pkmn, stat, amt_per_use, reduction) > 0
      pkmn.changeHappiness(happiness_type)
    else
      ret = false if i == 0
      break
    end
  end
  if !ret
    scene.pbDisplay(_INTL("It won't have any effect."))
    return false
  end
  scene.pbRefresh
  if reduction
    scene.pbDisplay(_INTL("{1}'s {2} decreased.", pkmn.name, GameData::Stat.get(stat).name))
  else  
    scene.pbDisplay(_INTL("{1}'s {2} increased.", pkmn.name, GameData::Stat.get(stat).name))
  end
  return true
end

def pbUseMaxIVRaisingItem(stat, pkmn, happiness_type, scene, reduction = false)
  ret = true
  if pkmn.iv[stat] != 31 && happiness_type == "vitamin"
    pkmn.iv[stat] = 31
    pkmn.calc_stats
    pkmn.changeHappiness(happiness_type)
  elsif pkmn.iv[stat] != 0 && happiness_type == "wing"
    pkmn.iv[stat] = 0
    pkmn.calc_stats
    pkmn.changeHappiness(happiness_type)
  else
    ret = false
  end
  if !ret
    scene.pbDisplay(_INTL("It won't have any effect."))
    return false
  end
  scene.pbRefresh
  if reduction
    scene.pbDisplay(_INTL("{1}'s {2} decreased to 0.", pkmn.name, GameData::Stat.get(stat).name))
  else  
    scene.pbDisplay(_INTL("{1}'s {2} increased to 31.", pkmn.name, GameData::Stat.get(stat).name))
  end
  return true
end

ItemHandlers::UseOnPokemon.add(:SHINYTOKEN, proc { |item, qty, pkmn, scene|
  if pkmn.shiny? || pkmn.egg?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.shiny = true
  scene.pbDisplay(_INTL("{1}'s appearance has changed!", pkmn.name))
  next true
})

ItemHandlers::UseFromBag.add(:KARMATOKEN, proc { |item|
  next 2
})

ItemHandlers::UseInField.add(:KARMATOKEN, proc { |item|
  $game_variables[26] *= -1
  pbMessage("Your Karma has been inverted to #{$game_variables[26]}!")
  next true
})
