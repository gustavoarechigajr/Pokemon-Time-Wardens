#===============================================================================
#
#===============================================================================
def pbBattleChallenge
  $PokemonGlobal.challenge = BattleChallenge.new if !$PokemonGlobal.challenge
  return $PokemonGlobal.challenge
end

def pbBattleChallengeBattle
  return pbBattleChallenge.pbBattle
end

# Used in events
def pbHasEligible?(*arg)
  return pbBattleChallenge.rules.ruleset.hasValidTeam?($player.party)
end

#===============================================================================
#
#===============================================================================
def pbGetBTTrainers(challengeID)
  trlists = (load_data("Data/trainer_lists.dat") rescue [])
  trlists.each { |tr| return tr[0] if !tr[5] && tr[2].include?(challengeID) }
  trlists.each { |tr| return tr[0] if tr[5] }   # is default list
  return []
end

def pbGetBTPokemon(challengeID)
  trlists = (load_data("Data/trainer_lists.dat") rescue [])
  trlists.each { |tr| return tr[1] if !tr[5] && tr[2].include?(challengeID) }
  trlists.each { |tr| return tr[1] if tr[5] }   # is default list
  return []
end
#===============================================================================
# Pokémon party visuals
#===============================================================================
class Original_PokemonParty_Scene
  def pbStartScene(party, starthelptext, annotations = nil, multiselect = false, can_access_storage = false)
    @sprites = {}
    @party = party
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    @multiselect = multiselect
    @can_access_storage = can_access_storage
    addBackgroundPlane(@sprites, "partybg", "Party/bg", @viewport)
    @sprites["messagebox"] = Window_AdvancedTextPokemon.new("")
    @sprites["messagebox"].z              = 50
    @sprites["messagebox"].viewport       = @viewport
    @sprites["messagebox"].visible        = false
    @sprites["messagebox"].letterbyletter = true
    pbBottomLeftLines(@sprites["messagebox"], 2)
    @sprites["storagetext"] = Window_UnformattedTextPokemon.new(
      @can_access_storage ? _INTL("[Special]: To Boxes") : ""
    )
    @sprites["storagetext"].x           = 32
    @sprites["storagetext"].y           = Graphics.height - @sprites["messagebox"].height - 16
    @sprites["storagetext"].z           = 10
    @sprites["storagetext"].viewport    = @viewport
    @sprites["storagetext"].baseColor   = Color.new(248, 248, 248)
    @sprites["storagetext"].shadowColor = Color.new(0, 0, 0)
    @sprites["storagetext"].windowskin  = nil
    @sprites["helpwindow"] = Window_UnformattedTextPokemon.new(starthelptext)
    @sprites["helpwindow"].viewport = @viewport
    @sprites["helpwindow"].visible  = true
    pbBottomLeftLines(@sprites["helpwindow"], 1)
    pbSetHelpText(starthelptext)
    # Add party Pokémon sprites
    Settings::MAX_PARTY_SIZE.times do |i|
      if @party[i]
        @sprites["pokemon#{i}"] = PokemonPartyPanel.new(@party[i], i, @viewport)
      else
        @sprites["pokemon#{i}"] = PokemonPartyBlankPanel.new(@party[i], i, @viewport)
      end
      @sprites["pokemon#{i}"].text = annotations[i] if annotations
    end
    if @multiselect
      @sprites["pokemon#{Settings::MAX_PARTY_SIZE}"] = PokemonPartyConfirmSprite.new(@viewport)
      @sprites["pokemon#{Settings::MAX_PARTY_SIZE + 1}"] = PokemonPartyCancelSprite2.new(@viewport)
    else
      @sprites["pokemon#{Settings::MAX_PARTY_SIZE}"] = PokemonPartyCancelSprite.new(@viewport)
    end
    # Select first Pokémon
    @activecmd = 0
    @sprites["pokemon0"].selected = true
    pbFadeInAndShow(@sprites) { update }
  end

  def pbEndScene
    pbFadeOutAndHide(@sprites) { update }
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end

  def pbDisplay(text)
    @sprites["messagebox"].text    = text
    @sprites["messagebox"].visible = true
    @sprites["helpwindow"].visible = false
    pbPlayDecisionSE
    loop do
      Graphics.update
      Input.update
      self.update
      if @sprites["messagebox"].busy?
        if Input.trigger?(Input::USE)
          pbPlayDecisionSE if @sprites["messagebox"].pausing?
          @sprites["messagebox"].resume
        end
      elsif Input.trigger?(Input::BACK) || Input.trigger?(Input::USE)
        break
      end
    end
    @sprites["messagebox"].visible = false
    @sprites["helpwindow"].visible = true
  end

  def pbDisplayConfirm(text)
    ret = -1
    @sprites["messagebox"].text    = text
    @sprites["messagebox"].visible = true
    @sprites["helpwindow"].visible = false
    using(cmdwindow = Window_CommandPokemon.new([_INTL("Yes"), _INTL("No")])) {
      cmdwindow.visible = false
      pbBottomRight(cmdwindow)
      cmdwindow.y -= @sprites["messagebox"].height
      cmdwindow.z = @viewport.z + 1
      loop do
        Graphics.update
        Input.update
        cmdwindow.visible = true if !@sprites["messagebox"].busy?
        cmdwindow.update
        self.update
        if !@sprites["messagebox"].busy?
          if Input.trigger?(Input::BACK)
            ret = false
            break
          elsif Input.trigger?(Input::USE) && @sprites["messagebox"].resume
            ret = (cmdwindow.index == 0)
            break
          end
        end
      end
    }
    @sprites["messagebox"].visible = false
    @sprites["helpwindow"].visible = true
    return ret
  end

  def pbShowCommands(helptext, commands, index = 0)
    ret = -1
    helpwindow = @sprites["helpwindow"]
    helpwindow.visible = true
    using(cmdwindow = Window_CommandPokemonColor.new(commands)) {
      cmdwindow.z     = @viewport.z + 1
      cmdwindow.index = index
      pbBottomRight(cmdwindow)
      helpwindow.resizeHeightToFit(helptext, Graphics.width - cmdwindow.width)
      helpwindow.text = helptext
      pbBottomLeft(helpwindow)
      loop do
        Graphics.update
        Input.update
        cmdwindow.update
        self.update
        if Input.trigger?(Input::BACK)
          pbPlayCancelSE
          ret = -1
          break
        elsif Input.trigger?(Input::USE)
          pbPlayDecisionSE
          ret = cmdwindow.index
          break
        end
      end
    }
    return ret
  end

  def pbChooseNumber(helptext, maximum, initnum = 1)
    return UIHelper.pbChooseNumber(@sprites["helpwindow"], helptext, maximum, initnum) { update }
  end

  def pbSetHelpText(helptext)
    helpwindow = @sprites["helpwindow"]
    pbBottomLeftLines(helpwindow, 1)
    helpwindow.text = helptext
    helpwindow.width = 398
    helpwindow.visible = true
    Kernel.tts(helptext)
  end

  def pbHasAnnotations?
    return !@sprites["pokemon0"].text.nil?
  end

  def pbAnnotate(annot)
    Settings::MAX_PARTY_SIZE.times do |i|
      @sprites["pokemon#{i}"].text = (annot) ? annot[i] : nil
    end
  end

  def pbSelect(item)
    @activecmd = item
    numsprites = Settings::MAX_PARTY_SIZE + ((@multiselect) ? 2 : 1)
    numsprites.times do |i|
      @sprites["pokemon#{i}"].selected = (i == @activecmd)
    end
  end

  def pbPreSelect(item)
    @activecmd = item
  end

  def pbSwitchBegin(oldid, newid)
    pbSEPlay("GUI party switch")
    oldsprite = @sprites["pokemon#{oldid}"]
    newsprite = @sprites["pokemon#{newid}"]
    timeTaken = Graphics.frame_rate * 4 / 10
    distancePerFrame = (Graphics.width / (2.0 * timeTaken)).ceil
    timeTaken.times do
      oldsprite.x += (oldid & 1) == 0 ? -distancePerFrame : distancePerFrame
      newsprite.x += (newid & 1) == 0 ? -distancePerFrame : distancePerFrame
      Graphics.update
      Input.update
      self.update
    end
  end

  def pbSwitchEnd(oldid, newid)
    pbSEPlay("GUI party switch")
    oldsprite = @sprites["pokemon#{oldid}"]
    newsprite = @sprites["pokemon#{newid}"]
    oldsprite.pokemon = @party[oldid]
    newsprite.pokemon = @party[newid]
    timeTaken = Graphics.frame_rate * 4 / 10
    distancePerFrame = (Graphics.width / (2.0 * timeTaken)).ceil
    timeTaken.times do
      oldsprite.x -= (oldid & 1) == 0 ? -distancePerFrame : distancePerFrame
      newsprite.x -= (newid & 1) == 0 ? -distancePerFrame : distancePerFrame
      Graphics.update
      Input.update
      self.update
    end
    Settings::MAX_PARTY_SIZE.times do |i|
      @sprites["pokemon#{i}"].preselected = false
      @sprites["pokemon#{i}"].switching   = false
    end
    pbRefresh
  end

  def pbClearSwitching
    Settings::MAX_PARTY_SIZE.times do |i|
      @sprites["pokemon#{i}"].preselected = false
      @sprites["pokemon#{i}"].switching   = false
    end
  end

  def pbSummary(pkmnid, inbattle = false)
    oldsprites = pbFadeOutAndHide(@sprites)
    scene = PokemonSummary_Scene.new
    screen = PokemonSummaryScreen.new(scene, inbattle)
    screen.pbStartScreen(@party, pkmnid)
    yield if block_given?
    pbFadeInAndShow(@sprites, oldsprites)
  end

  def pbChooseItem(bag)
    ret = nil
    pbFadeOutIn {
      scene = PokemonBag_Scene.new
      screen = PokemonBagScreen.new(scene, bag)
      ret = screen.pbChooseItemScreen(proc { |item| GameData::Item.get(item).can_hold? })
      yield if block_given?
    }
    return ret
  end

  def pbUseItem(bag, pokemon)
    ret = nil
    pbFadeOutIn {
      scene = PokemonBag_Scene.new
      screen = PokemonBagScreen.new(scene, bag)
      ret = screen.pbChooseItemScreen(proc { |item|
        itm = GameData::Item.get(item)
        next false if !pbCanUseOnPokemon?(itm)
        next false if pokemon.hyper_mode && !GameData::Item.get(item)&.is_scent?
        if itm.is_machine?
          move = itm.move
          next false if pokemon.hasMove?(move) || !pokemon.compatible_with_move?(move)
        end
        next true
      })
      yield if block_given?
    }
    return ret
  end

  def pbChoosePokemon(switching = false, initialsel = -1, canswitch = 0)
    Settings::MAX_PARTY_SIZE.times do |i|
      @sprites["pokemon#{i}"].preselected = (switching && i == @activecmd)
      @sprites["pokemon#{i}"].switching   = switching
    end
    @activecmd = initialsel if initialsel >= 0
    pbRefresh
    loop do
      Graphics.update
      Input.update
      self.update
      oldsel = @activecmd
      key = -1
      key = Input::DOWN if Input.repeat?(Input::DOWN)
      key = Input::RIGHT if Input.repeat?(Input::RIGHT)
      key = Input::LEFT if Input.repeat?(Input::LEFT)
      key = Input::UP if Input.repeat?(Input::UP)
      if key >= 0
        @activecmd = pbChangeSelection(key, @activecmd)
      end
      if @activecmd != oldsel   # Changing selection
        pbPlayCursorSE
        numsprites = Settings::MAX_PARTY_SIZE + ((@multiselect) ? 2 : 1)
        numsprites.times do |i|
          @sprites["pokemon#{i}"].selected = (i == @activecmd)
        end
      end
      cancelsprite = Settings::MAX_PARTY_SIZE + ((@multiselect) ? 1 : 0)
      if Input.trigger?(Input::SPECIAL) && @can_access_storage && canswitch != 2
        pbPlayDecisionSE
        pbFadeOutIn {
          scene = PokemonStorageScene.new
          screen = PokemonStorageScreen.new(scene, $PokemonStorage)
          screen.pbStartScreen(0)
          pbHardRefresh
        }
      elsif Input.trigger?(Input::JUMPDOWN) && @can_access_storage && canswitch != 2
        pbFadeOutIn {PokemonPartyShowcase_Scene.new($Trainer.party)}
      elsif Input.trigger?(Input::JUMPUP) && @can_access_storage && canswitch != 2 && $Trainer.tutornet==true
        pbFadeOutIn {
          scene = PokemonTutorNet_Scene.new
          screen = PokemonTutorNetScreen.new(scene)
          screen.pbStartScreen
        }
      elsif Input.trigger?(Input::ACTION) && canswitch == 1 && @activecmd != cancelsprite
        pbPlayDecisionSE
        return [1, @activecmd]
      elsif Input.trigger?(Input::ACTION) && canswitch == 2
        return -1
      elsif Input.trigger?(Input::BACK)
        pbPlayCloseMenuSE if !switching
        return -1
      elsif Input.trigger?(Input::USE)
        if @activecmd == cancelsprite
          (switching) ? pbPlayDecisionSE : pbPlayCloseMenuSE
          return -1
        else
          pbPlayDecisionSE
          return @activecmd
        end
      end
    end
  end

  def pbChangeSelection(key, currentsel)
    numsprites = Settings::MAX_PARTY_SIZE + ((@multiselect) ? 2 : 1)
    case key
    when Input::LEFT
      loop do
        currentsel -= 1
        break unless currentsel > 0 && currentsel < @party.length && !@party[currentsel]
      end
      if currentsel >= @party.length && currentsel < Settings::MAX_PARTY_SIZE
        currentsel = @party.length - 1
      end
      currentsel = numsprites - 1 if currentsel < 0
    when Input::RIGHT
      loop do
        currentsel += 1
        break unless currentsel < @party.length && !@party[currentsel]
      end
      if currentsel == @party.length
        currentsel = Settings::MAX_PARTY_SIZE
      elsif currentsel == numsprites
        currentsel = 0
      end
    when Input::UP
      if currentsel >= Settings::MAX_PARTY_SIZE
        currentsel -= 1
        while currentsel > 0 && currentsel < Settings::MAX_PARTY_SIZE && !@party[currentsel]
          currentsel -= 1
        end
      else
        loop do
          currentsel -= 2
          break unless currentsel > 0 && !@party[currentsel]
        end
      end
      if currentsel >= @party.length && currentsel < Settings::MAX_PARTY_SIZE
        currentsel = @party.length - 1
      end
      currentsel = numsprites - 1 if currentsel < 0
    when Input::DOWN
      if currentsel >= Settings::MAX_PARTY_SIZE - 1
        currentsel += 1
      else
        currentsel += 2
        currentsel = Settings::MAX_PARTY_SIZE if currentsel < Settings::MAX_PARTY_SIZE && !@party[currentsel]
      end
      if currentsel >= @party.length && currentsel < Settings::MAX_PARTY_SIZE
        currentsel = Settings::MAX_PARTY_SIZE
      elsif currentsel >= numsprites
        currentsel = 0
      end
    end
    return currentsel
  end

  def pbHardRefresh
    oldtext = []
    lastselected = -1
    Settings::MAX_PARTY_SIZE.times do |i|
      oldtext.push(@sprites["pokemon#{i}"].text)
      lastselected = i if @sprites["pokemon#{i}"].selected
      @sprites["pokemon#{i}"].dispose
    end
    lastselected = @party.length - 1 if lastselected >= @party.length
    lastselected = 0 if lastselected < 0
    Settings::MAX_PARTY_SIZE.times do |i|
      if @party[i]
        @sprites["pokemon#{i}"] = PokemonPartyPanel.new(@party[i], i, @viewport)
      else
        @sprites["pokemon#{i}"] = PokemonPartyBlankPanel.new(@party[i], i, @viewport)
      end
      @sprites["pokemon#{i}"].text = oldtext[i]
    end
    pbSelect(lastselected)
  end

  def pbRefresh
    Settings::MAX_PARTY_SIZE.times do |i|
      sprite = @sprites["pokemon#{i}"]
      if sprite
        if sprite.is_a?(PokemonPartyPanel)
          sprite.pokemon = sprite.pokemon
        else
          sprite.refresh
        end
      end
    end
  end

  def pbRefreshSingle(i)
    sprite = @sprites["pokemon#{i}"]
    if sprite
      if sprite.is_a?(PokemonPartyPanel)
        sprite.pokemon = sprite.pokemon
      else
        sprite.refresh
      end
    end
  end

  def update
    pbUpdateSpriteHash(@sprites)
  end
end

#===============================================================================
# Pokémon party mechanics
#===============================================================================
class Original_PokemonPartyScreen
  attr_reader :scene
  attr_reader :party

  def initialize(scene, party)
    @scene = scene
    @party = party
  end

  def pbStartScene(helptext, _numBattlersOut, annotations = nil)
    @scene.pbStartScene(@party, helptext, annotations)
  end

  def pbChoosePokemon(helptext = nil)
    @scene.pbSetHelpText(helptext) if helptext
    return @scene.pbChoosePokemon
  end

  def pbPokemonGiveScreen(item)
    @scene.pbStartScene(@party, _INTL("Give to which Pokémon?"))
    pkmnid = @scene.pbChoosePokemon
    ret = false
    if pkmnid >= 0
      ret = pbGiveItemToPokemon(item, @party[pkmnid], self, pkmnid)
    end
    pbRefreshSingle(pkmnid)
    @scene.pbEndScene
    return ret
  end

  def pbPokemonGiveMailScreen(mailIndex)
    @scene.pbStartScene(@party, _INTL("Give to which Pokémon?"))
    pkmnid = @scene.pbChoosePokemon
    if pkmnid >= 0
      pkmn = @party[pkmnid]
      if pkmn.hasItem? || pkmn.mail
        pbDisplay(_INTL("This Pokémon is holding an item. It can't hold mail."))
      elsif pkmn.egg?
        pbDisplay(_INTL("Eggs can't hold mail."))
      else
        pbDisplay(_INTL("Mail was transferred from the Mailbox."))
        pkmn.mail = $PokemonGlobal.mailbox[mailIndex]
        pkmn.item = pkmn.mail.item
        $PokemonGlobal.mailbox.delete_at(mailIndex)
        pbRefreshSingle(pkmnid)
      end
    end
    @scene.pbEndScene
  end

  def pbEndScene
    @scene.pbEndScene
  end

  def pbUpdate
    @scene.update
  end

  def pbHardRefresh
    @scene.pbHardRefresh
  end

  def pbRefresh
    @scene.pbRefresh
  end

  def pbRefreshSingle(i)
    @scene.pbRefreshSingle(i)
  end

  def pbDisplay(text)
    @scene.pbDisplay(text)
  end

  def pbConfirm(text)
    return @scene.pbDisplayConfirm(text)
  end

  def pbShowCommands(helptext, commands, index = 0)
    return @scene.pbShowCommands(helptext, commands, index)
  end

  # Checks for identical species
  def pbCheckSpecies(array)   # Unused
    array.length.times do |i|
      (i + 1...array.length).each do |j|
        return false if array[i].species == array[j].species
      end
    end
    return true
  end

  # Checks for identical held items
  def pbCheckItems(array)   # Unused
    array.length.times do |i|
      next if !array[i].hasItem?
      (i + 1...array.length).each do |j|
        return false if array[i].item == array[j].item
      end
    end
    return true
  end

  def pbSwitch(oldid, newid)
    if oldid != newid
      @scene.pbSwitchBegin(oldid, newid)
      tmp = @party[oldid]
      @party[oldid] = @party[newid]
      @party[newid] = tmp
      @scene.pbSwitchEnd(oldid, newid)
    end
  end

  def pbChooseMove(pokemon, helptext, index = 0)
    movenames = []
    pokemon.moves.each do |i|
      next if !i || !i.id
      if i.total_pp <= 0
        movenames.push(_INTL("{1} (PP: ---)", i.name))
      else
        movenames.push(_INTL("{1} (PP: {2}/{3})", i.name, i.pp, i.total_pp))
      end
    end
    return @scene.pbShowCommands(helptext, movenames, index)
  end

  def pbRefreshAnnotations(ableProc)   # For after using an evolution stone
    return if !@scene.pbHasAnnotations?
    annot = []
    @party.each do |pkmn|
      elig = ableProc.call(pkmn)
      annot.push((elig) ? _INTL("ABLE") : _INTL("NOT ABLE"))
    end
    @scene.pbAnnotate(annot)
  end

  def pbClearAnnotations
    @scene.pbAnnotate(nil)
  end

  def pbPokemonMultipleEntryScreenEx(ruleset)
    annot = []
    statuses = []
    ordinals = [_INTL("INELIGIBLE"), _INTL("NOT ENTERED"), _INTL("BANNED")]
    positions = [_INTL("FIRST"), _INTL("SECOND"), _INTL("THIRD"), _INTL("FOURTH"),
                 _INTL("FIFTH"), _INTL("SIXTH"), _INTL("SEVENTH"), _INTL("EIGHTH"),
                 _INTL("NINTH"), _INTL("TENTH"), _INTL("ELEVENTH"), _INTL("TWELFTH")]
    Settings::MAX_PARTY_SIZE.times do |i|
      if i < positions.length
        ordinals.push(positions[i])
      else
        ordinals.push("#{i + 1}th")
      end
    end
    return nil if !ruleset.hasValidTeam?(@party)
    ret = nil
    addedEntry = false
    @party.length.times do |i|
      statuses[i] = (ruleset.isPokemonValid?(@party[i])) ? 1 : 2
      annot[i] = ordinals[statuses[i]]
    end
    @scene.pbStartScene(@party, _INTL("Choose Pokémon and confirm."), annot, true)
    loop do
      realorder = []
      @party.length.times do |i|
        @party.length.times do |j|
          if statuses[j] == i + 3
            realorder.push(j)
            break
          end
        end
      end
      realorder.length.times do |i|
        statuses[realorder[i]] = i + 3
      end
      @party.length.times do |i|
        annot[i] = ordinals[statuses[i]]
      end
      @scene.pbAnnotate(annot)
      if realorder.length == ruleset.number && addedEntry
        @scene.pbSelect(Settings::MAX_PARTY_SIZE)
      end
      @scene.pbSetHelpText(_INTL("Choose Pokémon and confirm."))
      pkmnid = @scene.pbChoosePokemon
      addedEntry = false
      if pkmnid == Settings::MAX_PARTY_SIZE   # Confirm was chosen
        ret = []
        realorder.each do |i|
          ret.push(@party[i])
        end
        error = []
        break if ruleset.isValid?(ret, error)
        pbDisplay(error[0])
        ret = nil
      end
      break if pkmnid < 0   # Cancelled
      cmdEntry   = -1
      cmdNoEntry = -1
      cmdSummary = -1
      commands = []
      if (statuses[pkmnid] || 0) == 1
        commands[cmdEntry = commands.length]   = _INTL("Entry")
      elsif (statuses[pkmnid] || 0) > 2
        commands[cmdNoEntry = commands.length] = _INTL("No Entry")
      end
      pkmn = @party[pkmnid]
      commands[cmdSummary = commands.length]   = _INTL("Summary")
      commands[commands.length]                = _INTL("Cancel")
      command = @scene.pbShowCommands(_INTL("Do what with {1}?", pkmn.name), commands) if pkmn
      if cmdEntry >= 0 && command == cmdEntry
        if realorder.length >= ruleset.number && ruleset.number > 0
          pbDisplay(_INTL("No more than {1} Pokémon may enter.", ruleset.number))
        else
          statuses[pkmnid] = realorder.length + 3
          addedEntry = true
          pbRefreshSingle(pkmnid)
        end
      elsif cmdNoEntry >= 0 && command == cmdNoEntry
        statuses[pkmnid] = 1
        pbRefreshSingle(pkmnid)
      elsif cmdSummary >= 0 && command == cmdSummary
        @scene.pbSummary(pkmnid) {
          @scene.pbSetHelpText((@party.length > 1) ? _INTL("Choose a Pokémon.") : _INTL("Choose Pokémon or cancel."))
        }
      end
    end
    @scene.pbEndScene
    return ret
  end

  def pbChooseAblePokemon(ableProc, allowIneligible = false)
    annot = []
    eligibility = []
    @party.each do |pkmn|
      elig = ableProc.call(pkmn)
      eligibility.push(elig)
      annot.push((elig) ? _INTL("ABLE") : _INTL("NOT ABLE"))
    end
    ret = -1
    @scene.pbStartScene(
      @party,
      (@party.length > 1) ? _INTL("Choose a Pokémon.") : _INTL("Choose Pokémon or cancel."),
      annot
    )
    loop do
      @scene.pbSetHelpText(
        (@party.length > 1) ? _INTL("Choose a Pokémon.") : _INTL("Choose Pokémon or cancel.")
      )
      pkmnid = @scene.pbChoosePokemon
      break if pkmnid < 0
      if !eligibility[pkmnid] && !allowIneligible
        pbDisplay(_INTL("This Pokémon can't be chosen."))
      else
        ret = pkmnid
        break
      end
    end
    @scene.pbEndScene
    return ret
  end

  def pbChooseTradablePokemon(ableProc, allowIneligible = false)
    annot = []
    eligibility = []
    @party.each do |pkmn|
      elig = ableProc.call(pkmn)
      elig = false if pkmn.egg? || pkmn.shadowPokemon? || pkmn.cannot_trade
      eligibility.push(elig)
      annot.push((elig) ? _INTL("ABLE") : _INTL("NOT ABLE"))
    end
    ret = -1
    @scene.pbStartScene(
      @party,
      (@party.length > 1) ? _INTL("Choose a Pokémon.") : _INTL("Choose Pokémon or cancel."),
      annot
    )
    loop do
      @scene.pbSetHelpText(
        (@party.length > 1) ? _INTL("Choose a Pokémon.") : _INTL("Choose Pokémon or cancel.")
      )
      pkmnid = @scene.pbChoosePokemon
      break if pkmnid < 0
      if !eligibility[pkmnid] && !allowIneligible
        pbDisplay(_INTL("This Pokémon can't be chosen."))
      else
        ret = pkmnid
        break
      end
    end
    @scene.pbEndScene
    return ret
  end

  def pbPokemonScreen
    can_access_storage = false
    if ($player.has_box_link || $bag.has?(:POKEMONBOXLINK)) &&
       !$game_switches[Settings::DISABLE_BOX_LINK_SWITCH] &&
       !$game_map.metadata&.has_flag?("DisableBoxLink")
      can_access_storage = true
    end
    @scene.pbStartScene(@party,
                        (@party.length > 1) ? _INTL("Choose a Pokémon.") : _INTL("Choose Pokémon or cancel."),
                        nil, false, can_access_storage)
    # Main loop
    loop do
      # Choose a Pokémon or cancel or press Action to quick switch
      @scene.pbSetHelpText((@party.length > 1) ? _INTL("Choose a Pokémon.") : _INTL("Choose Pokémon or cancel."))
      party_idx = @scene.pbChoosePokemon(false, -1, 1)
      break if (party_idx.is_a?(Numeric) && party_idx < 0) || (party_idx.is_a?(Array) && party_idx[1] < 0)
      # Quick switch
      if party_idx.is_a?(Array) && party_idx[0] == 1   # Switch
        @scene.pbSetHelpText(_INTL("Move to where?"))
        old_party_idx = party_idx[1]
        party_idx = @scene.pbChoosePokemon(true, -1, 2)
        pbSwitch(old_party_idx, party_idx) if party_idx >= 0 && party_idx != old_party_idx
        next
      end
      # Chose a Pokémon
      pkmn = @party[party_idx]
      # Get all commands
      command_list = []
      commands = []
      MenuHandlers.each_available(:party_menu, self, @party, party_idx) do |option, hash, name|
        command_list.push(name)
        commands.push(hash)
      end
      command_list.push(_INTL("Cancel"))
      # Add field move commands
      if !pkmn.egg?
        insert_index = (($DEBUG && $BOSSDEV)) ? 2 : 1
        pkmn.moves.each_with_index do |move, i|
          next if !HiddenMoveHandlers.hasHandler(move.id) &&
                  ![:MILKDRINK, :SOFTBOILED].include?(move.id)
          command_list.insert(insert_index, [move.name, 1])
          commands.insert(insert_index, i)
          insert_index += 1
        end
      end
      # Choose a menu option
      choice = @scene.pbShowCommands(_INTL("Do what with {1}?", pkmn.name), command_list)
      next if choice < 0 || choice >= commands.length
      # Effect of chosen menu option
      case commands[choice]
      when Hash   # Option defined via a MenuHandler below
        commands[choice]["effect"].call(self, @party, party_idx)
      when Integer   # Hidden move's index
        move = pkmn.moves[commands[choice]]
        if [:MILKDRINK, :SOFTBOILED].include?(move.id)
          amt = [(pkmn.totalhp / 5).floor, 1].max
          if pkmn.hp <= amt
            pbDisplay(_INTL("Not enough HP..."))
            next
          end
          @scene.pbSetHelpText(_INTL("Use on which Pokémon?"))
          old_party_idx = party_idx
          loop do
            @scene.pbPreSelect(old_party_idx)
            party_idx = @scene.pbChoosePokemon(true, party_idx)
            break if party_idx < 0
            newpkmn = @party[party_idx]
            movename = move.name
            if party_idx == old_party_idx
              pbDisplay(_INTL("{1} can't use {2} on itself!", pkmn.name, movename))
            elsif newpkmn.egg?
              pbDisplay(_INTL("{1} can't be used on an Egg!", movename))
            elsif newpkmn.fainted? || newpkmn.hp == newpkmn.totalhp
              pbDisplay(_INTL("{1} can't be used on that Pokémon.", movename))
            else
              pkmn.hp -= amt
              hpgain = pbItemRestoreHP(newpkmn, amt)
              @scene.pbDisplay(_INTL("{1}'s HP was restored by {2} points.", newpkmn.name, hpgain))
              pbRefresh
            end
            break if pkmn.hp <= amt
          end
          @scene.pbSelect(old_party_idx)
          pbRefresh
        elsif pbCanUseHiddenMove?(pkmn, move.id)
          if pbConfirmUseHiddenMove(pkmn, move.id)
            @scene.pbEndScene
            if move.id == :FLY
              scene = PokemonRegionMap_Scene.new(-1, false)
              screen = PokemonRegionMapScreen.new(scene)
              ret = screen.pbStartFlyScreen
              if ret
                $game_temp.fly_destination = ret
                return [pkmn, move.id]
              end
              @scene.pbStartScene(
                @party, (@party.length > 1) ? _INTL("Choose a Pokémon.") : _INTL("Choose Pokémon or cancel.")
              )
              next
            end
            return [pkmn, move.id]
          end
        end
      end
    end
    @scene.pbEndScene
    return nil
  end
end

#===============================================================================
#
#===============================================================================
def pbEntryScreen(*arg)
  retval = false
  pbFadeOutIn {
    scene = Original_PokemonParty_Scene.new
    screen = Original_PokemonPartyScreen.new(scene, $player.party)
    ret = screen.pbPokemonMultipleEntryScreenEx(pbBattleChallenge.rules.ruleset)
    # Set party
    pbBattleChallenge.setParty(ret) if ret
    # Continue (return true) if Pokémon were chosen
    retval = (ret && ret.length > 0)
  }
  return retval
end

#===============================================================================
#
#===============================================================================
class Game_Player < Game_Character
  def moveto2(x, y)
    @x = x
    @y = y
    @real_x = @x * Game_Map::REAL_RES_X
    @real_y = @y * Game_Map::REAL_RES_Y
    @prelock_direction = 0
  end
end

#===============================================================================
#
#===============================================================================
class Game_Event
  def pbInChallenge?
    return pbBattleChallenge.pbInChallenge?
  end
end

#===============================================================================
#
#===============================================================================
def pbBattleChallengeGraphic(event)
  nextTrainer = pbBattleChallenge.nextTrainer
  bttrainers = pbGetBTTrainers(pbBattleChallenge.currentChallenge)
  filename = GameData::TrainerType.charset_filename_brief((bttrainers[nextTrainer][0] rescue nil))
  begin
    filename = "trainer_FABLEDHERO" if nil_or_empty?(filename) # Changed by Jos 2023-05-29 to make sure only spirit NPCs appear
    bitmap = AnimatedBitmap.new("Graphics/Characters/" + filename)
    bitmap.dispose
    event.character_name = filename
  rescue
    event.character_name = "trainer_FABLEDHERO" # Changed by Jos 2023-05-29 to make sure only spirit NPCs appear
  end
end

def pbBattleChallengeBeginSpeech
  return "..." if !pbBattleChallenge.pbInProgress?
  bttrainers = pbGetBTTrainers(pbBattleChallenge.currentChallenge)
  tr = bttrainers[pbBattleChallenge.nextTrainer]
  return (tr) ? pbGetMessageFromHash(MessageTypes::BeginSpeech, tr[2]) : "..."
end

#===============================================================================
#
#===============================================================================

class BattleChallengeData
  def pbStart(t, numRounds)
    @inProgress   = true
    @resting      = false
    @decision     = 0
    @swaps        = t.currentSwaps
    @wins         = t.currentWins
    @battleNumber = 1
    @trainers     = []
    winstreak     = pbBattleChallenge.getPreviousWins(pbBattleChallenge.currentChallenge)
    raise _INTL("Number of rounds is 0 or less.") if numRounds <= 0
    @numRounds = numRounds
    # Get all the trainers for the next set of battles
    btTrainers = pbGetBTTrainers(pbBattleChallenge.currentChallenge)
    boss_fight = ((winstreak == 28) || (winstreak > 28 && (winstreak - 28) % 35 == 0))
    boss_id = [481, 482, 483, 484, 485, 486, 487, 488, 489, 490, 491, 492, 493, 494, 495, 496, 497, 498, 499, 500]
    while @trainers.length < @numRounds
      if @trainers.length >= 6 && boss_fight
        @trainers.push(boss_id.sample)
      else
        newtrainer = pbBattleChallengeTrainer(@wins + @trainers.length, btTrainers)
        found = false
        @trainers.each do |tr|
          found = true if tr == newtrainer
        end
        @trainers.push(newtrainer) if !found
      end
    end
    @start = [$game_map.map_id, $game_player.x, $game_player.y]
    @oldParty = $player.party
    $player.party = @party if @party
    Game.save(safe: true)
  end
end

def pbBattleChallengeTrainer(win_count, bttrainers)
  # This table's start points and lengths are based on a bttrainers size of 300.
  # They are scaled based on the actual size of bttrainers later.
  table = [   # Each value is [minimum win count, range start point, range length]
    [ 0,   0, 100],   # 0-100
    [ 6,  80,  40],   # 80-120
    [ 7,  80,  40],   # 80-120
    [13, 120,  20],   # 120-140
    [14, 100,  40],   # 100-140
    [20, 140,  20],   # 140-160
    [21, 120,  40],   # 120-160
    [27, 160,  20],   # 160-180
    [28, 140,  40],   # 140-180
    [34, 180,  20],   # 180-200
    [35, 160,  40],   # 160-200
    [41, 200,  20],   # 200-220
    [42, 180,  40],   # 180-220
    [48, 220,  40],   # 220-260
    [49, 200, 100]    # 200-300 - This line is used for all higher win_counts
  ]
  slot = nil
  table.each { |val| slot = val if val[0] <= win_count && (!slot || slot[0] < val[0]) }
  return 0 if !slot
  # Scale the start point and length based on how many trainers are in bttrainers
  offset = slot[1] * bttrainers.length / 300
  length = slot[2] * bttrainers.length / 300
  # Return a random trainer index from the chosen range
  num = offset + rand(length)
  num -= 17 if num > 400
  return num
end

def pbGenerateBattleTrainer(idxTrainer, rules)
  bttrainers = pbGetBTTrainers(pbBattleChallenge.currentChallenge)
  btpokemon = pbGetBTPokemon(pbBattleChallenge.currentChallenge)
  level = rules.ruleset.suggestedLevel
  # Create the trainer
  trainerdata = bttrainers[idxTrainer]
  opponent = NPCTrainer.new(
    pbGetMessageFromHash(MessageTypes::TrainerNames, trainerdata[1]),
    trainerdata[0]
  )
  # Determine how many IVs the trainer's Pokémon will have
  indvalues = 31
  indvalues = 21 if idxTrainer < 220
  indvalues = 18 if idxTrainer < 200
  indvalues = 15 if idxTrainer < 180
  indvalues = 12 if idxTrainer < 160
  indvalues = 9 if idxTrainer < 140
  indvalues = 6 if idxTrainer < 120
  indvalues = 3 if idxTrainer < 100
  # Get the indices within bypokemon of the Pokémon the trainer may have
  pokemonnumbers = trainerdata[5]
  # The number of possible Pokémon is <= the required number; make them
  # all Pokémon and use them
  if pokemonnumbers.length <= rules.ruleset.suggestedNumber
    pokemonnumbers.each do |n|
      rndpoke = btpokemon[n]
      pkmn = rndpoke.createPokemon(level, indvalues, opponent)
      opponent.party.push(pkmn)
    end
    return opponent
  end
  # There are more possible Pokémon than there are spaces available in the
  # trainer's party; randomly choose Pokémon
  force_boss = pbForceBoss([opponent.trainer_type, opponent.name])
  boss_shift = false
  loop do
    opponent.party.clear
    while opponent.party.length < rules.ruleset.suggestedNumber
      boss_check = opponent.party.length == 0 && force_boss != nil
      boss_shift = true if boss_check
      rnd = pokemonnumbers[rand(pokemonnumbers.length)]
      rndpoke = (boss_check) ? btpokemon[force_boss] : btpokemon[rnd]
      pkmn = rndpoke.createPokemon(level, indvalues, opponent)
      opponent.party.push(pkmn)
    end
    break if rules.ruleset.isValid?(opponent.party)
  end
  if boss_shift
    opponent.party.push(opponent.party[0])
    opponent.party.delete_at(0)
  end
  return opponent
end


#===============================================================================
#
#===============================================================================
class PBPokemon
  attr_accessor :species
  attr_accessor :item
  attr_accessor :nature
  attr_accessor :ability
  attr_accessor :move1
  attr_accessor :move2
  attr_accessor :move3
  attr_accessor :move4
  attr_accessor :ev

  # This method is how each Pokémon is compiled from the PBS files listing
  # Battle Tower/Cup Pokémon.
  def self.fromInspected(str)
    insp = str.gsub(/^\s+/, "").gsub(/\s+$/, "")
    pieces = insp.split(/\s*;\s*/)
    species = (GameData::Species.exists?(pieces[0])) ? GameData::Species.get(pieces[0]).id : nil
    item = (GameData::Item.exists?(pieces[1])) ? GameData::Item.get(pieces[1]).id : nil
    nature = (GameData::Nature.exists?(pieces[2])) ? GameData::Nature.get(pieces[2]).id : nil
    ability = (GameData::Ability.exists?(pieces[3])) ? GameData::Ability.get(pieces[3]).id : nil
    ev = pieces[4].split(/\s*,\s*/)
    ev_array = []
    ev.each do |stat|
      case stat.upcase
      when "HP"          then ev_array.push(:HP)
      when "ATK"         then ev_array.push(:ATTACK)
      when "DEF"         then ev_array.push(:DEFENSE)
      when "SA", "SPATK" then ev_array.push(:SPECIAL_ATTACK)
      when "SD", "SPDEF" then ev_array.push(:SPECIAL_DEFENSE)
      when "SPD"         then ev_array.push(:SPEED)
      end
    end
    moves = pieces[5].split(/\s*,\s*/)
    moveid = []
    Pokemon::MAX_MOVES.times do |i|
      move_data = GameData::Move.try_get(moves[i])
      moveid.push(move_data.id) if move_data
    end
    moveid.push(GameData::Move.keys.first) if moveid.length == 0   # Get any one move
    return self.new(species, item, nature, ability, moveid[0], moveid[1], moveid[2], moveid[3], ev_array)
  end

  def self.fromPokemon(pkmn)
    mov1 = (pkmn.moves[0]) ? pkmn.moves[0].id : nil
    mov2 = (pkmn.moves[1]) ? pkmn.moves[1].id : nil
    mov3 = (pkmn.moves[2]) ? pkmn.moves[2].id : nil
    mov4 = (pkmn.moves[3]) ? pkmn.moves[3].id : nil
    ev_array = []
    GameData::Stat.each_main do |s|
      ev_array.push(s.id) if pkmn.ev[s.id] > 60
    end
    return self.new(pkmn.species, pkmn.item_id, pkmn.nature,
                    pkmn.ability, mov1, mov2, mov3, mov4, ev_array)
  end

  def initialize(species, item, nature, ability, move1, move2, move3, move4, ev)
    @species = species
    itm = GameData::Item.try_get(item)
    @item    = itm ? itm.id : nil
    @nature  = nature
    @ability = ability
    @move1   = move1
    @move2   = move2
    @move3   = move3
    @move4   = move4
    @ev      = ev
  end

  def inspect
    c1 = GameData::Species.get(@species).id
    c2 = (@item) ? GameData::Item.get(@item).id : ""
    c3 = (@nature) ? GameData::Nature.get(@nature).id : ""
    c4 = (@ability) ? GameData::Ability.get(@ability) : ""
    evlist = ""
    @ev.each do |stat|
      evlist += "," if evlist != ""
      evlist += stat.real_name_brief
    end
    c5 = (@move1) ? GameData::Move.get(@move1).id : ""
    c6 = (@move2) ? GameData::Move.get(@move2).id : ""
    c7 = (@move3) ? GameData::Move.get(@move3).id : ""
    c8 = (@move4) ? GameData::Move.get(@move4).id : ""
    return "#{c1};#{c2};#{c3};#{evlist};#{c5},#{c6},#{c7},#{c8}"
  end

  def convertMove(move)
    move = :FRUSTRATION if move == :RETURN && GameData::Move.exists?(:FRUSTRATION)
    return move
  end

  def createPokemon(level, iv, trainer)
    boss_check = (trainer != nil) ? [@species, trainer.trainer_type, trainer.name] : nil
    pkmn = Pokemon.new(@species, level, trainer, false)
    pkmn.item = @item
    pkmn.personalID = rand(2**16) | (rand(2**16) << 16)
    pkmn.nature = nature
    pkmn.ability = ability
    pkmn.happiness = 0
    pkmn.moves.push(Pokemon::Move.new(self.convertMove(@move1)))
    pkmn.moves.push(Pokemon::Move.new(self.convertMove(@move2))) if @move2
    pkmn.moves.push(Pokemon::Move.new(self.convertMove(@move3))) if @move3
    pkmn.moves.push(Pokemon::Move.new(self.convertMove(@move4))) if @move4
    pkmn.moves.compact!
    if ev.length > 0
      ev.each { |stat| pkmn.ev[stat] = Pokemon::EV_LIMIT / ev.length }
    end
    GameData::Stat.each_main { |s| pkmn.iv[s.id] = iv }
    pkmn.calc_stats
    boss_id = nil
    boss_id = pbBossCheck(boss_check)
    if boss_id.is_a?(Array)
      boss = GameData::BossBattles.try_get(boss_id[0])
      pkmn.enablebossmon
      pkmn.shieldCount = boss.shieldCount
      pkmn.bossId      = boss_id[0]
      pkmn.name        = boss_id[1] if boss_id[1] != nil
      pkmn.shiny       = boss_id[2] if boss_id[2] != nil
	  pkmn.ace         = true
    end
    return pkmn
  end
end


def pbBossCheck(boss_check)
  case boss_check
    #when [:SPECIES, :TRAINERID, "Trainer Name"]; return [:BOSS_ID, "Nickname", true/false(shiny?)]
    #when [:SPECIES ,:BETATESTER_Anime, "Anime"]; return [:BOSS_ID, "Nickname", true/false(shiny?)]
    #when [:SPECIES ,:BETATESTER_MissNyakura, "MissNyakura"]; return [:BOSS_ID, "Nickname", true/false(shiny?)]
    #when [:SPECIES ,:BETATESTER_WitchyAlex, "WitchyAlex"]; return [:BOSS_ID, "Nickname", true/false(shiny?)]
    #when [:SPECIES ,:COMMUNITYARTIST_Boro, "Boro"]; return [:BOSS_ID, "Nickname", true/false(shiny?)]
    when [:WIGGLYTUFF2 ,:COMMUNITYARTIST_Ignotus68, "Ignotus68"]; return [:BTBOSS_IGNOTUS_WIGGLYTUFF2, "Violence", false]
    #when [:SPECIES ,:COMMUNITYARTIST_Zeta, "Zeta"]; return [:BOSS_ID, "Nickname", true/false(shiny?)]
    #when [:SPECIES ,:COMMUNITYARTIST_Otter, "Otter"]; return [:BOSS_ID, "Nickname", true/false(shiny?)]
    #when [:SPECIES ,:COMMUNITYARTIST_YGS, "YGS"]; return [:BOSS_ID, "Nickname", true/false(shiny?)]
    #when [:SPECIES ,:COMMUNITYARTIST_Attea, "Attea"]; return [:BOSS_ID, "Nickname", true/false(shiny?)]
    #when [:SPECIES ,:DEV_HexxVixtar, "HexxVixtar"]; return [:BOSS_ID, "Nickname", true/false(shiny?)]
    #when [:SPECIES ,:BETATESTER_FabulaFares, "FabulaFares"]; return [:BOSS_ID, "Nickname", true/false(shiny?)]
    #when [:SPECIES ,:DEV_Badman, "Badman"]; return [:BOSS_ID, "Nickname", true/false(shiny?)]
    when [:SWAMPERT, :DEV_PDM20, "PDM20"]; return [:BTBOSS_PDM20_SWAMPERT, "Helios", true]
    #when [:SPECIES ,:DEV_Endless, "Endless"]; return [:BOSS_ID, "Nickname", true/false(shiny?)]
    #when [:SPECIES ,:BETATESTER_Riptidecord, "Riptidecord"]; return [:BOSS_ID, "Nickname", true/false(shiny?)]
    #when [:SPECIES ,:DEV_DemICE, "DemICE"]; return [:BOSS_ID, "Nickname", true/false(shiny?)]
    #when [:SPECIES ,:B9K_FINALFORM, "Breloom 9000"]; return [:BOSS_ID, "Nickname", true/false(shiny?)]
    else; return nil
  end
end

def pbForceBoss(boss_check)
  case boss_check
   #when [:TRAINERID, "Trainer Name"]; return Force_BT_Boss::ID
    #when [:BETATESTER_Anime, "Anime"]; return Force_BT_Boss::Anime
    #when [:BETATESTER_MissNyakura, "MissNyakura"]; return Force_BT_Boss::MissNyakura
    #when [:BETATESTER_WitchyAlex, "WitchyAlex"]; return Force_BT_Boss::WitchyAlex
    #when [:COMMUNITYARTIST_Boro, "Boro"]; return Force_BT_Boss::Boro
    when [:COMMUNITYARTIST_Ignotus68, "Ignotus68"]; return Force_BT_Boss::Ignotus68
    #when [:COMMUNITYARTIST_Zeta, "Zeta"]; return Force_BT_Boss::Zeta
    #when [:COMMUNITYARTIST_Otter, "Otter"]; return Force_BT_Boss::Otter
    #when [:COMMUNITYARTIST_YGS, "YGS"]; return Force_BT_Boss::YGS
    #when [:COMMUNITYARTIST_Attea, "Attea"]; return Force_BT_Boss::Attea
    #when [:DEV_HexxVixtar, "HexxVixtar"]; return Force_BT_Boss::HexxVixtar
    #when [:BETATESTER_FabulaFares, "FabulaFares"]; return Force_BT_Boss::FabulaFares
    #when [:DEV_Badman, "Badman"]; return Force_BT_Boss::Badman
    when [:DEV_PDM20, "PDM20"]; return Force_BT_Boss::PDM20
    #when [:DEV_Endless, "Endless"]; return Force_BT_Boss::Endless
    #when [:BETATESTER_Riptidecord, "Riptidecord"]; return Force_BT_Boss::Riptidecord
    #when [:DEV_DemICE, "DemICE"]; return Force_BT_Boss::DemICE
    #when [:B9K_FINALFORM, "Breloom 9000"]; return Force_BT_Boss::Breloom9000
    else; return nil
  end
end

module Force_BT_Boss
  Anime       = 0
  MissNyakura = 0
  WitchyAlex  = 0
  Boro        = 0
  Ignotus68   = 1211 #T.Wigglytuff
  Zeta        = 0
  Otter       = 0
  YGS         = 0
  Attea       = 0
  HexxVixtar  = 0
  FabulaFares = 0
  Badman      = 0
  PDM20       = 1341 #Swampert
  Endless     = 0
  Riptidecord = 0
  DemICE      = 0
  Breloom9000 = 0
end


# Data Export (export Trainer data for Frontier import)#
def build_frontier_data
  File.open("dist/BT/frontier_gen.txt","wb") { |f|
    trainer_data = []
    whitelist = [:BETATESTER_Anime, :BETATESTER_MissNyakura, :BETATESTER_WitchyAlex, :COMMUNITYARTIST_Boro, :COMMUNITYARTIST_Ignotus68, :COMMUNITYARTIST_Zeta, :COMMUNITYARTIST_Otter, :COMMUNITYARTIST_YGS, :COMMUNITYARTIST_Attea, :COMMUNITYARTIST_Hypertox, :COMMUNITYARTIST_Raffs07, :ROVERDEV_SexyRexy, :DEV_HexxVixtar, :BETATESTER_FabulaFares, :DEV_Badman, :DEV_Endless, :BETATESTER_Riptidecord, :DEV_DemICE, :B9K_FINALFORM, :DEV_PDM20]
    GameData::Trainer.each do |trainer|
      next if !whitelist.include?(trainer.trainer_type)
      trainer_data.push([trainer.trainer_type, trainer.real_name, trainer.version])
    end
    for t in 0...trainer_data.length
      foe_trainers, foe_items, foe_party, foe_party_starts = TrainerBattle.generate_foes(trainer_data[t])
      # f.write("#---[#{trainer_data[t][0]}, #{trainer_data[t][1]}, #{trainer_data[t][2]}]---#\r\n")
      # f.write("#---[#{trainer_data[t][0]}, #{trainer_data[t][1]}}]---#\r\n")
      for p in 0...foe_party.length
        pkmn = foe_party[p]
        evs = []
        mon = GameData::Species.get_species_form(pkmn.species,pkmn.form).id.to_s
        itm = (GameData::Item.try_get(pkmn.item) == nil) ? "" : pkmn.item.id.to_s
        nat = (GameData::Nature.try_get(pkmn.nature) == nil) ? "" : pkmn.nature.id.to_s
        abl = (GameData::Ability.try_get(pkmn.ability) == nil) ? "" : pkmn.ability.id.to_s
        evs.push(:HP) if pkmn.ev[:HP] > 99
        evs.push(:ATK) if pkmn.ev[:ATTACK] > 99
        evs.push(:DEF) if pkmn.ev[:DEFENSE] > 99
        evs.push(:SA) if pkmn.ev[:SPECIAL_ATTACK] > 99
        evs.push(:SD) if pkmn.ev[:SPECIAL_DEFENSE] > 99
        evs.push(:SPD) if pkmn.ev[:SPEED] > 99
        mv1 = (pkmn.moves[0] == nil) ? "" : pkmn.moves[0].id
        mv2 = (pkmn.moves[1] == nil) ? "" : pkmn.moves[1].id
        mv3 = (pkmn.moves[2] == nil) ? "" : pkmn.moves[2].id
        mv4 = (pkmn.moves[3] == nil) ? "" : pkmn.moves[3].id
        f.write("#{mon};")
        f.write("#{itm};")
        f.write("#{nat};")
        f.write("#{abl};")
        if evs != []
          for e in 0...evs.length
            f.write("#{evs[e]},") if e+1 != evs.length && evs.length > 1
            f.write("#{evs[e]};") if e+1 == evs.length
          end
        else
          f.write("HP;")
        end
        f.write("#{mv1},")
        f.write("#{mv2},")
        f.write("#{mv3},")
        f.write("#{mv4}")
        f.write("\r\n")
      end
      pbSetWindowText("Writing #{t+1} / #{trainer_data.length} Trainers")
    end
    pbSetWindowText(System.game_title)
  }
end

def build_frontier_trainers
  File.open("dist/BT/bt_trainers.txt","wb") {|f|
    offset = 1186
    trainers = [
      [:BETATESTER_Anime, "Anime", 0, 5, offset],
      [:BETATESTER_MissNyakura, "MissNyakura", 6, 11, offset],
      [:BETATESTER_WitchyAlex, "WitchyAlex", 12, 17, offset],
      [:COMMUNITYARTIST_Boro, "Boro", 18, 23, offset],
      [:COMMUNITYARTIST_Ignotus68, "Ignotus68", 24, 29, offset],
      [:COMMUNITYARTIST_Zeta, "Zeta", 30, 35, offset],
      [:COMMUNITYARTIST_Otter, "Otter", 36, 41, offset],
      [:COMMUNITYARTIST_YGS, "YGS", 42, 47, offset],
      [:COMMUNITYARTIST_Attea, "Attea", 48, 53, offset],
      [:COMMUNITYARTIST_Hypertox, "Hypertox", 54, 59, offset],
      [:COMMUNITYARTIST_Raffs07, "Raffs07", 60, 65, offset],
      [:ROVERDEV_SexyRexy, "SexyRexy", 66, 71, offset],
      [:DEV_HexxVixtar, "HexxVixtar", 72, 95, offset], #23
      [:BETATESTER_FabulaFares, "FabulaFares", 96, 119, offset], #23
      [:DEV_Badman, "Badman", 120, 143, offset], #23
      [:DEV_PDM20, "PDM20", 144, 167, offset],
      [:DEV_Endless, "Endless", 168, 191, offset], #23
      [:BETATESTER_Riptidecord, "Riptidecord", 192, 215, offset], #23
      [:DEV_DemICE, "DemICE", 216, 239, offset], #23
      [:B9K_FINALFORM, "Breloom 9000", 240, 263, offset] #23
    ]
    idx = 400
    for i in 0...trainers.length
      case trainers[i][1]
        when "Anime"; text = ["Was not expecting to see a living person here, everyone ive seen so far are shadows, spirits, or some abomination thing that the shadows and spirits kill. I was just here to fight them and train up some spare pokemon, since im cursed and all. If you want a fight, sure, but be ready to work for it.", "These mons did better then i expected, these are just spare mons i was training in case others died", "well, guess its time to train up a new batch Pokemon, since you killed these ones."]
        when "MissNyakura"; text = ["I want to nap, but ok let's play!", "...How did you beat the game but lost to me?", "Noooooo my Vevees."]
        when "WitchyAlex"; text = ["what da dog doin, I'm Alex!!! Go my puppers, slayyy your enemies lmao", "wait I won???????? pupper gayming, skill issue lmao", "you should pet me or I'm gonna lick your face off,,,"]
        when "Boro"; text = ["What's up, I'm Boro. Have you been collecting my masterpieces around the region? If not, you should get on that.", "Wow you suck. But if you wanna slide me a twenty we can pretend this never happened...", "This is bull you're a cheater this game sucks what a scam I'm not even using my real controller I'm on mouse and keyboard you had aim assist carrying you."]
        when "Ignotus68"; text = ["'How could a ghost burn?' You're wondering.", "Figures.", "Do you know how many times I missed Toxic? And I still won?"]
        when "Zeta"; text = ["hehehHHAHAH, lets have some fun!!", "ew! dont cry, you'll get snot on my outfit-", "nooo...you made my scepter upset. Apologize right now!"]
        when "Otter"; text = ["Howdy! I’m Otter. Don’t you love all the different kinds of Pokémon there are? Let me show you some of my favorites!", "I can’t believe I did it!", "Well, that’s not a surprise..."]
        when "YGS"; text = ["Wus good? You're fighting ME now.", "Better luck next time, EEDIOT. >:)", "Eh, whatever, I was just kinda wingin' it."]
        when "Attea"; text = ["I'm a pokemon that trains Pokemon, don't ask how it works idk either dude. Anyway want a Pokemon battle while i'm stuck here", "Get dunked on.", "You can't catch me, even if you just won."]
        when "Raffs07"; text = ["Hello sir/ma’am/mx. I’ve taken the placement of Raffs as he decided to quit. Are you ready to battle now?", "Ah it seems I have lost! Raffs suggest read some monga while you plan your team to defeat me.", "Ah it seems I have lost. Raffs suggest you reas some manga for our next match."]
        when "Hypertox"; text = ["Wheeze… He... He's coming.", "I feel better than ever! Now a Relicanth is coming for you!", "Wheeze… that really took alot out of... Wheeze… me..."]
        when "HexxVixtar"; text = ["Fite me.", "I won.", "I Lost."]
        when "FabulaFares"; text = ["This seems like a good chance for me to test out some sets.", "Maybe I was a bit too mean with these?", "Hmmm, I guess some of these are too gimmicky."]
        when "Badman"; text = ["Fite me.", "I won.", "I Lost."]
        when "PDM20"; text = ["Surpise Bitch! I'm Invading the Battle Frontier!", "Suck it lil bitch~! o7 to your win streak!", "You Fucking what mate!? How the hell did you beat Helios!?"]
        when "Endless"; text = ["Fite me.", "I won.", "I Lost."]
        when "Riptidecord"; text = ["BOAT GOES BINTED UPN.", "You really lost to me? Pasting in the entire Bee movie script now- wait I can't do that? Copyright? Fine.", "Lose lose days..."]
        when "DemICE"; text = ["Fite me.", "I won.", "I Lost."]
        when "Breloom9000"; text = ["Fite me.", "I won.", "I Lost."]
        else; text = ["Fite me.", "I won.", "I Lost."]
      end
      idx += 1
      f.write("#------------------------------#\r\n")
      f.write("[#{idx}]\r\n")
      f.write("EndSpeechLose = #{text[2]}\r\n")
      f.write("Name = #{trainers[i][1]}\r\n")
      f.write("PokemonNos = ")
      for v in 0...2000
        f.write("#{v+trainers[i][4]},") if v >= trainers[i][2] && v < trainers[i][3]
        f.write("#{v+trainers[i][4]}\r\n") if v == trainers[i][3]
      end
      f.write("BeginSpeech = #{text[0]}\r\n")
      f.write("Type = #{trainers[i][0]}\r\n")
      f.write("EndSpeechWin = #{text[1]}\r\n")
    end
  }
end
