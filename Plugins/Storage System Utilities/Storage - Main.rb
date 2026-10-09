#===============================================================================
# Storage System Utilities
# By Swdfm
# Works For Both Essentials Version 20 and 21
#===============================================================================
STORAGE_ARROW_PATH = "Graphics/Pictures/Storage/"

# Can Boxes be quickly swapped by selecting "Swap" from the Box Heading?
CAN_SWAP_BOXES   = true

# Can multiple Pokemon be selected/moved at the same time using the green hand?
CAN_MULTI_SELECT = true

# Can Pokemon be mass released by pressing the Action Key while having multiple Pokemon grabed? 
# Need to have CAN_MULTI_SELECT selected
CAN_MASS_RELEASE = true

# Can one "pour" Pokemon into a box?
# This lets you quickly store held Pokemon into a box by clicking Use button on page header while moving held Pokemon
CAN_BOX_POUR     = false

#===============================================================================
# Using Version 21 or not?
#===============================================================================
def pbVersion21?
  return Essentials::VERSION.include?("21")
end

#===============================================================================
# Nitty Gritty below here!
# Don't touch unless you knwo what you're doing!
#===============================================================================
# PokemonBoxIcon Overrides
#===============================================================================
class PokemonBoxIcon < IconSprite
  #===============================================================================
  # Turns the sprite(s) into a certain colour
  #===============================================================================
  def make_clear
    @type = :Clear
  end
  def make_green
    @type = :Green
  end
  def make_grey
    @type = :Grey
  end
  
  #===============================================================================
  # update Override
  #===============================================================================
  def update
    super
    @type = :Clear if !@type
    return update_21 if pbVersion21?
    @release.update
    do_colours
    self.color = Color.new(0, 0, 0, 0)
     if @pokemon != nil && $PokemonStorage.sortType != nil
       self.tone = Tone.new(255,0,0,255) if !@pokemon.types.include?($PokemonStorage.sortType)
     elsif @pokemon != nil && $PokemonStorage.sortSpecies != nil
       self.tone = Tone.new(0,255,0,255) if @pokemon.species == $PokemonStorage.sortSpecies
     elsif @pokemon != nil && $PokemonStorage.sortItems != nil
       self.tone = Tone.new(0,0,255,255) if @pokemon.hasItem? == $PokemonStorage.sortItems
     elsif @pokemon != nil && ($PokemonStorage.sortType == nil || $PokemonStorage.sortSpecies == nil || $PokemonStorage.sortItems == nil)
       self.tone = Tone.new(0,0,0,0)
     else
       self.tone = Tone.new(0,0,0,0)
     end
    dispose if @startRelease && !releasing?
  end
  
  def update_21
    do_colours
    if releasing?
      time_now = System.uptime
      self.zoom_x = lerp(1.0, 0.0, 1.5, @release_timer_start, System.uptime)
      self.zoom_y = self.zoom_x
      self.opacity = lerp(255, 0, 1.5, @release_timer_start, System.uptime)
      if self.opacity == 0
        @release_timer_start = nil
        dispose
      end
    end
  end
  
  def do_colours
    case @type
    when :Clear
      self.color = Color.new(0, 0, 0, 0)
    when :Green
      self.color = Color.new(0, 128, 0, 192)
    when :Grey
      self.color = Color.new(128, 128, 128, 255)
    end
  end
end

#===============================================================================
# PokemonBoxArrow Override
#===============================================================================
class PokemonBoxArrow < Sprite
  attr_accessor :multi
  
  #===============================================================================
  # initialize Add On
  #===============================================================================
  alias swdfm_init initialize
  def initialize(viewport = nil)
    swdfm_init(viewport)
    @path  = STORAGE_ARROW_PATH
    if @path == ""
      @path  = "Graphics/Pictures/Storage/"
      @path  = "Graphics/UI/Storage/" if pbVersion21?
    end
    @multi = false
    @handsprite.addBitmap("point1g", @path + "cursor_point_1_g")
    @handsprite.addBitmap("point2g", @path + "cursor_point_2_g")
    @handsprite.addBitmap("grabg", @path + "cursor_grab_g")
    @handsprite.addBitmap("fistg", @path + "cursor_fist_g")
  end
  
  #===============================================================================
  # update Override (v20)
  #===============================================================================
  def update
    @updating = true
    super
    return update_21 if pbVersion21?
    heldpkmn = heldPokemon
    heldpkmn&.update
    @handsprite.update
    @holding = false if !heldpkmn
    t = @tension
    b = @multi ? "g" : (@quickswap ? "q" : "")
    if @grabbingState > 0
      if @grabbingState <= 4 * Graphics.frame_rate / 20
        @handsprite.changeBitmap("grab" + b)
        self.y = @spriteY + (4.0 * @grabbingState * 20 / Graphics.frame_rate)
        @grabbingState += 1
      elsif @grabbingState <= 8 * Graphics.frame_rate / 20
        @holding = true
        @handsprite.changeBitmap("fist" + b)
        self.y = @spriteY + (4 * ((8 * Graphics.frame_rate / 20) - @grabbingState) * 20 / Graphics.frame_rate)
        @grabbingState += 1
      else
        @grabbingState = 0
      end
    elsif @placingState > 0
      if @placingState <= 4 * Graphics.frame_rate / 20
        @handsprite.changeBitmap("fist" + b)
        self.y = @spriteY + (4.0 * @placingState * 20 / Graphics.frame_rate)
        @placingState += 1
      elsif @placingState <= 8 * Graphics.frame_rate / 20
        @holding = false
        @heldpkmn = nil
        @handsprite.changeBitmap("grab" + b)
        self.y = @spriteY + (4 * ((8 * Graphics.frame_rate / 20) - @placingState) * 20 / Graphics.frame_rate)
        @placingState += 1
      else
        @placingState = 0
      end
    elsif holding?
      @handsprite.changeBitmap("fist" + b)
    elsif t == :Selecting
      @handsprite.changeBitmap("grab" + b)
    elsif t == :Moving
      @handsprite.changeBitmap("fist" + b)
    else   # Idling
      self.x = @spriteX
      self.y = @spriteY
      if @frame < Graphics.frame_rate / 2
        @handsprite.changeBitmap("point1" + b)
      else
        @handsprite.changeBitmap("point2" + b)
      end
    end
    @frame += 1
    @frame = 0 if @frame >= Graphics.frame_rate
    @updating = false
  end
  
  #===============================================================================
  # update Override (v21)
  #===============================================================================
  def update_21
    heldpkmn = heldPokemon
    heldpkmn&.update
    @handsprite.update
    @holding = false if !heldpkmn
    t = @tension
    b = @multi ? "g" : (@quickswap ? "q" : "")
    if @grabbing_timer_start
      if System.uptime - @grabbing_timer_start <= GRAB_TIME / 2
        @handsprite.changeBitmap("grab" + b)
        self.y = @spriteY + lerp(0, 16, GRAB_TIME / 2, @grabbing_timer_start, System.uptime)
      else
        @holding = true
        @handsprite.changeBitmap("fist" + b)
        delta_y = lerp(16, 0, GRAB_TIME / 2, @grabbing_timer_start + (GRAB_TIME / 2), System.uptime)
        self.y = @spriteY + delta_y
        @grabbing_timer_start = nil if delta_y == 0
      end
    elsif @placing_timer_start
      if System.uptime - @placing_timer_start <= GRAB_TIME / 2
        @handsprite.changeBitmap("fist" + b)
        self.y = @spriteY + lerp(0, 16, GRAB_TIME / 2, @placing_timer_start, System.uptime)
      else
        @holding = false
        @heldpkmn = nil
        @handsprite.changeBitmap("grab" + b)
        delta_y = lerp(16, 0, GRAB_TIME / 2, @placing_timer_start + (GRAB_TIME / 2), System.uptime)
        self.y = @spriteY + delta_y
        @placing_timer_start = nil if delta_y == 0
      end
    elsif holding?
      @handsprite.changeBitmap("fist" + b)
    elsif t == :Selecting
      @handsprite.changeBitmap("grab" + b)
    elsif t == :Moving
      @handsprite.changeBitmap("fist" + b)
    else   # Idling
      self.x = @spriteX
      self.y = @spriteY
      if (System.uptime / 0.5).to_i.even?   # Changes every 0.5 seconds
        @handsprite.changeBitmap("point1" + b)
      else
        @handsprite.changeBitmap("point2" + b)
      end
    end
    @updating = false
  end
  
  #===============================================================================
  # Additional methods: Tension
  # Used For Multiple Grabbing
  #===============================================================================
  def set_tension
    @tension = :Selecting # 1
  end
  
  def start_tension
    @tension = :Moving # 2
  end
  
  def release_tension
    @tension = :None # 0
  end
end

#===============================================================================
# PokemonStorageScene Override
#===============================================================================
class PokemonStorageScene
  attr_reader :multi
  
  #===============================================================================
  # pbStartBox Addition
  #===============================================================================
  alias swdfm_start_box pbStartBox
  def pbStartBox(*args)
    @grabber = StorageGrabber.new
    swdfm_start_box(*args)
  end
  
  #===============================================================================
  # pbSetArrow Addition
  #===============================================================================
  alias swdfm_set_arrow pbSetArrow
  def pbSetArrow(arrow, selection)
    swdfm_set_arrow(arrow, selection)
    return unless selection >= 0
    t = @multi && @grabber.holding_anything? && !@grabber.carrying
    return unless t
    @grabber.do_with(selection)
    do_green
  end
  
  #===============================================================================
  # pbChangeSelection Addition
  #===============================================================================
  alias swdfm_change_sel pbChangeSelection
  def pbChangeSelection(key, selection)
    skip = @multi && @grabber.holding_anything? && !@grabber.carrying
    case key
    when Input::UP
      case selection
      when -1   # Box name
        selection = -2
      when -2   # Party
        selection = PokemonBox::BOX_SIZE - 1 - (PokemonBox::BOX_WIDTH * 2 / 3)   # 25
      when -3   # Close Box
        selection = PokemonBox::BOX_SIZE - (PokemonBox::BOX_WIDTH / 3)   # 28
      else
        selection -= PokemonBox::BOX_WIDTH
        if skip && selection < 0
          selection += PokemonBox::BOX_SIZE
        elsif selection < 0
          selection = -1
        end
      end
    when Input::DOWN
      case selection
      when -1   # Box name
        selection = PokemonBox::BOX_WIDTH / 3   # 2
      when -2   # Party
        selection = -1
      when -3   # Close Box
        selection = -1
      else
        selection += PokemonBox::BOX_WIDTH
        if skip && selection >= PokemonBox::BOX_SIZE
          selection -= PokemonBox::BOX_SIZE
        elsif selection >= PokemonBox::BOX_SIZE
          if selection < PokemonBox::BOX_SIZE + (PokemonBox::BOX_WIDTH / 2)
            selection = -2   # Party
          else
            selection = -3   # Close Box
          end
        end
      end
    when Input::LEFT, Input::RIGHT
      selection = swdfm_change_sel(key, selection)
    end
    return selection
  end

  #===============================================================================
  # pbSelectBoxInternal Override
  #===============================================================================
  def pbSelectBoxInternal(_party)
    selection = @selection
    pbSetArrow(@sprites["arrow"], selection)
    pbUpdateOverlay(selection)
    pbSetMosaic(selection)
    loop do
      Graphics.update
      Input.update
      key = -1
      key = Input::DOWN if Input.repeat?(Input::DOWN)
      key = Input::RIGHT if Input.repeat?(Input::RIGHT)
      key = Input::LEFT if Input.repeat?(Input::LEFT)
      key = Input::UP if Input.repeat?(Input::UP)
      if key >= 0
        pbPlayCursorSE
        selection = pbChangeSelection(key, selection)
        pbSetArrow(@sprites["arrow"], selection)
        case selection
        when -4
          nextbox = (@storage.currentBox + @storage.maxBoxes - 1) % @storage.maxBoxes
          pbSwitchBoxToLeft(nextbox)
          @storage.currentBox = nextbox
        when -5
          nextbox = (@storage.currentBox + 1) % @storage.maxBoxes
          pbSwitchBoxToRight(nextbox)
          @storage.currentBox = nextbox
        end
        selection = -1 if [-4, -5].include?(selection)
        pbUpdateOverlay(selection)
        pbSetMosaic(selection)
      end
      self.update
      t = @grabber.holding_anything? && !@grabber.carrying
      if Input.trigger?(Input::JUMPUP) && !t
        pbPlayCursorSE
        nextbox = (@storage.currentBox + @storage.maxBoxes - 1) % @storage.maxBoxes
        pbSwitchBoxToLeft(nextbox)
        @storage.currentBox = nextbox
        pbUpdateOverlay(selection)
        pbSetMosaic(selection)
      elsif Input.trigger?(Input::JUMPDOWN) && !t
        pbPlayCursorSE
        nextbox = (@storage.currentBox + 1) % @storage.maxBoxes
        pbSwitchBoxToRight(nextbox)
        @storage.currentBox = nextbox
        pbUpdateOverlay(selection)
        pbSetMosaic(selection)
      elsif Input.trigger?(Input::SPECIAL) && !t   # Jump to box name
        if selection != -1
          pbPlayCursorSE
          selection = -1
          pbSetArrow(@sprites["arrow"], selection)
          pbUpdateOverlay(selection)
          pbSetMosaic(selection)
        end
      elsif Input.trigger?(Input::ACTION) && @command == 0   # Organize only
        if !t && !@grabber.carrying
          pbPlayDecisionSE
          pbSetQuickSwap(!@quickswap)
        elsif @grabber.carrying && CAN_MASS_RELEASE
          pbMassRelease
        end
      elsif Input.trigger?(Input::BACK)
        @selection = selection
        return nil
      elsif Input.trigger?(Input::USE)
        @selection = selection
        if selection >= 0
          return [@storage.currentBox, selection]
        elsif selection == -1   # Box name
          return [-4, -1]
        elsif selection == -2   # Party Pokémon          
          return [-2, -1] if !@multi
          pbMassRelease if @grabber.carrying && @multi
        elsif selection == -3   # Close Box
          return [-3, -1]
        end
      end
    end
  end

  #===============================================================================
  # pbSelectPartyInternal Override
  #===============================================================================
  def pbSelectPartyInternal(party, depositing)
    selection = @selection
    pbPartySetArrow(@sprites["arrow"], selection)
    pbUpdateOverlay(selection, party)
    pbSetMosaic(selection)
    lastsel = 1
    loop do
      Graphics.update
      Input.update
      key = -1
      key = Input::DOWN if Input.repeat?(Input::DOWN)
      key = Input::RIGHT if Input.repeat?(Input::RIGHT)
      key = Input::LEFT if Input.repeat?(Input::LEFT)
      key = Input::UP if Input.repeat?(Input::UP)
      if key >= 0
        pbPlayCursorSE
        newselection = pbPartyChangeSelection(key, selection)
        case newselection
        when -1
          return -1 if !depositing
        when -2
          selection = lastsel
        else
          selection = newselection
        end
        pbPartySetArrow(@sprites["arrow"], selection)
        lastsel = selection if selection > 0
        pbUpdateOverlay(selection, party)
        pbSetMosaic(selection)
      end
      self.update
      if Input.trigger?(Input::ACTION) && @command == 0   # Organize only
        pbPlayDecisionSE
        pbSetQuickSwap(!@quickswap, true)
      elsif Input.trigger?(Input::BACK)
        @selection = selection
        return -1
      elsif Input.trigger?(Input::USE)
        if selection >= 0 && selection < Settings::MAX_PARTY_SIZE
          @selection = selection
          return selection
        elsif selection == Settings::MAX_PARTY_SIZE   # Close Box
          @selection = selection
          return (depositing) ? -3 : -1
        end
      end
    end
  end
  
  #===============================================================================
  # New Method To Swap Boxes
  #===============================================================================
  def pbSwapBoxes(newbox)
    return if @storage.currentBox == newbox
    @storage.swap(newbox, @storage.currentBox)
    @sprites["box"].update
    refresh_box_sprites
  end
  
  #===============================================================================
  # pbSetQuickSwap Override
  #===============================================================================
  def pbSetQuickSwap(value, ignore_multi = false)
    ignore_multi = true if !CAN_MULTI_SELECT
    #mod me
    # Set to Quickswap
    if @screen.pbHeldPokemon
     if !@quickswap
      @quickswap = true
     else
      @quickswap = false
     end
    else
     if !@quickswap && !@multi
      @quickswap = true
      @multi     = false
     elsif @quickswap && !@multi && !ignore_multi 
      @quickswap = false
      @multi     = true
    # Set to white
     else
      @quickswap = false
      @multi     = false
     end
    end
    @sprites["arrow"].quickswap = @quickswap
    @sprites["arrow"].multi = @multi
  end
  
  #===============================================================================
  # pbChooseBox
  #===============================================================================
  def pbChooseBox(msg, swapping = false)
    commands = []
    @storage.maxBoxes.times do |i|
      box = @storage[i]
      if box
        if swapping  && i == @storage.currentBox
          commands.push("Don't Swap")
          next
        end
        commands.push(_INTL("{1} ({2}/{3})", box.name, box.nitems, box.length))
      end
    end
    return pbShowCommands(msg, commands, @storage.currentBox)
  end

  def pbUpdateOverlay(selection, party = nil)
    overlay = @sprites["overlay"].bitmap
    overlay.clear
    buttonbase = Color.new(248, 248, 248)
    buttonshadow = Color.new(80, 80, 80)
    if @grabber.carrying
      pbDrawTextPositions(
        overlay,
        [[_INTL("Release All"), 270, 334, 2, buttonbase, buttonshadow, 1],
         [_INTL("Exit"), 446, 334, 2, buttonbase, buttonshadow, 1]]
      )
      else
      pbDrawTextPositions(
        overlay,
        [[_INTL("Party: {1}", (@storage.party.length rescue 0)), 270, 334, 2, buttonbase, buttonshadow, 1],
         [_INTL("Exit"), 446, 334, 2, buttonbase, buttonshadow, 1]]
      )
      end
    pokemon = nil
    if @screen.pbHeldPokemon
      pokemon = @screen.pbHeldPokemon
    elsif selection >= 0
      pokemon = (party) ? party[selection] : @storage[@storage.currentBox, selection]
    end
    if !pokemon
      @sprites["pokemon"].visible = false
      return
    end
    @sprites["pokemon"].visible = true
    base   = Color.new(88, 88, 80)
    shadow = Color.new(168, 184, 184)
    nonbase   = Color.new(208, 208, 208)
    nonshadow = Color.new(224, 224, 224)
    pokename = pokemon.name
    dexnum = pbGetRegionalNumber(0, pokemon.species)
    textstrings = [
      [pokename, 10, 14, false, base, shadow]
    ]
    if !pokemon.egg?
      imagepos = []
      if pokemon.male?
        textstrings.push([_INTL("♂"), 148, 14, false, Color.new(24, 112, 216), Color.new(136, 168, 208)])
      elsif pokemon.female?
        textstrings.push([_INTL("♀"), 148, 14, false, Color.new(248, 56, 32), Color.new(224, 152, 144)])
      end
      imagepos.push(["Graphics/Pictures/Storage/overlay_lv", 6, 246])
      textstrings.push([pokemon.level.to_s, 28, 240, false, base, shadow])
      textstrings.push([_INTL("Dex.{1}",dexnum), 164, 240, 1, base, shadow])
      if pokemon.ability
        textstrings.push([pokemon.ability.name, 86, 312, 2, base, shadow])
      else
        textstrings.push([_INTL("No ability"), 86, 312, 2, nonbase, nonshadow])
      end
      if pokemon.item
        textstrings.push([pokemon.item.name, 86, 348, 2, base, shadow])
      else
        textstrings.push([_INTL("No item"), 86, 348, 2, nonbase, nonshadow])
      end
      if pokemon.shiny?
        imagepos.push(["Graphics/Pictures/shiny", 156, 198])
      end
      typebitmap = AnimatedBitmap.new(_INTL("Graphics/Pictures/types"))
      pokemon.types.each_with_index do |type, i|
        type_number = GameData::Type.get(type).icon_position
        type_rect = Rect.new(0, type_number * 28, 64, 28)
        type_x = (pokemon.types.length == 1) ? 52 : 18 + (70 * i)
        overlay.blt(type_x, 272, typebitmap.bitmap, type_rect)
      end
      #drawMarkings(overlay, 70, 240, 128, 20, pokemon.markings)
      pbDrawImagePositions(overlay, imagepos)
    end
    pbDrawTextPositions(overlay, textstrings)
    @sprites["pokemon"].setPokemonBitmap(pokemon)
  end
  
  #===============================================================================
  # Additional methods
  #===============================================================================  
  # Tension: Used For Multiple Grabbing
  #===============================================================================
  def grabber
    return @grabber
  end
  
  def set_tension
    @sprites["arrow"].set_tension
  end
  
  def start_tension
    @sprites["arrow"].start_tension
  end
  
  def release_tension
    @sprites["arrow"].release_tension
  end
  
  #===============================================================================
  # Sets all necessary sprites to green
  #===============================================================================
  def do_green
    piv   = @grabber.mock_pivot
    piv_x = piv % PokemonBox::BOX_WIDTH
    piv_y = (piv / PokemonBox::BOX_WIDTH).floor
    sels = []
    for i in @grabber.mons
      x = i[0] + piv_x
      y = i[1] + piv_y
      sel = x + PokemonBox::BOX_WIDTH * y
      sels.push(sel)
    end
    for i in 0...PokemonBox::BOX_SIZE
      boxpokesprite = @sprites["box"].getPokemon(i)
      if sels.include?(i)
        boxpokesprite.make_green if boxpokesprite!=nil
      else
        boxpokesprite.make_clear if boxpokesprite!=nil
      end
    end
  end
  
  #===============================================================================
  # Method to refresh all box sprites
  #===============================================================================
  def refresh_box_sprites
    @sprites["box"].refreshSprites = true
    @sprites["box"].refreshBox = true
    pbHardRefresh
  end
  
  #===============================================================================
  # Changes from wherever the anchor is to the top left of the selection
  #===============================================================================
  def quick_change(selection)
    pbSetArrow(@sprites["arrow"], selection)
    pbUpdateOverlay(selection)
    pbSetMosaic(selection)
    @selection = selection
  end
  
  #===============================================================================
  # Shortcut to mass release
  #===============================================================================
  def pbMassRelease
    @screen.pbMassRelease
  end
  
  #===============================================================================
  # Greys all necessary sprites
  #===============================================================================
  def do_greys(ableProc = nil)
    return if !ableProc
    for i in 0...(PokemonBox::BOX_SIZE + PokemonBox::BOX_WIDTH)
      if i < PokemonBox::BOX_SIZE
        boxpokesprite = @sprites["box"].getPokemon(i)
      else
        boxpokesprite = @sprites["boxparty"].getPokemon(i-30)
      end
      next if !boxpokesprite
      next if !boxpokesprite.getPokemon
      if ableProc.call(boxpokesprite.getPokemon)
        boxpokesprite.make_clear
      else
        boxpokesprite.make_grey
      end
    end
  end
end

#===============================================================================
# PokemonStorageScreen Override
#===============================================================================
class PokemonStorageScreen
  #===============================================================================
  # pbStartScreen Override
  #===============================================================================
  def pbStartScreen(command)
    $game_temp.in_storage = true
    @heldpkmn = nil
    case command
    when 0   # Organise
      @scene.pbStartBox(self, command)
      loop do
        selected = @scene.pbSelectBox(@storage.party)
        if selected.nil?
          if pbHeldPokemon
            pbDisplay(_INTL("You're holding a Pokémon!"))
            next
          elsif @scene.grabber.carrying
            pbDisplay(_INTL("You're holding Pokémon!"))
            next
          end
          next if pbConfirm(_INTL("Continue Box operations?"))
          break
        elsif selected[0] == -3   # Close box
          if pbHeldPokemon
            pbDisplay(_INTL("You're holding a Pokémon!"))
            next
          elsif @scene.grabber.carrying
            pbDisplay(_INTL("You're holding Pokémon!"))
            next
          end
          if pbConfirm(_INTL("Exit from the Box?"))
            pbSEPlay("PC close")
            break
          end
          next
        elsif selected[0] == -4   # Box name
          if @scene.grabber.carrying && CAN_BOX_POUR
            if pbPour(selected)
              @scene.grabber.carrying = false
              @scene.grabber.clear
              @scene.release_tension
            end
          else
            pbBoxCommands
          end
        else
          pokemon = @storage[selected[0], selected[1]]
          heldpoke = pbHeldPokemon
          next if !pokemon && !heldpoke && !@scene.grabber.carrying
          if @scene.quickswap
            if @heldpkmn
              (pokemon) ? pbSwap(selected) : pbPlace(selected)
            else
              pbHold(selected)
            end
          elsif @scene.multi
            if !@scene.grabber.carrying
              if @scene.grabber.holding_anything?
                @scene.grabber.carrying = true
                # Gathers held mons data in @carried_mons in the grabber
                @scene.grabber.pack_up(@storage, selected[0])
                # Deletes mon off storage
                pbHold_Multi(selected)
                @scene.start_tension
                # Moves the hand to mock pivot position
                @scene.quick_change(@scene.grabber.mock_pivot)
                selected[1] = @scene.grabber.mock_pivot
              else
                # Start tension here
                @scene.grabber.setPivot(selected[1])
                @scene.grabber.do_with(selected[1])
                @scene.do_green
                @scene.set_tension
              end
            else
              # Drop Off If Possible
              if @scene.grabber.place_with_positions(@storage, selected[0], selected[1])
                pbPlace_Multi(selected)
                # @scene.grabber.get_new_carried_mons
                @scene.grabber.carrying = false
                @scene.grabber.clear
                @scene.release_tension
              else
                next
              end
            end
          else
            commands = []
            cmdMove     = -1
            cmdSummary  = -1
            cmdWithdraw = -1
            cmdItem     = -1
            cmdMark     = -1
            cmdRelease  = -1
            cmdDebug    = -1
            if heldpoke
              helptext = _INTL("{1} is selected.", heldpoke.name)
              commands[cmdMove = commands.length] = (pokemon) ? _INTL("Shift") : _INTL("Place")
            elsif pokemon
              helptext = _INTL("{1} is selected.", pokemon.name)
              commands[cmdMove = commands.length] = _INTL("Move")
            end
            commands[cmdSummary = commands.length]  = _INTL("Summary")
            commands[cmdWithdraw = commands.length] = (selected[0] == -1) ? _INTL("Store") : _INTL("Withdraw")
            commands[cmdItem = commands.length]     = _INTL("Item")
            commands[cmdMark = commands.length]     = _INTL("Mark")
            commands[cmdRelease = commands.length]  = _INTL("Release")
            commands[cmdDebug = commands.length]    = _INTL("Debug") if ($DEBUG && $BOSSDEV)
            commands[commands.length]               = _INTL("Cancel")
            command = pbShowCommands(helptext, commands)
            if cmdMove >= 0 && command == cmdMove   # Move/Shift/Place
              if @heldpkmn
                (pokemon) ? pbSwap(selected) : pbPlace(selected)
              else
                pbHold(selected)
              end
            elsif cmdSummary >= 0 && command == cmdSummary   # Summary
              pbSummary(selected, @heldpkmn)
            elsif cmdWithdraw >= 0 && command == cmdWithdraw   # Store/Withdraw
              (selected[0] == -1) ? pbStore(selected, @heldpkmn) : pbWithdraw(selected, @heldpkmn)
            elsif cmdItem >= 0 && command == cmdItem   # Item
              pbItem(selected, @heldpkmn)
            elsif cmdMark >= 0 && command == cmdMark   # Mark
              pbMark(selected, @heldpkmn)
            elsif cmdRelease >= 0 && command == cmdRelease   # Release
              pbRelease(selected, @heldpkmn)
            elsif cmdDebug >= 0 && command == cmdDebug   # Debug
              pbPokemonDebug((@heldpkmn) ? @heldpkmn : pokemon, selected, heldpoke)
            end
          end
        end
      end
      @scene.pbCloseBox
    when 1   # Withdraw
      @scene.pbStartBox(self, command)
      loop do
        selected = @scene.pbSelectBox(@storage.party)
        if selected.nil?
          next if pbConfirm(_INTL("Continue Box operations?"))
          break
        else
          case selected[0]
          when -2   # Party Pokémon
            pbDisplay(_INTL("Which one will you take?"))
            next
          when -3   # Close box
            if pbConfirm(_INTL("Exit from the Box?"))
              pbSEPlay("PC close")
              break
            end
            next
          when -4   # Box name
            pbBoxCommands
            next
          end
          pokemon = @storage[selected[0], selected[1]]
          next if !pokemon
          command = pbShowCommands(_INTL("{1} is selected.", pokemon.name),
                                   [_INTL("Withdraw"),
                                    _INTL("Summary"),
                                    _INTL("Mark"),
                                    _INTL("Release"),
                                    _INTL("Cancel")])
          case command
          when 0 then pbWithdraw(selected, nil)
          when 1 then pbSummary(selected, nil)
          when 2 then pbMark(selected, nil)
          when 3 then pbRelease(selected, nil)
          end
        end
      end
      @scene.pbCloseBox
    when 2   # Deposit
      @scene.pbStartBox(self, command)
      loop do
        selected = @scene.pbSelectParty(@storage.party)
        if selected == -3   # Close box
          if pbConfirm(_INTL("Exit from the Box?"))
            pbSEPlay("PC close")
            break
          end
          next
        elsif selected < 0
          next if pbConfirm(_INTL("Continue Box operations?"))
          break
        else
          pokemon = @storage[-1, selected]
          next if !pokemon
          command = pbShowCommands(_INTL("{1} is selected.", pokemon.name),
                                   [_INTL("Store"),
                                    _INTL("Summary"),
                                    _INTL("Mark"),
                                    _INTL("Release"),
                                    _INTL("Cancel")])
          case command
          when 0 then pbStore([-1, selected], nil)
          when 1 then pbSummary([-1, selected], nil)
          when 2 then pbMark([-1, selected], nil)
          when 3 then pbRelease([-1, selected], nil)
          end
        end
      end
      @scene.pbCloseBox
    when 3
      @scene.pbStartBox(self, command)
      @scene.pbCloseBox
    end
    $game_temp.in_storage = false
  end
  
  #===============================================================================
  # pbBoxCommands Override
  #===============================================================================
  def pbBoxCommands
    c_consts = [:SWAP]
    c_consts.push(:SORTBOX)
    c_consts.push(:SORTPC)
    c_consts.push(:JUMP) if CAN_SWAP_BOXES
    c_consts.push(:WALL, :NAME, :CANCEL)
    commands = [(($PokemonStorage.boxes.length <= 90) ? _INTL("Swap") : _INTL("Jump"))]
    commands.push(_INTL("Sort Box"))
    commands.push(_INTL("Sort PC"))
    commands.push((($PokemonStorage.boxes.length <= 90) ? _INTL("Jump") : _INTL("Search"))) if CAN_SWAP_BOXES
    commands.push(
      _INTL("Wallpaper"),
      _INTL("Name"),
      _INTL("Cancel")
    )
    command = pbShowCommands(_INTL("What do you want to do?"), commands)
    box = $PokemonStorage.boxes.length
    case c_consts[command]
    when :SWAP
	  if box <= 90
        pbBoxOrganizer(@storage.currentBox, @scene)
      else
        destbox = @scene.pbChooseBox(_INTL("Jump to which Box?"))
        @scene.pbJumpToBox(destbox) if destbox >= 0
	  end
    when :SORTBOX
      sort_Box
    when :SORTPC
      sort_PC
    when :JUMP
	  if box <= 90
        destbox = @scene.pbChooseBox(_INTL("Jump to which Box?"))
        @scene.pbJumpToBox(destbox) if destbox >= 0
      else
        pbSearchSubMenu(false)
	  end
    when :WALL
      papers = @storage.availableWallpapers
      index = 0
      papers[1].length.times do |i|
        if papers[1][i] == @storage[@storage.currentBox].background
          index = i
          break
        end
      end
      wpaper = pbShowCommands(_INTL("Pick the wallpaper."), papers[0], index)
      @scene.pbChangeBackground(papers[1][wpaper]) if wpaper >= 0
    when :NAME
      @scene.pbBoxName(_INTL("Box name?"), 0, 12)
    end
  end

  def sort_Box
    ret = pbSortPokemon()
    if ret == -2
      pbDisplay(_INTL("{1} is empty.", $PokemonStorage.boxes[$PokemonStorage.currentBox].name))
    elsif ret == -1
    else
      @scene.pbHardRefresh
      pbDisplay(_INTL("{1} was sorted.", $PokemonStorage.boxes[$PokemonStorage.currentBox].name))
    end
  end
  
  def sort_PC
    minbox = @scene.pbChooseBox(_INTL("Which box to sort first?"))
    return if minbox == -1
    maxbox = @scene.pbChooseBox(_INTL("Which box to sort last?"))
    return if maxbox == -1
    ret = pbSortPokemon(minbox, maxbox)
    if ret == -2
      pbDisplay(_INTL("#{minbox == maxbox ? $PokemonStorage.boxes[minbox].name : "{1} to {2}"} is empty.", $PokemonStorage.boxes[minbox].name, $PokemonStorage.boxes[maxbox].name))
    elsif ret == -1
    else
      @scene.pbHardRefresh
      pbDisplay(_INTL("#{minbox == maxbox ? $PokemonStorage.boxes[minbox].name : "{1} to {2}"} was sorted.", $PokemonStorage.boxes[minbox].name, $PokemonStorage.boxes[maxbox].name))
    end
  end
  
  # Sorting derived from VeryBasic's sorting mod from Pokemon Reborn
  def pbSortPokemon(minbox=$PokemonStorage.currentBox, maxbox=$PokemonStorage.currentBox)
    pcempty = false
    boxes = minbox <= maxbox ? (minbox..maxbox).to_a : (minbox...maxbox).to_a + (0..maxbox).to_a
    for b in boxes
      for s in 0...$PokemonStorage.boxes[b].length
        if $PokemonStorage.boxes[b][s]
          pcempty = false
          break
        end
      end
    end
    return -2 if pcempty
    commands = [
      _INTL("Name"),
      _INTL("Level"),
      _INTL("Dex No."),
      _INTL("Type"),
      #_INTL("Item"),
    ]
    command = pbShowCommands(_INTL("How would you like to sort\n#{minbox == maxbox ? $PokemonStorage.boxes[minbox].name : "{1} to {2}"}?", $PokemonStorage.boxes[minbox].name, $PokemonStorage.boxes[maxbox].name), commands)
    return -1 if command == -1
    pokemon = []
    eggs = []
    for box in boxes
      for slot in 0...$PokemonStorage.boxes[box].length
        poke = $PokemonStorage.boxes[box][slot]
        if poke
          poke.egg? ? eggs.push(poke) : pokemon.push(poke)
          $PokemonStorage.boxes[box][slot] = nil
        end
      end
    end
    default = ->(x, y) { 2 * (x.species <=> y.species) + (x.form <=> y.form) }
    case command
    when 0 # Name
      pokes = pokemon.sort do |x, y|
        name = x.name <=> y.name
        name == 0 ? default.call(x, y) : name
      end
    when 1 # Level
      pokes = pokemon.sort do |x, y|
        level = y.level <=> x.level
        level == 0 ? default.call(x, y) : level
      end
    when 2 # Dex No.
      pokes = pokemon.sort do |x, y|
        dexno = x.dexno <=> y.dexno
        dexno == 0 ? default.call(x, y) : dexno
      end
    when 3 # Type
      pokes = pokemon.sort do |x, y|
        type = (2 * (x.types[0] <=> y.types[0]))
        type == 0 ? default.call(x, y) : type
      end
#    when 4  # Held Item
#      pokes = pokemon.sort do |x, y|
#        if x.item.nil? && !y.item.nil?
#          1
#        elsif !x.item.nil? && y.item.nil?
#          -1
#        else
#          item = x.item <=> y.item
#          item == 0 ? default.call(x, y) : item
#        end
#      end
    end
    if eggs != []
      eggs = eggs.sort { |x, y| default.call(x, y) }
      pokes += eggs
    end
    for box in boxes
      for slot in 0...$PokemonStorage.boxes[box].length
        $PokemonStorage.boxes[box][slot] = pokes.shift
        break if pokes.empty?
      end
    end
  end

  #===============================================================================
  # ***Additional methods***
  #===============================================================================
  def pbHold_Multi(selected)
    box, index = selected
    if box == -1 && pbAble?(@storage[box, index]) && pbAbleCount <= 1
      pbPlayBuzzerSE
      pbDisplay(_INTL("That's your last Pokémon!"))
      return
    end
    for i in @scene.grabber.get_carried_mons
      @storage.pbDelete(box, i)
    end
    index = @scene.grabber.get_carried_mons[0]
    @heldpkmn = @storage[box, index]
    @scene.refresh_box_sprites
    @scene.pbRefresh
  end
  
  def pbPlace_Multi(selected)
    box, index = selected
    for i in @scene.grabber.get_new_carried_mons(index)
      this_index = i[0]
      if @storage[box, this_index]
        raise _INTL("Position {1}, {2} is not empty...", box, this_index)
      end
      if box != -1 && this_index >= @storage.maxPokemon(box)
        pbDisplay("Can't place that there.")
        return
      end
      this_pkmn = i[1]
      if box >= 0 && this_pkmn
        this_pkmn.formTime = nil if this_pkmn.respond_to?("formTime")
        this_pkmn.form     = 0 if this_pkmn.isSpecies?(:SHAYMIN)
        this_pkmn.heal
      end
      @storage[box,this_index] = this_pkmn
      if box==-1
        @storage.party.compact!
      end
    end
    @scene.refresh_box_sprites
    @scene.pbRefresh
    @heldpkmn = nil
  end
  
  #===============================================================================
  # Puts all held Pokemon into available slots in a box
  #===============================================================================
  def pbPour(selected)
    box = @storage.currentBox
    mons_to_place = @scene.grabber.carried_mons.clone
    count = 0
    for i in 0...PokemonBox::BOX_SIZE
      next if @storage[box, i]
      m_t_p = mons_to_place.pop
      @storage[box, i] = m_t_p[0]
      count += 1
      break if mons_to_place.empty?
    end
    emptied = mons_to_place.empty?
    @scene.grabber.pour(count)
    @scene.refresh_box_sprites
    @scene.pbRefresh
    @heldpkmn = nil if emptied
    return emptied
  end
  
  #===============================================================================
  # Releases all held Pokemon
  #===============================================================================
  def pbMassRelease
    if @scene.grabber.contains_an_egg?
      pbDisplay(_INTL("You can't release an Egg!"))
      return false
    end
    # NOTE: No need to stop if last mon because this cannot be done in party!
    command = pbShowCommands(_INTL("Release these Pokémon?"), [_INTL("No"), _INTL("Yes")])
    return unless command == 1
    @scene.grabber.clear
    @scene.pbRefresh
    pbDisplay(_INTL("The Pokémon were released."))
    pbDisplay(_INTL("Bye-bye, Pokémon!"))
    @scene.pbRefresh
    @scene.grabber.carrying = false
    @scene.release_tension
  end

  #===============================================================================
  # Take Item Command to account for runes
  #===============================================================================
  def pbItem(selected, heldpoke)
    box = selected[0]
    index = selected[1]
    pokemon = (heldpoke) ? heldpoke : @storage[box, index]
    if pokemon.egg?
      pbDisplay(_INTL("Eggs can't hold items."))
      return
    elsif pokemon.mail
      pbDisplay(_INTL("Please remove the mail."))
      return
    end
    if pokemon.item
      itemname = pokemon.item.name
      if pbConfirm(_INTL("Take this {1}?", itemname))
        if pokemon.item.has_flag?("AbilityRune")
          $game_switches[Runic_Constants::RUNICSWITCH] = false
          pbDisplay(_INTL("The {1} Was reabsorbed by the Runic Slab.", itemname, pokemon.name))
          pokemon.item = nil
          @scene.pbHardRefresh
        elsif $bag.add(pokemon.item)
          pbDisplay(_INTL("Took the {1}.", itemname))
          pokemon.item = nil
          @scene.pbHardRefresh
        else
          pbDisplay(_INTL("Can't store the {1}.", itemname))
        end
      end
    else
      item = scene.pbChooseItem($bag)
      if item
        itemname = GameData::Item.get(item).name
        pokemon.item = item
        $bag.remove(item)
        pbDisplay(_INTL("{1} is now being held.", itemname))
        @scene.pbHardRefresh
      end
    end
  end
end

class PokemonStorage
  def allWallpapers
    return [
      # Basic wallpapers
      _INTL("Forest"), _INTL("City"), _INTL("Desert"), _INTL("Savanna"),
      _INTL("Crag"), _INTL("Volcano"), _INTL("Snow"), _INTL("Cave"),
      _INTL("Beach"), _INTL("Seafloor"), _INTL("River"), _INTL("Sky"),
      _INTL("Poké Center"), _INTL("Machine"), _INTL("Checks"), _INTL("Simple"),
      # Special wallpapers
      _INTL("Space"), _INTL("Backyard"), _INTL("Nostalgic 1"), _INTL("Torchic"),
      _INTL("Trio 1"), _INTL("PikaPika 1"), _INTL("Legend 1"), _INTL("Team Galactic 1"),
      _INTL("Distortion"), _INTL("Contest"), _INTL("Nostalgic 2"), _INTL("Croagunk"),
      _INTL("Trio 2"), _INTL("PikaPika 2"), _INTL("Legend 2"), _INTL("Team Galactic 2"),
      _INTL("Heart"), _INTL("Soul"), _INTL("Big Brother"), _INTL("Pokéathlon"),
      _INTL("Trio 3"), _INTL("Spiky Pika"), _INTL("Kimono Girl"), _INTL("Revival"),
      _INTL("Retro"),
      #Nat Dexer
      _INTL("Nat 1"),_INTL("Nat 2"),_INTL("Nat 3"),_INTL("Nat 4"),_INTL("Nat 5"),
      _INTL("Nat 6"),_INTL("Nat 7"),_INTL("Nat 8"),_INTL("Nat 9"),_INTL("Nat 10"),
      _INTL("Nat 11"),_INTL("Nat 12"),_INTL("Nat 13"),_INTL("Nat 14"),_INTL("Nat 15"),
      _INTL("Nat 16"),_INTL("Nat 17"),_INTL("Nat 18"),_INTL("Nat 19"),_INTL("Nat 20"),
      _INTL("Nat 21"),_INTL("Nat 22"),_INTL("Nat 23"),_INTL("Nat 24"),_INTL("Nat 25"),
      _INTL("Nat 26"),_INTL("Nat 27"),_INTL("Nat 28"),_INTL("Nat 29"),_INTL("Nat 30"),
      _INTL("Nat 31"),_INTL("Nat 32"),_INTL("Nat 33"),_INTL("Nat 34"),_INTL("Nat 35"),
      _INTL("Nat 36"),_INTL("Nat 37"),_INTL("Nat 38"),_INTL("Nat 39"),_INTL("Nat 40")
    ]
  end

  def pbUnlockBox(amount=1,maxPokemon=30)
    amount+=@boxes.length
    for i in @boxes.length...amount
      ip1=i+1
      @boxes[i]=PokemonBox.new(_ISPRINTF("Box {1:d}",ip1),maxPokemon)
      backid=i%40
      @boxes[i].background="box#{backid}"
    end
  end
end

def pbEmptyPocket(index)
  if !$PokemonGlobal.pcItemStorage
    $PokemonGlobal.pcItemStorage = PCItemStorage.new
  end
  index += 1
  count = $bag.pockets[index].length
  storage = $PokemonGlobal.pcItemStorage.items
  bag = $bag.pockets[index]
   if count >= 1
   for i in 0...count
    storage.push(bag[i])
   end
   bag = []
   $bag.pockets[index] = bag
   pbMessage(_INTL("All items in the {1} Pocket have been stored in the Item Storage", Settings.bag_pocket_names[index-1]))
  else
   pbMessage(_INTL("There are no items in the {1} Pocket", Settings.bag_pocket_names[index-1]))
  end
end

def pbForceDepositPocket
  command = 0
  loop do
    command = pbShowCommandsWithHelp(nil,[_INTL("Dump all Items"),_INTL("Dump all Medicine"),_INTL("Dump all Poké Balls"),_INTL("Dump all Evolution Items"),_INTL("Dump all Berries"),_INTL("Dump all Specialty Items"),_INTL("Dump all Battle Items"),_INTL("Dump all Key Items"),_INTL("Exit")],[_INTL("Dump all the items within the Items Pocket"),_INTL("Dump all the items within the Medicine Pocket"),_INTL("Dump all the items within the Poké Balls Pocket"),_INTL("Dump all the items within the Evolution Pocket"),_INTL("Dump all the items within the Berries Pocket"),_INTL("Dump all the items within the Specialty Pocket"),_INTL("Dump all the items within the Battle Items Pocket"),_INTL("Dump all the items within the Key Items Pocket"),_INTL("Go back to the previous menu.")], -1, command)
    if command != -1 && command != 8
      pbEmptyPocket(command)
      break
    else
      break
    end
  end
end

def pbTrainerPCMenu
  command = 0
  cmd = [_INTL("Item Storage"),_INTL("Mailbox"),_INTL("Deposit Items"),_INTL("Turn Off")]
  loop do
    command = pbMessage(_INTL("What do you want to do?"),cmd, -1, nil, command)
    case command
    when 0 then pbPCItemStorage
    when 1 then pbPCMailbox
    when 2 then pbForceDepositPocket 
    else break
    end
  end
end

class Pokemon
  def dexno
    dexnum = pbGetRegionalNumber(0, self.species)
    return dexnum
  end
end
