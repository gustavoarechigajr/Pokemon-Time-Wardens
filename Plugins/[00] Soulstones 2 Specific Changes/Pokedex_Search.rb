class PokedexSearchSelectionSprite < Sprite

  def mode=(value)
    @mode = value
    case @mode
    when 0     # Order
      @xstart = 46
      @ystart = 128
      @xgap = 236
      @ygap = 64
      @cols = 2
    when 1     # Name
      @xstart = 78
      @ystart = 114
      @xgap = 52
      @ygap = 52
      @cols = 7
    when 2     # Type
      @xstart = -10
      @ystart = 100
      @xgap = 102
      @ygap = 46
      @cols = 5
    when 3, 4   # Height, weight
      @xstart = 44
      @ystart = 110
      @xgap = 8
      @ygap = 112
    when 5     # Color
      @xstart = 62
      @ystart = 114
      @xgap = 132
      @ygap = 52
      @cols = 3
    when 6     # Shape
      @xstart = 82
      @ystart = 116
      @xgap = 70
      @ygap = 70
      @cols = 5
    end
  end

end

class PokemonPokedex_Scene
  def pbRefreshDexSearchParam(mode, cmds, sel, _index)
    overlay = @sprites["overlay"].bitmap
    overlay.clear
    base   = Color.new(248, 248, 248)
    shadow = Color.new(72, 72, 72)
    # Write various bits of text
    textpos = [
      [_INTL("Search Mode"), Graphics.width / 2, 10, 2, base, shadow],
      [_INTL("OK"), 80, 346, 2, base, shadow, 1],
      [_INTL("Cancel"), Graphics.width - 80, 346, 2, base, shadow, 1]
    ]
    title = [_INTL("Order"), _INTL("Name"), _INTL("Type"), _INTL("Height"),
             _INTL("Weight"), _INTL("Color"), _INTL("Shape")][mode]
    textpos.push([title, 102, (mode == 6) ? 70 : 64, 0, base, shadow])
    case mode
    when 0   # Order
      xstart = 46
      ystart = 128
      xgap = 236
      ygap = 64
      halfwidth = 92
      cols = 2
      selbuttony = 0
      selbuttonheight = 44
    when 1   # Name
      xstart = 78
      ystart = 114
      xgap = 52
      ygap = 52
      halfwidth = 22
      cols = 7
      selbuttony = 156
      selbuttonheight = 44
    when 2   # Type
      xstart = -10
      ystart = 100
      xgap = 102
      ygap = 46
      halfwidth = 62
      cols = 5
      selbuttony = 44
      selbuttonheight = 44
    when 3, 4   # Height, weight
      xstart = 44
      ystart = 110
      xgap = 304 / (cmds.length + 1)
      ygap = 112
      halfwidth = 60
      cols = cmds.length + 1
    when 5   # Color
      xstart = 62
      ystart = 114
      xgap = 132
      ygap = 52
      halfwidth = 62
      cols = 3
      selbuttony = 44
      selbuttonheight = 44
    when 6   # Shape
      xstart = 82
      ystart = 116
      xgap = 70
      ygap = 70
      halfwidth = 0
      cols = 5
      selbuttony = 88
      selbuttonheight = 68
    end
    # Draw selected option(s) text in top bar
    case mode
    when 2   # Type icons
      2.times do |i|
        if !sel[i] || sel[i] < 0
          textpos.push(["----", 298 + (128 * i), 66, 2, base, shadow, 1])
        else
          type_number = @typeCommands[sel[i]].icon_position
          typerect = Rect.new(0, type_number * 32, 96, 32)
          overlay.blt(250 + (128 * i), 58, @typebitmap.bitmap, typerect)
        end
      end
    when 3   # Height range
      ht1 = (sel[0] < 0) ? 0 : (sel[0] >= @heightCommands.length) ? 999 : @heightCommands[sel[0]]
      ht2 = (sel[1] < 0) ? 999 : (sel[1] >= @heightCommands.length) ? 0 : @heightCommands[sel[1]]
      hwoffset = false
      if System.user_language[3..4] == "US"    # If the user is in the United States
        ht1 = (sel[0] >= @heightCommands.length) ? 99 * 12 : (ht1 / 0.254).round
        ht2 = (sel[1] < 0) ? 99 * 12 : (ht2 / 0.254).round
        txt1 = sprintf("%d'%02d''", ht1 / 12, ht1 % 12)
        txt2 = sprintf("%d'%02d''", ht2 / 12, ht2 % 12)
        hwoffset = true
      else
        txt1 = sprintf("%.1f", ht1 / 10.0)
        txt2 = sprintf("%.1f", ht2 / 10.0)
      end
      textpos.push([txt1, 286, 66, 2, base, shadow, 1])
      textpos.push([txt2, 414, 66, 2, base, shadow, 1])
      overlay.blt(462, 52, @hwbitmap.bitmap, Rect.new(0, (hwoffset) ? 44 : 0, 32, 44))
    when 4   # Weight range
      wt1 = (sel[0] < 0) ? 0 : (sel[0] >= @weightCommands.length) ? 9999 : @weightCommands[sel[0]]
      wt2 = (sel[1] < 0) ? 9999 : (sel[1] >= @weightCommands.length) ? 0 : @weightCommands[sel[1]]
      hwoffset = false
      if System.user_language[3..4] == "US"   # If the user is in the United States
        wt1 = (sel[0] >= @weightCommands.length) ? 99_990 : (wt1 / 0.254).round
        wt2 = (sel[1] < 0) ? 99_990 : (wt2 / 0.254).round
        txt1 = sprintf("%.1f", wt1 / 10.0)
        txt2 = sprintf("%.1f", wt2 / 10.0)
        hwoffset = true
      else
        txt1 = sprintf("%.1f", wt1 / 10.0)
        txt2 = sprintf("%.1f", wt2 / 10.0)
      end
      textpos.push([txt1, 286, 66, 2, base, shadow, 1])
      textpos.push([txt2, 414, 66, 2, base, shadow, 1])
      overlay.blt(462, 52, @hwbitmap.bitmap, Rect.new(32, (hwoffset) ? 44 : 0, 32, 44))
    when 5   # Color
      if sel[0] < 0
        textpos.push(["----", 362, 66, 2, base, shadow, 1])
      else
        textpos.push([cmds[sel[0]].name, 362, 66, 2, base, shadow, 1])
      end
    when 6   # Shape icon
      if sel[0] >= 0
        shaperect = Rect.new(0, @shapeCommands[sel[0]].icon_position * 60, 60, 60)
        overlay.blt(332, 50, @shapebitmap.bitmap, shaperect)
      end
    else
      if sel[0] < 0
        text = ["----", "-", "----", "", "", "----", ""][mode]
        textpos.push([text, 362, 66, 2, base, shadow, 1])
      else
        textpos.push([cmds[sel[0]], 362, 66, 2, base, shadow, 1])
      end
    end
    # Draw selected option(s) button graphic
    if [3, 4].include?(mode)   # Height, weight
      xpos1 = xstart + ((sel[0] + 1) * xgap)
      xpos1 = xstart if sel[0] < -1
      xpos2 = xstart + ((sel[1] + 1) * xgap)
      xpos2 = xstart + (cols * xgap) if sel[1] < 0
      xpos2 = xstart if sel[1] >= cols - 1
      ypos1 = ystart + 180
      ypos2 = ystart + 36
      overlay.blt(16, 120, @searchsliderbitmap.bitmap, Rect.new(0, 192, 32, 44)) if sel[1] < cols - 1
      overlay.blt(464, 120, @searchsliderbitmap.bitmap, Rect.new(32, 192, 32, 44)) if sel[1] >= 0
      overlay.blt(16, 264, @searchsliderbitmap.bitmap, Rect.new(0, 192, 32, 44)) if sel[0] >= 0
      overlay.blt(464, 264, @searchsliderbitmap.bitmap, Rect.new(32, 192, 32, 44)) if sel[0] < cols - 1
      hwrect = Rect.new(0, 0, 120, 96)
      overlay.blt(xpos2, ystart, @searchsliderbitmap.bitmap, hwrect)
      hwrect.y = 96
      overlay.blt(xpos1, ystart + ygap, @searchsliderbitmap.bitmap, hwrect)
      textpos.push([txt1, xpos1 + halfwidth, ypos1, 2, base, nil, 1])
      textpos.push([txt2, xpos2 + halfwidth, ypos2, 2, base, nil, 1])
    else
      sel.length.times do |i|
        selrect = Rect.new(0, selbuttony, @selbitmap.bitmap.width, selbuttonheight)
        if sel[i] >= 0
          overlay.blt(xstart + ((sel[i] % cols) * xgap),
                      ystart + ((sel[i] / cols).floor * ygap),
                      @selbitmap.bitmap, selrect)
        else
          overlay.blt(xstart + ((cols - 1) * xgap),
                      ystart + ((cmds.length / cols).floor * ygap),
                      @selbitmap.bitmap, selrect)
        end
      end
    end
    # Draw options
    case mode
    when 0, 1   # Order, name
      cmds.length.times do |i|
        x = xstart + halfwidth + ((i % cols) * xgap)
        y = ystart + 14 + ((i / cols).floor * ygap)
        textpos.push([cmds[i], x, y, 2, base, shadow, 1])
      end
      if mode != 0
        textpos.push([(mode == 1) ? "-" : "----",
                      xstart + halfwidth + ((cols - 1) * xgap),
                      ystart + 14 + ((cmds.length / cols).floor * ygap),
                      2, base, shadow, 1])
      end
    when 2   # Type
      typerect = Rect.new(0, 0, 96, 32)
      cmds.length.times do |i|
        typerect.y = @typeCommands[i].icon_position * 32
        overlay.blt(xstart + 14 + ((i % cols) * xgap),
                    ystart + 6 + ((i / cols).floor * ygap),
                    @typebitmap.bitmap, typerect)
      end
      textpos.push(["----",
                    xstart + halfwidth + ((cols - 1) * xgap),
                    ystart + 14 + ((cmds.length / cols).floor * ygap),
                    2, base, shadow, 1])
    when 5   # Color
      cmds.length.times do |i|
        x = xstart + halfwidth + ((i % cols) * xgap)
        y = ystart + 14 + ((i / cols).floor * ygap)
        textpos.push([cmds[i].name, x, y, 2, base, shadow, 1])
      end
      textpos.push(["----",
                    xstart + halfwidth + ((cols - 1) * xgap),
                    ystart + 14 + ((cmds.length / cols).floor * ygap),
                    2, base, shadow, 1])
    when 6   # Shape
      shaperect = Rect.new(0, 0, 60, 60)
      cmds.length.times do |i|
        shaperect.y = @shapeCommands[i].icon_position * 60
        overlay.blt(xstart + 4 + ((i % cols) * xgap),
                    ystart + 4 + ((i / cols).floor * ygap),
                    @shapebitmap.bitmap, shaperect)
      end
    end
    # Draw all text
    pbDrawTextPositions(overlay, textpos)
  end

  def pbDexSearchCommands(mode, selitems, mainindex)
    cmds = [@orderCommands, @nameCommands, @typeCommands, @heightCommands,
            @weightCommands, @colorCommands, @shapeCommands][mode]
    cols = [2, 7, 5, 1, 1, 3, 5][mode]
    ret = nil
    # Set background
    case mode
    when 0    then @sprites["searchbg"].setBitmap("Graphics/Pictures/Pokedex/bg_search_order")
    when 1    then @sprites["searchbg"].setBitmap("Graphics/Pictures/Pokedex/bg_search_name")
    when 2
      count = 0
      GameData::Type.each { |t| count += 1 if !t.pseudo_type && t.id != :SHADOW }
      if count == 18
        @sprites["searchbg"].setBitmap("Graphics/Pictures/Pokedex/bg_search_type_18")
      else
        @sprites["searchbg"].setBitmap("Graphics/Pictures/Pokedex/bg_search_type")
      end
    when 3, 4 then @sprites["searchbg"].setBitmap("Graphics/Pictures/Pokedex/bg_search_size")
    when 5    then @sprites["searchbg"].setBitmap("Graphics/Pictures/Pokedex/bg_search_color")
    when 6    then @sprites["searchbg"].setBitmap("Graphics/Pictures/Pokedex/bg_search_shape")
    end
    selindex = selitems.clone
    index     = selindex[0]
    oldindex  = index
    minmax    = 1
    oldminmax = minmax
    if [3, 4].include?(mode)
      index = oldindex = selindex[minmax]
    end
    @sprites["searchcursor"].mode   = mode
    @sprites["searchcursor"].cmds   = cmds.length
    @sprites["searchcursor"].minmax = minmax
    @sprites["searchcursor"].index  = index
    nextparam = cmds.length % 2
    pbRefreshDexSearchParam(mode, cmds, selindex, index)
    loop do
      pbUpdate
      if index != oldindex || minmax != oldminmax
        @sprites["searchcursor"].minmax = minmax
        @sprites["searchcursor"].index  = index
        oldindex  = index
        oldminmax = minmax
      end
      Graphics.update
      Input.update
      if [3, 4].include?(mode)
        if Input.trigger?(Input::UP)
          if index < -1   # From OK/Cancel
            minmax = 0
            index = selindex[minmax]
          elsif minmax == 0
            minmax = 1
            index = selindex[minmax]
          end
          if index != oldindex || minmax != oldminmax
            pbPlayCursorSE
            pbRefreshDexSearchParam(mode, cmds, selindex, index)
          end
        elsif Input.trigger?(Input::DOWN)
          case minmax
          when 1
            minmax = 0
            index = selindex[minmax]
          when 0
            minmax = -1
            index = -2
          end
          if index != oldindex || minmax != oldminmax
            pbPlayCursorSE
            pbRefreshDexSearchParam(mode, cmds, selindex, index)
          end
        elsif Input.repeat?(Input::LEFT)
          if index == -3
            index = -2
          elsif index >= -1
            if minmax == 1 && index == -1
              index = cmds.length - 1 if selindex[0] < cmds.length - 1
            elsif minmax == 1 && index == 0
              index = cmds.length if selindex[0] < 0
            elsif index > -1 && !(minmax == 1 && index >= cmds.length)
              index -= 1 if minmax == 0 || selindex[0] <= index - 1
            end
          end
          if index != oldindex
            selindex[minmax] = index if minmax >= 0
            pbPlayCursorSE
            pbRefreshDexSearchParam(mode, cmds, selindex, index)
          end
        elsif Input.repeat?(Input::RIGHT)
          if index == -2
            index = -3
          elsif index >= -1
            if minmax == 1 && index >= cmds.length
              index = 0
            elsif minmax == 1 && index == cmds.length - 1
              index = -1
            elsif index < cmds.length && !(minmax == 1 && index < 0)
              index += 1 if minmax == 1 || selindex[1] == -1 ||
                            (selindex[1] < cmds.length && selindex[1] >= index + 1)
            end
          end
          if index != oldindex
            selindex[minmax] = index if minmax >= 0
            pbPlayCursorSE
            pbRefreshDexSearchParam(mode, cmds, selindex, index)
          end
        end
      else
        if Input.trigger?(Input::UP)
          if index == -1   # From blank
            index = cmds.length - 1 - ((cmds.length - 1) % cols) - 1
          elsif index == -2   # From OK
            index = ((cmds.length - 1) / cols).floor * cols
          elsif index == -3 && mode == 0   # From Cancel
            index = cmds.length - 1
          elsif index == -3   # From Cancel
            index = -1
          elsif index >= cols
            index -= cols
          end
          pbPlayCursorSE if index != oldindex
        elsif Input.trigger?(Input::DOWN)
          if index == -1   # From blank
            index = -3
          elsif index >= 0
            if index + cols < cmds.length
              index += cols
            elsif (index / cols).floor < ((cmds.length - 1) / cols).floor
              index = (index % cols < cols / 2.0) ? cmds.length - 1 : -1
            else
              index = (index % cols < cols / 2.0) ? -2 : -3
            end
          end
          pbPlayCursorSE if index != oldindex
        elsif Input.trigger?(Input::LEFT)
          if index == -3
            index = -2
          elsif index == -1
            index = cmds.length - 1
          elsif index > 0 && index % cols != 0
            index -= 1
          end
          pbPlayCursorSE if index != oldindex
        elsif Input.trigger?(Input::RIGHT)
          if index == -2
            index = -3
          elsif index == cmds.length - 1 && mode != 0
            index = -1
          elsif index >= 0 && index % cols != cols - 1
            index += 1
          end
          pbPlayCursorSE if index != oldindex
        end
      end
      if Input.trigger?(Input::ACTION)
        index = -2
        pbPlayCursorSE if index != oldindex
      elsif Input.trigger?(Input::BACK)
        pbPlayCloseMenuSE
        ret = nil
        break
      elsif Input.trigger?(Input::USE)
        if index == -2      # OK
          pbPlayDecisionSE
          ret = selindex
          break
        elsif index == -3   # Cancel
          pbPlayCloseMenuSE
          ret = nil
          break
        elsif selindex != index && mode != 3 && mode != 4
          if mode == 2
            if index == -1
              nextparam = (selindex[1] >= 0) ? 1 : 0
            elsif index >= 0
              nextparam = (selindex[0] < 0) ? 0 : (selindex[1] < 0) ? 1 : nextparam
            end
            if index < 0 || selindex[(nextparam + 1) % 2] != index
              pbPlayDecisionSE
              selindex[nextparam] = index
              nextparam = (nextparam + 1) % 2
            end
          else
            pbPlayDecisionSE
            selindex[0] = index
          end
          pbRefreshDexSearchParam(mode, cmds, selindex, index)
        end
      end
    end
    Input.update
    # Set background image
    @sprites["searchbg"].setBitmap("Graphics/Pictures/Pokedex/bg_search")
    @sprites["searchcursor"].mode = -1
    @sprites["searchcursor"].index = mainindex
    return ret
  end

  def pbPokedex
    pbActivateWindow(@sprites, "pokedex") {
      loop do
        Graphics.update
        Input.update
        oldindex = @sprites["pokedex"].index
        pbUpdate
        if oldindex != @sprites["pokedex"].index
          $PokemonGlobal.pokedexIndex[pbGetSavePositionIndex] = @sprites["pokedex"].index if !@searchResults
          pbRefresh
        end
        if Input.trigger?(Input::ACTION)
          pbPlayDecisionSE
          @sprites["pokedex"].active = false
          pbDexSearch
          @sprites["pokedex"].active = true
        elsif Input.trigger?(Input::SPECIAL)
          pbPlayDecisionSE
          @sprites["pokedex"].active = false
          searchBySpeciesName
          @sprites["pokedex"].active = true
        elsif Input.trigger?(Input::BACK)
          if @searchResults
            pbPlayCancelSE
            pbCloseSearch
          else
            pbPlayCloseMenuSE
            break
          end
        elsif Input.trigger?(Input::USE)
          if $player.seen?(@sprites["pokedex"].species)
            pbPlayDecisionSE
            pbDexEntry(@sprites["pokedex"].index)
          end
        end
      end
    }
  end

  def searchBySpeciesName
    nameInput = pbEnterText(_INTL("Search species..."), 0, 12)
    if nameInput && nameInput != ""
      reversed = nameInput[0] == "-"
      nameInput = nameInput[1..-1] if reversed
      dexlist = pbGetDexList #searchStartingList
      dexlist = dexlist.find_all do |dex_item|
        # next false if autoDisqualifyFromSearch(dex_item[:species])
        next false if !$player.seen?(dex_item[0])
        searchPokeName = dex_item[0].to_s
        value = searchPokeName.downcase.include?(nameInput.downcase) ^ reversed # Boolean XOR
        next value
      end
      if dexlist.length == 0
        pbMessage(_INTL("No matching Pokémon were found."))
      else
        @dexlist = dexlist
        @sprites["pokedex"].commands = @dexlist
        @sprites["pokedex"].index    = 0
        @sprites["pokedex"].refresh
        @searchResults = true
      end
      if @searchResults
        @sprites["background"].setBitmap("Graphics/Pictures/Pokedex/bg_listsearch")
      else
        @sprites["background"].setBitmap("Graphics/Pictures/Pokedex/bg_list")
      end
      pbRefresh
      return dexlist
    end
    return nil
  end
end