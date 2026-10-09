###############################################################
# GENERATING AND EDITING POKEMONS, UPDATED TO V20.1
# Author: Jos_Louis
# Version: v1.0
# Credits to Grogro for the original script
# https://reliccastle.com/resources/705/
# Credits to TechSkylander1518 for the help in making this
##############################################################

def changeNature(pkmn)
    commands = []
    ids = []
    GameData::Nature.each do |nature|
      if nature.stat_changes.length == 0
        commands.push(_INTL("{1} (---)", nature.real_name))
      else
        plus_text = ""
        minus_text = ""
        nature.stat_changes.each do |change|
          if change[1] > 0
            plus_text += "/" if !plus_text.empty?
            plus_text += GameData::Stat.get(change[0]).name_brief
          elsif change[1] < 0
            minus_text += "/" if !minus_text.empty?
            minus_text += GameData::Stat.get(change[0]).name_brief
          end
        end
        commands.push(_INTL("{1} (+{2}, -{3})", nature.real_name, plus_text, minus_text))
      end
      ids.push(nature.id)
    end
    cmd=0
	commands.push(_INTL("Cancel"))
    cmd= pbMessage("Which nature do you want for your Pokémon?",commands,0,nil,0)
    if cmd == commands.length - 1 # Checks if player has cancelled
		pbSEPlay("GUI menu close")
		pbMessage(_INTL("If you change your mind, you know where to find me."))
	  return false
	elsif pkmn.nature == ids[cmd] # Checks if player's nature is what they already have right now
		pbSEPlay("GUI sel buzzer")
		pbMessage(_INTL("Your Pokemon already has this nature!"))
      return false
	else
		pkmn.nature = ids[cmd] # Otherwise, changes to the nature they selected
		$player.money -= 2500 # Deducts money
		pbSEPlay("Mining reveal full")
		pbMessage(_INTL("Well, see for yourself, your Pokemon's nature is now {1}.",pkmn.nature.real_name))
	  return true
	end
end

# Alternate Nature Change Script that doesn't cost money

def changeNature2(pkmn)
    commands = []
    ids = []
    GameData::Nature.each do |nature|
      if nature.stat_changes.length == 0
        commands.push(_INTL("{1} (---)", nature.real_name))
      else
        plus_text = ""
        minus_text = ""
        nature.stat_changes.each do |change|
          if change[1] > 0
            plus_text += "/" if !plus_text.empty?
            plus_text += GameData::Stat.get(change[0]).name_brief
          elsif change[1] < 0
            minus_text += "/" if !minus_text.empty?
            minus_text += GameData::Stat.get(change[0]).name_brief
          end
        end
        commands.push(_INTL("{1} (+{2}, -{3})", nature.real_name, plus_text, minus_text))
      end
      ids.push(nature.id)
    end
    cmd=0
    cmd= pbMessage("What nature do you want for your Pokémon?",commands,0,nil,0)
	if pkmn.nature = ids[cmd] # Since you can't see the nature yet, this gives you the option to select whatever you want
		pbSEPlay("Mining reveal full")
		pbMessage(_INTL("Well, see for yourself, your Pokemon's nature is now {1}.",pkmn.nature.real_name))
	  return true
	end
end

# Ability Change Script that costs money

def setabil(pkmn)
  abils = pkmn.getAbilityList
  ability_commands = []
  abil_cmd = 0
  for i in abils
    ability_commands.push(((i[1] < 2) ? "" : "(H) ") + GameData::Ability.get(i[0]).name)
    #abil_cmd = ability_commands.length - 1 if pkmn.ability_id == i[0]
  end
  ability_commands.push(_INTL("Cancel"))
  cmd= pbMessage(_INTL("Which ability do you want for your Pokémon? It currently has '{1}'.", pkmn.ability.name),ability_commands,0,nil,0)
  #abil_cmd = screen.pbShowCommands(_INTL("Choose an ability."), ability_commands, abil_cmd)
  if cmd == ability_commands.length - 1 # Checks if player has cancelled
    pbSEPlay("GUI menu close")
    pbMessage(_INTL("If you change your mind, you know where to find me."))
    return false
  elsif pkmn.ability == abils[cmd][0] # Checks if player's ability is what they already have right now
    pbSEPlay("GUI sel buzzer")
    pbMessage(_INTL("Your Pokemon already has this ability!"))
    return false
  else
    pkmn.ability = abils[cmd][0] # Otherwise, changes to the ability they selected
    pkmn.ability_index = cmd # Otherwise, changes to the ability they selected # Changed by PDM 2023-09-04 to fix resetting of abilities when you approach the move tutor.
    $player.money -= 2500 # Deducts money
    pbSEPlay("Mining reveal full")
    pbMessage(_INTL("Well, see for yourself, your Pokemon's ability is now changed."))
    return true
  end
  #pkmn.ability = nil
end

# Alternate Ability Change Script that doesn't cost money

def setabil2(pkmn)
  abils = pkmn.getAbilityList
  ability_commands = []
  abil_cmd = 0
  for i in abils
    ability_commands.push(((i[1] < 2) ? "" : "(H) ") + GameData::Ability.get(i[0]).name)
    #abil_cmd = ability_commands.length - 1 if pkmn.ability_id == i[0]
  end
  cmd= pbMessage(_INTL("Which ability do you want for your Pokémon? It currently has '{1}'.", pkmn.ability.name),ability_commands,0,nil,0)
  #abil_cmd = screen.pbShowCommands(_INTL("Choose an ability."), ability_commands, abil_cmd)
  if
    pkmn.ability = abils[cmd][0] # Otherwise, changes to the ability they selected
    pbSEPlay("Mining reveal full")
    pbMessage(_INTL("Well, see for yourself, your Pokemon's ability is now changed."))
    return true
  end
  #pkmn.ability = nil
end