class Pokemon
  def check_if_evo_is_new_stone_method(item_used)
    return check_evolution_internal { |pkmn, new_species, method, parameter|
      evo_method = [:Item, :ItemMale, :ItemFemale, :ItemDay, :ItemNight].include?(method)
      next (evo_method && pkmn.level < 30 && parameter==item_used.id) ? true : false
    }
  end
end

class PokemonBag_Scene
  def pbUpdateAnnotation
    itemwindow = @sprites["itemlist"]
    item = itemwindow.item
    itm = GameData::Item.get(item) if item
    annotations = []
    if @bag.last_viewed_pocket == 1 && item
      annotations.clear
      if itm.is_evolution_stone?
        for i in $player.party
          elig = i.check_evolution_on_use_item(itm)
          annotations.push((elig) ? _INTL("ABLE") : ((i.check_if_evo_is_new_stone_method(itm)) ? _INTL("LV.30") : _INTL("UNABLE")))
        end
      #-----------------------------------------------------------------------
      # Displays Tera Shard compatibility on the party.
      #-----------------------------------------------------------------------
      elsif PluginManager.installed?("Terastal Phenomenon") && itm.is_tera_shard?
        for i in $player.party
          elig = i.tera_type != itm.tera_shard_type
          annotations.push((elig) ? _INTL("ABLE") : _INTL("UNABLE"))
        end
      #-----------------------------------------------------------------------
      else
        for i in 0...Settings::MAX_PARTY_SIZE
          @sprites["pokemon#{i}"].text = annotations[i]
        end
      end
      for i in 0...Settings::MAX_PARTY_SIZE
        @sprites["pokemon#{i}"].text = annotations[i]
      end
    elsif @bag.last_viewed_pocket == 4 && item
      annotations.clear
      if itm.is_machine?
        machine = itm.move
        move = GameData::Move.get(machine).id
        movelist = nil
        if movelist!=nil && movelist.is_a?(Array)
          for i in 0...movelist.length
            movelist[i] = GameData::Move.get(movelist[i]).id
          end
        end
        $player.party.each_with_index do |pkmn, i|
          if pkmn.egg?
            annotations[i] = _INTL("UNABLE")
          elsif pkmn.hasMove?(move)
            annotations[i] = _INTL("LEARNED")
          else
            species = pkmn.species
            if movelist && movelist.any? { |j| j == species }
              annotations[i] = _INTL("ABLE")
            elsif pkmn.compatible_with_move?(move)
              annotations[i] = _INTL("ABLE")
            else
              annotations[i] = _INTL("UNABLE")
            end
          end
        end
      elsif itm.is_evolution_stone?
          for i in $player.party
            elig = i.check_evolution_on_use_item(itm)
            annotations.push((elig) ? _INTL("ABLE") : ((i.check_if_evo_is_new_stone_method(itm)) ? _INTL("LV.30") : _INTL("UNABLE")))
          end  
      else
        for i in @party
          annotations.push((elig) ? _INTL("ABLE") : _INTL("UNABLE"))
        end
      end
      for i in 0...Settings::MAX_PARTY_SIZE
        @sprites["pokemon#{i}"].text = annotations[i]
      end
    #-------------------------------------------------------------------------
    # Displays Z-Crystal compatibility on the party.
    #-------------------------------------------------------------------------
    elsif PluginManager.installed?("ZUD Mechanics") && 
          @bag.last_viewed_pocket == Settings::BAG_MAX_POCKET_SIZE.length && item
      annotations.clear
      if itm.is_z_crystal?
        for i in $player.party
          elig = i.compat_zmove?(i.moves, item) || i.compat_ultra?(item)
          annotations.push((elig) ? _INTL("ABLE") : _INTL("UNABLE"))
        end
      end
      for i in 0...Settings::MAX_PARTY_SIZE
        @sprites["pokemon#{i}"].text = annotations[i]
      end
    #-------------------------------------------------------------------------
    else
      for i in 0...Settings::MAX_PARTY_SIZE
        @sprites["pokemon#{i}"].text = nil if @sprites["pokemon#{i}"].text 
      end
    end
  end
end