class PokemonBox_Scene
  def pbUpdate
    pbUpdateSpriteHash(@sprites)
  end

  def pbUpdateOverlay
    overlay = @sprites["overlay"].bitmap
    overlay.clear
    if @sortType!=nil
      typebitmap = AnimatedBitmap.new(_INTL("Graphics/Pictures/types"))
      type_number = GameData::Type.get(@sortType).icon_position
      type_rect = Rect.new(0, type_number * 28, 64, 28)
      overlay.blt(134, 346, typebitmap.bitmap, type_rect)
    end
    buttonbase = Color.new(248, 248, 248)
    buttonshadow = Color.new(80, 80, 80)
    setName = "Box #:" if @curbox == []
    if @index <= 29
      boxName = @curset[@index].name if @curbox == []
    else
      boxName = "None"
    end
    curSetName = (@curset == @set1) ? "1 - 30" : ((@curset == @set2) ? "31 - 60" : "61 - 90")
    setName = "Set Box:" if @curbox != []
    boxName = @curbox.name if @curbox != []
    hold_num = (@curset[@index] != nil) ? @curset[@index].nitems : 0
    pbDrawTextPositions(
      overlay,[
        [_INTL("Holds: {1}", hold_num), 4, 16, 0, buttonbase, buttonshadow, 1],
        [_INTL("Box Set"), 4, 142, 0, buttonbase, buttonshadow, 1],
        [_INTL("{1}", (curSetName)), 4, 170, 0, buttonbase, buttonshadow, 1],
        [_INTL("{1}", (setName rescue "None")), 4, 314, 0, buttonbase, buttonshadow, 1],
        [_INTL("{1}", (boxName rescue "None")), 4, 350, 0, buttonbase, buttonshadow, 1]
      ]
    )
    boxSet1Name = "Box 1-30"
    boxSet2Name = ($PokemonStorage.boxes.length > 30) ? "Box 31-60" : "Locked"
    boxSet3Name = ($PokemonStorage.boxes.length > 60) ? "Box 61-90" : "Locked"
    textName1 = (@curset == @set1) ? boxSet3Name : ((@curset == @set2) ? boxSet1Name : boxSet2Name)
    textName2 = (@curset == @set1) ? boxSet2Name : ((@curset == @set2) ? boxSet3Name : boxSet1Name)
    pbDrawTextPositions(
      overlay,[
        [_INTL("{1}", textName1), 280, 346, 2, buttonbase, buttonshadow, 1],
        [_INTL("{1}", textName2), 412, 346, 2, buttonbase, buttonshadow, 1]
      ]
    )
    @curset.length.times do |i|
      # Box Icons ###############################################################################
      box = 0 if @curset == @set1
      box = 30 if @curset == @set2
      box = 60 if @curset == @set3
      sorting = (@sortType != nil) ? true : ((@sortSpecies != nil) ? true : ((@sortItems != nil) ? true : ((@sortShiny != nil) ? true : false)))
      if sorting
        if @sortArray[i+box] == true 
          path = "Graphics/Pictures/Storage/box_hosts_sort"
          path = "Graphics/Pictures/Storage/box_filled_sort" if @curset[i].full?
          @sprites["boxes_#{i}"].setBitmap(path)
        else
          path = "Graphics/Pictures/Storage/box_hosts"
          path = "Graphics/Pictures/Storage/box_filled" if @curset[i].full?
          path = "Graphics/Pictures/Storage/box_empty" if @curset[i].empty?
          @sprites["boxes_#{i}"].setBitmap(path)
        end
      else
        path = "Graphics/Pictures/Storage/box_hosts"
        path = "Graphics/Pictures/Storage/box_filled" if @curset[i].full?
        path = "Graphics/Pictures/Storage/box_empty" if @curset[i].empty?
        @sprites["boxes_#{i}"].setBitmap(path)
      end
      # Ball Icons ##############################################################################
      @sprites["bicon_#{i}"].setBitmap("Graphics/Pictures/Storage/slot_empty")
      @sprites["bicon_#{i}"].tone = Tone.new(0,0,0,0)
      if @index <= 29
        mon = @curset[@index][i]
        if mon != nil
          @sprites["bicon_#{i}"].setBitmap("Graphics/Pictures/Storage/slot_filled")
          @sprites["bicon_#{i}"].tone = Tone.new(0,255,0,255) if mon.types.include?(@sortType)
          @sprites["bicon_#{i}"].tone = Tone.new(255,0,255,255) if mon.species == @sortSpecies
          @sprites["bicon_#{i}"].tone = Tone.new(0,0,255,255) if mon.hasItem? == @sortItems
          @sprites["bicon_#{i}"].tone = Tone.new(255,255,0,255) if mon.shiny? == @sortShiny
        end
      end
    end  
  end

  def pbSortBoxes(idx)
   setVal = @curset
   if idx <=29
    val = (@curset==@set1) ? 1 : ((@curset==@set2) ? 2 : 3)
    if @curset==@set2
     idx += 30
    elsif @curset==@set3
     idx += 60
    end
    for i in 0...30
     tempbox1 = $PokemonStorage.boxes[idx][i]
     tempbox2 = $PokemonStorage.boxes[@boxID][i]
     $PokemonStorage.boxes[idx][i] = tempbox2
     $PokemonStorage.boxes[@boxID][i] = tempbox1
    end
    boxName1 = $PokemonStorage.boxes[idx]
    boxName2 = $PokemonStorage.boxes[@boxID]
    pbMessage(_INTL("The Pokemon in Box '{1}' has been swapped with Box '{2}'" , boxName2.name ,boxName1.name))
    @curbox = []
    @boxID  = 0
    pbReloadCurBox(val)
    @lastMenu.pbHardRefresh
    pbUpdateOverlay
   elsif idx >=30 && $PokemonStorage.boxes.length >= 60
     for i in 0...30
       if @curbox[i]!=nil
        dexnum = pbGetRegionalNumber(0, @curbox[i].species)
        boxNum = dexnum/30
        slotNum = dexnum - (boxNum*30)
        if slotNum==0
          boxNum -= 1
          slotNum = 30
        end
        if setVal == @set1
          boxNum += 60 if idx == 30
          boxNum += 30 if idx == 31
        elsif setVal == @set2
          boxNum += 0 if idx == 30
          boxNum += 60 if idx == 31
        elsif setVal == @set3
          boxNum += 30 if idx == 30
          boxNum += 0 if idx == 31
        end
        if boxNum>=$PokemonStorage.boxes.length
          boxNum -= $PokemonStorage.boxes.length
        end
        if $PokemonStorage.boxes[boxNum][slotNum-1] == nil
          $PokemonStorage.pbMove(boxNum, slotNum-1, @boxID, i)
        end
       end
     end
     pbMessage("Pokemon have been sorted by National dex Number")
     @curbox = []
   else
     pbMessage("National Dex Sorting Locked, releasing set box.")
     @curbox = []
   end
  end

  def pbSetBox(index)
    if @curset == @set1 && index != -1
     @curbox = @set1[index]
     @boxID = index
    pbMessage(_INTL("{1} has been set", @curbox.name))
    elsif @curset == @set2 && index != -1
     @curbox = @set2[index]
     @boxID = index+30
    pbMessage(_INTL("{1} has been set", @curbox.name))
    elsif @curset == @set3 && index != -1
     @curbox = @set3[index]
     @boxID = index+60
    pbMessage(_INTL("{1} has been set", @curbox.name))
    elsif index == -1
    pbMessage(_INTL("{1} has been unset", @curbox.name))
     @curbox = []
     @boxID  = 0
    end
  end

  def pbSwapSets(idx)
    curVal = @curset
    boxes = $PokemonStorage.boxes
    if boxes.length == 30 
      pbMessage("Function Locked, Unlock more Boxes.")
      pbUpdateOverlay
    elsif boxes.length == 60 # Changed by Jos 2023-10-23 based on PDM20's instructions
      if idx==30
        @curset = @set1 if curVal == @set2
        @curset = @set2 if curVal == @set1
      elsif idx==31
        @curset = @set1 if curVal == @set2
        @curset = @set2 if curVal == @set1
      end
      pbUpdateOverlay
    elsif boxes.length == 90
      if idx==30
        @curset = @set1 if curVal == @set2
        @curset = @set2 if curVal == @set3
        @curset = @set3 if curVal == @set1
      elsif idx==31
        @curset = @set1 if curVal == @set3
        @curset = @set2 if curVal == @set1
        @curset = @set3 if curVal == @set2
      end
      pbUpdateOverlay
    end
  end

  def pbSwapBoxes(index)
    val = (@curset==@set1) ? 1 : ((@curset==@set2) ? 2 : 3)
    if @curset==@set2
     index += 30
    elsif @curset==@set3
     index += 60
    end
    tempbox1 = $PokemonStorage.boxes[index]
    tempbox2 = $PokemonStorage.boxes[@boxID]
    $PokemonStorage.boxes[index] = tempbox2
    $PokemonStorage.boxes[@boxID] = tempbox1
    pbMessage(_INTL("Box '{1}' has been swapped with Box '{2}'" , tempbox2.name ,tempbox1.name))
    @curbox = []
    @boxID  = 0
    pbReloadCurBox(val)
    @lastMenu.pbHardRefresh
    pbUpdateOverlay
  end

  def pbMoveCursor
    arrow = @sprites["boxArrow"]
    case @index
    when 30
      arrow.x = 248
      arrow.y = 288
    when 31
      arrow.x = 380
      arrow.y = 288
    else
      arrow.x = (116 + 66 * (@index % 6))
      arrow.y = (-26 + 66 * (@index / 6))
    end
    @sprites["boxArrow"] = arrow
  end

  def pbReloadCurBox(idx)
    boxes      = $PokemonStorage.boxes
    @curset    = []
    @set1      = []
    @set2      = []
    @set3      = []
    for i in 0...30
     @set1[i] = boxes[i]
     @set2[i] = boxes[i+30]
     @set3[i] = boxes[i+60]
    end
    @curset = (idx==1) ? @set1 : ((idx==2) ? @set2 : @set3)
  end

  def pbStartScene(boxVal, lastMenu)
    box_val = $PokemonStorage.boxes.length
    boxes   = $PokemonStorage.boxes
    sys     = $PokemonStorage
    $PokemonStorage.sortType    = nil
    $PokemonStorage.sortSpecies = nil
    $PokemonStorage.sortItems   = nil
    $PokemonStorage.sortShiny   = nil
    @sortType     = $PokemonStorage.sortType
    @sortSpecies  = $PokemonStorage.sortSpecies
    @sortItems    = $PokemonStorage.sortItems
    @sortShiny    = $PokemonStorage.sortShiny
    @lastMenu     = lastMenu
    @index        = (boxVal<=29) ? boxVal : ((boxVal>=60) ? boxVal-60 : boxVal-30)
    @boxID        = 0
    @curbox       = []
    @curset       = []
    @set1         = []
    @set2         = []
    @set3         = []
    @sortArray    = []
    @endScene     = false
    if((box_val >= 59 && box_val <= 88) && $player.pokedex.seen_count>=1000)
      pbMessage("Congratulations, you have seen most of the Orion Dex, as such we have Added 30 extra Storage Boxes!")
      pbMessage("For reaching this milestone, we have also unlocked extra Wallpaper.")
      sys.pbUnlockBox(30)
      for i in 0...$PokemonStorage.allWallpapers.length
        pbUnlockWallpaper(i)
      end
    end
    for i in 0...30
      @set1[i] = boxes[i]
      @set2[i] = boxes[i+30]
      @set3[i] = boxes[i+60]
      @sortArray[i] = false
      @sortArray[i+30] = false
      @sortArray[i+60] = false
    end
    @curset = (boxVal<=29) ? @set1 : ((boxVal>=60) ? @set3 : @set2)
    @sprites = {}
    @bgviewport = Viewport.new(0,0,Graphics.width,Graphics.height)
    @bgviewport.z = 99999
    @pannelviewport = Viewport.new(0,0,Graphics.width,Graphics.height)
    @pannelviewport.z = 99999
    @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z = 99999
    addBackgroundPlane(@sprites,"background","Storage/background",@bgviewport)
    @sprites["pannel"] = IconSprite.new(0,0,@pannelviewport)
    @sprites["pannel"].setBitmap("Graphics/Pictures/Storage/overlay_boxes")
    @sprites["boxArrow"] = PokemonBoxArrow.new(@viewport)
    @sprites["boxArrow"].x = 116
    @sprites["boxArrow"].y = -26
    @sprites["boxArrow"].z = 99999 + 10
    @curset.length.times do |i|
    @sprites["boxes_#{i}"] = IconSprite.new(0,0,@viewport)
    box = 0 if @curset == @set1
    box = 30 if @curset == @set2
    box = 60 if @curset == @set3
    if @sortTpe != nil
      if @sortArray[i+box] == true 
        @sprites["boxes_#{i}"].setBitmap("Graphics/Pictures/Storage/box_hosts_sort")
        @sprites["boxes_#{i}"].setBitmap("Graphics/Pictures/Storage/box_filled_sort") if @curset[i].full?
      else
        @sprites["boxes_#{i}"].setBitmap("Graphics/Pictures/Storage/box_hosts")
        @sprites["boxes_#{i}"].setBitmap("Graphics/Pictures/Storage/box_empty") if @curset[i].empty?
        @sprites["boxes_#{i}"].setBitmap("Graphics/Pictures/Storage/box_filled") if @curset[i].full?
      end
    else
      @sprites["boxes_#{i}"].setBitmap("Graphics/Pictures/Storage/box_hosts")
      @sprites["boxes_#{i}"].setBitmap("Graphics/Pictures/Storage/box_empty") if @curset[i].empty?
      @sprites["boxes_#{i}"].setBitmap("Graphics/Pictures/Storage/box_filled") if @curset[i].full?
    end
      @sprites["boxes_#{i}"].x = 116 + 66*(i%6)
      @sprites["boxes_#{i}"].y = 6 + 66*(i/6)
      @sprites["boxes_#{i}"].z = 99999
    end
    30.times do |i|
      @sprites["bicon_#{i}"] = IconSprite.new(0,0,@viewport)
      @sprites["bicon_#{i}"].setBitmap("Graphics/Pictures/Storage/slot_empty")
      @sprites["bicon_#{i}"].setBitmap("Graphics/Pictures/Storage/slot_filled") if @curset[@index][i] != nil
      @sprites["bicon_#{i}"].x = 6 + 15*(i%6)
      @sprites["bicon_#{i}"].y = 50 + 15*(i/6)
      @sprites["bicon_#{i}"].z = 99999
    end
    ## Pokemon Data ##
    @sprites["overlay"] = BitmapSprite.new(Graphics.width,Graphics.height,@pannelviewport)
    pbSetSystemFont(@sprites["overlay"].bitmap)
    pbMoveCursor
    pbUpdateOverlay
    pbFadeInAndShow(@sprites) { pbUpdate }
  end
end

def pbSearchSubMenu(menu = true)
  pbPlayDecisionSE
  cmd = 0
  list_commands = [_INTL("Search for Type"),
                   _INTL("Search for Species (Alphabetically)"),
                   _INTL("Search for Species (Box Order)"),
                   _INTL("Search for Held Items"),
                   _INTL("Search for Shinies"),
                   _INTL("Cancel")]
  cmd = pbMessage(_INTL("Select an Action"),list_commands, -1, nil, cmd)
  case cmd
    when 0; pbSortType(menu)
    when 1; pbSearchSpecies(@lastMenu,true,menu)
    when 2; pbSearchSpecies(@lastMenu,false,menu)
    when 3; pbSortItem(menu)
    when 4; pbSortShiny(menu)
  end
end

def pbMenu
  key = @index
  val = key
  if Input.trigger?(Input::UP)
    case key
      when 30;    val = 26
      when 31;    val = 28
      when 0,1,2; val = 30
      when 3,4,5; val = 31
      else;       val -= 6
    end
  elsif Input.trigger?(Input::DOWN)   
    case key
      when 30;       val = 1
      when 31;       val = 3
      when 24,25,26; val = 30
      when 27,28,29; val = 31
      else;          val += 6
    end
  elsif Input.trigger?(Input::LEFT)
    case key
      when 0,6,12,18,24; val +=5
      when 30;           val = 31
      when 31;           val = 30
      else;              val -= 1
	end
  elsif Input.trigger?(Input::RIGHT)
    case key
      when 5,11,17,23,29; val -= 5
      when 30;            val = 31
      when 31;            val = 30
      else;               val += 1
	end
  end
  if Input.trigger?(Input::JUMPUP)
     pbPlayDecisionSE
     pbSwapSets(30)
  elsif Input.trigger?(Input::JUMPDOWN)
     pbPlayDecisionSE
     pbSwapSets(31)
  elsif Input.trigger?(Input::SPECIAL)
    pbSearchSubMenu
  elsif Input.trigger?(Input::ACTION) # Selecting a Box
    if @curbox == [] && @index < 30
      pbSetBox(@index)
    elsif @curbox != []
      pbSortBoxes(@index)
    else
      pbMessage("No box has been set, Set a box before tying this action.")
    end
  elsif Input.trigger?(Input::USE) && @index >=30 # Selecting a Box
    pbPlayDecisionSE
    pbSwapSets(@index)
  elsif Input.trigger?(Input::USE) && @index <=29 && @curbox == [] # Selecting a Box
    pbPlayDecisionSE
    idx = (@curset == @set1) ? @index : ((@curset == @set2) ? @index + 30 : @index + 60)
    $PokemonStorage.currentBox = idx
    @lastMenu.pbHardRefresh
    @endScene = true
  elsif Input.trigger?(Input::USE) && @index <=29 && @curbox != [] # Selecting a Box
    index          = 0
    helptext       = nil
    cmdSwapBox     = -1
    cmdJumpBox     = -1
    cmdRemove      = -1
    cmdExit        = -1
    commands       = []
    commands[cmdSwapBox = commands.length] = _INTL("Swap with Set Box")
    commands[cmdJumpBox = commands.length] = _INTL("Jump to Box") if $game_temp.in_storage
    commands[cmdRemove = commands.length]  = _INTL("Unset Box")
    commands[commands.length]              = _INTL("Cancel")
    userMenuChoice = pbShowCommands(helptext,commands,commands.length)
    if userMenuChoice == cmdSwapBox
      pbPlayDecisionSE
      pbSwapBoxes(@index)
    elsif userMenuChoice == cmdJumpBox
      idx = (@curset == @set1) ? @index : ((@curset == @set2) ? @index + 30 : @index + 60)
      $PokemonStorage.currentBox = idx
      @lastMenu.pbHardRefresh
      @endScene = true
    elsif userMenuChoice == cmdRemove # Select a Box
      pbPlayDecisionSE
      pbSetBox(-1)
    end
  end
  pbUpdateOverlay
  @index = val
end

def pbSelector
  loop do
    240.times {
      Graphics.update
      Input.update
      pbUpdate
      pbMenu
      pbMoveCursor
      break if Input.trigger?(Input::BACK) || @endScene == true
    }
    break if Input.trigger?(Input::BACK) || @endScene == true
  end
end

def pbEndScene
  pbFadeOutAndHide(@sprites) { pbUpdate }
  pbDisposeSpriteHash(@sprites)
  pbRefreshSceneMap
  @viewport.dispose
end

def pbSortItem(menu = true)
  command = 0
  command = pbMessage(_INTL("Search for Pokemon that has an Item?"),[
  _INTL("Has Item"),
  _INTL("No Item"),
  _INTL("Cancel")], -1, nil, command)
  case command
    when 0
      @sortSpecies = nil
      @sortType = nil
      @sortShiny = nil
      $PokemonStorage.sortSpecies = nil
      $PokemonStorage.sortType = nil
      $PokemonStorage.sortShiny = nil
      @sortItems = true
      $PokemonStorage.sortItems = true
      @lastMenu.pbHardRefresh if menu
      pbBoxIconSetUp(true, 2) if menu
      pbMessage(_INTL("Highlighting pokemon with a held item"))
    when 1
      @sortItems = false
      $PokemonStorage.sortItems = false
      @lastMenu.pbHardRefresh if menu
      pbBoxIconSetUp(true, 2) if menu
      pbMessage("Highlighting pokemon without a held item")
    when -1, 2
      @sortItems = nil
      $PokemonStorage.sortItems = nil
      @lastMenu.pbHardRefresh if menu
      pbBoxIconSetUp(false, 2) if menu
      pbMessage("Removing Highlight from pokemon")
  end
end

def pbSortShiny(menu = true)
  command = 0
  command = pbMessage(_INTL("Search for Pokemon that is Shiny?"),[
  _INTL("Is Shiny"),
  _INTL("Not SHiny"),
  _INTL("Cancel")], -1, nil, command)
  case command
    when 0
      @sortSpecies = nil
      @sortType = nil
      @sortItems = nil
      $PokemonStorage.sortSpecies = nil
      $PokemonStorage.sortType = nil
      $PokemonStorage.sortItems = nil
      @sortShiny = true
      $PokemonStorage.sortShiny = true
      @lastMenu.pbHardRefresh if menu
      pbBoxIconSetUp(true, 3) if menu
      pbMessage(_INTL("Highlighting pokemon that are Shiny"))
    when 1
      @sortShiny = false
      $PokemonStorage.sortShiny = false
      @lastMenu.pbHardRefresh if menu
      pbBoxIconSetUp(true, 3) if menu
      pbMessage("Highlighting pokemon that aren't Shiny")
    when -1, 2
      @sortShiny = nil
      $PokemonStorage.sortShiny = nil
      @lastMenu.pbHardRefresh if menu
      pbBoxIconSetUp(false, 3) if menu
      pbMessage("Removing Highlight from pokemon")
  end
end

def pbSortType(menu = true)
  command = 0
  typeName = ["Normal","Fighting","Flying","Poison","Ground","Rock","Bug","Ghost","Steel","Fire","Water","Grass","Electric","Psychic","Ice","Dragon","Dark","Fairy","Cosmic","Sound","Light"]
  typeID = [:NORMAL,:FIGHTING,:FLYING,:POISON,:GROUND,:ROCK,:BUG,:GHOST,:STEEL,:FIRE,:WATER,:GRASS,:ELECTRIC,:PSYCHIC,:ICE,:DRAGON,:DARK,:FAIRY,:COSMIC,:SOUND,:LIGHT]
  command = pbMessage(_INTL("Select a Type to filter"),[_INTL("Normal"), _INTL("Fighting"), _INTL("Flying"), _INTL("Poison"), _INTL("Ground"), _INTL("Rock"), _INTL("Bug"), _INTL("Ghost"), _INTL("Steel"), _INTL("Fire"), _INTL("Water"), _INTL("Grass"), _INTL("Electric"), _INTL("Psychic"), _INTL("Ice"), _INTL("Dragon"), _INTL("Dark"), _INTL("Fairy"), _INTL("Cosmic"), _INTL("Sound"), _INTL("Light"), _INTL("No Type")], -1, nil, command)
  val = command if (command >=0 && command != 21)
  case command
    when val
      if (val <=20 && val >=0)
        @sortSpecies = nil
        @sortItems = nil
        @sortShiny = nil
        $PokemonStorage.sortSpecies = nil
        $PokemonStorage.sortItems = nil
        $PokemonStorage.sortShiny = nil
        @sortType = typeID[command]
        $PokemonStorage.sortType = typeID[command]
        @lastMenu.pbHardRefresh if menu
        pbBoxIconSetUp(true, 0) if menu
        pbMessage(_INTL("Highlighting pokemon with the {1} type",typeName[command]))
      else
        @sortType = nil
        $PokemonStorage.sortType = nil
        @lastMenu.pbHardRefresh if menu
        pbBoxIconSetUp(false, 0) if menu
        pbMessage("Removing Highlight from pokemon")
      end
    else
      @sortType = nil
      $PokemonStorage.sortType = nil
      @lastMenu.pbHardRefresh if menu
      pbBoxIconSetUp(false, 0) if menu
      pbMessage("Removing Highlight from pokemon")
  end
end

def pbSearchSpecies(scene, order = false, menu = true)
  boxes = $PokemonStorage.boxes
  command = 0
  mon_Name = []
  mon_data = []
  for b in 0...boxes.length
    for m in 0...30
      if boxes[b][m] != nil
        mon = boxes[b][m]
        mon_data = [mon.species, b, m, mon.name]
        mon_Name.push(mon_data)
      end
    end
  end
  mon_Info = []
  if order
    mon_Name.sort!
  end
  for i in 0...mon_Name.length
   msg = _INTL("{1} is located in Box {2}", mon_Name[i][3],  (mon_Name[i][1]+1), mon_Name[i][2])
   mon_Info.push(msg)
  end
  mon_Info.push(_INTL("Cancel"))
  command = pbMessage(_INTL("Select a Pokemon to Search"),mon_Info, -1, nil, command)
  case command
    when -1, mon_Name.length
      @sortSpecies = nil
      $PokemonStorage.sortSpecies = nil
      scene.pbHardRefresh if menu
      if scene == @lastMenu
        pbBoxIconSetUp(false, 1) if menu
      end
      pbMessage("Removing Highlight from pokemon")
    else
      @sortType = nil
      @sortItems = nil
      @sortShiny = nil
      $PokemonStorage.sortType = nil
      $PokemonStorage.sortItems = nil
      $PokemonStorage.sortShiny = nil
      species_data = GameData::Species.get(mon_Name[command][0])
      species_Name = species_data.name
      @sortSpecies = mon_Name[command][0]
      $PokemonStorage.sortSpecies = mon_Name[command][0]
      scene.pbHardRefresh if menu
      if scene == @lastMenu
        pbBoxIconSetUp(true, 1) if menu
      end
      pbMessage(_INTL("Searching for {1}", species_Name))
  end
end

def pbBoxIconSetUp(sort, sel = 0)
  boxes = $PokemonStorage.boxes
  if sort
    for b in 0...boxes.length
      @sortArray[b] = false
      for m in 0...30
        if boxes[b][m] != nil
          mon = boxes[b][m]
          sortSel = mon.types.include?(@sortType) if sel == 0
          sortSel = (mon.species == @sortSpecies) if sel == 1
          sortSel = (mon.hasItem? == @sortItems) if sel == 2
          sortSel = (mon.shiny? == @sortShiny) if sel == 3
          @sortArray[b] = true if sortSel
        end
      end
    end
  else
    for i in 0...boxes.length
      @sortArray[i] = false
    end
  end
end

class PokemonBox_Screen
  def initialize(scene)
    @scene = scene
    pbPlayDecisionSE
  end

  def pbStartScreen(boxVal, lastMenu)
    pbFadeOutIn do
      @scene.pbStartScene(boxVal, lastMenu)
      @scene.pbSelector
      @scene.pbEndScene
    end
  end
end

def pbBoxOrganizer(boxVal, lastMenu)
  setUpSorting
  pbFadeOutIn do
    scene = PokemonBox_Scene.new
    screen = PokemonBox_Screen.new(scene)
    screen.pbStartScreen(boxVal, lastMenu)
  end
end

#===============================================================================
# Pokémon icons
#===============================================================================
class PokemonBoxIcon < IconSprite
  def update
    super
    @release.update
    self.color = Color.new(0, 0, 0, 0)
     if @pokemon != nil && $PokemonStorage.sortType != nil
       self.tone = Tone.new(255,0,0,255) if !@pokemon.types.include?($PokemonStorage.sortType)

     elsif @pokemon != nil && $PokemonStorage.sortSpecies != nil
       self.tone = Tone.new(0,255,0,255) if @pokemon.species == $PokemonStorage.sortSpecies

     elsif @pokemon != nil && $PokemonStorage.sortItems != nil
       self.tone = Tone.new(0,0,255,255) if @pokemon.hasItem? == $PokemonStorage.sortItems

     elsif @pokemon != nil && $PokemonStorage.sortShiny != nil
       self.tone = Tone.new(255,255,0,255) if @pokemon.shiny? == $PokemonStorage.sortShiny

     elsif @pokemon != nil && ($PokemonStorage.sortType == nil || $PokemonStorage.sortSpecies == nil || $PokemonStorage.sortItems == nil || $PokemonStorage.sortShiny == nil)
       self.tone = Tone.new(0,0,0,0)

     else
       self.tone = Tone.new(0,0,0,0)
     end
    dispose if @startRelease && !releasing?
  end
end

class PokemonStorage
  attr_accessor :sortType
  attr_accessor :sortSpecies
  attr_accessor :sortItems
  attr_accessor :sortShiny
  
  alias multibox_initialize initialize
  def initialize(maxBoxes = Settings::NUM_STORAGE_BOXES, maxPokemon = PokemonBox::BOX_SIZE)
    multibox_initialize(maxBoxes = Settings::NUM_STORAGE_BOXES, maxPokemon = PokemonBox::BOX_SIZE)
    @sortType    = nil
    @sortSpecies = nil
    @sortItems   = nil
    @sortShiny   = nil
  end

  def resetSorting
    if @sortType == nil
      @sortType = nil
    end
    if @sortSpecies == nil
      @sortSpecies = nil
    end
    if @sortItems == nil
      @sortItems = nil
    end
    if @sortShiny == nil
      @sortShiny = nil
    end
  end

  def sortType=(value)
    @sortType = value
  end 

  def sortType
    return @sortType
  end

  def sortSpecies=(value)
    @sortSpecies = value
  end 

  def sortSpecies
    return @sortSpecies
  end

  def sortItems=(value)
    @sortItems = value
  end 

  def sortItems
    return @sortItems
  end

  def sortShiny=(value)
    @sortShiny = value
  end 

  def sortShiny
    return @sortShiny
  end
end

def setUpSorting
  $PokemonStorage.resetSorting
end
