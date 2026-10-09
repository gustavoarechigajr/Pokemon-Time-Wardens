# Changed by DemICE 24-Sep-2023 for alphabetical Bag Sorting
class PokemonBag
  attr_accessor :last_viewed_pocket
  
  alias bag_sorting_initialize initialize
  def initialize
    bag_sorting_initialize
    @descending_sort=false
  end

  def sort_pocket_alphabetically
    current_pocket = @pockets[@last_viewed_pocket]
    sorted = current_pocket.sort_by do |item|
      GameData::Item.get(item[0]).name
    end
    sorted.reverse! if @descending_sort

    @descending_sort = !@descending_sort
    @pockets[@last_viewed_pocket] = sorted
  end  
  
end


class PokemonBag_Scene

  # Called when the item screen wants an item to be chosen from the screen
  def pbChooseItem
    @sprites["helpwindow"].visible = false
    itemwindow = @sprites["itemlist"]
    thispocket = @bag.pockets[itemwindow.pocket]
    swapinitialpos = -1
    lastreaditem = nil
    pbActivateWindow(@sprites, "itemlist") {
      loop do
        oldindex = itemwindow.index
        Graphics.update
        Input.update
        pbUpdate
        pbUpdateAnnotation
        curritem = itemwindow.item
        if lastreaditem != curritem
          lastreaditem = curritem
          if itemwindow.item
            ttsItem = GameData::Item.get(curritem)
            Kernel.tts(ttsItem.real_name)
            Kernel.tts("Quantity #{$bag.quantity(itemwindow.item)}") if ttsItem.pocket != 8
            Kernel.tts("Registed Item") if @bag.registered?(itemwindow.item)
          else
            Kernel.tts("CLOSE BAG")
          end
        end
        if itemwindow.sorting && itemwindow.index >= thispocket.length
          itemwindow.index = (oldindex == thispocket.length - 1) ? 0 : thispocket.length - 1
        end
        if itemwindow.index != oldindex
          # Move the item being switched
          if itemwindow.sorting
            thispocket.insert(itemwindow.index, thispocket.delete_at(oldindex))
          end
          # Update selected item for current pocket
          @bag.set_last_viewed_index(itemwindow.pocket, itemwindow.index)
          pbRefresh
        end
        if itemwindow.sorting
          if Input.trigger?(Input::ACTION) ||
             Input.trigger?(Input::USE)
            itemwindow.sorting = false
            pbPlayDecisionSE
            pbRefresh
          elsif Input.trigger?(Input::BACK)
            thispocket.insert(swapinitialpos, thispocket.delete_at(itemwindow.index))
            itemwindow.index = swapinitialpos
            itemwindow.sorting = false
            pbPlayCancelSE
            pbRefresh
          end
        else
          # Plays SE when scrolling the item list
          if Input.repeat?(Input::UP) && thispocket.length > 0 || 
             Input.repeat?(Input::DOWN) && thispocket.length>0
            pbSEPlay("GUI bag cursor") if itemwindow.index != 0 && itemwindow.index != thispocket.length
          end
          # Change pockets
          if Input.trigger?(Input::LEFT)
            newpocket = itemwindow.pocket
            loop do
              newpocket = (newpocket == 1) ? PokemonBag.pocket_count : newpocket - 1
              break if !@choosing || newpocket == itemwindow.pocket
              if @filterlist
                break if @filterlist[newpocket].length > 0
              elsif @bag.pockets[newpocket].length > 0
                break
              end
            end
            if itemwindow.pocket != newpocket
              itemwindow.pocket = newpocket
              @bag.last_viewed_pocket = itemwindow.pocket
              thispocket = @bag.pockets[itemwindow.pocket]
              pbSEPlay("GUI bag pocket")
              pbRefresh
            end
            Kernel.tts(PokemonBag.pocket_names[newpocket-1], true)
          elsif Input.trigger?(Input::RIGHT)
            newpocket = itemwindow.pocket
            loop do
              newpocket = (newpocket == PokemonBag.pocket_count) ? 1 : newpocket + 1
              break if !@choosing || newpocket == itemwindow.pocket
              if @filterlist
                break if @filterlist[newpocket].length > 0
              elsif @bag.pockets[newpocket].length > 0
                break
              end
            end
            if itemwindow.pocket != newpocket
              itemwindow.pocket = newpocket
              @bag.last_viewed_pocket = itemwindow.pocket
              thispocket = @bag.pockets[itemwindow.pocket]
              pbSEPlay("GUI bag pocket")
              pbRefresh
            end
            Kernel.tts(PokemonBag.pocket_names[newpocket-1], true)
          elsif Input.triggerex?(:V) || Input.trigger?(Input::AUX2)   # Changed by DemICE 24-Sep-2023 for alphabetical Bag Sorting
            @bag.sort_pocket_alphabetically
            newpocket = itemwindow.pocket
            loop do
              newpocket = (newpocket == PokemonBag.pocket_count) ? 1 : newpocket + 1
              break if !@choosing || newpocket == itemwindow.pocket
              if @filterlist
                break if @filterlist[newpocket].length > 0
              elsif @bag.pockets[newpocket].length > 0
                break
              end
            end
            if itemwindow.pocket != newpocket
              itemwindow.pocket = newpocket
              @bag.last_viewed_pocket = itemwindow.pocket
              thispocket = @bag.pockets[itemwindow.pocket]
            end
            newpocket = itemwindow.pocket
            loop do
              newpocket = (newpocket == 1) ? PokemonBag.pocket_count : newpocket - 1
              break if !@choosing || newpocket == itemwindow.pocket
              if @filterlist
                break if @filterlist[newpocket].length > 0
              elsif @bag.pockets[newpocket].length > 0
                break
              end
            end
            if itemwindow.pocket != newpocket
              itemwindow.pocket = newpocket
              @bag.last_viewed_pocket = itemwindow.pocket
              thispocket = @bag.pockets[itemwindow.pocket]
            end
            itemwindow.index = 0
            pbRefresh
          elsif Input.trigger?(Input::SPECIAL) && !@in_battle   # Checking party
            if $player.pokemon_count == 0
              pbMessage(_INTL("There is no Pokémon."))
            else
              pbPlayDecisionSE
              itemwindow.partysel = true
              pbRefresh
              pbDeactivateWindows(@sprites){pbChoosePoke(3, false)}
              pbRefresh
            end
          elsif Input.trigger?(Input::ACTION)   # Start switching the selected item
            if !@choosing && thispocket.length > 1 && itemwindow.index < thispocket.length &&
               !Settings::BAG_POCKET_AUTO_SORT[itemwindow.pocket - 1]
              itemwindow.sorting = true
              swapinitialpos = itemwindow.index
              pbPlayDecisionSE
              pbRefresh
            end
          elsif Input.trigger?(Input::BACK)   # Cancel the item screen
            pbPlayCloseMenuSE
            return nil
          elsif Input.trigger?(Input::CTRL) && TTS_ENABLED   # TTS Item Description
            if itemwindow.item
              ttsItem = GameData::Item.get(itemwindow.item)
              Kernel.tts(ttsItem.real_name, true)
              Kernel.tts(ttsItem.real_description)
            end
          elsif Input.trigger?(Input::USE)   # Choose selected item
            (itemwindow.item) ? pbPlayDecisionSE : pbPlayCloseMenuSE
            return itemwindow.item
          end
        end
      end
    }
  end

end