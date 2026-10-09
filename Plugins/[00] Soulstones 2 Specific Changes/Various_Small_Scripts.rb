#===============================================================================
# Transfer existing TMs to Tutor.net and then clear the TM pocket.
#===============================================================================
def evoitem_move
    for i in $bag.pockets[1]
        item = GameData::Item.get(i[0])
        qty = i[1]
        if item.is_evolution_stone?
          $bag.remove(item,qty)
          pbReceiveItem(item,qty)
        end  
    end    
end