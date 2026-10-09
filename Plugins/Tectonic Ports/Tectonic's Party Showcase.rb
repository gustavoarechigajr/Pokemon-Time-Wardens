class PokemonPartyShowcase_Scene
  POKEMON_ICON_SIZE = 64
  BASE_COLOR  = Color.new(225, 225, 225)
  SHADOW_COLOR = Color.new(20, 20, 20)

  def initialize(party,snapshot = false,snapShotName=nil)
    @sprites = {}
    @party = party
    @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z = 99999
    @statMode = 0
    backgroundFileName = "Party/showcase_bg"
    backgroundFileName += "_postgame" if $player.badge_count>=13
    addBackgroundPlane(@sprites, "bg", backgroundFileName, @viewport)
    @sprites["overlay"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    @overlay = @sprites["overlay"].bitmap
    pbSetSmallFont(@overlay)
    # Add party Pokémon sprites
    for i in 0...Settings::MAX_PARTY_SIZE
      next unless @party[i]
      renderShowcaseInfo(i,@party[i])
    end
    writeBottomText
    pbFadeInAndShow(@sprites) { pbUpdate }
    loop do
      Graphics.update
      Input.update
      pbUpdate
      if Input.trigger?(Input::BACK)
        pbEndScene
        pbPlayCloseMenuSE
        return
      elsif Input.trigger?(Input::LEFT)
        update = true
        if @statMode == 0
          @statMode = 4
        end
        @statMode -= 1
        updateShowcaseInfo(update)
      elsif Input.trigger?(Input::RIGHT)
        update = true
        if @statMode == 3
          @statMode = -1
        end
        @statMode += 1
        updateShowcaseInfo(update)
      end
    end
  end

  def updateShowcaseInfo(update = false)
    @overlay.dispose
    @sprites["overlay"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    @overlay = @sprites["overlay"].bitmap
    pbSetSmallFont(@overlay)
    for i in 0...Settings::MAX_PARTY_SIZE
      next unless @party[i]
      renderShowcaseInfo(i,@party[i], false) if update
    end
    writeBottomText
  end

  def writeBottomText
    # Show player name
    upped_color, upped_shadow = Color.new(200, 0, 0), Color.new(20, 0, 0)
    downed_color, downed_shadow = Color.new(0, 0, 200), Color.new(0, 0, 20)
    case [$game_variables[985],$player.difficulty_mode]
      when ["Adept",2];    base_color, shadow_color = downed_color, downed_shadow
      when ["Standard",2]; base_color, shadow_color = downed_color, downed_shadow
      when ["Unfair",1];   base_color, shadow_color = upped_color, upped_shadow
      when ["Standard",1]; base_color, shadow_color = downed_color, downed_shadow
      when ["Unfair",0];   base_color, shadow_color = upped_color, upped_shadow
      when ["Adept",0];    base_color, shadow_color = upped_color, upped_shadow
      else; base_color, shadow_color = BASE_COLOR, SHADOW_COLOR
    end
    playerName = "<ar>#{$Trainer.name}</ar>"
    drawFormattedTextEx(@overlay, Graphics.width - 168, Graphics.height - 16, 160, playerName, BASE_COLOR, SHADOW_COLOR)
    # Show player name
    badges = $player.badge_count
    settingsLabel = ((badges>=18) ? "End-Game" : (([13,14,15,16,17].include?(badges)) ? "Post Game Ch. #{badges+1}" : "Chapter #{badges+1}"))
    drawFormattedTextEx(@overlay, 4, Graphics.height - 16, 160, settingsLabel, BASE_COLOR, SHADOW_COLOR)
    diff_string = ($Trainer.difficulty_mode==2) ? "Unfair" : (($Trainer.difficulty_mode==1) ? "Adept" : "Standard")
    ap_stat = $Trainer.achievement_points
    diffSetting = "#{diff_string} Mode: #{ap_stat[1]} AP"
    drawFormattedTextEx(@overlay, 178, Graphics.height - 16, 300, diffSetting, base_color, shadow_color)
  end

  def renderShowcaseInfo(index,pokemon,refresh = true)
    displayX = ((index % 2) * (Graphics.width / 2)) + 6
    displayY = (index / 2) * (Graphics.height / 3 - 8) + 6
    mainIconY = displayY + 20
    newPokemonIcon = PokemonIconSprite.new(pokemon,@viewport) if refresh
    newPokemonIcon.x = displayX if refresh
    newPokemonIcon.y = mainIconY if refresh
    @sprites["pokemon#{index}"] = newPokemonIcon if refresh
    # Display pokemon name
    nameAndLevel = pokemon.name + " Lv. " + pokemon.level.to_s
    drawTextEx(@overlay, displayX + 14, displayY, 200, 1, nameAndLevel, BASE_COLOR, SHADOW_COLOR)
    # Display item icon
    if pokemon.hasItem? && refresh
     itemX = displayX + POKEMON_ICON_SIZE - 8
     itemY = mainIconY + POKEMON_ICON_SIZE - 8
     newItemIcon = ItemIconSprite.new(itemX,itemY,pokemon.item,@viewport)
     newItemIcon.zoom_x = 0.5
     newItemIcon.zoom_y = 0.5
     @sprites["item_#{index}"] = newItemIcon
    end
    # Display ball caught in icon
    if refresh
      newItemIcon = ItemIconSprite.new(displayX + 200,mainIconY + POKEMON_ICON_SIZE + 16,pokemon.poke_ball,@viewport)
      newItemIcon.zoom_x = 0.5
      newItemIcon.zoom_y = 0.5
      @sprites["ball_#{index}"] = newItemIcon
    end
    # Display gender
    genderX = displayX + 196
    genderY = displayY
    if pokemon.male?
      drawTextEx(@overlay, genderX, genderY, 80, 1, _INTL("♂"), Color.new(0,112,248), Color.new(120,184,232))
    elsif pokemon.female?
      drawTextEx(@overlay, genderX, genderY, 80, 1, _INTL("♀"), Color.new(232,32,16), Color.new(248,168,184))
    end
    # Draw shiny icon
    if pokemon.shiny?
      shinyIconFileName = "Graphics/Pictures/shiny"
      pbDrawImagePositions(@overlay,[[shinyIconFileName,displayX-2,mainIconY-20,0,0,16,16]])
    end
    # Display moves
    pokemon.moves.each_with_index do |pokemonMove,moveIndex|
      next if moveIndex > 3
      moveName = GameData::Move.get(pokemonMove.id).real_name
      drawTextEx(@overlay, displayX + POKEMON_ICON_SIZE + 8, mainIconY + 2 + moveIndex * 16, 200, 1, moveName, BASE_COLOR, SHADOW_COLOR)
    end
    # Display ability name
    abilityName = pokemon.ability&.real_name || "No Ability"
    drawTextEx(@overlay, displayX + 4, mainIconY + POKEMON_ICON_SIZE + 8, 200, 1, abilityName, BASE_COLOR, SHADOW_COLOR)
    # Set Nture Values
    statshadows = {}
    GameData::Stat.each_main { |s| statshadows[s.id] = SHADOW_COLOR }
    pokemon.nature_for_stats.stat_changes.each do |change|
      statshadows[change[0]] = Color.new(136, 96, 72) if change[1] > 0
      statshadows[change[0]] = Color.new(64, 120, 152) if change[1] < 0
    end
    # Display Stat Points
    statValueX = displayX + 218
    statHash = [pokemon.ev, pokemon.iv, {:HP => pokemon.hp, :ATTACK => pokemon.attack, :DEFENSE => pokemon.defense, :SPECIAL_ATTACK => pokemon.spatk, :SPECIAL_DEFENSE => pokemon.spdef, :SPEED => pokemon.speed}, {:HP => "HP",:ATTACK => "Atk",:DEFENSE => "Def",:SPECIAL_ATTACK => "SpA",:SPECIAL_DEFENSE => "SpD",:SPEED => "Spe"}]
    statValues = [statHash[@statMode][:HP],statHash[@statMode][:ATTACK],statHash[@statMode][:DEFENSE],statHash[@statMode][:SPECIAL_ATTACK],statHash[@statMode][:SPECIAL_DEFENSE],statHash[@statMode][:SPEED]]
    statValues.each_with_index do |statValue,statIndex|
      curStatID = [:HP,:ATTACK,:DEFENSE,:SPECIAL_ATTACK,:SPECIAL_DEFENSE,:SPEED]
      thisText = statValue
      thisColor = BASE_COLOR.clone
      thisShadow = statshadows[curStatID[statIndex]]
      if statValue.is_a?(Numeric)
        thisColor.alpha = 200 if statValue == 0
        thisShadow.alpha = 200 if statValue == 0
        thisText = statValue.to_s
      end
      drawTextEx(@overlay, statValueX, 16 + displayY + 16 * statIndex, 80, 1, thisText, thisColor, thisShadow)
    end
    statMode = [
      ["EVs",BASE_COLOR,SHADOW_COLOR],
      ["IVs",BASE_COLOR,SHADOW_COLOR],
      ["Val",BASE_COLOR,SHADOW_COLOR],
      ["Ord",BASE_COLOR,SHADOW_COLOR],
    ]
    drawTextEx(@overlay, displayX + 218, displayY - 2, 80, 1, statMode[@statMode][0], statMode[@statMode][1], statMode[@statMode][2])
  end

  def pbEndScene
    pbFadeOutAndHide(@sprites) { pbUpdate }
    pbDisposeSpriteHash(@sprites)
    # DISPOSE OF BITMAPS HERE #
  end

  def pbUpdate
    pbUpdateSpriteHash(@sprites)
  end
end

MenuHandlers.add(:pc_menu, :team_showcase, {
 "name"    => _INTL("Team Showcase"),
 "order"   => 25,
 "description" => _INTL("Show off your current party."),
 "effect"   => proc {
  pbFadeOutIn {PokemonPartyShowcase_Scene.new($Trainer.party)}
 }
})
