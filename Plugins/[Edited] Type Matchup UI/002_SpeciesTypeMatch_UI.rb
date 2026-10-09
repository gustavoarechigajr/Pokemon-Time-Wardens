class SpeciesTypeMatch_Scene
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
      @sprites["icon_#{i}"].x = Graphics.width/2 - 112 + 224*i
      @sprites["icon_#{i}"].y = @h+40
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
    pbSetSystemFont(@overlay_type)
    region = pbGetCurrentRegion
    @blacklist = []
    GameData::Species.each { |s|
      @blacklist.push(s.id) if s.real_form_name == "Anomaly" || (Settings::LEGEND_LIST.include?(s.species) && !$player.pokedex.owned?(s.id))
    }
    @blacklist.push(:ARCEUS_97)
    @blacklist.push(:ARCEUS_98)
    @blacklist.push(:ARCEUS_99)
    # If no Regional Dex defined for the given region, use the National Pokédex
    if !@species || @species.length == 0
      @species = []
      @old_species = []
      GameData::Species.each { |s| @species.push(s.id) if !@blacklist.include?(s.id); @old_species.push(s.id) if !@blacklist.include?(s.id) } # Changed by DemICE 29-Sep-2023 to fix forms not being included
    end
    @types = []
    GameData::Type.each { |t| @types.push(t.id) if !t.pseudo_type }
  end

  def pbTypeMatchUp
    @index = 0
    species = @species[@index]
    @init = true
    tts_name = GameData::Species.get(species).real_name
    Kernel.tts("Type Matchup for #{tts_name}.",true)
    Kernel.tts("USE Button: Jump to Different Species.")
    Kernel.tts("Action Button: Swap to Party Mode.")
    Kernel.tts("LEFT and RIGHT: Switch to next/Previous Species.")
    Kernel.tts("Special Button: Filter Species List bu Type.")
    Kernel.tts("Control Button: Announce current Species type Matchups.")
    drawSpeciesTypes(species)
    pbFadeInAndShow(@sprites) { pbUpdate }
    default=true
    loop do
      Graphics.update
      Input.update
      pbUpdate
      refresh = false
      if Input.trigger?(Input::RIGHT) && @index< @species.length-1
        pbPlayCursorSE
        @index +=1
        newSpecies = @species[@index]
        refresh = true
      elsif Input.trigger?(Input::LEFT) && @index> 0
        pbPlayCursorSE
        @index -=1
        newSpecies = @species[@index]
        refresh = true
      elsif Input.trigger?(Input::USE) # Option to choose specific type
        oldSpecies = @species[@index]
        newSpecies = pbChooseSpeciesFromList(oldSpecies, oldSpecies)
        if oldSpecies != newSpecies
          @index = @species.index(newSpecies)
          refresh = true
        end
      elsif Input.trigger?(Input::SPECIAL) # Changed by PDM20 22-Oct-2023
        oldSpecies = @species[@index]
        newSpecies = pbChooseMonoTypeSpecies(oldSpecies, oldSpecies)
        if oldSpecies != newSpecies
          @index = @species.index(newSpecies)
          refresh = true
        end
      elsif Input.trigger?(Input::ACTION) # Changed by DemICE 23-Sep-2023
        @species = @old_species
        if $Trainer.party.length>0
          pbPlayCursorSE
          @species=[]
          if default==true
            for i in $Trainer.party
              @species.push(i.species) # Changed by DemICE 29-Sep-2023 to fix forms not being included. # Changed by PDM20 to avoid a crash happening when you pressed Action and Use consecutively.
            end
            default=false
            @index=0
            newSpecies = @species[@index]
            refresh = true
          else
            region = pbGetCurrentRegion
            #@species = pbAllRegionalSpecies(region)
            # If no Regional Dex defined for the given region, use the National Pokédex
            GameData::Species.each { |s| @species.push(s.id) if !@blacklist.include?(s.id) } # Changed by DemICE 29-Sep-2023 to fix forms not being included
            default=true
            @index=0
            newSpecies = @species[@index]
            refresh = true
          end
        end
      elsif Input.trigger?(Input::CTRL) && TTS_ENABLED
        drawSpeciesTypes(@species[@index], true)
      elsif Input.trigger?(Input::BACK)
        pbPlayCloseMenuSE
        break
      end
      drawSpeciesTypes(newSpecies) if refresh
    end
  end

  def drawSpeciesTypes(species, speak = false)
    @sprites["rightarrow"].visible = (@index < @species.length-1) ? true : false
    @sprites["leftarrow"].visible = (@index > 0) ? true : false
    @overlay_type.clear
    s = GameData::Species.get(species)
    2.times do |i|
      @sprites["icon_#{i}"].pbSetParams(s.id,0,s.form,false)
    end
    # Types of selected Pokémon
    s.types.each_with_index do |type, i|
      type_number = GameData::Type.get(type).icon_position
      type_rect = Rect.new(0, type_number * 28, 64, 28)
      type_x = (s.types.length == 1) ? Graphics.width/2-32 : Graphics.width/2 - (64 * ((i + 1)%2))
      @overlay_type.blt(type_x,@h+36,@typebitmap.bitmap,type_rect)
    end
    # Type Matchups #
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
        when "x0"; icon_eff = "eff - x0"
        when " 0"; icon_eff = "eff - 0"
        when "-2"; icon_eff = "eff - 2"
        when "-1"; icon_eff = "eff - 1"
        when "+1"; icon_eff = "eff - x1"
        when "+2"; icon_eff = "eff - x2"
        else;      icon_eff = "eff - 0"
      end
      @sprites["calc_#{i}"] = IconSprite.new(0, 0, @viewport)
      @sprites["calc_#{i}"].setBitmap("Graphics/Pictures/TypeMatch/" + icon_eff)
      @sprites["calc_#{i}"].x = 26 + (66 * (i % 7))
      @sprites["calc_#{i}"].y = 68 + (96 * (i / 7))
    end
    # Type Matchups #
    base   = Color.new(80,80,88)
    shadow = Color.new(160,160,168)
    textpos = [
      ["USE: Jump",4,Graphics.height-26,0,Color.new(248,248,248),Color.new(72,80,88)],
      ["ARROWS: Navigate",Graphics.width*0.4,Graphics.height-26,2,Color.new(248,248,248),Color.new(72,80,88)],
      ["ACTION: Party Mode",Graphics.width-4,Graphics.height-26,1,Color.new(248,248,248),Color.new(72,80,88)] # Changed by DemICE 23-Sep-2023
    ]
    tts_name = s.real_name
    tts_form = (s.form > 0) ? s.real_form_name : ""
    Kernel.tts("Type Matchups for #{tts_name} #{tts_form}.") if !speak
    if speak
      tts_types = (s.types.length > 1) ? "#{s.types[0]} #{s.types[1]} Type" : "#{s.types[0]} Type"
      Kernel.tts("Type Matchups for #{tts_types} #{tts_name} #{tts_form}.",true)
      ttsData = {
        :restx4 => [],
        :restx2 => [],
        :weakx4 => [],
        :weakx2 => [],
        :immune => []
      }
      for tts in 0...base_types.length
        ttsData[:immune].push(base_types[tts]) if calc_tpye_eff[tts] == "x0"
        ttsData[:weakx4].push(base_types[tts]) if calc_tpye_eff[tts] == "+2"
        ttsData[:restx4].push(base_types[tts]) if calc_tpye_eff[tts] == "-2"
        ttsData[:restx4].push(base_types[tts]) if calc_tpye_eff[tts] == "-1"
        ttsData[:weakx2].push(base_types[tts]) if calc_tpye_eff[tts] == "+1"
      end
      immune, weakx2, weakx4, restx2, restx4 = "", "", "", "", ""
      if ttsData[:immune] != []
        for im in 0...ttsData[:immune].length; immune += "#{GameData::Type.get(ttsData[:immune][im]).real_name} "; end
      end
      if ttsData[:weakx4] != []
        for w4 in 0...ttsData[:weakx4].length; weakx4 += "#{GameData::Type.get(ttsData[:weakx4][w4]).real_name} "; end
      end
      if ttsData[:weakx2] != []
        for w2 in 0...ttsData[:weakx2].length; weakx2 += "#{GameData::Type.get(ttsData[:weakx2][w2]).real_name} "; end
      end
      if ttsData[:restx4] != []
        for r4 in 0...ttsData[:restx4].length; restx4 += "#{GameData::Type.get(ttsData[:restx4][r4]).real_name} "; end
      end
      if ttsData[:restx2] != []
        for r2 in 0...ttsData[:restx2].length; restx2 += "#{GameData::Type.get(ttsData[:restx2][r2]).real_name} "; end
      end
      Kernel.tts("#{s.real_name} is Immune to #{immune}") if ttsData[:immune] != []
      Kernel.tts("#{s.real_name} is 4 times weak to #{weakx4}") if ttsData[:weakx4] != []
      Kernel.tts("#{s.real_name} is weak to #{weakx2}") if ttsData[:weakx2] != []
      Kernel.tts("#{s.real_name} is 4 times resist to #{restx4}") if ttsData[:restx4] != []
      Kernel.tts("#{s.real_name} is resist to #{restx2}") if ttsData[:restx2] != []
    end
    pbDrawTextPositions(@overlay_text,textpos) if @init
    # Draw species name
    pbDrawTextPositions(@overlay_type,[
           [s.real_name,Graphics.width/2,@h+10,2,base,shadow]
        ])
    @init = false
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
  def pbChooseSpeciesFromList(default = nil, currSpecies)
    commands = []
    @species.each do |s|
      t = GameData::Species.get(s)
      if t.real_form_name.nil?
        formname=""
      else
        formname=" - "+t.real_form_name
        formname=" - Mega" if formname.include?("Mega")
      end
      commands.push([commands.length + 1, t.real_name+formname, t.id]) #if t.form == 0  # Changed by DemICE 29-Sep-2023 to fix forms not being included
    end
    return pbChooseList(commands, default, currSpecies, 1) # Changed by DemICE 29-Sep-2023 to make the list alphabetical
  end

  # Borrowed from the editor scripts
  # Renamed so as to not break anything anywhere else
  def pbChooseMonoTypeSpecies(default = nil, currSpecies)
   cmd = 0
   typeName = ["Normal","Fighting","Flying","Poison","Ground","Rock","Bug","Ghost","Steel","Fire","Water","Grass","Electric","Psychic","Ice","Dragon","Dark","Fairy","Cosmic","Sound","Light"]
   typeID = [:NORMAL,:FIGHTING,:FLYING,:POISON,:GROUND,:ROCK,:BUG,:GHOST,:STEEL,:FIRE,:WATER,:GRASS,:ELECTRIC,:PSYCHIC,:ICE,:DRAGON,:DARK,:FAIRY,:COSMIC,:SOUND,:LIGHT]
   cmdType = []
   for i in 0...21
    cmdType.push(_INTL(typeName[i]))
   end
   loop do
    cmd = pbMessage(_INTL("Select a Type to filter"),cmdType, 0, nil, cmd)
    index = cmd if cmd != -1
    case index
     when index
     commands = []
     @species.each do |s|
       mon = GameData::Species.get(s)
       if mon.types.include?(typeID[index])
         t = GameData::Species.get(s)
         if t.real_form_name.nil?
           formname=""
         else
           formname=" - "+t.real_form_name
           formname=" - Mega" if formname.include?("Mega")
         end
         commands.push([commands.length + 1, t.real_name+formname, t.id]) #if t.form == 0  # Changed by DemICE 29-Sep-2023 to fix forms not being included
       end
     end
     return pbChooseList(commands, default, currSpecies, 1) # Changed by DemICE 29-Sep-2023 to make the list alphabetical
    else
      break
    end
   end
  end
end

class SpeciesTypeMatch_Screen
  
  def initialize(scene)
    @scene = scene
  end

  def pbStartScreen
    @scene.pbStartScene
    @scene.pbTypeMatchUp
    @scene.pbEndScene
  end
  
end

def pbSpeciesTypeMatchUI
  pbFadeOutIn {
    scene = SpeciesTypeMatch_Scene.new
    screen = SpeciesTypeMatch_Screen.new(scene)
    screen.pbStartScreen
  }
end
