module MultipleForms
  @@formSpecies = SpeciesHandlerHash.new

  def self.copy(sym, *syms)
    @@formSpecies.copy(sym, *syms)
  end

  def self.register(sym, hash)
    @@formSpecies.add(sym, hash)
  end

  def self.registerIf(cond, hash)
    @@formSpecies.addIf(cond, hash)
  end

  def self.hasFunction?(pkmn, func)
    spec = (pkmn.is_a?(Pokemon)) ? pkmn.species : pkmn
    sp = @@formSpecies[spec]
    return sp && sp[func]
  end

  def self.getFunction(pkmn, func)
    spec = (pkmn.is_a?(Pokemon)) ? pkmn.species : pkmn
    sp = @@formSpecies[spec]
    return (sp && sp[func]) ? sp[func] : nil
  end

  def self.call(func, pkmn, *args)
    sp = @@formSpecies[pkmn.species]
    return nil if !sp || !sp[func]
    return sp[func].call(pkmn, *args)
  end
end

def drawSpot(bitmap, spotpattern, x, y, red, green, blue)
  height = spotpattern.length
  width  = spotpattern[0].length
  height.times do |yy|
    spot = spotpattern[yy]
    width.times do |xx|
      next if spot[xx] != 1
      xOrg = (x + xx) << 1
      yOrg = (y + yy) << 1
      color = bitmap.get_pixel(xOrg, yOrg)
      r = color.red + red
      g = color.green + green
      b = color.blue + blue
      color.red   = [[r, 0].max, 255].min
      color.green = [[g, 0].max, 255].min
      color.blue  = [[b, 0].max, 255].min
      bitmap.set_pixel(xOrg, yOrg, color)
      bitmap.set_pixel(xOrg + 1, yOrg, color)
      bitmap.set_pixel(xOrg, yOrg + 1, color)
      bitmap.set_pixel(xOrg + 1, yOrg + 1, color)
    end
  end
end

def pbSpindaSpots(pkmn, bitmap)
  spot1 = [
    [0, 0, 1, 1, 1, 1, 0, 0],
    [0, 1, 1, 1, 1, 1, 1, 0],
    [1, 1, 1, 1, 1, 1, 1, 1],
    [1, 1, 1, 1, 1, 1, 1, 1],
    [1, 1, 1, 1, 1, 1, 1, 1],
    [1, 1, 1, 1, 1, 1, 1, 1],
    [1, 1, 1, 1, 1, 1, 1, 1],
    [0, 1, 1, 1, 1, 1, 1, 0],
    [0, 0, 1, 1, 1, 1, 0, 0]
  ]
  spot2 = [
    [0, 0, 1, 1, 1, 0, 0],
    [0, 1, 1, 1, 1, 1, 0],
    [1, 1, 1, 1, 1, 1, 1],
    [1, 1, 1, 1, 1, 1, 1],
    [1, 1, 1, 1, 1, 1, 1],
    [1, 1, 1, 1, 1, 1, 1],
    [1, 1, 1, 1, 1, 1, 1],
    [0, 1, 1, 1, 1, 1, 0],
    [0, 0, 1, 1, 1, 0, 0]
  ]
  spot3 = [
    [0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0],
    [0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0],
    [0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0],
    [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
    [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
    [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
    [0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0],
    [0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0],
    [0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0]
  ]
  spot4 = [
    [0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0],
    [0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0],
    [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0],
    [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
    [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
    [0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0],
    [0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0]
  ]
  id = pkmn.personalID
  h = (id >> 28) & 15
  g = (id >> 24) & 15
  f = (id >> 20) & 15
  e = (id >> 16) & 15
  d = (id >> 12) & 15
  c = (id >> 8) & 15
  b = (id >> 4) & 15
  a = (id) & 15
  if pkmn.shiny?
    drawSpot(bitmap, spot1, b + 33, a + 25, -75, -10, -150)
    drawSpot(bitmap, spot2, d + 21, c + 24, -75, -10, -150)
    drawSpot(bitmap, spot3, f + 39, e + 7, -75, -10, -150)
    drawSpot(bitmap, spot4, h + 15, g + 6, -75, -10, -150)
  else
    drawSpot(bitmap, spot1, b + 33, a + 25, 0, -115, -75)
    drawSpot(bitmap, spot2, d + 21, c + 24, 0, -115, -75)
    drawSpot(bitmap, spot3, f + 39, e + 7, 0, -115, -75)
    drawSpot(bitmap, spot4, h + 15, g + 6, 0, -115, -75)
  end
end

###==========================================================================###
###      Large Script change by PDM20 to remove all canon form functions     ###
###            core version of this script has also been Disabled            ###
###==========================================================================###
# Changed by Jos 2024-06-02 to remove randomization of Burmy and Wormadam forms
# Changed by Jos 2024-12-07 to disable Rotom's forms.
# Changed by Jos 2023-02-17 to disable weird form mechanics for Giratina
# Changed by Jos 2022-11-04 Got rid of Deerling forms
# Changed by Jos 2024-02-18 to get rid of Greninja forms
# Changed by Jos 2022-10-27 to disable this
# Simplified Bibarel forms to just male and female and they both have parental bond
# Changed by Jos 2024-02-18 to get rid of Pumpkaboo forms
# Changed by Jos 2024-02-18 to get rid of Hoopa form
# Changed by Jos 2024-02-18 to get rid of Rockruff and Lycanroc forms
# Changed by Jos 2024-02-18 to get rid of Minior forms
# Changed by Jos 2022-11-27 because these forms are stupid
# Stupid gimmick. Removing.
# Changed by Jos 2022-11-27 because these forms are stupid
# Changed by Jos 2022-11-27 because Milcery and Alcremie's 60 forms are stupid
# Changed by Jos 2022-11-04 Don't need regional form stuff so disabling it all so it doesn't create unintended consequences.


#===============================================================================
# Regular form differences
#===============================================================================
MultipleForms.register(:CASTFORM, {
  "getFormOnLeavingBattle" => proc { |pkmn, battle, usedInBattle, endBattle|
    if Randomizer.on?
      next 0 if ($PokemonGlobal.randomizedData[:ABILITY] == nil) # Changed by PDM20 so alternate forms can function in randomizers
    else
      next 0
    end
  }
})

# Changed by Jos 2024-06-02 to register Burmy's new forms
# Glow Worm (Form 0) shows up on:
# Triton Cave (149, 150, 178), Caverns of Rhea (337 - 340), Charon Tunnels (198, 285, 201, 286, 290, 291)
#
# Rockworm (Form 1) shows up on:
# Europa Cave (113,114,115), Deimos Caves (498)
#
# Snowworm form (Form 2) shows up on:
# Route 2A (130), 2B (134), Route 11A/B (197, 284)

MultipleForms.register(:BURMY,{
	"getFormOnCreation"=>proc{|pokemon|
		next 0 if !$game_map
		if [130,134,197,248].include?($game_map.map_id)
			next 2
		elsif [113,114,115,498].include?($game_map.map_id)
			next 1
		else
			next 0
		end
	}
})


# Changed by Jos 2024-02-18 Added comment to clarify that Cherrim still uses existing form changing function modes.
MultipleForms.register(:CHERRIM, {
  "getFormOnLeavingBattle" => proc { |pkmn, battle, usedInBattle, endBattle|
    if Randomizer.on?
      next 0 if ($PokemonGlobal.randomizedData[:ABILITY] == nil) # Changed by PDM20 so alternate forms can function in randomizers
    else
      next 0
    end
  }
})

# Changed by Jos 2024-02-18 Added comment to clarify that Darmanitan still uses existing form changing function modes.
MultipleForms.register(:DARMANITAN, {
  "getFormOnLeavingBattle" => proc { |pkmn, battle, usedInBattle, endBattle|
    if Randomizer.on?
      next 0 if ($PokemonGlobal.randomizedData[:ABILITY] == nil) # Changed by PDM20 so alternate forms can function in randomizers
    else
      next 0
    end
    next 2 * (pkmn.form / 2) if ($PokemonGlobal.randomizedData[:ABILITY] == nil) # Changed by PDM20 so alternate forms can function in randomizers
  }
})

# Changed by Jos 2022-10-11 for Espurr forms
# Orion Sewers Maps 159, 160, 162, 163
MultipleForms.register(:ESPURR,{
	"getFormOnCreation"=>proc{|pokemon|
		next 0 if !$game_map
		if [159, 160, 162, 163].include?($game_map.map_id)
			next 1
		else
			next 0
		end
	}
})


# Changed by Jos 2022-10-11 for Honedge forms
# Bow Form (Form 1) shows up on:
# Map #127 is Route 4A
#
# Axe form (Form 2) shows up on:
# Map #224 is Hyperion Lake
#
# Mace form (Form 3) shows up on:
# Map #128 is Route 4B

MultipleForms.register(:HONEDGE,{
	"getFormOnCreation"=>proc{|pokemon|
		next 0 if !$game_map
		if [128].include?($game_map.map_id)
			next 3
		elsif [224].include?($game_map.map_id)
			next 2
		elsif [127].include?($game_map.map_id)
			next 1
		else
			next 0
		end
	}
})


# Changed by Jos 2024-02-18 Added comment to clarify that Wishiwashi still uses existing form changing function modes.
MultipleForms.register(:WISHIWASHI, {
  "getFormOnLeavingBattle" => proc { |pkmn, battle, usedInBattle, endBattle|
    if Randomizer.on?
      next 0 if ($PokemonGlobal.randomizedData[:ABILITY] == nil) # Changed by PDM20 so alternate forms can function in randomizers
    else
      next 0
    end

  }
})

# Changed by Jos 2024-10-06 Added comment to clarify that Unown works like Wishiwashi and will revert to basic form when out of battle.
MultipleForms.register(:UNOWN, {
  "getFormOnLeavingBattle" => proc { |pkmn, battle, usedInBattle, endBattle|
    if Randomizer.on?
      next 0 if ($PokemonGlobal.randomizedData[:ABILITY] == nil) # Changed by PDM20 so alternate forms can function in randomizers
    else
      next 0
    end

  }
})

# Changed by Jos 2024-02-18 Added comment to clarify that Mimikyu still uses existing form changing function modes.
MultipleForms.register(:MIMIKYU, {
  "getFormOnLeavingBattle" => proc { |pkmn, battle, usedInBattle, endBattle|
    if Randomizer.on?
      next 0 if (pkmn.fainted? || endBattle) && ($PokemonGlobal.randomizedData[:ABILITY] == nil) # Changed by PDM20 so alternate forms can function in randomizers
    else
      next 0
    end

  }
})

MultipleForms.register(:MIMIKYU2, {
  "getFormOnLeavingBattle" => proc { |pkmn, battle, usedInBattle, endBattle|
    if Randomizer.on?
      next 0 if (pkmn.fainted? || endBattle) && ($PokemonGlobal.randomizedData[:ABILITY] == nil) # Changed by PDM20 so alternate forms can function in randomizers
    else
      next 0
    end

  }
})

MultipleForms.register(:TOGEDEMARU, {
  "getFormOnLeavingBattle" => proc { |pkmn, battle, usedInBattle, endBattle|
    if Randomizer.on?
      next 0 if (endBattle) && ($PokemonGlobal.randomizedData[:ABILITY] == nil) # Changed by PDM20 so alternate forms can function in randomizers
    else
      next 0
    end
  }
})

MultipleForms.register(:EISCUE, {
  "getFormOnLeavingBattle" => proc { |pkmn, battle, usedInBattle, endBattle|
    if Randomizer.on?
      next 0 if (pkmn.fainted? || endBattle) && ($PokemonGlobal.randomizedData[:ABILITY] == nil) # Changed by PDM20 so alternate forms can function in randomizers
    else
      next 0
    end
  }
})

# Added by Fabula 2026-04-31 to account for Morpeko
MultipleForms.register(:MORPEKO, {
  "getFormOnLeavingBattle" => proc { |pkmn, battle, usedInBattle, endBattle|
    if Randomizer.on?
      next 0 if (pkmn.fainted? || endBattle) && ($PokemonGlobal.randomizedData[:ABILITY] == nil) # Changed by PDM20 so alternate forms can function in randomizers
    else
      next 0
    end
  }
  
})
# Changed by Jos 2024-08-31 to allow for new Squawkabilly forms
MultipleForms.register(:SQUAWKABILLY, {
  "getFormOnCreation" => proc { |pkmn|
    next rand(3)
  }
})

MultipleForms.copy(:ESPURR, :MEOWSTIC)
MultipleForms.copy(:BURMY, :WORMADAM, :MOTHIM)
MultipleForms.copy(:HONEDGE, :DOUBLADE, :AEGISLASH)