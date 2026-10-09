class Bitmap
  attr_accessor :storedPath
end

class Battle::Scene::PokemonDataBox < SpriteWrapper
  def initializeOtherGraphics(viewport)
    # Create other bitmaps
    @statBoostsToggle = false
    @numbersBitmap = AnimatedBitmap.new(_INTL("Graphics/Pictures/Battle/icon_numbers"))
    @hpBarBitmap   = AnimatedBitmap.new(_INTL("Graphics/Pictures/Battle/overlay_hp"))
    @expBarBitmap  = AnimatedBitmap.new(_INTL("Graphics/Pictures/Battle/overlay_exp"))
    @sprites["Atk"]  = Sprite.new(viewport)
    @sprites["Def"]  = Sprite.new(viewport)
    @sprites["SpAtk"]  = Sprite.new(viewport)
    @sprites["SpDef"]  = Sprite.new(viewport)
    @sprites["Spe"]  = Sprite.new(viewport)
    @sprites["Eva"]  = Sprite.new(viewport)
    @sprites["Acc"]  = Sprite.new(viewport)
    @sprites["Atk"].visible = false
    @sprites["Def"].visible = false
    @sprites["SpAtk"].visible = false
    @sprites["SpDef"].visible = false
    @sprites["Spe"].visible = false
    @sprites["Eva"].visible = false
    @sprites["Acc"].visible = false
    @sprites["Atk"].z = 199 # Changed by Jos 2022-10-30 to allow Essentials Deluxe UI to supercede the views
    @sprites["Def"].z = 199 # AND Changed by DemICE 02-Oct-2023 to make the boosts not show above the text windows
    @sprites["SpAtk"].z = 199
    @sprites["SpDef"].z = 199
    @sprites["Spe"].z = 199
    @sprites["Eva"].z = 199
    @sprites["Acc"].z = 199
    # Trapstarr's Type Display  # Changed by DemICE 16-Oct-2023 Trapstarr gave me his type icon display script.
    # case $PokemonSystem.typedisplay
    # when 1
    #   @typeDisplayBitmap = AnimatedBitmap.new(_INTL("Graphics/Pictures/TypeIcons_Lolpy1"))
    # when 2
    #   @typeDisplayBitmap = AnimatedBitmap.new(_INTL("Graphics/Pictures/TypeIcons_TCG"))
    # when 3
      @typeDisplayBitmap = AnimatedBitmap.new(_INTL("Graphics/Pictures/Battle/TypeIcons_Square"))
    # when 4
    #   @typeDisplayBitmap = AnimatedBitmap.new(_INTL("Graphics/Pictures/types_display"))
    # end
    # Create sprite to draw HP numbers on
    @hpNumbers = BitmapSprite.new(124, 16, viewport)
  #    pbSetSmallFont(@hpNumbers.bitmap)
    @sprites["hpNumbers"] = @hpNumbers
    # Create sprite wrapper that displays HP bar
    @hpBar = SpriteWrapper.new(viewport)
    @hpBar.bitmap = @hpBarBitmap.bitmap
    @hpBar.src_rect.height = @hpBarBitmap.height / 3
    @sprites["hpBar"] = @hpBar
    # Create sprite wrapper that displays Exp bar
    @expBar = SpriteWrapper.new(viewport)
    @expBar.bitmap = @expBarBitmap.bitmap
    @sprites["expBar"] = @expBar
    # Changed by DemICE 16-Oct-2023 Trapstarr gave me his type icon display script.
    # Trapstarr's Type Display: Create a sprite wrapper that displays Opponents Type
    typeDisplayBitmap = Bitmap.new(Graphics.width, Graphics.height)  
    @typeDisplay = SpriteWrapper.new(viewport)  
    @typeDisplay.bitmap = typeDisplayBitmap  
    @sprites["typeDisplay"] = @typeDisplay
    @sprites["typeDisplay"].z = 198
    # Create sprite wrapper that displays everything except the above
    @contents = BitmapWrapper.new(@databoxBitmap.width, @databoxBitmap.height)
    self.bitmap  = @contents
    self.visible = false
    self.z       = 150 + ((@battler.index / 2) * 5)
    pbSetSystemFont(self.bitmap)
  end

  def pbBitmap(name)
    begin
      dir = name.split("/")[0...-1].join("/") + "/"
      file = name.split("/")[-1]
      bmp = RPG::Cache.load_bitmap(dir, file)
      bmp.storedPath = name
    rescue
      Console.echo _INTL("Image located at '#{name}' was not found!")
      bmp = Bitmap.new(2,2)
    end
    return bmp
  end

  #-----------------------------------------------------------------------------
  # Toggles the visibility of the Move Info UI.
  #-----------------------------------------------------------------------------
  def pbToggleStatBoosts
    update
    #pbUpdateMoveInfoWindow(battler, index)
  end

  def draw_pinch
    return if @battler.hp >= (@battler.totalhp / 3)
    return if ![:BLAZE, :TORRENT, :OVERGROW, :SWARM, :STARSTRUCK, :IRRADIATE, :MAESTRO, :SPELLCASTER].include?(@battler.ability.id)
    pbDrawImagePositions(self.bitmap, [["Graphics/Pictures/Battle/icon_pinch", @spriteBaseX - 24, 36, 0, 0, -1, 16]])
  end

  def refresh
    self.bitmap.clear
    return if !@battler.pokemon
    textPos = []
    imagePos = []
    stat_boost = []
    $stages = stat_boost
    # Draw background panel
    self.bitmap.blt(0, 0, @databoxBitmap.bitmap, Rect.new(0, 0, @databoxBitmap.width, @databoxBitmap.height))
    # Draw Pokémon's name
    nameWidth = self.bitmap.text_size(@battler.name).width
    nameOffset = 0
    nameOffset = nameWidth - 116 if nameWidth > 116
    textPos.push([@battler.name, @spriteBaseX + 8 - nameOffset, 12, false, NAME_BASE_COLOR, NAME_SHADOW_COLOR])
    # Draw Pokémon's gender symbol
    case @battler.displayGender
    when 0   # Male
      textPos.push([_INTL("♂"), @spriteBaseX + 126, 12, false, MALE_BASE_COLOR, MALE_SHADOW_COLOR])
    when 1   # Female
      textPos.push([_INTL("♀"), @spriteBaseX + 126, 12, false, FEMALE_BASE_COLOR, FEMALE_SHADOW_COLOR])
    end
    pbDrawTextPositions(self.bitmap, textPos)
    # Draw Pokémon's level
    imagePos.push(["Graphics/Pictures/Battle/overlay_lv", @spriteBaseX + 140, 16])
    pbDrawNumber(@battler.level, self.bitmap, @spriteBaseX + 162, 16)
    # Draw shiny icon
    if @battler.shiny?
      shinyX = (@battler.opposes?(0)) ? 199 : -6   # Foe's/player's # Changed by Jos 2023-10-21 to adjust the position of shiny star.
      imagePos.push(["Graphics/Pictures/shiny", @spriteBaseX + shinyX, 36])
    end
    # Draw Mega Evolution/Primal Reversion icon
    if @battler.mega?
      imagePos.push(["Graphics/Pictures/Battle/icon_mega", @spriteBaseX + 8, 34])
    elsif @battler.primal?
      primalX = (@battler.opposes?) ? 208 : -28   # Foe's/player's
      if @battler.isSpecies?(:KYOGRE)
        imagePos.push(["Graphics/Pictures/Battle/icon_primal_Kyogre", @spriteBaseX + primalX, 4])
      elsif @battler.isSpecies?(:GROUDON)
        imagePos.push(["Graphics/Pictures/Battle/icon_primal_Groudon", @spriteBaseX + primalX, 4])
      end
    end
    # Draw owned icon (foe Pokémon only)
    if @battler.owned? && @battler.opposes?(0)
      imagePos.push(["Graphics/Pictures/Battle/icon_own", @spriteBaseX + 8, 36])
    end
    i = @battler.stages[:ATTACK]
    j = @battler.stages[:DEFENSE]
    k = @battler.stages[:SPECIAL_ATTACK]
    l = @battler.stages[:SPECIAL_DEFENSE]
    m = @battler.stages[:SPEED]
    n = @battler.stages[:EVASION]
    o = @battler.stages[:ACCURACY]
    stat_boost.push(i)
    stat_boost.push(j)
    stat_boost.push(k)
    stat_boost.push(l)
    stat_boost.push(m)
    stat_boost.push(n)
    stat_boost.push(o)
    @stat_path_atk =  "Graphics/Pictures/SS2 Stat Overlay/Atk#{$stages[0]}"
    @stat_path_def = "Graphics/Pictures/SS2 Stat Overlay/Def#{$stages[1]}"
    @stat_path_spatk = "Graphics/Pictures/SS2 Stat Overlay/SpAtk#{$stages[2]}"
    @stat_path_spdef = "Graphics/Pictures/SS2 Stat Overlay/SpDef#{$stages[3]}"
    @stat_path_spe = "Graphics/Pictures/SS2 Stat Overlay/Spe#{$stages[4]}"
    @stat_path_eva = "Graphics/Pictures/SS2 Stat Overlay/Eva#{$stages[5]}"
    @stat_path_acc = "Graphics/Pictures/SS2 Stat Overlay/Acc#{$stages[6]}"
    statX = (@battler.opposes?) ? @spriteX + 220 : @spriteX - 44
    statY = @spriteY -4
    statArray=[]
    # Changed by DemICE 17-Oct-2023 Changed the placement of the icons
    if !pbInSafari?
      if @sideSize < 2
        @sprites["Atk"].bitmap = $stages[0] != 0 ? pbBitmap(@stat_path_atk) : nil
        @sprites["Atk"].visible = $stages[0] != 0 ? true : false
        statArray.push(@sprites["Atk"]) if @sprites["Atk"].visible
        # @sprites["Atk"].x = statX
        # @sprites["Atk"].y = statY
        @sprites["Def"].bitmap = $stages[1] != 0 ? pbBitmap(@stat_path_def) : nil
        @sprites["Def"].visible = $stages[1] != 0 ? true : false
        statArray.push(@sprites["Def"]) if @sprites["Def"].visible
        # @sprites["Def"].x = statX + 30
        # @sprites["Def"].y = statY
        @sprites["SpAtk"].bitmap = $stages[2] != 0 ? pbBitmap(@stat_path_spatk) : nil
        @sprites["SpAtk"].visible = $stages[2] != 0 ? true : false
        statArray.push(@sprites["SpAtk"]) if @sprites["SpAtk"].visible
        # @sprites["SpAtk"].x = statX#(@battler.opposes?) ? statX : statX
        # @sprites["SpAtk"].y = statY + 16
        @sprites["SpDef"].bitmap = $stages[3] != 0 ? pbBitmap(@stat_path_spdef) : nil
        @sprites["SpDef"].visible = $stages[3] != 0 ? true : false
        statArray.push(@sprites["SpDef"]) if @sprites["SpDef"].visible
        # @sprites["SpDef"].x = statX + 30#(@battler.opposes?) ? statX + 30 : statX + 20
        # @sprites["SpDef"].y = statY + 16
        @sprites["Spe"].bitmap = $stages[4] != 0 ? pbBitmap(@stat_path_spe) : nil
        @sprites["Spe"].visible = $stages[4] != 0 ? true : false
        statArray.push(@sprites["Spe"]) if @sprites["Spe"].visible
        # @sprites["Spe"].x = statX + 14#(@battler.opposes?) ? statX + 14 : statX -40
        # @sprites["Spe"].y = statY + 32
        @sprites["Eva"].bitmap = $stages[5] != 0 ? pbBitmap(@stat_path_eva) : nil
        @sprites["Eva"].visible = $stages[5] != 0 ? true : false
        statArray.push(@sprites["Eva"]) if @sprites["Eva"].visible
        # @sprites["Eva"].x = statX#(@battler.opposes?) ? statX : statX
        # @sprites["Eva"].y = statY + 48
        @sprites["Acc"].bitmap = $stages[6] != 0 ? pbBitmap(@stat_path_acc) : nil
        @sprites["Acc"].visible = $stages[6] != 0 ? true : false
        statArray.push(@sprites["Acc"]) if @sprites["Acc"].visible
        # @sprites["Acc"].x = statX + 30#(@battler.opposes?) ? statX + 30 : statX + 30
        # @sprites["Acc"].y = statY + 48
        statX2=statX+30
        statX3=statX+14
        coordX=[
          statX, statX2,
          statX, statX2,
          statX3,
          statX,  statX2
        ]
        statY2=statY+16
        statY3=statY+32
        statY4=statY+48
        coordY=[
          statY, statY,
          statY2, statY2,
          statY3, 
          statY4, statY4
        ]
      else
        @sprites["Atk"].bitmap = $stages[0] != 0 ? pbBitmap(@stat_path_atk) : nil
        @sprites["Atk"].visible = $stages[0] != 0 ? true : false
        statArray.push(@sprites["Atk"]) if @sprites["Atk"].visible
        # @sprites["Atk"].x = statX
        # @sprites["Atk"].y = statY +16
        @sprites["Def"].bitmap = $stages[1] != 0 ? pbBitmap(@stat_path_def) : nil
        @sprites["Def"].visible = $stages[1] != 0 ? true : false
        statArray.push(@sprites["Def"]) if @sprites["Def"].visible
        # @sprites["Def"].x = statX + 30
        # @sprites["Def"].y = statY +16
        @sprites["SpAtk"].bitmap = $stages[2] != 0 ? pbBitmap(@stat_path_spatk) : nil
        @sprites["SpAtk"].visible = $stages[2] != 0 ? true : false
        statArray.push(@sprites["SpAtk"]) if @sprites["SpAtk"].visible
        # @sprites["SpAtk"].x = statX#(@battler.opposes?) ? statX : statX
        # @sprites["SpAtk"].y = statY + 32
        @sprites["SpDef"].bitmap = $stages[3] != 0 ? pbBitmap(@stat_path_spdef) : nil
        @sprites["SpDef"].visible = $stages[3] != 0 ? true : false
        statArray.push(@sprites["SpDef"]) if @sprites["SpDef"].visible
        # @sprites["SpDef"].x = statX + 30#(@battler.opposes?) ? statX + 30 : statX + 20
        # @sprites["SpDef"].y = statY + 32
        @sprites["Eva"].bitmap = $stages[5] != 0 ? pbBitmap(@stat_path_eva) : nil
        @sprites["Eva"].visible = $stages[5] != 0 ? true : false
        statArray.push(@sprites["Eva"]) if @sprites["Eva"].visible
        # @sprites["Eva"].x = statX -16#(@battler.opposes?) ? statX -16 : statX +16
        # @sprites["Eva"].y = statY + 48
        @sprites["Spe"].bitmap = $stages[4] != 0 ? pbBitmap(@stat_path_spe) : nil
        @sprites["Spe"].visible = $stages[4] != 0 ? true : false
        statArray.push(@sprites["Spe"]) if @sprites["Spe"].visible
        # @sprites["Spe"].x = statX +14 #(@battler.opposes?) ? statX + 14 : statX -40
        # @sprites["Spe"].y = statY + 48
        @sprites["Acc"].bitmap = $stages[6] != 0 ? pbBitmap(@stat_path_acc) : nil
        @sprites["Acc"].visible = $stages[6] != 0 ? true : false
        statArray.push(@sprites["Acc"]) if @sprites["Acc"].visible
        # @sprites["Acc"].x = statX + 44#(@battler.opposes?) ? statX + 30 : statX + 30
        # @sprites["Acc"].y = statY + 48
        statX2=statX+30
        statX3=statX-16
        statX4=statX+14
        statX5=statX+44
        coordX=[
          statX, statX2,
          statX, statX2,
          statX3,statX4,statX5
        ]
        statY2=statY+16
        statY3=statY+32
        statY4=statY+48
        coordY=[
          statY2, statY2,
          statY3, statY3,
          statY4,statY4, statY4
        ]
      end
      for i in 0..statArray.length
        next if statArray[i].nil?
        statArray[i].x=coordX[i]
        statArray[i].y=coordY[i]
      end
       # Changed by DemICE 16-Oct-2023 toggle stat stages boosts on/off
      @sprites["Atk"].visible = !$statBoostsToggle
      @sprites["Def"].visible = !$statBoostsToggle
      @sprites["SpAtk"].visible = !$statBoostsToggle
      @sprites["SpDef"].visible = !$statBoostsToggle
      @sprites["Spe"].visible = !$statBoostsToggle
      @sprites["Eva"].visible = !$statBoostsToggle
      @sprites["Acc"].visible = !$statBoostsToggle
    end
    # Draw status icon
    if @battler.status != :NONE
      if @battler.status == :POISON && @battler.statusCount > 0   # Badly poisoned
        s = GameData::Status.count - 1
      else
        s = GameData::Status.get(@battler.status).icon_position
      end
      if s >= 0
        imagePos.push(["Graphics/Pictures/Battle/icon_statuses", @spriteBaseX + 24, 36,
                       0, s * STATUS_ICON_HEIGHT, -1, STATUS_ICON_HEIGHT])
      end
    end
    pbDrawImagePositions(self.bitmap, imagePos)
    draw_item_icon
    draw_pinch
    refreshHP
    refreshExp
  end

  def draw_shiny_icon
    return if !@battler.shiny?
    shiny_x = (@battler.opposes?(0)) ? 206 : -6   # Foe's/player's
    path = (@battler.super_shiny?) ? "Graphics/EmpyCards/super_shiny" : "Graphics/Pictures/shiny"
    pbDrawImagePositions(self.bitmap, [[path, @spriteBaseX + shiny_x, 36]])
  end

  # Changed by DemICE 17-Oct-2023 Changed the placement of the icons
  def overlay_refresh
    stat_boost = []
    $stages = stat_boost
    i = @battler.stages[:ATTACK]
    j = @battler.stages[:DEFENSE]
    k = @battler.stages[:SPECIAL_ATTACK]
    l = @battler.stages[:SPECIAL_DEFENSE]
    m = @battler.stages[:SPEED]
    n = @battler.stages[:EVASION]
    o = @battler.stages[:ACCURACY]
    stat_boost.push(i)
    stat_boost.push(j)
    stat_boost.push(k)
    stat_boost.push(l)
    stat_boost.push(m)
    stat_boost.push(n)
    stat_boost.push(o)
    @stat_path_atk =  "Graphics/Pictures/SS2 Stat Overlay/Atk#{$stages[0]}"
    @stat_path_def = "Graphics/Pictures/SS2 Stat Overlay/Def#{$stages[1]}"
    @stat_path_spatk = "Graphics/Pictures/SS2 Stat Overlay/SpAtk#{$stages[2]}"
    @stat_path_spdef = "Graphics/Pictures/SS2 Stat Overlay/SpDef#{$stages[3]}"
    @stat_path_spe = "Graphics/Pictures/SS2 Stat Overlay/Spe#{$stages[4]}"
    @stat_path_eva = "Graphics/Pictures/SS2 Stat Overlay/Eva#{$stages[5]}"
    @stat_path_acc = "Graphics/Pictures/SS2 Stat Overlay/Acc#{$stages[6]}"
    statX = (@battler.opposes?) ? @spriteX + 242 : @spriteX - 30
    statY = @spriteY -4
    statArray=[]
    if !pbInSafari?
      if @sideSize < 2
        @sprites["Atk"].bitmap = $stages[0] != 0 ? pbBitmap(@stat_path_atk) : nil
        @sprites["Atk"].visible = $stages[0] != 0 ? true : false
        statArray.push(@sprites["Atk"]) if @sprites["Atk"].visible
        # @sprites["Atk"].x = statX
        # @sprites["Atk"].y = statY
        @sprites["Def"].bitmap = $stages[1] != 0 ? pbBitmap(@stat_path_def) : nil
        @sprites["Def"].visible = $stages[1] != 0 ? true : false
        statArray.push(@sprites["Def"]) if @sprites["Def"].visible
        # @sprites["Def"].x = statX + 30
        # @sprites["Def"].y = statY
        @sprites["SpAtk"].bitmap = $stages[2] != 0 ? pbBitmap(@stat_path_spatk) : nil
        @sprites["SpAtk"].visible = $stages[2] != 0 ? true : false
        statArray.push(@sprites["SpAtk"]) if @sprites["SpAtk"].visible
        # @sprites["SpAtk"].x = statX#(@battler.opposes?) ? statX : statX
        # @sprites["SpAtk"].y = statY + 16
        @sprites["SpDef"].bitmap = $stages[3] != 0 ? pbBitmap(@stat_path_spdef) : nil
        @sprites["SpDef"].visible = $stages[3] != 0 ? true : false
        statArray.push(@sprites["SpDef"]) if @sprites["SpDef"].visible
        # @sprites["SpDef"].x = statX + 30#(@battler.opposes?) ? statX + 30 : statX + 20
        # @sprites["SpDef"].y = statY + 16
        @sprites["Spe"].bitmap = $stages[4] != 0 ? pbBitmap(@stat_path_spe) : nil
        @sprites["Spe"].visible = $stages[4] != 0 ? true : false
        statArray.push(@sprites["Spe"]) if @sprites["Spe"].visible
        # @sprites["Spe"].x = statX + 14#(@battler.opposes?) ? statX + 14 : statX -40
        # @sprites["Spe"].y = statY + 32
        @sprites["Eva"].bitmap = $stages[5] != 0 ? pbBitmap(@stat_path_eva) : nil
        @sprites["Eva"].visible = $stages[5] != 0 ? true : false
        statArray.push(@sprites["Eva"]) if @sprites["Eva"].visible
        # @sprites["Eva"].x = statX#(@battler.opposes?) ? statX : statX
        # @sprites["Eva"].y = statY + 48
        @sprites["Acc"].bitmap = $stages[6] != 0 ? pbBitmap(@stat_path_acc) : nil
        @sprites["Acc"].visible = $stages[6] != 0 ? true : false
        statArray.push(@sprites["Acc"]) if @sprites["Acc"].visible
        # @sprites["Acc"].x = statX + 30#(@battler.opposes?) ? statX + 30 : statX + 30
        # @sprites["Acc"].y = statY + 48
        statX2=statX+30
        statX3=statX+14
        coordX=[
          statX, statX2,
          statX, statX2,
          statX3,
          statX,  statX2
        ]
        statY2=statY+16
        statY3=statY+32
        statY4=statY+48
        coordY=[
          statY, statY,
          statY2, statY2,
          statY3, 
          statY4, statY4
        ]
      else
        @sprites["Atk"].bitmap = $stages[0] != 0 ? pbBitmap(@stat_path_atk) : nil
        @sprites["Atk"].visible = $stages[0] != 0 ? true : false
        statArray.push(@sprites["Atk"]) if @sprites["Atk"].visible
        # @sprites["Atk"].x = statX
        # @sprites["Atk"].y = statY +16
        @sprites["Def"].bitmap = $stages[1] != 0 ? pbBitmap(@stat_path_def) : nil
        @sprites["Def"].visible = $stages[1] != 0 ? true : false
        statArray.push(@sprites["Def"]) if @sprites["Def"].visible
        # @sprites["Def"].x = statX + 30
        # @sprites["Def"].y = statY +16
        @sprites["SpAtk"].bitmap = $stages[2] != 0 ? pbBitmap(@stat_path_spatk) : nil
        @sprites["SpAtk"].visible = $stages[2] != 0 ? true : false
        statArray.push(@sprites["SpAtk"]) if @sprites["SpAtk"].visible
        # @sprites["SpAtk"].x = statX#(@battler.opposes?) ? statX : statX
        # @sprites["SpAtk"].y = statY + 32
        @sprites["SpDef"].bitmap = $stages[3] != 0 ? pbBitmap(@stat_path_spdef) : nil
        @sprites["SpDef"].visible = $stages[3] != 0 ? true : false
        statArray.push(@sprites["SpDef"]) if @sprites["SpDef"].visible
        # @sprites["SpDef"].x = statX + 30#(@battler.opposes?) ? statX + 30 : statX + 20
        # @sprites["SpDef"].y = statY + 32
        @sprites["Eva"].bitmap = $stages[5] != 0 ? pbBitmap(@stat_path_eva) : nil
        @sprites["Eva"].visible = $stages[5] != 0 ? true : false
        statArray.push(@sprites["Eva"]) if @sprites["Eva"].visible
        # @sprites["Eva"].x = statX -16#(@battler.opposes?) ? statX -16 : statX +16
        # @sprites["Eva"].y = statY + 48
        @sprites["Spe"].bitmap = $stages[4] != 0 ? pbBitmap(@stat_path_spe) : nil
        @sprites["Spe"].visible = $stages[4] != 0 ? true : false
        statArray.push(@sprites["Spe"]) if @sprites["Spe"].visible
        # @sprites["Spe"].x = statX +14 #(@battler.opposes?) ? statX + 14 : statX -40
        # @sprites["Spe"].y = statY + 48
        @sprites["Acc"].bitmap = $stages[6] != 0 ? pbBitmap(@stat_path_acc) : nil
        @sprites["Acc"].visible = $stages[6] != 0 ? true : false
        statArray.push(@sprites["Acc"]) if @sprites["Acc"].visible
        # @sprites["Acc"].x = statX + 44#(@battler.opposes?) ? statX + 30 : statX + 30
        # @sprites["Acc"].y = statY + 48
        statX2=statX+30
        statX3=statX-16
        statX4=statX+14
        statX5=statX+44
        coordX=[
          statX, statX2,
          statX, statX2,
          statX3,statX4,statX5
        ]
        statY2=statY+16
        statY3=statY+32
        statY4=statY+48
        coordY=[
          statY2, statY2,
          statY3, statY3,
          statY4,statY4, statY4
        ]
      end
      for i in 0..statArray.length
        next if statArray[i].nil?
        statArray[i].x=coordX[i]
        statArray[i].y=coordY[i]
      end
       # Changed by DemICE 16-Oct-2023 toggle stat stages boosts on/off
      @sprites["Atk"].visible = !$statBoostsToggle
      @sprites["Def"].visible = !$statBoostsToggle
      @sprites["SpAtk"].visible = !$statBoostsToggle
      @sprites["SpDef"].visible = !$statBoostsToggle
      @sprites["Spe"].visible = !$statBoostsToggle
      @sprites["Eva"].visible = !$statBoostsToggle
      @sprites["Acc"].visible = !$statBoostsToggle
    end
  end

  # Changed by DemICE 16-Oct-2023 Trapstarr gave me his type icon display script.
  # Trapstarr's Type Display
  def refreshtypeDisplay
    @typeDisplay.bitmap.clear
    return if !@battler.pokemon || @battler.fainted?
    if @hpBar.visible
      drawtypeDisplay
    end
  end

  # Changed by DemICE 16-Oct-2023 Trapstarr gave me his type icon display script.
  # Trapstarr's Type Display
  def updatetypeDisplay
    refreshtypeDisplay
  end


  def update(frameCounter = 0)
    super()
    # Animate HP bar
    updateHPAnimation
    # Animate Exp bar
    updateExpAnimation
    # Trapstarr's Type Display # Changed by DemICE 16-Oct-2023 Trapstarr gave me his type icon display script.
      updatetypeDisplay	
    # Update coordinates of the data box
    updatePositions(frameCounter)
    overlay_refresh
    pbUpdateSpriteHash(@sprites)
  end
end
