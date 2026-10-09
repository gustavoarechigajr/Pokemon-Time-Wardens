class PokemonBagScreen

  # UI logic for the item screen for choosing an item.
  def pbChooseItemScreen(proc = nil)
    oldlastpocket = @bag.last_viewed_pocket
    oldchoices = @bag.last_pocket_selections.clone
    @bag.reset_last_selections if proc  # Changed by DemICE 04-Sep-2023 fixing repel reuse selection.
    @scene.pbStartScene(@bag, $player.party, true, proc)
    item = @scene.pbChooseItem
    @scene.pbEndScene
    @bag.last_viewed_pocket = oldlastpocket
    @bag.last_pocket_selections = oldchoices
    return item
  end
  
end  
