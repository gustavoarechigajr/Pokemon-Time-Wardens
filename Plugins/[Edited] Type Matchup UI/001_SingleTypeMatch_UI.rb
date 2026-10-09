class TypeMatch_Scene
  # Filename for base graphic
  WINDOWSKIN = ""
  # Choose whether you want the background to animate
  MOVINGBACKGROUND = false

  def initialize
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    @sprites = {}
  end

  def pbStartScene
    addBackgroundPlane(@sprites,"bg","TypeMatch/bg",@viewport)
    @h = -4
    @w = 0
    @typebitmap = AnimatedBitmap.new(_INTL("Graphics/Pictures/types"))
    2.times do |i|
      @sprites["icon_#{i}"] = PokemonSpeciesIconSprite.new(nil,@viewport)
      @sprites["icon_#{i}"].setOffset(PictureOrigin::CENTER)
      @sprites["icon_#{i}"].x = Graphics.width/2 - 96 + 192*i
      @sprites["icon_#{i}"].y = @h+34
      @sprites["icon_#{i}"].mirror = true if i==0
    end
    @sprites["rightarrow"] = AnimatedSprite.new("Graphics/Pictures/rightarrow",8,40,28,2,@viewport)
    @sprites["rightarrow"].x = Graphics.width - @sprites["rightarrow"].bitmap.width
    @sprites["rightarrow"].y = 32
    @sprites["rightarrow"].visible = false
    @sprites["rightarrow"].play
    @sprites["leftarrow"] = AnimatedSprite.new("Graphics/Pictures/leftarrow",8,40,28,2,@viewport)
    @sprites["leftarrow"].x = 0
    @sprites["leftarrow"].y = 32
    @sprites["leftarrow"].visible = false
    @sprites["leftarrow"].play
    @sprites["bottombar"] = BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    @sprites["bottombar"].bitmap.fill_rect(0,Graphics.height-32,Graphics.width,32,Color.new(48,192,216))
    @sprites["bottombar"].visible = true
    @sprites["text"] = BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    @overlay_text = @sprites["text"].bitmap
    pbSetSystemFont(@overlay_text)
    @sprites["type"] = BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    @overlay_type = @sprites["type"].bitmap
    @types = []
    GameData::Type.each { |s| @types.push(s.id) if !s.pseudo_type }
    @types.sort!
  end

  def pbTypeMatchUp
    @index = 0
    type = @types[@index]
    @init = true
    drawTypes(type)
    pbFadeInAndShow(@sprites) { pbUpdate }
    loop do
      Graphics.update
      Input.update
      pbUpdate
      refresh = false
      if Input.trigger?(Input::RIGHT) && @index< @types.length-1
        pbPlayCursorSE
        @index +=1
        newType = @types[@index]
        refresh = true
      elsif Input.trigger?(Input::LEFT) && @index> 0
        pbPlayCursorSE
        @index -=1
        newType = @types[@index]
        refresh = true
      elsif Input.trigger?(Input::USE) # Option to choose specific type
        oldType = @types[@index]
        newType = pbChooseTypeFromList(oldType, oldType)
        if oldType != newType
          @index = @types.index(newType)
          refresh = true
        end
      elsif Input.trigger?(Input::BACK)
        pbPlayCloseMenuSE
        break
      end
      drawTypes(newType) if refresh
    end
  end

  def drawTypes(type)
    @sprites["rightarrow"].visible = (@index < @types.length-1) ? true : false
    @sprites["leftarrow"].visible = (@index > 0) ? true : false
    @overlay_type.clear
    s = getRandomSpeciesFromType(type)
    2.times do |i|
      @sprites["icon_#{i}"].pbSetParams(s,0,0,false)
    end
    # Selected type
    type = GameData::Type.get(type)
    type_number = GameData::Type.get(type).icon_position
    @overlay_type.blt(Graphics.width/2-32,@h+20,@typebitmap.bitmap,
                  Rect.new(0, type_number * 28, 64, 28))
    # Type Calcs #
    base_types = []
    calc_tpye_eff = []
    GameData::Type.each do |data|
      next if data.id == :QMARKS
      base_types.push(data.id)
    end
    for i in 0...base_types.length
      type_calc = Effectiveness.calculate(base_types[i], s.types[0], s.types[1])
      calc_eff = "x0" if Effectiveness.immune?(type_calc)
      calc_eff = " 0" if Effectiveness.neutral?(type_calc)
      calc_eff = "-2" if Effectiveness.barely_effective?(type_calc)
      calc_eff = "-1" if Effectiveness.not_so_effective?(type_calc)
      calc_eff = "+1" if Effectiveness.pretty_effective?(type_calc)
      calc_eff = "+2" if Effectiveness.hyper_effective?(type_calc)
      calc_tpye_eff.push(calc_eff)
    end
    for i in 0...calc_tpye_eff.length
      calc = calc_tpye_eff[i]
      case calc
        when "x0"; then icon_eff = "eff - x0"
        when " 0"; then icon_eff = "eff - 0"
        when "-2"; then icon_eff = "eff - 2"
        when "-1"; then icon_eff = "eff - 1"
        when "+1"; then icon_eff = "eff - x1"
        when "+2"; then icon_eff = "eff - x2"
      else
         icon_eff = "eff - 0"
      end
      @sprites["calc_#{i}"] = IconSprite.new(0, 0, @viewport)
      @sprites["calc_#{i}"].setBitmap("Graphics/Pictures/TypeMatch/" + icon_eff)
      @sprites["calc_#{i}"].x = 26 + (66 * (i % 7))
      @sprites["calc_#{i}"].y = 68 + (96 * (i / 7))
    end
    # Type Calcs #
    base   = Color.new(80,80,88)
    shadow = Color.new(160,160,168)
    textpos = [
      ["USE: Jump",4,Graphics.height-26,0,Color.new(248,248,248),Color.new(72,80,88)],
      ["ARROWS: Navigate",Graphics.width/2,Graphics.height-26,2,Color.new(248,248,248),Color.new(72,80,88)],
      ["BACK: Exit",Graphics.width-4,Graphics.height-26,1,Color.new(248,248,248),Color.new(72,80,88)]
    ]
    pbDrawTextPositions(@overlay_text,textpos) if @init
    @init = false
  end

  # Method that pulls a random species of the given type
  def getRandomSpeciesFromType(type)
    arr = []
    GameData::Species.each { |s| arr.push(s.id) if s.form==0 && (s.types[0]==type || s.types[1]==type) && s.generation <6 }
    return arr[rand(arr.length)]
  end

  def pbUpdate
    pbUpdateSpriteHash(@sprites)
    if @sprites["bg"] && MOVINGBACKGROUND
      @sprites["bg"].ox-=1
      @sprites["bg"].oy-=1
    end
  end

  # Dipose stuff at the end
  def pbEndScene
    pbFadeOutAndHide(@sprites) { pbUpdate }
    pbDisposeSpriteHash(@sprites)
    @typebitmap.dispose
    @viewport.dispose
  end

  # Borrowed from the editor scripts
  # Renamed so as to not break anything anywhere else
  def pbChooseTypeFromList(default = nil, currType)
    commands = []
    GameData::Type.each { |t| commands.push([commands.length + 1, t.name, t.id]) if !t.pseudo_type }
    return pbChooseList(commands, default, currType, 1)
  end
end

class TypeMatch_Screen
  
  def initialize(scene)
    @scene = scene
  end

  def pbStartScreen
    @scene.pbStartScene
    @scene.pbTypeMatchUp
    @scene.pbEndScene
  end
  
end

def pbTypeMatchUI
  pbFadeOutIn {
    scene = TypeMatch_Scene.new
    screen = TypeMatch_Screen.new(scene)
    screen.pbStartScreen
  }
end