def pbDisplayBattlePointsWindow(msgwindow)
  pointsString = ($player) ? $player.battle_points.to_s_formatted : "0"
  pointswindow = Window_AdvancedTextPokemon.new(_INTL("Battle Points:\n<ar>{1}</ar>", pointsString))
  pointswindow.setSkin("Graphics/Windowskins/goldskin")
  pointswindow.resizeToFit(pointswindow.text, Graphics.width)
  pointswindow.width = 160 if pointswindow.width <= 160
  if msgwindow.y == 0
    pointswindow.y = Graphics.height - pointswindow.height
  else
    pointswindow.y = 0
  end
  pointswindow.viewport = msgwindow.viewport
  pointswindow.z = msgwindow.z
  return pointswindow
end

def pbDisplayAchievementPointsWindow(msgwindow)
  pointsString = ($player) ? $Trainer.achievement_points[0].to_s_formatted : "0"
  pointswindow = Window_AdvancedTextPokemon.new(_INTL("Achievement Points:\n<ar>{1}</ar>", pointsString))
  pointswindow.setSkin("Graphics/Windowskins/goldskin")
  pointswindow.resizeToFit(pointswindow.text, Graphics.width)
  pointswindow.width = 160 if pointswindow.width <= 160
  if msgwindow.y == 0
    pointswindow.y = Graphics.height - pointswindow.height
  else
    pointswindow.y = 0
  end
  pointswindow.viewport = msgwindow.viewport
  pointswindow.z = msgwindow.z
  return pointswindow
end



#===============================================================================
# Abstraction layer for Pokemon Essentials
#===============================================================================
class BattlePointShopAdapter
  def getBP(useBP)
    cash = (useBP) ? $player.battle_points : $Trainer.achievement_points[0]
    return cash
  end

  def getBPString(useBP)
    cash = (useBP) ? $player.battle_points : $Trainer.achievement_points[0]
    title = (useBP) ? "BP" : "AP"
    align = (useBP) ? "\n<r>" : "<r>"
    return _INTL("{3}{1} {2}", cash.to_s_formatted, title, align)
  end

  def setBP(value, useBP)
    $Trainer.achievement_points[0] = value if !useBP
    $player.battle_points = value if useBP
  end

  def getInventory
    return $bag
  end

  def getName(item)
    return GameData::Item.get(item).portion_name
  end

  def getNamePlural(item)
    return GameData::Item.get(item).portion_name_plural
  end

  def getDisplayName(item)
    item_name = GameData::Item.get(item).name
    if GameData::Item.get(item).is_machine?
      machine = GameData::Item.get(item).move
      item_name = _INTL("{1} {2}", item_name, GameData::Move.get(machine).name)
    end
    return item_name
  end

  def getDisplayNamePlural(item)
    item_name_plural = GameData::Item.get(item).name_plural
    if GameData::Item.get(item).is_machine?
      machine = GameData::Item.get(item).move
      item_name_plural = _INTL("{1} {2}", item_name_plural, GameData::Move.get(machine).name)
    end
    return item_name_plural
  end

  def getDescription(item)
    return GameData::Item.get(item).description
  end

  def getItemIcon(item)
    return (item) ? GameData::Item.icon_filename(item) : nil
  end

  # Unused
  def getItemIconRect(_item)
    return Rect.new(0, 0, 48, 48)
  end

  def getQuantity(item)
    return $bag.quantity(item)
  end

  def showQuantity?(item)
    return !GameData::Item.get(item).is_important?
  end

  def getPrice(item, useBP)
    if $game_temp.mart_prices && $game_temp.mart_prices[item]
      if $game_temp.mart_prices[item][0] > 0
        return $game_temp.mart_prices[item][0]
      end
    end
    price = GameData::Item.get(item).bp_price 
    for i in 0...AP_SHOP_PRICE.length
      price = AP_SHOP_PRICE[i][1] if (AP_SHOP_PRICE[i][0] == item) && !useBP
    end
    return price
  end

  def getDisplayPrice(item, selling = false, useBP = true)
    price = getPrice(item, useBP).to_s_formatted
    title = (useBP) ? "BP" : "AP"
    return _INTL("{1} {2}", price, title)
  end

  def addItem(item)
    return $bag.add(item)
  end

  def removeItem(item)
    return $bag.remove(item)
  end
end

#===============================================================================
# Battle Point Shop
#===============================================================================
class Window_BattlePointShop < Window_DrawableCommand
  def initialize(stock, adapter, x, y, width, height, useBP = true, viewport = nil)
    @stock       = stock
    @adapter     = adapter
    super(x, y, width, height, viewport)
    @selarrow    = AnimatedBitmap.new("Graphics/Pictures/Mart/cursor")
    @baseColor   = Color.new(88, 88, 80)
    @shadowColor = Color.new(168, 184, 184)
    @useBP       = useBP
    self.windowskin = nil
  end

  def itemCount
    return @stock.length + 1
  end

  def item
    return (self.index >= @stock.length) ? nil : @stock[self.index]
  end

  def drawItem(index, count, rect)
    textpos = []
    rect = drawCursor(index, rect)
    ypos = rect.y
    if index == count - 1
      textpos.push([_INTL("CANCEL"), rect.x, ypos + 2, :left, self.baseColor, self.shadowColor])
    else
      item = @stock[index]
      itemname = @adapter.getDisplayName(item)
      qty = @adapter.getDisplayPrice(item, false, @useBP)
      sizeQty = self.contents.text_size(qty).width
      xQty = rect.x + rect.width - sizeQty - 2 - 16
      textpos.push([itemname, rect.x, ypos + 2, :left, self.baseColor, self.shadowColor])
      textpos.push([qty, xQty, ypos + 2, :left, self.baseColor, self.shadowColor])
    end
    pbDrawTextPositions(self.contents, textpos)
  end
end

#===============================================================================
#
#===============================================================================
class BattlePointShop_Scene
  def update
    pbUpdateSpriteHash(@sprites)
    @subscene&.pbUpdate
  end

  def pbRefresh
    if @subscene
      @subscene.pbRefresh
    else
      itemwindow = @sprites["itemwindow"]
      @sprites["icon"].item = itemwindow.item
      @sprites["itemtextwindow"].text =
        (itemwindow.item) ? @adapter.getDescription(itemwindow.item) : _INTL("Quit shopping.")
      @sprites["qtywindow"].visible = !itemwindow.item.nil?
      @sprites["qtywindow"].text    = _INTL("In Bag:<r>{1}", @adapter.getQuantity(itemwindow.item))
      @sprites["qtywindow"].y       = Graphics.height - 102 - @sprites["qtywindow"].height
      itemwindow.refresh
    end
    cash = (@useBP) ? "Battle" : "Achievement"
    @sprites["battlepointwindow"].text = _INTL("{2} Points:{1}", @adapter.getBPString(@useBP), cash)
  end

  def pbStartScene(stock, adapter, useBP)
    # Scroll right before showing screen
    pbScrollMap(6, 5, 5)
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    @stock = stock
    @adapter = adapter
    @useBP   = useBP
    @sprites = {}
    @sprites["background"] = IconSprite.new(0, 0, @viewport)
    @sprites["background"].setBitmap("Graphics/Pictures/Mart/bg")
    @sprites["icon"] = ItemIconSprite.new(36, Graphics.height - 50, nil, @viewport)
    winAdapter = BattlePointShopAdapter.new
    @sprites["itemwindow"] = Window_BattlePointShop.new(
      stock, winAdapter, Graphics.width - 316 - 16, 10, 330 + 16, Graphics.height - 124, @useBP
    )
    @sprites["itemwindow"].viewport = @viewport
    @sprites["itemwindow"].index = 0
    @sprites["itemwindow"].refresh
    @sprites["itemtextwindow"] = Window_UnformattedTextPokemon.newWithSize(
      "", 64, Graphics.height - 96 - 16, Graphics.width - 64, 128, @viewport
    )
    pbPrepareWindow(@sprites["itemtextwindow"])
    @sprites["itemtextwindow"].baseColor = Color.new(248, 248, 248)
    @sprites["itemtextwindow"].shadowColor = Color.new(0, 0, 0)
    @sprites["itemtextwindow"].windowskin = nil
    @sprites["helpwindow"] = Window_AdvancedTextPokemon.new("")
    pbPrepareWindow(@sprites["helpwindow"])
    @sprites["helpwindow"].visible = false
    @sprites["helpwindow"].viewport = @viewport
    pbBottomLeftLines(@sprites["helpwindow"], 1)
    @sprites["battlepointwindow"] = Window_AdvancedTextPokemon.new("")
    pbPrepareWindow(@sprites["battlepointwindow"])
    @sprites["battlepointwindow"].setSkin("Graphics/Windowskins/goldskin")
    @sprites["battlepointwindow"].visible = true
    @sprites["battlepointwindow"].viewport = @viewport
    @sprites["battlepointwindow"].x = 0
    @sprites["battlepointwindow"].y = 0
    @sprites["battlepointwindow"].width = 190
    @sprites["battlepointwindow"].height = 96
    @sprites["battlepointwindow"].baseColor = Color.new(88, 88, 80)
    @sprites["battlepointwindow"].shadowColor = Color.new(168, 184, 184)
    @sprites["qtywindow"] = Window_AdvancedTextPokemon.new("")
    pbPrepareWindow(@sprites["qtywindow"])
    @sprites["qtywindow"].setSkin("Graphics/Windowskins/goldskin")
    @sprites["qtywindow"].viewport = @viewport
    @sprites["qtywindow"].width = 190
    @sprites["qtywindow"].height = 64
    @sprites["qtywindow"].baseColor = Color.new(88, 88, 80)
    @sprites["qtywindow"].shadowColor = Color.new(168, 184, 184)
    @sprites["qtywindow"].text = _INTL("In Bag:<r>{1}", @adapter.getQuantity(@sprites["itemwindow"].item))
    @sprites["qtywindow"].y = Graphics.height - 102 - @sprites["qtywindow"].height
    pbDeactivateWindows(@sprites)
    pbRefresh
    Graphics.frame_reset
  end

  def pbEndScene
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
    # Scroll left after showing screen
    pbScrollMap(4, 5, 5)
  end

  def pbPrepareWindow(window)
    window.visible = true
    window.letterbyletter = false
  end

  def pbShowBattlePoints
    pbRefresh
    @sprites["battlepointwindow"].visible = true
  end

  def pbHideBattlePoints
    pbRefresh
    @sprites["battlepointwindow"].visible = false
  end

  def pbShowQuantity
    pbRefresh
    @sprites["qtywindow"].visible = true
  end

  def pbHideQuantity
    pbRefresh
    @sprites["qtywindow"].visible = false
  end

  def pbDisplay(msg, brief = false)
    cw = @sprites["helpwindow"]
    cw.letterbyletter = true
    cw.text = msg
    pbBottomLeftLines(cw, 2)
    cw.visible = true
    pbPlayDecisionSE
    refreshed_after_busy = false
    timer_start = System.uptime
    loop do
      Graphics.update
      Input.update
      self.update
      if !cw.busy?
        return if brief
        if !refreshed_after_busy
          pbRefresh
          timer_start = System.uptime
          refreshed_after_busy = true
        end
      end
      if Input.trigger?(Input::USE) || Input.trigger?(Input::BACK)
        cw.resume if cw.busy?
      end
      return if refreshed_after_busy && System.uptime - timer_start >= 1.5
    end
  end

  def pbDisplayPaused(msg)
    cw = @sprites["helpwindow"]
    cw.letterbyletter = true
    cw.text = msg
    pbBottomLeftLines(cw, 2)
    cw.visible = true
    yielded = false
    pbPlayDecisionSE
    Kernel.tts(msg)
    loop do
      Graphics.update
      Input.update
      wasbusy = cw.busy?
      self.update
      if !cw.busy? && !yielded
        yield if block_given?   # For playing SE as soon as the message is all shown
        yielded = true
      end
      pbRefresh if !cw.busy? && wasbusy
      if Input.trigger?(Input::USE) || Input.trigger?(Input::BACK)
        if cw.resume && !cw.busy?
          @sprites["helpwindow"].visible = false
          break
        end
      end
    end
  end

  def pbConfirm(msg)
    dw = @sprites["helpwindow"]
    dw.letterbyletter = true
    dw.text = msg
    dw.visible = true
    pbBottomLeftLines(dw, 2)
    commands = [_INTL("Yes"), _INTL("No")]
    cw = Window_CommandPokemon.new(commands)
    cw.viewport = @viewport
    pbBottomRight(cw)
    cw.y -= dw.height
    cw.index = 0
    pbPlayDecisionSE
    Kernel.tts(msg, true)
    loop do
      cw.visible = !dw.busy?
      Graphics.update
      Input.update
      cw.update
      self.update
      if Input.trigger?(Input::BACK) && dw.resume && !dw.busy?
        cw.dispose
        @sprites["helpwindow"].visible = false
        return false
      end
      if Input.trigger?(Input::USE) && dw.resume && !dw.busy?
        cw.dispose
        @sprites["helpwindow"].visible = false
        return (cw.index == 0)
      end
    end
  end


  # Changed by Jos 2023-09-14 to fix the first screen not properly showing the right amount of BP cost.
    def pbChooseNumber(helptext, item, maximum)
      curnumber = 1
      ret = 0
      helpwindow = @sprites["helpwindow"]
      itemprice = @adapter.getPrice(item, @useBP)
      itemprice = 1 if itemprice < 1  # Ensure a minimum item price of 1BP
      pbDisplay(helptext, true)
      Kernel.tts(helptext, true)
      using(numwindow = Window_AdvancedTextPokemon.new("")) do   # Showing number of items
        pbPrepareWindow(numwindow)
        numwindow.viewport = @viewport
        numwindow.width = 224
        numwindow.height = 64
        numwindow.baseColor = Color.new(88, 88, 80)
        numwindow.shadowColor = Color.new(168, 184, 184)
        cash = @useBP ? "B" : "A"
        numwindow.text = _INTL("x{1}<r>{2} {3}P", curnumber, (curnumber * itemprice).to_s_formatted, cash)
        pbBottomRight(numwindow)
        numwindow.y -= helpwindow.height
        lastreadnum = nil
        loop do
          Graphics.update
          Input.update
          numwindow.update
          update
          oldnumber = curnumber
          if lastreadnum != curnumber
            lastreadnum = curnumber
            Kernel.tts("#{curnumber} for #{curnumber * itemprice} #{cash}P")
          end
          if Input.repeat?(Input::LEFT)
            curnumber -= 10
            curnumber = 1 if curnumber < 1
            if curnumber != oldnumber
              numwindow.text = _INTL("x{1}<r>{2} {3}P", curnumber, (curnumber * itemprice).to_s_formatted, cash)
              pbPlayCursorSE
            end
          elsif Input.repeat?(Input::RIGHT)
            curnumber += 10
            curnumber = maximum if curnumber > maximum
            if curnumber != oldnumber
              numwindow.text = _INTL("x{1}<r>{2} {3}P", curnumber, (curnumber * itemprice).to_s_formatted, cash)
              pbPlayCursorSE
            end
          elsif Input.repeat?(Input::UP)
            curnumber += 1
            curnumber = 1 if curnumber > maximum
            if curnumber != oldnumber
              numwindow.text = _INTL("x{1}<r>{2} {3}P", curnumber, (curnumber * itemprice).to_s_formatted, cash)
              pbPlayCursorSE
            end
          elsif Input.repeat?(Input::DOWN)
            curnumber -= 1
            curnumber = maximum if curnumber < 1
            if curnumber != oldnumber
              numwindow.text = _INTL("x{1}<r>{2} {3}P", curnumber, (curnumber * itemprice).to_s_formatted, cash)
              pbPlayCursorSE
            end
          elsif Input.trigger?(Input::USE)
            ret = curnumber
            break
          elsif Input.trigger?(Input::BACK)
            pbPlayCancelSE
            ret = 0
            break
          end
        end
      end
      helpwindow.visible = false
      return ret
    end

  def pbChooseItem
    itemwindow = @sprites["itemwindow"]
    @sprites["helpwindow"].visible = false
    pbActivateWindow(@sprites, "itemwindow") do
      pbRefresh
      lasreaditem = nil
      loop do
        Graphics.update
        Input.update
        curr_item = itemwindow.item
        if curr_item != lasreaditem
          lasreaditem = curr_item
          if itemwindow.item
            tts_itm = GameData::Item.get(itemwindow.item)
            itemprice = @adapter.getPrice(itemwindow.item, @useBP)
            Kernel.tts(tts_itm.real_name, true)
            Kernel.tts("#{itemprice} BP") if @useBP
            Kernel.tts("#{itemprice} AP") if !@useBP
            Kernel.tts(tts_itm.real_description)
          else
            cash = (@useBP) ? $player.battle_points : $Trainer.achievement_points[0]
            title = (@useBP) ? "Battle Points" : "Acheivement Points"
            Kernel.tts("You have #{cash} #{title}.", true)
            Kernel.tts("CANCEL: Quit Shopping")
          end
        end
        olditem = itemwindow.item
        self.update
        pbRefresh if itemwindow.item != olditem
        if Input.trigger?(Input::BACK)
          pbPlayCloseMenuSE
          return nil
        elsif Input.trigger?(Input::USE)
          if itemwindow.index < @stock.length
            pbRefresh
            return @stock[itemwindow.index]
          else
            return nil
          end
        end
      end
    end
  end
end

#===============================================================================
#
#===============================================================================
class BattlePointShopScreen
  def initialize(scene, stock, useBP)
    @useBP = useBP
    @scene = scene
    @stock = stock
    @adapter = BattlePointShopAdapter.new
  end
  
  def pbConfirm(msg)
    return @scene.pbConfirm(msg)
  end

  def pbDisplay(msg)
    return @scene.pbDisplay(msg)
  end

  def pbDisplayPaused(msg, &block)
    return @scene.pbDisplayPaused(msg, &block)
  end

  def pbBuyScreen
    @scene.pbStartScene(@stock, @adapter, @useBP)
    item = nil
    cash = @useBP ? "B" : "A"
    loop do
      item = @scene.pbChooseItem
      break if !item
      quantity       = 0
      itemname       = @adapter.getName(item)
      itemnameplural = @adapter.getNamePlural(item)
      price = @adapter.getPrice(item, @useBP)
      if @adapter.getBP(@useBP) < price
        cash = @useBP ? "B" : "A"
        pbDisplayPaused(_INTL("You don't have enough {1}P.", cash))
        next
      end
      if GameData::Item.get(item).is_important?
        next if !pbConfirm(_INTL("You would like the {1}?\nThat will be {2} {3}P.",
                                 itemname, price.to_s_formatted, cash))
        quantity = 1
      else
        maxafford = (price <= 0) ? Settings::BAG_MAX_PER_SLOT : @adapter.getBP(@useBP) / price
        maxafford = Settings::BAG_MAX_PER_SLOT if maxafford > Settings::BAG_MAX_PER_SLOT
        quantity = @scene.pbChooseNumber(
          _INTL("How many {1} would you like?", itemnameplural), item, maxafford
        )
        next if quantity == 0
        price *= quantity
        if quantity > 1
          next if !pbConfirm(_INTL("You would like {1} {2}?\nThey'll be {3} {4}P.",
                                   quantity, itemnameplural, price.to_s_formatted, cash))
        elsif quantity > 0
          next if !pbConfirm(_INTL("So you want {1} {2}?\nIt'll be {3} {4}P.",
                                   quantity, itemname, price.to_s_formatted, cash))
        end
      end
      if @adapter.getBP(@useBP) < price
        pbDisplayPaused(_INTL("I'm sorry, you don't have enough {1}P.", cash))
        next
      end
      added = 0
      quantity.times do
        break if !@adapter.addItem(item)
        added += 1
      end
      if added == quantity
        $stats.battle_points_spent += price
        $stats.mart_items_bought += quantity
        @adapter.setBP(@adapter.getBP(@useBP) - price, @useBP)
        @stock.delete_if { |itm| GameData::Item.get(itm).is_important? && $bag.has?(itm) }
        pbDisplayPaused(_INTL("Here you are! Thank you!")) { pbSEPlay("Mart buy item") }
      else
        added.times do
          if !@adapter.removeItem(item)
            raise _INTL("Failed to delete stored items")
          end
        end
        pbDisplayPaused(_INTL("You have no room in your Bag."))
      end
    end
    @scene.pbEndScene
  end
end

#===============================================================================
#
#===============================================================================
def pbBattlePointShop(stock, speech = nil, useBP = true, shop_id = 0)
  shop = (useBP) ? stock : stock[shop_id]
  shop.delete_if { |item| GameData::Item.get(item).is_important? && $bag.has?(item) }
  if speech.nil?
    pbMessage(_INTL("Welcome to the Time Warden's Armory.")) # Changed by Jos 2023-09-03 for message
#    pbMessage(_INTL("We can exchange your BP for rewards.")) # Changed by Jos 2023-09-03 for message
  else
    pbMessage(speech)
  end
  scene = BattlePointShop_Scene.new
  screen = BattlePointShopScreen.new(scene, shop, useBP)
  screen.pbBuyScreen
  cash = useBP ? "B" : "A"
  pbMessage(_INTL("Thank you for visiting. Please return when you have saved up more {1}P.",cash)) # Changed by Jos 2023-09-03 for message
#  pbMessage(_INTL("Please visit us again when you have saved up more BP."))
  $game_temp.clear_mart_prices
end

def pbCallAPShop(shop_id = 0)
  pbBattlePointShop(AP_SHOP_ITEMS,_INTL("Welcome to the AP Shop."),false,shop_id)
end

AP_SHOP_ITEMS = [
    # Shards - Shop 0
    [:HEARTSCALE,:RAIDBAIT,:BLUESHARD,:REDSHARD,:GREENSHARD,:YELLOWSHARD,:ORANGESHARD,:PURPLESHARD,:HPCRYSTAL1,:PPUP,:PPMAX],
    # Various Combat Items - Shop 1
    [:MUSCLEBAND,:WISEGLASSES,:BOOSTERENERGY,:EXPERTBELT,:SCOPELENS,:SAFETYGOGGLES,:FLAMEORB,:TOXICORB,:FROSTORB,:LEFTOVERS,:ROCKYHELMET,:HIVISJACKET,:HEAVYDUTYBOOTS,:UTILITYUMBRELLA,:LOADEDDICE,:BODYARMOR,:LIGHTCLAY,:TERRAINEXTENDER,:HEATROCK,:SMOOTHROCK,:ICYROCK,:DAMPROCK,:FOCUSSASH,:CHOICEBAND,:CHOICESPECS,:CHOICESCARF,:LIFEORB,:ASSAULTVEST,:ASSAULTARMOR,:EVIOLITE],
    # Cool Key Items - Shop 2
    [:BLACKMARKETTOKEN,:ITEMFINDER,:POKEMONBOXLINK,:INFINITEREPELTOGGLE,:SHINYTOKEN,:KARMATOKEN],
    # Cool Key Items - Shop 3
    [:MASTERBALL,:BLACKMARKETTOKEN,:ITEMFINDER,:POKEMONBOXLINK,:INFINITEREPELTOGGLE,:SHINYTOKEN,:KARMATOKEN],
    # Plates - Shop 4
    [:BLANKPLATE,:FLAMEPLATE,:SPLASHPLATE,:ZAPPLATE,:MEADOWPLATE,:ICICLEPLATE,:FISTPLATE,:TOXICPLATE,:EARTHPLATE,:SKYPLATE,:MINDPLATE,:INSECTPLATE,:STONEPLATE,:SPOOKYPLATE,:DRACOPLATE,:DREADPLATE,:IRONPLATE,:PIXIEPLATE,:STELLARPLATE,:HOLYPLATE,:RHYTHMPLATE],
    # Type Shields - Shop 5
    [:SHIELDNORMAL,:SHIELDFIRE,:SHIELDWATER,:SHIELDELECTRIC,:SHIELDGRASS,:SHIELDICE,:SHIELDFIGHTING,:SHIELDPOISON,:SHIELDGROUND,:SHIELDFLYING,:SHIELDPSYCHIC,:SHIELDBUG,:SHIELDROCK,:SHIELDGHOST,:SHIELDDRAGON,:SHIELDDARK,:SHIELDSTEEL,:SHIELDFAIRY,:SHIELDCOSMIC,:SHIELDLIGHT,:SHIELDSOUND,:SWORDNORMAL,:SWORDFIRE,:SWORDWATER,:SWORDELECTRIC,:SWORDGRASS,:SWORDICE,:SWORDFIGHTING,:SWORDPOISON,:SWORDGROUND,:SWORDFLYING,:SWORDPSYCHIC,:SWORDBUG,:SWORDROCK,:SWORDGHOST,:SWORDDRAGON,:SWORDDARK,:SWORDSTEEL,:SWORDFAIRY,:SWORDCOSMIC,:SWORDLIGHT,:SWORDSOUND],
    # Evolution Stones - Shop 6
    [:WINDSTONE,:MOONSTONE,:GEMSTONE,:LEAFSTONE,:ICESTONE,:ROYALSTONE,:FIRESTONE,:LINKSTONE,:IRONSTONE,:DUSKSTONE,:POWERSTONE,:SHINYSTONE,:WATERSTONE,:THUNDERSTONE,:NOXIOUSSTONE,:SANDSTONE,:SWARMSTONE,:SUNSTONE,:DAWNSTONE,:HUMMINGSTONE]
    ]

AP_SHOP_PRICE = [
    # Shards - Shop 0
    [:HEARTSCALE,1],[:RAIDBAIT,1],[:BLUESHARD,2],[:REDSHARD,2],[:GREENSHARD,2],[:YELLOWSHARD,2],[:ORANGESHARD,2],[:PURPLESHARD,2],[:HPCRYSTAL1,2],[:PPUP,3],[:PPMAX,8],
    # Various Combat Items - Shop 1
    [:MUSCLEBAND,5],[:WISEGLASSES,5],[:BOOSTERENERGY,5],[:EXPERTBELT,10],[:SCOPELENS,20],[:SAFETYGOGGLES,20],[:FLAMEORB,30],[:TOXICORB,30],[:FROSTORB,30],[:LEFTOVERS,30],[:ROCKYHELMET,30],[:HIVISJACKET,30],[:HEAVYDUTYBOOTS,30],[:UTILITYUMBRELLA,30],[:LOADEDDICE,40],[:BODYARMOR,40],[:LIGHTCLAY,40],[:TERRAINEXTENDER,40],[:HEATROCK,40],[:SMOOTHROCK,40],[:ICYROCK,40],[:DAMPROCK,40],[:FOCUSSASH,40],[:CHOICEBAND,50],[:CHOICESPECS,50],[:CHOICESCARF,50],[:LIFEORB,50],[:ASSAULTVEST,50],[:ASSAULTARMOR,50],[:EVIOLITE,50],
    # Cool Key Items - Shop 2
    [:BLACKMARKETTOKEN,5],[:ITEMFINDER,25],[:POKEMONBOXLINK,30],[:INFINITEREPELTOGGLE,50],[:SHINYTOKEN,50],[:KARMATOKEN,2],
    # Cool Key Items - Shop 3
    [:MASTERBALL,3],[:BLACKMARKETTOKEN,5],[:ITEMFINDER,25],[:POKEMONBOXLINK,30],[:INFINITEREPELTOGGLE,50],[:SHINYTOKEN,50],[:KARMATOKEN,2],
    # Plates - Shop 4
    [:BLANKPLATE,10],[:FLAMEPLATE,10],[:SPLASHPLATE,10],[:ZAPPLATE,10],[:MEADOWPLATE,10],[:ICICLEPLATE,10],[:FISTPLATE,10],[:TOXICPLATE,10],[:EARTHPLATE,10],[:SKYPLATE,10],[:MINDPLATE,10],[:INSECTPLATE,10],[:STONEPLATE,10],[:SPOOKYPLATE,10],[:DRACOPLATE,10],[:DREADPLATE,10],[:IRONPLATE,10],[:PIXIEPLATE,10],[:STELLARPLATE,10],[:HOLYPLATE,10],[:RHYTHMPLATE,10],
    # Shields - Shop 5
    [:SHIELDNORMAL,60],[:SHIELDFIRE,60],[:SHIELDWATER,60],[:SHIELDELECTRIC,60],[:SHIELDGRASS,60],[:SHIELDICE,60],[:SHIELDFIGHTING,60],[:SHIELDPOISON,60],[:SHIELDGROUND,60],[:SHIELDFLYING,60],[:SHIELDPSYCHIC,60],[:SHIELDBUG,60],[:SHIELDROCK,60],[:SHIELDGHOST,60],[:SHIELDDRAGON,60],[:SHIELDDARK,60],[:SHIELDSTEEL,60],[:SHIELDFAIRY,60],[:SHIELDCOSMIC,60],[:SHIELDLIGHT,60],[:SHIELDSOUND,60],[:SWORDNORMAL,60],[:SWORDFIRE,60],[:SWORDWATER,60],[:SWORDELECTRIC,60],[:SWORDGRASS,60],[:SWORDICE,60],[:SWORDFIGHTING,60],[:SWORDPOISON,60],[:SWORDGROUND,60],[:SWORDFLYING,60],[:SWORDPSYCHIC,60],[:SWORDBUG,60],[:SWORDROCK,60],[:SWORDGHOST,60],[:SWORDDRAGON,60],[:SWORDDARK,60],[:SWORDSTEEL,60],[:SWORDFAIRY,60],[:SWORDCOSMIC,60],[:SWORDLIGHT,60],[:SWORDSOUND,60],[:ATK_SWAPPER,60],[:DEF_SWAPPER,60],
    # Evolution Stones - Shop 6
    [:WINDSTONE,10],[:MOONSTONE,10],[:GEMSTONE,10],[:LEAFSTONE,10],[:ICESTONE,10],[:ROYALSTONE,10],[:FIRESTONE,10],[:LINKSTONE,10],[:IRONSTONE,10],[:DUSKSTONE,10],[:POWERSTONE,10],[:SHINYSTONE,10],[:WATERSTONE,10],[:THUNDERSTONE,10],[:NOXIOUSSTONE,10],[:SANDSTONE,10],[:SWARMSTONE,10],[:SUNSTONE,10],[:DAWNSTONE,10],[:HUMMINGSTONE,10]
    ]
    
#  SHOP ITEM = [[Shop0], [Shop1], [Shop2], [Shop3]]
#  SHOP PRICE + [[Items,Price],[Items,Price],[Items,Price]]