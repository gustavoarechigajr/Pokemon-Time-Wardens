#===============================================================================
# Data box for boss battles (by Stochastic)
# - adapted by Sardines for Pokemon Rejuvenation
# - Updated by the Repudiation Team for Essentials v21.1.
# - We won't be providing graphics for this plugin, but this code is basically a framework for you to make your own scene.
#===============================================================================
#===============================================================================
# Data box for regular battles
#===============================================================================
class Battle::Scene::BossPokemonDataBox < Sprite
  attr_reader   :battler
  attr_accessor :selected
  attr_reader   :animatingHP
  attr_reader   :animatingExp
  attr_accessor :shieldCount
  attr_reader :shieldX
  attr_reader :shieldY
  attr_reader :shieldGaugeX
  attr_reader :shieldGaugeY

  # Time in seconds to fully fill the Exp bar (from empty).
  EXP_BAR_FILL_TIME  = 1.75
  # Maximum time in seconds to make a change to the HP bar.
  HP_BAR_CHANGE_TIME = 1.0
  STATUS_ICON_HEIGHT = 16
  NAME_BASE_COLOR         = Color.new(255, 255, 255) # Changed by Jos 2022-10-02
  NAME_SHADOW_COLOR       = Color.new(100, 100, 100) # Changed by Jos 2022-10-02
  MALE_BASE_COLOR         = Color.new(255, 255, 255) # Changed by Jos 2022-10-02
  MALE_SHADOW_COLOR       = NAME_SHADOW_COLOR
  FEMALE_BASE_COLOR       = Color.new(255, 255, 255) # Changed by Jos 2022-10-02
  FEMALE_SHADOW_COLOR     = NAME_SHADOW_COLOR

  def initialize(battler, sideSize, viewport = nil)
    super(viewport)
    @battler      = battler
    @sprites      = {}
    @spriteX      = 0
    @spriteY      = 0
    @spriteBaseX  = 0
    @selected     = 0
    @frame        = 0
    @showHP       = false   # Specifically, show the HP numbers
    @animatingHP  = false
    @showExp      = false   # Specifically, show the Exp bar
    @animatingExp = false
    @expFlash     = 0
    @shieldCount  = battler.shieldCount
    @sideSize     = sideSize # Changed by DemICE 17-Oct-2023
    @onPlayerSide = battler.index.even?
    initializeDataBoxGraphic(sideSize)
    initializeOtherGraphics(viewport)
    refresh
  end

  def initializeDataBoxGraphic(sideSize)
    # Get the data box graphic and set whether the HP numbers/Exp bar are shown
    box_name = (@onPlayerSide) ? "databox_thin" : "BossBattle/boss_bar"
    @databoxBitmap&.dispose
    @databoxBitmap = AnimatedBitmap.new("Graphics/Pictures/Battle/#{box_name}")
    # Determine the co-ordinates of the data box and the left edge padding width
    if @onPlayerSide
      @spriteX = Graphics.width - 244
      @spriteY = Graphics.height - 192
      @spriteBaseX = 34
    else
      @spriteX = -6
      @spriteY = 16
      @spriteBaseX = 16
    end
    case sideSize
      when 2
        @spriteX += [-12,   0,  0,  0][@battler.index]
        @spriteY += [-20, -14, 34, 60][@battler.index]
      when 3
        @spriteX += [-12,   0,-60,  0,  0,  0][@battler.index]
        @spriteY += [-42, -14,  4, 46, 50,106][@battler.index]
    end  
  end

  def initializeOtherGraphics(viewport)
    # Create other bitmaps
    @statBoostsToggle = false
    @numbersBitmap = AnimatedBitmap.new(_INTL("Graphics/Pictures/Battle/icon_numbers"))
    shield_tag = (@shieldCount > 0) ? "" : ""
    hp_name = (@onPlayerSide) ? "overlay_hp" : "BossBattle/hpbarboss#{shield_tag}"
    @hpBarBitmap   = AnimatedBitmap.new(_INTL("Graphics/Pictures/Battle/#{hp_name}"))
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
    @typeDisplayBitmap = AnimatedBitmap.new(_INTL("Graphics/Pictures/Battle/TypeIcons_Square"))
    @shieldDisplayBitmap = AnimatedBitmap.new(_INTL("Graphics/Pictures/Battle/BossBattle/bossbarshield"))
    # Create sprite to draw HP numbers on
    @hpNumbers = BitmapSprite.new(124, 16, viewport)
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
    # Shield Update
    shieldDisplayBitmap = Bitmap.new(Graphics.width, Graphics.height)  
    @shieldDisplay = SpriteWrapper.new(viewport)
    @shieldDisplay.bitmap = shieldDisplayBitmap
    @sprites["shieldDisplay"] = @shieldDisplay
    @sprites["shieldDisplay"].z = 198
    # Create sprite wrapper that displays everything except the above
    @contents = BitmapWrapper.new(@databoxBitmap.width, @databoxBitmap.height)
    self.bitmap  = @contents
    self.visible = false
    self.z       = 150 + ((@battler.index / 2) * 5)
    pbSetSystemFont(self.bitmap)
  end

  def dispose
    pbDisposeSpriteHash(@sprites)
    @databoxBitmap.dispose
    @numbersBitmap.dispose
    @hpBarBitmap.dispose
    @expBarBitmap.dispose
    @shieldbitmaps.dispose if @shieldbitmaps
    # Trapstarr's Type Display Icon # Changed by DemICE 16-Oct-2023 Trapstarr gave me his type icon display script.
    @typeDisplayBitmap.dispose if @typeDisplayBitmap # Prevents nil
    @contents.dispose
    super
  end

  def x=(value)
    super
    @hpBar.x     = value + @spriteBaseX -10
    @expBar.x    = value + @spriteBaseX + 6
    @hpNumbers.x = value + @spriteBaseX + 80
  end

  def y=(value)
    super
    @hpBar.y     = value + 46
    @expBar.y    = value + 74
    @hpNumbers.y = value + 52
  end

  def z=(value)
    super
    @hpBar.z     = value + 1
    @expBar.z    = value + 1
    @hpNumbers.z = value + 2
  end

  def opacity=(value)
    super
    @sprites.each do |i|
      i[1].opacity = value if !i[1].disposed?
    end
  end

  def visible=(value)
    super
    @sprites.each do |i|
      i[1].visible = value if !i[1].disposed?
    end
    @expBar.visible = (value && @showExp)
  end

  def color=(value)
    super
    @sprites.each do |i|
      i[1].color = value if !i[1].disposed?
    end
  end

  def battler=(b)
    @battler = b
    self.visible = (@battler && !@battler.fainted?)
  end

  def hp
    return (@animatingHP) ? @currentHP : @battler.hp
  end

  def exp_fraction
    return 0.0 if @rangeExp == 0
    return (@animatingExp) ? @currentExp.to_f / @rangeExp : @battler.pokemon.exp_fraction
  end

  def animateHP(oldHP, newHP, rangeHP)
    @currentHP   = oldHP
    @endHP       = newHP
    @rangeHP     = rangeHP
    # NOTE: A change in HP takes the same amount of time to animate, no matter
    #       how big a change it is.
    @hpIncPerFrame = (newHP - oldHP).abs / (HP_BAR_CHANGE_TIME * Graphics.frame_rate)
    # minInc is the smallest amount that HP is allowed to change per frame.
    # This avoids a tiny change in HP still taking HP_BAR_CHANGE_TIME seconds.
    minInc = (rangeHP * 4) / (@hpBarBitmap.width * HP_BAR_CHANGE_TIME * Graphics.frame_rate)
    @hpIncPerFrame = minInc if @hpIncPerFrame < minInc
    @animatingHP   = true
  end
  
  # Changed by DemICE 16-Oct-2023 Trapstarr gave me his type icon display script.
  # Updated by PDM20 9-Dec-2024 to account for Protean
  # Trapstarr's Type Display
  def drawtypeDisplay
    typeDisplay = @sprites["typeDisplay"].bitmap
    if @battler.opposes?(0)
      type3 = (@battler.effects[PBEffects::Type3]) ? true : false
      types = @battler.pbTypes(type3)
      if @battler.effects[PBEffects::Illusion]
        types = @battler.displayPokemon.types
      end
      type1 = (types.length==3) ? types[2] : types[0]
      type2 = (types.length==3) ? types[2] : ((types.length==2) ? types[1] : types[0])
      typeindexes=[:NORMAL,:FIGHTING,:FLYING,:POISON,:GROUND,:ROCK,:BUG,:GHOST,:STEEL,:QMARKS,:FIRE,:WATER,:GRASS,:ELECTRIC,:PSYCHIC,:ICE,:DRAGON,:DARK,:FAIRY,:COSMIC,:SOUND,:LIGHT]
      type1_number=0
      type2_number=0
      for i in 0..typeindexes.length
        type1_number = i if type1==typeindexes[i]
        type2_number = i if type2==typeindexes[i]
      end 
      type1rect = Rect.new(0, type1_number * 20, 24, 20)
      type2rect = Rect.new(0, type2_number * 20, 24, 20)
      scale = 1
      scaled_width = (type1rect.width * scale).to_i
      scaled_height = (type1rect.height * (scale)).to_i
      type_x = @spriteX + 170
      type_y = @spriteY + 2
      type2_y = type_y + 2 # Spacing
      if type1 == type2
        typeDisplay.stretch_blt(Rect.new(type_x, type_y, scaled_width, scaled_height),@typeDisplayBitmap.bitmap,type1rect)
      else
        typeDisplay.stretch_blt(Rect.new(type_x, type_y, scaled_width, scaled_height),@typeDisplayBitmap.bitmap,type1rect)
        typeDisplay.stretch_blt(Rect.new(type_x, type2_y + scaled_height, scaled_width, scaled_height),@typeDisplayBitmap.bitmap,type2rect)
      end
    end
  end

  def drawShieldDisplay(shields = @shieldCount)
    shieldDisplay = @sprites["shieldDisplay"].bitmap
    shield_width, shield_height = @shieldDisplayBitmap.width, @shieldDisplayBitmap.height
    offset = [@spriteX + 266,@spriteY + 14]
    shieldX = [ 0,20,10,10]
    shieldY = [10,10, 0,20]
    shield_rect = Rect.new(0,0,shield_width,shield_height)
    for i in 0...shields
      shieldDisplay.stretch_blt(Rect.new(offset[0]+shieldX[i],offset[1]+shieldY[i],shield_width,shield_height),@shieldDisplayBitmap.bitmap,shield_rect) if !@onPlayerSide
    end
  end
  
  def animateExp(oldExp, newExp, rangeExp)
    return if rangeExp == 0
    @currentExp     = ($PokemonSystem.quick_level_up == 1) ? newExp : oldExp
    @endExp         = newExp
    @rangeExp       = rangeExp
    # NOTE: Filling the Exp bar from empty to full takes EXP_BAR_FILL_TIME
    #       seconds no matter what. Filling half of it takes half as long, etc.
    @expIncPerFrame = rangeExp / (EXP_BAR_FILL_TIME * Graphics.frame_rate)
    @animatingExp   = true
    pbSEPlay("Pkmn exp gain") if @showExp
  end

  def pbDrawNumber(number, btmp, startX, startY, align = 0)
    # -1 means draw the / character
    n = (number == -1) ? [10] : number.to_i.digits.reverse
    charWidth  = @numbersBitmap.width / 11
    charHeight = @numbersBitmap.height
    startX -= charWidth * n.length if align == 1
    n.each do |i|
      btmp.blt(startX, startY, @numbersBitmap.bitmap, Rect.new(i * charWidth, 0, charWidth, charHeight))
      startX += charWidth
    end
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

  def pbToggleStatBoosts
    update
  end

  def refresh
    self.bitmap.clear
    return if !@battler.pokemon
    textPos = []
    imagePos = []
    stat_boost = []
    # Shield Updte
    updateshieldDisplay
    # Stat boosts
    $stages = stat_boost
    # Draw background panel
    self.bitmap.blt(0, 0, @databoxBitmap.bitmap, Rect.new(0, 0, @databoxBitmap.width, @databoxBitmap.height))
    # Draw Pokémon's name
    case @battler.displayGender
      when 0; gender = "♂" # Male
      when 1; gender = "♀" # Female
      else; gender = ""
    end
    fullname = "#{@battler.name} #{gender}"
    textPos.push([fullname, @spriteBaseX - 6 , 20, false, NAME_BASE_COLOR, NAME_SHADOW_COLOR])
    # Draw Pokémon's gender symbol
    pbDrawTextPositions(self.bitmap, textPos)
    # Draw Pokémon's level
    imagePos.push(["Graphics/Pictures/Battle/overlay_lv", @spriteBaseX + 178, 26])
    pbDrawNumber(@battler.level, self.bitmap, @spriteBaseX + 200, 26)
    # Draw shiny icon
    if @battler.shiny?
      imagePos.push(["Graphics/Pictures/shiny", @spriteBaseX + 260, 53])
    end
    stat_boost.push(@battler.stages[:ATTACK], @battler.stages[:DEFENSE], @battler.stages[:SPECIAL_ATTACK], @battler.stages[:SPECIAL_DEFENSE], @battler.stages[:SPEED], @battler.stages[:EVASION], @battler.stages[:ACCURACY])
    @stat_path_atk =  "Graphics/Pictures/SS2 Stat Overlay/Atk#{$stages[0]}"
    @stat_path_def = "Graphics/Pictures/SS2 Stat Overlay/Def#{$stages[1]}"
    @stat_path_spatk = "Graphics/Pictures/SS2 Stat Overlay/SpAtk#{$stages[2]}"
    @stat_path_spdef = "Graphics/Pictures/SS2 Stat Overlay/SpDef#{$stages[3]}"
    @stat_path_spe = "Graphics/Pictures/SS2 Stat Overlay/Spe#{$stages[4]}"
    @stat_path_eva = "Graphics/Pictures/SS2 Stat Overlay/Eva#{$stages[5]}"
    @stat_path_acc = "Graphics/Pictures/SS2 Stat Overlay/Acc#{$stages[6]}"
    statX = @spriteX + 4
    statY = @spriteY + 54
    statArray=[]
    if !pbInSafari?
      if @sideSize < 2
        @sprites["Atk"].bitmap = $stages[0] != 0 ? pbBitmap(@stat_path_atk) : nil
        @sprites["Atk"].visible = $stages[0] != 0 ? true : false
        statArray.push(@sprites["Atk"]) if @sprites["Atk"].visible

        @sprites["Def"].bitmap = $stages[1] != 0 ? pbBitmap(@stat_path_def) : nil
        @sprites["Def"].visible = $stages[1] != 0 ? true : false
        statArray.push(@sprites["Def"]) if @sprites["Def"].visible

        @sprites["SpAtk"].bitmap = $stages[2] != 0 ? pbBitmap(@stat_path_spatk) : nil
        @sprites["SpAtk"].visible = $stages[2] != 0 ? true : false
        statArray.push(@sprites["SpAtk"]) if @sprites["SpAtk"].visible
        @sprites["SpDef"].bitmap = $stages[3] != 0 ? pbBitmap(@stat_path_spdef) : nil
        @sprites["SpDef"].visible = $stages[3] != 0 ? true : false
        statArray.push(@sprites["SpDef"]) if @sprites["SpDef"].visible
        @sprites["Spe"].bitmap = $stages[4] != 0 ? pbBitmap(@stat_path_spe) : nil
        @sprites["Spe"].visible = $stages[4] != 0 ? true : false
        statArray.push(@sprites["Spe"]) if @sprites["Spe"].visible
        @sprites["Eva"].bitmap = $stages[5] != 0 ? pbBitmap(@stat_path_eva) : nil
        @sprites["Eva"].visible = $stages[5] != 0 ? true : false
        statArray.push(@sprites["Eva"]) if @sprites["Eva"].visible
        @sprites["Acc"].bitmap = $stages[6] != 0 ? pbBitmap(@stat_path_acc) : nil
        @sprites["Acc"].visible = $stages[6] != 0 ? true : false
        statArray.push(@sprites["Acc"]) if @sprites["Acc"].visible
        coordX = []
        for i in 0...7
          coordX.push((statX+(i*32)))
        end
        coordY = [statY, statY, statY, statY, statY, statY, statY]
      else
        @sprites["Atk"].bitmap = $stages[0] != 0 ? pbBitmap(@stat_path_atk) : nil
        @sprites["Atk"].visible = $stages[0] != 0 ? true : false
        statArray.push(@sprites["Atk"]) if @sprites["Atk"].visible
        @sprites["Def"].bitmap = $stages[1] != 0 ? pbBitmap(@stat_path_def) : nil
        @sprites["Def"].visible = $stages[1] != 0 ? true : false
        statArray.push(@sprites["Def"]) if @sprites["Def"].visible
        @sprites["SpAtk"].bitmap = $stages[2] != 0 ? pbBitmap(@stat_path_spatk) : nil
        @sprites["SpAtk"].visible = $stages[2] != 0 ? true : false
        statArray.push(@sprites["SpAtk"]) if @sprites["SpAtk"].visible
        @sprites["SpDef"].bitmap = $stages[3] != 0 ? pbBitmap(@stat_path_spdef) : nil
        @sprites["SpDef"].visible = $stages[3] != 0 ? true : false
        statArray.push(@sprites["SpDef"]) if @sprites["SpDef"].visible
        @sprites["Eva"].bitmap = $stages[5] != 0 ? pbBitmap(@stat_path_eva) : nil
        @sprites["Eva"].visible = $stages[5] != 0 ? true : false
        statArray.push(@sprites["Eva"]) if @sprites["Eva"].visible
        @sprites["Spe"].bitmap = $stages[4] != 0 ? pbBitmap(@stat_path_spe) : nil
        @sprites["Spe"].visible = $stages[4] != 0 ? true : false
        statArray.push(@sprites["Spe"]) if @sprites["Spe"].visible
        @sprites["Acc"].bitmap = $stages[6] != 0 ? pbBitmap(@stat_path_acc) : nil
        @sprites["Acc"].visible = $stages[6] != 0 ? true : false
        statArray.push(@sprites["Acc"]) if @sprites["Acc"].visible
        coordX = []
        for i in 0...7
          coordX.push((statX+(i*32)))
        end
        coordY = [statY, statY, statY, statY, statY, statY, statY]
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
        imagePos.push(["Graphics/Pictures/Battle/icon_statuses", @spriteBaseX + 214, 56,
                       0, s * STATUS_ICON_HEIGHT, -1, STATUS_ICON_HEIGHT])
      end
    end
    pbDrawImagePositions(self.bitmap, [["Graphics/Plugins/Essentials Deluxe/icon_mega", @spriteBaseX + 276,46]]) if @battler.mega?
    pbDrawImagePositions(self.bitmap, imagePos)
    refreshHP
    refreshExp
  end

  def refreshHP
    @hpNumbers.bitmap.clear
    return if !@battler.pokemon
    # Show HP numbers
    if @showHP
      pbDrawNumber(self.hp, @hpNumbers.bitmap, 54, 2, 1)
      pbDrawNumber(-1, @hpNumbers.bitmap, 54, 2)   # / char
      pbDrawNumber(@battler.totalhp, @hpNumbers.bitmap, 70, 2)
    end
    # Resize HP bar
    w = 0
    if self.hp > 0
      w = @hpBarBitmap.width.to_f * self.hp / @battler.totalhp
      w = 1 if w < 1
      # NOTE: The line below snaps the bar's width to the nearest 2 pixels, to
      #       fit in with the rest of the graphics which are doubled in size.
      w = ((w / 2.0).round) * 2
    end
    @hpBar.src_rect.width = w
    hpColor = 0                                  # Green bar
    hpColor = 1 if self.hp <= @battler.totalhp / 2   # Yellow bar
    hpColor = 2 if self.hp <= @battler.totalhp / 4   # Red bar
    @hpBar.src_rect.y = hpColor * @hpBarBitmap.height / 3
  end

  def refreshExp
    return if !@showExp
    w = exp_fraction * @expBarBitmap.width
    # NOTE: The line below snaps the bar's width to the nearest 2 pixels, to
    #       fit in with the rest of the graphics which are doubled in size.
    w = ((w / 2).round) * 2
    @expBar.src_rect.width = w
  end

  # Changed by DemICE 17-Oct-2023 Changed the placement of the icons
  def overlay_refresh
    stat_boost = []
    $stages = stat_boost
    stat_boost.push(@battler.stages[:ATTACK], @battler.stages[:DEFENSE], @battler.stages[:SPECIAL_ATTACK], @battler.stages[:SPECIAL_DEFENSE], @battler.stages[:SPEED], @battler.stages[:EVASION], @battler.stages[:ACCURACY])
    @stat_path_atk =  "Graphics/Pictures/SS2 Stat Overlay/Atk#{$stages[0]}"
    @stat_path_def = "Graphics/Pictures/SS2 Stat Overlay/Def#{$stages[1]}"
    @stat_path_spatk = "Graphics/Pictures/SS2 Stat Overlay/SpAtk#{$stages[2]}"
    @stat_path_spdef = "Graphics/Pictures/SS2 Stat Overlay/SpDef#{$stages[3]}"
    @stat_path_spe = "Graphics/Pictures/SS2 Stat Overlay/Spe#{$stages[4]}"
    @stat_path_eva = "Graphics/Pictures/SS2 Stat Overlay/Eva#{$stages[5]}"
    @stat_path_acc = "Graphics/Pictures/SS2 Stat Overlay/Acc#{$stages[6]}"
    statX = @spriteX + 4
    statY = @spriteY + 54
    statArray=[]
    if !pbInSafari?
      if @sideSize < 2
        @sprites["Atk"].bitmap = $stages[0] != 0 ? pbBitmap(@stat_path_atk) : nil
        @sprites["Atk"].visible = $stages[0] != 0 ? true : false
        statArray.push(@sprites["Atk"]) if @sprites["Atk"].visible
        @sprites["Def"].bitmap = $stages[1] != 0 ? pbBitmap(@stat_path_def) : nil
        @sprites["Def"].visible = $stages[1] != 0 ? true : false
        statArray.push(@sprites["Def"]) if @sprites["Def"].visible
        @sprites["SpAtk"].bitmap = $stages[2] != 0 ? pbBitmap(@stat_path_spatk) : nil
        @sprites["SpAtk"].visible = $stages[2] != 0 ? true : false
        statArray.push(@sprites["SpAtk"]) if @sprites["SpAtk"].visible
        @sprites["SpDef"].bitmap = $stages[3] != 0 ? pbBitmap(@stat_path_spdef) : nil
        @sprites["SpDef"].visible = $stages[3] != 0 ? true : false
        statArray.push(@sprites["SpDef"]) if @sprites["SpDef"].visible
        @sprites["Spe"].bitmap = $stages[4] != 0 ? pbBitmap(@stat_path_spe) : nil
        @sprites["Spe"].visible = $stages[4] != 0 ? true : false
        statArray.push(@sprites["Spe"]) if @sprites["Spe"].visible
        @sprites["Eva"].bitmap = $stages[5] != 0 ? pbBitmap(@stat_path_eva) : nil
        @sprites["Eva"].visible = $stages[5] != 0 ? true : false
        statArray.push(@sprites["Eva"]) if @sprites["Eva"].visible
        @sprites["Acc"].bitmap = $stages[6] != 0 ? pbBitmap(@stat_path_acc) : nil
        @sprites["Acc"].visible = $stages[6] != 0 ? true : false
        statArray.push(@sprites["Acc"]) if @sprites["Acc"].visible
        coordX = []
        for i in 0...7
          coordX.push((statX+(i*32)))
        end
        coordY = [statY, statY, statY, statY, statY, statY, statY]
      else
        @sprites["Atk"].bitmap = $stages[0] != 0 ? pbBitmap(@stat_path_atk) : nil
        @sprites["Atk"].visible = $stages[0] != 0 ? true : false
        statArray.push(@sprites["Atk"]) if @sprites["Atk"].visible
        @sprites["Def"].bitmap = $stages[1] != 0 ? pbBitmap(@stat_path_def) : nil
        @sprites["Def"].visible = $stages[1] != 0 ? true : false
        statArray.push(@sprites["Def"]) if @sprites["Def"].visible
        @sprites["SpAtk"].bitmap = $stages[2] != 0 ? pbBitmap(@stat_path_spatk) : nil
        @sprites["SpAtk"].visible = $stages[2] != 0 ? true : false
        statArray.push(@sprites["SpAtk"]) if @sprites["SpAtk"].visible
        @sprites["SpDef"].bitmap = $stages[3] != 0 ? pbBitmap(@stat_path_spdef) : nil
        @sprites["SpDef"].visible = $stages[3] != 0 ? true : false
        statArray.push(@sprites["SpDef"]) if @sprites["SpDef"].visible
        @sprites["Eva"].bitmap = $stages[5] != 0 ? pbBitmap(@stat_path_eva) : nil
        @sprites["Eva"].visible = $stages[5] != 0 ? true : false
        statArray.push(@sprites["Eva"]) if @sprites["Eva"].visible
        @sprites["Spe"].bitmap = $stages[4] != 0 ? pbBitmap(@stat_path_spe) : nil
        @sprites["Spe"].visible = $stages[4] != 0 ? true : false
        statArray.push(@sprites["Spe"]) if @sprites["Spe"].visible
        @sprites["Acc"].bitmap = $stages[6] != 0 ? pbBitmap(@stat_path_acc) : nil
        @sprites["Acc"].visible = $stages[6] != 0 ? true : false
        statArray.push(@sprites["Acc"]) if @sprites["Acc"].visible
        coordX = []
        for i in 0...7
          coordX.push((statX+(i*30)))
        end
        coordY = [statY, statY, statY, statY, statY, statY, statY]
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
    if @shieldCount == 0
      @typeDisplay.bitmap.clear
    end
    return if !@battler.pokemon || @battler.fainted?
    if @hpBar.visible
      drawtypeDisplay
    end
  end

  def refreshShieldDisplay(shields = @shieldCount)
    @shieldDisplay.bitmap.clear
    return if !@battler.pokemon || @battler.fainted?
    if shields > 0
      drawShieldDisplay(shields)
    end
  end

  # Changed by DemICE 16-Oct-2023 Trapstarr gave me his type icon display script.
  # Trapstarr's Type Display
  def updatetypeDisplay
    refreshtypeDisplay
  end

  def updateshieldDisplay(shield = @battler.shieldCount)
    @shieldCount = @battler.shieldCount
    refreshShieldDisplay(@shieldCount)
  end

  def updateHPAnimation
    return if !@animatingHP
    if @currentHP < @endHP      # Gaining HP
      @currentHP += @hpIncPerFrame
      @currentHP = @endHP if @currentHP >= @endHP
    elsif @currentHP > @endHP   # Losing HP
      @currentHP -= @hpIncPerFrame
      @currentHP = @endHP if @currentHP <= @endHP
    end
    # Refresh the HP bar/numbers
    refreshHP
    @animatingHP = false if @currentHP == @endHP
  end

  def updateExpAnimation
    return if !@animatingExp
    if !@showExp   # Not showing the Exp bar, no need to waste time animating it
      @currentExp = @endExp
      @animatingExp = false
      return
    end
    if @currentExp < @endExp   # Gaining Exp
      @currentExp += @expIncPerFrame
      @currentExp = @endExp if @currentExp >= @endExp
    elsif @currentExp > @endExp   # Losing Exp
      @currentExp -= @expIncPerFrame
      @currentExp = @endExp if @currentExp <= @endExp
    end
    # Refresh the Exp bar
    refreshExp
    return if @currentExp != @endExp   # Exp bar still has more to animate
    # Exp bar is completely filled, level up with a flash and sound effect
    if @currentExp >= @rangeExp
      if @expFlash == 0
        pbSEStop
        @expFlash = Graphics.frame_rate / 5
        pbSEPlay("Pkmn exp full")
        self.flash(Color.new(64, 200, 248, 192), @expFlash)
        @sprites.each do |i|
          i[1].flash(Color.new(64, 200, 248, 192), @expFlash) if !i[1].disposed?
        end
      else
        @expFlash -= 1
        @animatingExp = false if @expFlash == 0
      end
    else
      pbSEStop
      # Exp bar has finished filling, end animation
      @animatingExp = false
    end
  end

  QUARTER_ANIM_PERIOD = Graphics.frame_rate * 3 / 20

  def updatePositions(frameCounter)
    self.x = @spriteX
    self.y = @spriteY
    # Data box bobbing while Pokémon is selected
    if @selected == 1 || @selected == 2   # Choosing commands/targeted or damaged
      case (frameCounter / QUARTER_ANIM_PERIOD).floor
      when 1 then self.y = @spriteY - 2
      when 3 then self.y = @spriteY + 2
      end
    end
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

class Battle::Scene
  alias bossbattle_pbInitSprites pbInitSprites
  def pbInitSprites
    bossbattle_pbInitSprites
    @battle.battlers.each_with_index do |b, i|
      next if !b
      if b.isbossmon
        @sprites["dataBox_#{i}"] = BossPokemonDataBox.new(b, @battle.pbSideSize(i), @viewport)
      elsif @battle.wildBattleMode == :raid || (b.index.odd? && @battle.battlers.length >= 6) || (b.index.even? && @battle.battlers[4] != nil)
        @sprites["dataBox_#{i}"] = RaidPokemonDataBox.new(b, @battle.pbSideSize(i), @viewport)
      else
        @sprites["dataBox_#{i}"] = PokemonDataBox.new(b, @battle.pbSideSize(i), @viewport)
      end
    end
  end

  def pbRefresh
    @battle.battlers.each_with_index do |b, i|
      next if !b
      sprite = @sprites["dataBox_#{i}"]
      new_databox = false
      if b.isbossmon
        if sprite.is_a?(PokemonDataBox) || sprite.is_a?(RaidPokemonDataBox)
          @sprites["dataBox_#{i}"] = BossPokemonDataBox.new(b, @battle.pbSideSize(i), @viewport)
          new_databox = true
        end
      elsif @battle.wildBattleMode == :raid || (b.index.odd? && @battle.battlers.length >= 6) || (b.index.even? && @battle.battlers[4] != nil)
        if sprite.is_a?(BossPokemonDataBox) || sprite.is_a?(PokemonDataBox)
          @sprites["dataBox_#{i}"] = RaidPokemonDataBox.new(b, @battle.pbSideSize(i), @viewport)
          new_databox = true
        end
      else
        if sprite.is_a?(BossPokemonDataBox) || sprite.is_a?(RaidPokemonDataBox)
          @sprites["dataBox_#{i}"] = PokemonDataBox.new(b, @battle.pbSideSize(i), @viewport)
          new_databox = true
        end
      end
      @sprites["dataBox_#{i}"].initializeDataBoxGraphic(@battle.pbSideSize(i)) if new_databox
      @sprites["dataBox_#{i}"]&.refresh
    end
  end

  def pbRefreshOne(idxBattler)
    sprite = @sprites["dataBox_#{idxBattler}"]
    new_databox = false
    if @battle.battlers[idxBattler].isbossmon
      if sprite.is_a?(PokemonDataBox) || sprite.is_a?(RaidPokemonDataBox)
        @sprites["dataBox_#{idxBattler}"] = BossPokemonDataBox.new(idxBattler, @battle.pbSideSize(idxBattler), @viewport)
        new_databox = true
      end
    elsif @battle.wildBattleMode == :raid || sprite.is_a?(RaidPokemonDataBox)
      if sprite.is_a?(BossPokemonDataBox)
        @sprites["dataBox_#{idxBattler}"] = RaidPokemonDataBox.new(idxBattler, @battle.pbSideSize(idxBattler), @viewport)
        new_databox = true
      end
    else
      if sprite.is_a?(BossPokemonDataBox)
        @sprites["dataBox_#{idxBattler}"] = PokemonDataBox.new(idxBattler, @battle.pbSideSize(idxBattler), @viewport)
        new_databox = true
      end
    end
    @sprites["dataBox_#{idxBattler}"].initializeDataBoxGraphic(@battle.pbSideSize(idxBattler)) if new_databox
    @sprites["dataBox_#{idxBattler}"]&.refresh
  end

  def pbUpdateShield(shield, index)
    return false if !@battle.battlers[index]
    @battle.battlers[index].pokemon.shieldCount = shield
    @sprites["dataBox_#{index}"].updateshieldDisplay(shield)
  end

  def pbUpdateBattlerInfo(battler)
    @infoUIOverlay1.clear
    @infoUIOverlay2.clear
    pbUpdateBattlerIcons
    return if !@infoUIToggle
    xpos = 28
    ypos = 25
    iconX = xpos + 29
    iconY = ypos + 62
    panelX = xpos + 239
    case [battler.level, battler.isRaidBoss?]
      when [0..19, true]; level_tet = _INTL("Rk. 1")
      when [20..29, true]; level_tet = _INTL("Rk. 2")
      when [30..39, true]; level_tet = _INTL("Rk. 3")
      when [40..64, true]; level_tet = _INTL("Rk. 4")
      when [65..74, true]; level_tet = _INTL("Rk. 5")
      when [75..99, true]; level_tet = _INTL("Rk. 6")
      when [100..115, true]; level_tet = _INTL("Rk. 7")
      else; level_txt = _INTL("Lv. {1}", battler.level)
    end
    #---------------------------------------------------------------------------
    # General UI elements.
    poke = (battler.opposes?) ? battler.displayPokemon : battler.pokemon
    imagePos = [[@path + "Battle Info/info_bg", 0, 0],
                [@path + "Battle Info/info_ui", 0, 0],
                [@path + "Battle Info/battler_gender", xpos + 146, ypos + 24, poke.gender * 22, 0, 22, 20]]
    textPos  = [[_INTL("{1}", poke.name), iconX + 83, iconY - 16, 2, BASE_DARK, SHADOW_DARK],
                [level_txt, xpos + 17, ypos + 106, 0, BASE_LIGHT, SHADOW_LIGHT],
                [_INTL("Turn {1}", @battle.turnCount + 1), Graphics.width - xpos - 32, ypos + 6, 2, BASE_LIGHT, SHADOW_LIGHT]]
    #---------------------------------------------------------------------------
    # Battler icon.
    @battle.allBattlers.each do |b|
      @sprites["battler_icon#{b.index}"].x = iconX
      @sprites["battler_icon#{b.index}"].y = iconY
      @sprites["battler_icon#{b.index}"].visible = (b == battler)
    end
    #---------------------------------------------------------------------------
    # Battler HP.
    if battler.hp > 0
      w = battler.hp * 96 / battler.totalhp.to_f
      w = 1 if w < 1
      w = ((w / 2).round) * 2
      hpzone = 0
      hpzone = 1 if battler.hp <= (battler.totalhp / 2).floor
      hpzone = 2 if battler.hp <= (battler.totalhp / 4).floor
      imagePos.push(["Graphics/Pictures/Battle/overlay_hp", 86, 89, 0, hpzone * 6, w, 6])
    end
    # Battler status.
    if battler.status != :NONE
      iconPos = GameData::Status.get(battler.status).icon_position
      imagePos.push(["Graphics/Pictures/statuses", xpos + 86, ypos + 105, 0, iconPos * 16, 44, 16])
    end
    # Shininess
    imagePos.push(["Graphics/Pictures/shiny", xpos + 143, ypos + 105]) if poke.shiny?
    # Owner
    if !battler.wild?
      imagePos.push([@path + "Battle Info/panel_owner", xpos - 34, ypos + 4])
      textPos.push([@battle.pbGetOwnerFromBattlerIndex(battler.index).name, xpos + 32, ypos + 6, 2, BASE_LIGHT, SHADOW_LIGHT])
    end
    # Battler's last move used.
    if battler.lastMoveUsed
      movename = GameData::Move.get(battler.lastMoveUsed).name
      movename = movename[0..12] + "..." if movename.length > 16
      textPos.push([_INTL("Used: #{movename}"), xpos + 348, ypos + 106, 2, BASE_LIGHT, SHADOW_LIGHT])
    end
    #---------------------------------------------------------------------------
    # Battler info for player-owned Pokemon.
    if battler.pbOwnedByPlayer?
      imagePos.push(
        [@path + "Battle Info/panel_owner", xpos + 36, iconY + 11],
        [@path + "Battle Info/panel_effects", panelX, 65, 0, 0, 218, 24],
        [@path + "Battle Info/panel_effects", panelX, 89, 0, 0, 218, 24]
      )
      textPos.push(
        [_INTL("Abil."), xpos + 272, ypos + 44, 2, BASE_LIGHT, SHADOW_LIGHT],
        [_INTL("Item"), xpos + 272, ypos + 68, 2, BASE_LIGHT, SHADOW_LIGHT],
        [_INTL("{1}", battler.abilityName), xpos + 375, ypos + 44, 2, BASE_DARK, SHADOW_DARK],
        [_INTL("{1}", battler.itemName), xpos + 375, ypos + 68, 2, BASE_DARK, SHADOW_DARK],
        [sprintf("%d/%d", battler.hp, battler.totalhp), iconX + 73, iconY + 13, 2, BASE_LIGHT, SHADOW_LIGHT]
      )
    elsif $RevealedAbility[battler.index].is_a?(Hash)
      if $RevealedAbility[battler.index][0] != {:pkmn=>nil,:abil=>nil}
        imagePos.push(
          [@path + "Battle Info/panel_effects", panelX, 65, 0, 0, 218, 24]
        )
        textPos.push(
          [_INTL("Abil."), xpos + 272, ypos + 44, 2, BASE_LIGHT, SHADOW_LIGHT],
          [_INTL("{1}", battler.abilityName), xpos + 375, ypos + 44, 2, BASE_DARK, SHADOW_DARK]
        )
      end
    elsif battler.isbossmon
      imagePos.push(
        [@path + "Battle Info/panel_owner", xpos + 36, iconY + 11],
      )
      textPos.push(
        [sprintf("Shields: %d", battler.shieldCount), iconX + 73, iconY + 13, 2, BASE_LIGHT, SHADOW_LIGHT]
      )
    end
    #---------------------------------------------------------------------------
    # Battler's stat stages.
    stat_images, stat_text = pbAddStatsDisplay(xpos, ypos, battler)
    imagePos += stat_images
    textPos  += stat_text
    #---------------------------------------------------------------------------
    # Effects in play that affect the battler.
    effect_images, effect_text = pbAddEffectsDisplay(xpos, ypos, panelX, battler)
    imagePos += effect_images
    textPos  += effect_text
    #---------------------------------------------------------------------------
    pbDrawImagePositions(@infoUIOverlay1, imagePos)
    pbDrawTextPositions(@infoUIOverlay2, textPos)
    #---------------------------------------------------------------------------
    # Battler's typing.
    pbAddTypesDisplay(xpos, ypos, battler, poke)
  end
end

#-------------------------------------------------------------------------------
# Pokemon bitmaps (In battle)
#-------------------------------------------------------------------------------
class Battle::Scene::BattlerSprite < RPG::Sprite
  def pbSetPosition
    return if !@_iconBitmap
    pbSetOrigin
    if @index.even?
      self.z = 50 + (5 * @index / 2)
    else
      self.z = 50 - (5 * (@index + 1) / 2)
    end
    p = Battle::Scene.pbBattlerPosition(@index, @sideSize)
    @spriteX = p[0]
    @spriteY = p[1]
    @spriteX += 20 if @pkmn.isbossmon
    @pkmn.species_data.apply_metrics_to_sprite(self, @index, false, @dynamax)
  end
end


#-------------------------------------------------------------------------------
# Shadow sprite for Pokémon (used in battle)
#-------------------------------------------------------------------------------
class Battle::Scene::BattlerShadowSprite < RPG::Sprite
  def pbSetPosition
    return if !@_iconBitmap
    pbSetOrigin
    self.z = 3
    p = Battle::Scene.pbBattlerPosition(@index, @sideSize)
    self.x = p[0]
    self.y = p[1]
    self.x += 20 if @pkmn.isbossmon
    @pkmn.species_data.apply_metrics_to_sprite(self, @index, true, @dynamax)
  end
end
