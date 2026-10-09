#===============================================================================
# Game data for databox styles.
#===============================================================================
module GameData
  class DataboxStyle
    attr_reader :id            # :Symbol              : ID for a style.
    attr_reader :real_name     # "String"             : Name of a style.
    attr_reader :sprite_x      # [ally, foe]          : Array of databox base x values. Ally side subtracts from Graphics.width.
    attr_reader :sprite_y      # [ally, foe]          : Array of databox base y values. Ally side subtracts from Graphics.height.
    attr_reader :sprite_base_x # [ally, foe]          : Array of x values to shift databox elements by based on side size.
    attr_reader :offset_x      # [[double], [triple]] : Arrays of x values to shift databox values by in double/triple battles.
    attr_reader :offset_y      # [[double], [triple]] : Arrays of y values to shift databox values by in double/triple battles.
    attr_reader :hp_offset     # [[ally], [foe]]      : Arrays of [x, y] values to shift HP bar positioning.
    attr_reader :exp_offset    # [x, y]               : Array of [x, y] values to shift Exp. bar positioning. Foe side doesn't use this.
    attr_reader :name_pos      # [[ally], [foe]]      : Arrays of [x, y, alignment] values for positioning a battler's name.
    attr_reader :owned_icon    # [x, y]               : Array of [x, y] values for ownership icon positioning. Ally side doesn't use this.
    attr_reader :shiny_icon    # [[ally], [foe]]      : Arrays of [x, y] values for shiny icon positioning.
    attr_reader :status_icon   # [[ally], [foe]]      : Arrays of [x, y] values for status icon positioning.
    attr_reader :special_icon  # [[ally], [foe]]      : Arrays of [x, y] values for Mega Evolution icon positioning (and others).
    attr_reader :vertical_anim # true/false           : When true, databox slides on/off screen vertically rather than horizontally.
    attr_reader :max_side_size # Integer (1-3)        : Sets the max side size this style is compatible with.
    
    DATA = {}

    extend ClassMethodsSymbols
    include InstanceMethods

    def self.load; end
    def self.save; end

    def initialize(hash)
      @id            = hash[:id]
      @real_name     = hash[:name]          || "Unnamed"
      @sprite_x      = hash[:sprite_x]      || [0, 0]
      @sprite_y      = hash[:sprite_y]      || [0, 0]
      @sprite_base_x = hash[:sprite_base_x] || [0, 0]
      @offset_x      = hash[:offset_x]      || [[0, 0, 0, 0], [0, 0, 0, 0, 0, 0]]
      @offset_y      = hash[:offset_y]      || [[0, 0, 0, 0], [0, 0, 0, 0, 0, 0]]
      @hp_offset     = hash[:hp_offset]     || [[0, 0], [0, 0]]
      @exp_offset    = hash[:exp_offset]    || [0, 0]
      @name_pos      = hash[:name_pos]      || [[0, 0], [0, 0]]
      @owned_icon    = hash[:owned_icon]    || [0, 0]
      @shiny_icon    = hash[:shiny_icon]    || [[0, 0], [0, 0]]
      @status_icon   = hash[:status_icon]   || [[0, 0], [0, 0]]
      @special_icon  = hash[:special_icon]  || [[0, 0], [0, 0]]
      @vertical_anim = hash[:vertical_anim] || false
      @max_side_size = hash[:max_side_size] || 3
    end

    def name
      return _INTL(@real_name)
    end
  end
end

#===============================================================================
# Basic databox style.
GameData::DataboxStyle.register({
  :id            => :Basic,
  :name          => _INTL("Basic"),
  :sprite_x      => [262, -16],
  :sprite_y      => [154, 12],
  :sprite_base_x => [34, 16],
  :offset_x      => [[0, 8, -8, 0],    [0, 16, -8, 8, -16, 0]],
  #:offset_y      => [[-38, -8, 8, 38], [-80, -10, -34, 36, 12, 82]],
  :offset_y      => [[-38, -8, 8, 38], [-80+24, -10, -34+16, 36, 12+8, 82]],
  :hp_offset     => [[46, 30], [90, 26]],
  :exp_offset    => [114, 40],
  :name_pos      => [[138, 6, Settings::ROOT[:right]], [22, 2, Settings::ROOT[:left]]],
  :owned_icon    => [2, 3],
  :shiny_icon    => [[154, 5],  [2, 23]],
  :status_icon   => [[182, 28], [18, 24]],
  :special_icon  => [[-12, 14], [231, 10]]
})

# Long databox style.
GameData::DataboxStyle.register({
  :id            => :Long,
  :name          => _INTL("Long"),
  :hp_offset     => [[0, 0], [50, 30]],
  :name_pos      => [[0, 0], [256, 4, Settings::ROOT[:center]]],
  :owned_icon    => [10, 27],
  :shiny_icon    => [[0, 0], [10, 25]],
  :status_icon   => [[0, 0], [4, 4]],
  :special_icon  => [[0, 0], [478, 16]],
  :vertical_anim => true,
  :max_side_size => 1
})

#===============================================================================
# Data box for regular battles
#===============================================================================
class Battle::Scene::RaidPokemonDataBox < Sprite
  attr_reader   :battler
  attr_accessor :selected
  attr_reader   :animatingHP
  attr_reader   :animatingExp

  # Time in seconds to fully fill the Exp bar (from empty).
  EXP_BAR_FILL_TIME  = 1.75
  # Maximum time in seconds to make a change to the HP bar.
  HP_BAR_CHANGE_TIME = 1.0
  STATUS_ICON_HEIGHT = 16
  NAME_BASE_COLOR         = Color.new(72, 72, 72)
  NAME_SHADOW_COLOR       = Color.new(184, 184, 184)
  MALE_BASE_COLOR         = Color.new(48, 96, 216)
  MALE_SHADOW_COLOR       = NAME_SHADOW_COLOR
  FEMALE_BASE_COLOR       = Color.new(248, 88, 40)
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
    initializeDataBoxGraphic(sideSize)
    initializeOtherGraphics(viewport)
    refresh
  end

  def initializeDataBoxGraphic(sideSize)
    onPlayerSide = @battler.index.even?
    # Get the data box graphic and set whether the HP numbers/Exp bar are shown
    if sideSize == 1   # One Pokémon on side, use the regular dara box BG
      bgFilename = ["Graphics/Pictures/Battle/databox_normal",
                    "Graphics/Pictures/Battle/databox_normal_foe"][@battler.index % 2]
      if onPlayerSide
        @showHP  = true
        @showExp = true
      end
    else   # Multiple Pokémon on side, use the thin dara box BG
      bgFilename = ["Graphics/Pictures/Battle/databox_thin",
                    "Graphics/Pictures/Battle/databox_thin_foe"][@battler.index % 2]
    end
    @databoxBitmap&.dispose
    @databoxBitmap = AnimatedBitmap.new(bgFilename)
    # Determine the co-ordinates of the data box and the left edge padding width
    if onPlayerSide
      @spriteX = Graphics.width - 244
      @spriteY = Graphics.height - 192
      @spriteBaseX = 34
    else
      @spriteX = -16
      @spriteY = 36
      @spriteBaseX = 16
    end
    case sideSize
    when 2
      @spriteX += [-12,  12,  0,  0][@battler.index]
      @spriteY += [-20, -34, 34, 20][@battler.index]
    when 3
      @spriteX += [-12,  12, -6,  6,  0,  0][@battler.index]
      @spriteY += [-42, -46,  4,  0, 50, 46][@battler.index]
    end
  end

  def initializeOtherGraphics(viewport)
    # Create other bitmaps
    @numbersBitmap = AnimatedBitmap.new("Graphics/Pictures/Battle/icon_numbers")
    @hpBarBitmap   = AnimatedBitmap.new("Graphics/Pictures/Battle/overlay_hp")
    @expBarBitmap  = AnimatedBitmap.new("Graphics/Pictures/Battle/overlay_exp")
    # Trapstarr's Type Display  # Changed by DemICE 16-Oct-2023 Trapstarr gave me his type icon display script.
    @typeDisplayBitmap = AnimatedBitmap.new(_INTL("Graphics/Pictures/Battle/TypeIcons_Square"))
    # Create sprite to draw HP numbers on
    @hpNumbers = BitmapSprite.new(124, 16, viewport)
    # pbSetSmallFont(@hpNumbers.bitmap)
    @sprites["hpNumbers"] = @hpNumbers
    # Create sprite wrapper that displays HP bar
    @hpBar = Sprite.new(viewport)
    @hpBar.bitmap = @hpBarBitmap.bitmap
    @hpBar.src_rect.height = @hpBarBitmap.height / 3
    @sprites["hpBar"] = @hpBar
    # Create sprite wrapper that displays Exp bar
    @expBar = Sprite.new(viewport)
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

  def dispose
    pbDisposeSpriteHash(@sprites)
    @databoxBitmap.dispose
    @numbersBitmap.dispose
    @hpBarBitmap.dispose
    @expBarBitmap.dispose
    @contents.dispose
    super
  end

  def x=(value)
    super
    @hpBar.x     = value + @spriteBaseX + 102
    @expBar.x    = value + @spriteBaseX + 6
    @hpNumbers.x = value + @spriteBaseX + 80
  end

  def y=(value)
    super
    @hpBar.y     = value + 40
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
          # how big a change it is.
    @hpIncPerFrame = (newHP - oldHP).abs / (HP_BAR_CHANGE_TIME * Graphics.frame_rate)
    # minInc is the smallest amount that HP is allowed to change per frame.
    # This avoids a tiny change in HP still taking HP_BAR_CHANGE_TIME seconds.
    minInc = (rangeHP * 4) / (@hpBarBitmap.width * HP_BAR_CHANGE_TIME * Graphics.frame_rate)
    @hpIncPerFrame = minInc if @hpIncPerFrame < minInc
    @animatingHP   = true
  end

  def animateExp(oldExp, newExp, rangeExp)
    return if rangeExp == 0
    @currentExp     = ($PokemonSystem.quick_level_up == 1) ? newExp : oldExp
    @endExp         = newExp
    @rangeExp       = rangeExp
    # NOTE: Filling the Exp bar from empty to full takes EXP_BAR_FILL_TIME
          # seconds no matter what. Filling half of it takes half as long, etc.
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

  def draw_background
    self.bitmap.blt(0, 0, @databoxBitmap.bitmap, Rect.new(0, 0, @databoxBitmap.width, @databoxBitmap.height))
  end

  def draw_name
    nameWidth = self.bitmap.text_size(@battler.name).width
    nameOffset = 0
    nameOffset = nameWidth - 116 if nameWidth > 116
    pbDrawTextPositions(self.bitmap,
      [[@battler.name, @spriteBaseX + 8 - nameOffset, 12, false, NAME_BASE_COLOR, NAME_SHADOW_COLOR]]
    )
  end

  def draw_level
    # "Lv" graphic
    pbDrawImagePositions(self.bitmap,
      [["Graphics/Pictures/Battle/overlay_lv", @spriteBaseX + 140, 16]]
    )
    # Level number
    pbDrawNumber(@battler.level, self.bitmap, @spriteBaseX + 162, 16)
  end

  def draw_gender
    gender = @battler.displayGender
    return if ![0, 1].include?(gender)
    gender_text  = (gender == 0) ? _INTL("♂") : _INTL("♀")
    base_color   = (gender == 0) ? MALE_BASE_COLOR : FEMALE_BASE_COLOR
    shadow_color = (gender == 0) ? MALE_SHADOW_COLOR : FEMALE_SHADOW_COLOR
    pbDrawTextPositions(self.bitmap, [[gender_text, @spriteBaseX + 126, 12, false, base_color, shadow_color]])
  end

  def draw_status
    return if @battler.status == :NONE
    if @battler.status == :POISON && @battler.statusCount > 0   # Badly poisoned
      s = GameData::Status.count - 1
    else
      s = GameData::Status.get(@battler.status).icon_position
    end
    return if s < 0
    pbDrawImagePositions(self.bitmap, [["Graphics/Pictures/Battle/icon_statuses", @spriteBaseX + 24, 36,
                                        0, s * STATUS_ICON_HEIGHT, -1, STATUS_ICON_HEIGHT]])
  end

  def draw_shiny_icon
    return if !@battler.shiny?
    shiny_x = (@battler.opposes?(0)) ? 206 : -6   # Foe's/player's
    pbDrawImagePositions(self.bitmap, [["Graphics/Pictures/shiny", @spriteBaseX + shiny_x, 36]])
  end

  def draw_special_form_icon
    # Mega Evolution/Primal Reversion icon
    if @battler.mega?
      Console.echo_warn("Mega")
      x_offset = (@battler.index.odd?) ? -45 : 38
      y_offset = (@battler.index.odd?) ? 24 : 34
      pbDrawImagePositions(self.bitmap, [["Graphics/Pictures/Battle/icon_mega", @spriteBaseX + x_offset, y_offset]])
    elsif @battler.primal?
      filename = nil
      if @battler.isSpecies?(:GROUDON)
        filename = "Graphics/Pictures/Battle/icon_primal_Groudon"
      elsif @battler.isSpecies?(:KYOGRE)
        filename = "Graphics/Pictures/Battle/icon_primal_Kyogre"
      end
      primalX = (@battler.opposes?) ? 208 : -28   # Foe's/player's
      pbDrawImagePositions(self.bitmap, [[filename, @spriteBaseX + primalX, 4]]) if filename
    end
  end

  def draw_owned_icon
    return if !@battler.owned? || !@battler.opposes?(0)   # Draw for foe Pokémon only
    pbDrawImagePositions(self.bitmap, [["Graphics/Pictures/Battle/icon_own", @spriteBaseX + 8, 36]])
  end

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
      scale = 1#($PokemonSystem.typedisplay == 4) ? 0.65 : 1
      scaled_width = (type1rect.width * scale).to_i
      scaled_height = (type1rect.height * (scale)).to_i
      type_x = @spriteBaseX + (@hpBar.x + 96) # Changed by Jos 2023-10-21 to edit the position of the hp bar.
      type2_x = type_x + 22 # Spacing
      type_y = @hpBar.y - 26
      if type1 == type2
        typeDisplay.stretch_blt(Rect.new(type2_x, type_y, scaled_width, scaled_height),@typeDisplayBitmap.bitmap,type1rect)
      else
        typeDisplay.stretch_blt(Rect.new(type_x, type_y, scaled_width, scaled_height),@typeDisplayBitmap.bitmap,type1rect)
        typeDisplay.stretch_blt(Rect.new(type2_x, type_y, scaled_width, scaled_height),@typeDisplayBitmap.bitmap,type2rect)
      end
    end
  end

  def draw_pinch
    return if @battler.hp >= (@battler.totalhp / 3)
    return if ![:BLAZE, :TORRENT, :OVERGROW, :SWARM, :STARSTRUCK, :IRRADIATE, :MAESTRO, :SPELLCASTER].include?(@battler.ability.id)
    if @style.id == :Basic
      x_offset = (@battler.index.odd?) ? 227 : -2
      y_offset = (@battler.index.odd?) ? 20 : 26
      pbDrawImagePositions(self.bitmap, [["Graphics/Pictures/Battle/icon_pinch", @spriteBaseX+x_offset, y_offset, 0, 0, -1, 16]])
    else
      pbDrawImagePositions(self.bitmap, [["Graphics/Pictures/Battle/icon_pinch", @spriteBaseX - 24, 36, 0, 0, -1, 16]])
    end
  end

  def refresh
    self.bitmap.clear
    return if !@battler.pokemon
    draw_background
    draw_name
    draw_level
    draw_gender
    draw_status
    draw_shiny_icon
    draw_pinch
    draw_special_form_icon
    draw_owned_icon
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
            # fit in with the rest of the graphics which are doubled in size.
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
          # fit in with the rest of the graphics which are doubled in size.
    w = ((w / 2).round) * 2
    @expBar.src_rect.width = w
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
    pbUpdateSpriteHash(@sprites)
  end
end

#===============================================================================
# Battle databox styles.
#===============================================================================
class Battle::Scene::RaidPokemonDataBox
  attr_reader :style, :spriteX, :spriteY
  
  #-----------------------------------------------------------------------------
  # Text colors for stylized databoxes.
  #-----------------------------------------------------------------------------
  STYLE_BASE_COLOR     = Color.new(248, 248, 248)
  STYLE_SHADOW_COLOR   = Color.new(32, 32, 32)
  DYNAMAX_SHADOW_COLOR = Color.new(248, 32, 32)
  
  #-----------------------------------------------------------------------------
  # Aliases for setting databox style properties if battle rule is enabled.
  #-----------------------------------------------------------------------------
  alias dbk_dxinitializeDataBoxGraphic initializeDataBoxGraphic
  def initializeDataBoxGraphic(sideSize)
    rule = @battler.battle.databoxStyle
    if rule.is_a?(Array)
      @style = GameData::DataboxStyle.try_get(rule.first)
      if @battler.wild?
        case @battler.index
        when 1 then @title = rule[1]
        when 3 then @title = rule[2]
        when 5 then @title = rule[3]
        end
      end
    elsif rule == nil
      @style = GameData::DataboxStyle.try_get(:Basic)
    else
      @style = GameData::DataboxStyle.try_get(rule)
    end
    if @style != nil
      @path = Settings::DELUXE_GRAPHICS_PATH + "Databoxes"
      @databoxBitmap&.dispose
      box = (@battler.index.even?) ? "databox" : "databox_foe"
      try_file = sprintf("%s/%s/%s", @path, @style.id, box)
      if sideSize > @style.max_side_size || !pbResolveBitmap(try_file)
        @style = GameData::DataboxStyle.get(:Basic) 
      end
      @databoxBitmap = AnimatedBitmap.new(sprintf("%s/%s/%s", @path, @style.id, box))
      set_style_properties(sideSize)
    else
      dbk_dxinitializeDataBoxGraphic(sideSize)
    end
  end
  
  alias dbk_dxinitializeOtherGraphics initializeOtherGraphics
  def initializeOtherGraphics(viewport)
    if @style
      @numbersBitmap = AnimatedBitmap.new("Graphics/Pictures/Battle/icon_numbers")
      @hpNumbers = BitmapSprite.new(124, 16, viewport)
      @typeDisplayBitmap = AnimatedBitmap.new(_INTL("Graphics/Pictures/Battle/TypeIcons_Square"))
      @sprites["hpNumbers"] = @hpNumbers
      try_file = sprintf("%s/%s/overlay_exp", @path, @style.id)
      expPath = (pbResolveBitmap(try_file)) ? @style.id : :Basic
      @expBarBitmap = AnimatedBitmap.new(sprintf("%s/%s/overlay_exp", @path, expPath))
      @expBar = Sprite.new(viewport)
      @expBar.bitmap = @expBarBitmap.bitmap
      @sprites["expBar"] = @expBar
      overlay = (@battler.index.even?) ? "overlay_hp" : "overlay_hp_foe"
      @hpBarBitmap = AnimatedBitmap.new(sprintf("%s/%s/%s", @path, @style.id, overlay))
      @hpBar = Sprite.new(viewport)
      @hpBar.bitmap = @hpBarBitmap.bitmap
      @hpBar.src_rect.height = @hpBarBitmap.height / 3
      @sprites["hpBar"] = @hpBar

      # Changed by DemICE 16-Oct-2023 Trapstarr gave me his type icon display script.
      # Trapstarr's Type Display: Create a sprite wrapper that displays Opponents Type
      typeDisplayBitmap = Bitmap.new(Graphics.width, Graphics.height)  
      @typeDisplay = SpriteWrapper.new(viewport)  
      @typeDisplay.bitmap = typeDisplayBitmap  
      @sprites["typeDisplay"] = @typeDisplay
      @sprites["typeDisplay"].z = 198

      @contents = Bitmap.new(@databoxBitmap.width, @databoxBitmap.height)
      self.bitmap  = @contents
      self.visible = false
      self.z       = 150 + ((@battler.index / 2) * 5)
      pbSetSmallFont(self.bitmap)
    else
      dbk_dxinitializeOtherGraphics(viewport)
    end
  end
  
  alias :dbk_dxx= :x=
  def x=(value)
    self.dbk_dxx=(value)
    @hpBar.x  = value + @hpOffsetXY[0]  if @hpOffsetXY
    @expBar.x = value + @expOffsetXY[0] if @expOffsetXY
  end

  alias :dbk_dxy= :y=
  def y=(value)
    self.dbk_dxy=(value)
    @hpBar.y  = value + @hpOffsetXY[1]  if @hpOffsetXY
    @expBar.y = value + @expOffsetXY[1] if @expOffsetXY
  end
  
  alias dbk_dxrefresh refresh
  def refresh
    return if !@battler.pokemon
    if @style
      self.bitmap.clear
      update_style
      draw_background
      draw_style_text
      draw_style_icons
      draw_pinch
      draw_plugin_elements
      refreshHP
      refreshExp
    else
      dbk_dxrefresh
    end
  end
  
  #-----------------------------------------------------------------------------
  # Used to set a databox's style to default in case the side size is changed mid-battle.
  #-----------------------------------------------------------------------------
  def update_style
    sideSize = @battler.battle.pbSideSize(@battler.index)
    if sideSize > @style.max_side_size && @style.id != :Basic
      @style = GameData::DataboxStyle.get(:Basic)
      set_style_properties(sideSize)
      @databoxBitmap&.dispose
      suffix = (@battler.index.odd?) ? "_foe" : ""
      @databoxBitmap = AnimatedBitmap.new(sprintf("%s/%s/databox%s", @path, @style.id, suffix))
      @hpBarBitmap = AnimatedBitmap.new(sprintf("%s/%s/overlay_hp%s", @path, @style.id, suffix))
      @hpBar.bitmap = @hpBarBitmap.bitmap
      @hpBar.src_rect.height = @hpBarBitmap.height / 3
      @sprites["hpBar"] = @hpBar
      @contents = Bitmap.new(@databoxBitmap.width, @databoxBitmap.height)
      self.bitmap = @contents
      pbSetSmallFont(self.bitmap)
    end
  end
  
  #-----------------------------------------------------------------------------
  # Utility for manually changing databox styles mid-battle.
  #-----------------------------------------------------------------------------
  def refresh_style
    old_style = @style
    sideSize = @battler.battle.pbSideSize(@battler.index)
    initializeDataBoxGraphic(sideSize)
    return if @style == old_style
    if @style
      try_exp = sprintf("%s/%s/overlay_exp", @path, @style.id)
      expPath = (pbResolveBitmap(try_exp)) ? @style.id : :Basic
      @expBarBitmap = AnimatedBitmap.new(sprintf("%s/%s/overlay_exp", @path, expPath))
      if @battler.index.odd?
        @hpBarBitmap = AnimatedBitmap.new(sprintf("%s/%s/overlay_hp_foe", @path, @style.id))
      else
        @hpBarBitmap = AnimatedBitmap.new(sprintf("%s/%s/overlay_hp", @path, @style.id))
      end
    else
      @hpOffsetXY   = nil
      @expOffsetXY  = nil
      @expBarBitmap = AnimatedBitmap.new("Graphics/Pictures/Battle/overlay_exp")
      @hpBarBitmap  = AnimatedBitmap.new("Graphics/Pictures/Battle/overlay_hp")
    end
    @expBar.bitmap = @expBarBitmap.bitmap
    @sprites["expBar"] = @expBar
    @hpBar.bitmap = @hpBarBitmap.bitmap
    @hpBar.src_rect.height = @hpBarBitmap.height / 3
    @sprites["hpBar"] = @hpBar
    @contents = Bitmap.new(@databoxBitmap.width, @databoxBitmap.height)
    self.bitmap = @contents
    if @style
      pbSetSmallFont(self.bitmap)
    else
      pbSetSystemFont(self.bitmap)
    end
    refresh
  end
  
  #-----------------------------------------------------------------------------
  # Utility for setting values for each databox element based on style.
  #-----------------------------------------------------------------------------
  def set_style_properties(sideSize)
    shadow = (@battler.dynamax?) ? DYNAMAX_SHADOW_COLOR : STYLE_SHADOW_COLOR
    @nameColors = [STYLE_BASE_COLOR, shadow, :outline]
    if @battler.index.even?
      @spriteX = Graphics.width - @style.sprite_x[0]
      @spriteY = Graphics.height - @style.sprite_y[0]
    else
      @spriteX = @style.sprite_x[1].clone
      @spriteY = @style.sprite_y[1].clone
    end
    if sideSize > 1
      @spriteX += @style.offset_x[sideSize - 2][@battler.index]
      @spriteY += @style.offset_y[sideSize - 2][@battler.index]
    end
    side = (@battler.index.even?) ? 0 : 1
    @spriteBaseX     = @style.sprite_base_x[side].clone
    @hpOffsetXY      = @style.hp_offset[side].clone
    @expOffsetXY     = @style.exp_offset.clone
    @show_exp_bar    = @battler.index.even?
    @show_hp_numbers = false
    @displayPos   = {
      :name    => @style.name_pos[side].clone,
      :owned   => @style.owned_icon.clone,
      :shiny   => @style.shiny_icon[side].clone,
      :status  => @style.status_icon[side].clone,
      :special => @style.special_icon[side].clone
    }
    if @style.id == :Long
      @displayPos[:owned][0] = 2  if @battler.shiny?
      @displayPos[:shiny][0] = 18 if @battler.owned? && @battler.opposes?(0)
    end
    @displayPos.each_key { |k| @displayPos[k][0] += @spriteBaseX }
  end

  #-----------------------------------------------------------------------------
  # Draws plugin elements on a databox. Placeholder to be used by plugins.
  #-----------------------------------------------------------------------------
  def draw_plugin_elements; end
  
  #-----------------------------------------------------------------------------
  # Draws all text elements on a databox based on style.
  #-----------------------------------------------------------------------------
  def draw_style_text
    textpos = []
    namePos = @displayPos[:name]
    if @battler.index.even?
      case @battler.gender
      when 0 then textpos.push(["♂", *namePos, MALE_BASE_COLOR, STYLE_SHADOW_COLOR, @nameColors[2]])
      when 1 then textpos.push(["♀", *namePos, FEMALE_BASE_COLOR, STYLE_SHADOW_COLOR, @nameColors[2]])
      end
      textpos.push([@battler.name, namePos[0] - 16, namePos[1], namePos[2], *@nameColors])
      textpos.push([@battler.level.to_s, namePos[0] + 58, namePos[1], Settings::ROOT[:left], STYLE_BASE_COLOR, STYLE_SHADOW_COLOR])
    elsif 
      if !@battler.wild?
        display_name = @battler.name
      elsif @title
        display_name = _INTL(@title, @battler.name)
      elsif defined?(@battler.pokemon.memento)
        display_name = @battler.name_title(false)
      else
        display_name = @battler.name
      end
      bat_lv = (@style.id == :Basic && @battler.index.odd?) ?  " Lv.#{@battler.level}" : ""
      textpos.push(["#{display_name}#{bat_lv}", *namePos, *@nameColors])
    end
    pbDrawTextPositions(self.bitmap, textpos)
  end

  #-----------------------------------------------------------------------------
  # Draws all images on a databox based on style.
  #-----------------------------------------------------------------------------
  def draw_style_icons
    imagepos = []
    namePos = @displayPos[:name]
    imagepos.push([@path + "/overlay_lv", namePos[0] + 34, namePos[1] + 2]) if @battler.index.even?
    imagepos.push([@path + "/icon_own", *@displayPos[:owned]]) if @battler.owned? && @battler.opposes?(0)
    imagepos.push([@path + "/shiny", *@displayPos[:shiny]]) if @battler.shiny?
    if @battler.status != :NONE
      if @battler.status == :POISON && @battler.statusCount > 0
        s = GameData::Status.count - 1
      else
        s = GameData::Status.get(@battler.status).icon_position
      end
      imagepos.push([_INTL("Graphics/Pictures/Battle/icon_statuses"), *@displayPos[:status], 0, s * STATUS_ICON_HEIGHT, -1, STATUS_ICON_HEIGHT])
    end
    specialPos = @displayPos[:special]
    if @battler.shadowPokemon? && @battler.inHyperMode?
      filename = "Graphics/Pictures/Battle/icon_hyper_mode"
      imagepos.push([filename, specialPos[0] + 4, specialPos[1] + 4])
    elsif @battler.mega?
      base_file = "Graphics/Pictures/Battle/icon_mega"
      try_file = base_file + "_" + @battler.pokemon.speciesName
      filename = (pbResolveBitmap(try_file)) ? try_file : base_file
      imagepos.push([filename, specialPos[0] + 4, specialPos[1] + 4]) if filename
    elsif @battler.primal?
      base_file = "Graphics/Pictures/Battle/icon_primal"
      try_file = base_file + "_" + @battler.pokemon.speciesName
      filename = (pbResolveBitmap(try_file)) ? try_file : base_file
      imagepos.push([filename, *specialPos]) if filename
    elsif @battler.ultra?
      filename = Settings::ZMOVE_GRAPHICS_PATH + "icon_ultra"
      imagepos.push([filename, specialPos[0], specialPos[1] + 2])
    elsif @battler.dynamax?
      filename = Settings::DYNAMAX_GRAPHICS_PATH + "icon_dynamax"
      imagepos.push([filename, *specialPos])
    elsif @battler.tera?
      filename = Settings::TERASTAL_GRAPHICS_PATH + "tera_types"
      type_number = GameData::Type.get(@battler.tera_type).icon_position
      imagepos.push([filename, specialPos[0], specialPos[1] + 2, 0, type_number * 32, 32, 32])
    elsif @battler.battle.raidBattle? && @battler.hasZCrystal?
      filename = _INTL("Graphics/Items/#{@battler.item_id}")
      offsetX = (@battler.index.even?) ? 0   : (@style.id == :Basic) ? -12 : -16
      offsetY = (@battler.index.even?) ? -12 : (@style.id == :Basic) ? -24 : -24
      imagepos.push([filename, specialPos[0] + offsetX, specialPos[1] + offsetY])
    end
    pbDrawImagePositions(self.bitmap, imagepos)
  end
end

#===============================================================================
# Utility for changing databox styles mid-battle.
#===============================================================================
class Battle::Scene
  def pbRefreshStyle(style = nil, *titles)
    return if pbInSafari?
    if GameData::DataboxStyle.exists?(style)
      if titles.length > 0
        args = [style]
        titles.each { |t| args.push(t) }
        @battle.databoxStyle = args
      else
        @battle.databoxStyle = style
      end
    else
      @battle.databoxStyle = nil
    end
    databoxes = []
    @battle.battlers.each { |b| databoxes.push(@sprites["dataBox_#{b.index}"]) if b }
    hideAnim = Animation::DataBoxDisappearAll.new(@sprites, @viewport, databoxes)
    loop do
      hideAnim.update
      pbUpdate
      break if hideAnim.animDone?
    end
    hideAnim.dispose
    databoxes.each { |box| box.refresh_style }
    showAnim = Animation::DataBoxAppearAll.new(@sprites, @viewport, databoxes)
    loop do
      showAnim.update
      pbUpdate
      break if showAnim.animDone?
    end
    showAnim.dispose
  end
end

#===============================================================================
# Aliases to the show/hide animations for certain databox styles.
#===============================================================================
class Battle::Scene::Animation::DataBoxAppear < Battle::Scene::Animation
  alias dbk_dxcreateProcesses createProcesses
  def createProcesses
    sprite = @sprites["dataBox_#{@idxBox}"]
    return if !sprite
    safari = sprite.is_a?(Battle::Scene::SafariDataBox)
    if !sprite.is_a?(Battle::Scene::RaidPokemonDataBox)
      dbk_dxcreateProcesses
    elsif !safari && sprite.style && GameData::DataboxStyle.get(sprite.style).vertical_anim
      box = addSprite(sprite)
      box.setVisible(0, true)
	  # box.refresh
      box.setDelta(0, 0, -sprite.height)
      box.moveDelta(0, 8, 0, sprite.height)
    else
      dbk_dxcreateProcesses
    end
  end
end

class Battle::Scene::Animation::DataBoxDisappear < Battle::Scene::Animation
  alias dbk_dxcreateProcesses createProcesses
  def createProcesses
    sprite = @sprites["dataBox_#{@idxBox}"]
    return if !sprite
    safari = sprite.is_a?(Battle::Scene::SafariDataBox)
    if !sprite.is_a?(Battle::Scene::RaidPokemonDataBox)
      dbk_dxcreateProcesses
    elsif !safari && sprite.style && GameData::DataboxStyle.get(sprite.style).vertical_anim
      box = addSprite(sprite)
      box.moveDelta(0, 8, 0, -sprite.height)
      box.setVisible(8, false)
    else
      dbk_dxcreateProcesses
    end
  end
end

#===============================================================================
# Animations to show/hide all visible databoxes all at once.
#===============================================================================
class Battle::Scene::Animation::DataBoxAppearAll < Battle::Scene::Animation
  def initialize(sprites, viewport, boxes)
    @boxes = boxes
    super(sprites, viewport)
  end

  def createProcesses
    @boxes.each do |box|
      sprite = addSprite(box)
      vertical = box.style && GameData::DataboxStyle.get(box.style).vertical_anim
      dir = (box.battler.index.even?) ? 1 : -1
      delta = (vertical) ? [0, -box.height] : [dir * Graphics.width / 2, 0]
      sprite.setXY(0, box.spriteX, box.spriteY)
      sprite.setDelta(0, *delta)
      sprite.setVisible(0, true) if !box.battler.fainted?
	  # sprite.refresh
      (vertical) ? delta[1] *= -1 : delta[0] *= -1
      sprite.moveDelta(0, 8, *delta)
    end
  end
end

class Battle::Scene::Animation::DataBoxDisappearAll < Battle::Scene::Animation
  def initialize(sprites, viewport, boxes)
    @boxes = boxes
    super(sprites, viewport)
  end

  def createProcesses
    @boxes.each do |box|
      sprite = addSprite(box)
      vertical = box.style && GameData::DataboxStyle.get(box.style).vertical_anim
      dir = (box.battler.index.even?) ? 1 : -1
      delta = (vertical) ? [0, -box.height] : [dir * Graphics.width / 2, 0]
      sprite.moveDelta(0, 8, *delta)
      sprite.setVisible(8, false)
    end
  end
end

