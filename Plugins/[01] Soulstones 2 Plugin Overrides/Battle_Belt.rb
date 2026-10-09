class Trainer
  attr_accessor(:battlebelt)
  attr_accessor(:beltbag)
  attr_accessor(:bagup)
  
  alias battlebelt_initialize initialize
  def initialize(name, trainer_type)
    battlebelt_initialize(name, trainer_type) 
    reset_battlebelt
  end

  def reset_battlebelt
    @battlebelt = {
      :med1   => [:NONE,0,"None"],
      :med2   => [:NONE,0,"None"],
      :combat => [:NONE,0,"None"]
    }
    @beltbag=PokemonBag.new
    @bagup=nil
    $usingbelt=false
  end
end

class PokemonPartyScreen
  def pbPokemonScreen
    ret = nil
    beltvisible=true
    can_access_storage = false
    if ($player.has_box_link || $bag.has?(:POKEMONBOXLINK)) &&
       !$game_switches[Settings::DISABLE_BOX_LINK_SWITCH] &&
       !$game_map.metadata&.has_flag?("DisableBoxLink")
      can_access_storage = true
    end
    @scene.pbStartScene(@party,_INTL("Battle Belt:"),nil, false, can_access_storage,true)
    loop do
      @scene.pbSetHelpText(_INTL("Battle Belt:"))
      party_idx = @scene.pbChoosePokemon(false, -1, 1)
      break if (party_idx.is_a?(Numeric) && party_idx < 0) || (party_idx.is_a?(Array) && party_idx[1] < 0)
      if party_idx.is_a?(Array) && party_idx[0] == 1
        @scene.pbSetHelpText(_INTL("Move where?"))
        old_party_idx = party_idx[1]
        party_idx = @scene.pbChoosePokemon(true, -1, 2)
        pbSwitch(old_party_idx, party_idx) if party_idx >= 0 && party_idx != old_party_idx
        next
      end
      pkmn = @party[party_idx]
      command_list = []
      commands = []
      MenuHandlers.each_available(:party_menu, self, @party, party_idx) do |option, hash, name|
        if PluginManager.installed?("Improved Field Skills") && option == :field_skill
          command_list.push([name, 1])
        elsif PluginManager.installed?("Legendary Breeding") && option == :egg_skill
          command_list.push([name, 2])
        elsif PluginManager.installed?("Pokémon Birthsigns") && option.to_s.include?("birthsign_skill")
          if [:birthsign_skill_celestial, :birthsign_skill_creator].include?(option)
            color = BirthsignHandlers::triggerMenuCommandOption(:VOID, pkmn)
            option = :celestial_skill
          else
            color = BirthsignHandlers::triggerMenuCommandOption(pkmn.birthsign.id, pkmn)
            option = :birthsign_skill
          end
          command_list.push([name, color])
        else
          command_list.push(name)
        end
        commands.push([option, hash])
      end
      command_list.push(_INTL("Cancel"))
      if !PluginManager.installed?("Improved Field Skills") && !pkmn.egg?
        insert_index = (($DEBUG && $BOSSDEV)) ? 2 : 1
        pkmn.moves.each_with_index do |move, i|
          next if !HiddenMoveHandlers.hasHandler(move.id) && ![:MILKDRINK, :SOFTBOILED].include?(move.id)
            command_list.insert(insert_index, [move.name, 1])
            commands.insert(insert_index, i)
            insert_index += 1
          end
      end
      choice = @scene.pbShowBeltCommands(command_list)
      next if choice < 0 || choice >= commands.length
      case commands[choice]
        when Array
          if [:field_skill, :birthsign_skill].include?(commands[choice][0])
            ret = commands[choice][1]["effect"].call(self, @party, party_idx)
            break if !ret.nil?
          else
            commands[choice][1]["effect"].call(self, @party, party_idx)
          end
        when Integer
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
                @scene.pbStartScene(@party, (@party.length > 1) ? _INTL("Choose a Pokémon.") : _INTL("Choose Pokémon or cancel."))
                next
              end
              return [pkmn, move.id]
            end
          end
        end
    end
    @scene.pbEndScene
    return ret
  end
end

class PokemonParty_Scene
  def pbStartScene(party, starthelptext, annotations = nil, multiselect = false, can_access_storage = false, idle=false)
    @sprites = {}
    @party = party
    @idle=idle
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
      if idle
        @sprites["pokemon#{Settings::MAX_PARTY_SIZE + 1}"] = PokemonPartyBattleBeltSprite2.new(@viewport)
      else
        @sprites["pokemon#{Settings::MAX_PARTY_SIZE + 1}"] = PokemonPartyCancelSprite2.new(@viewport)
      end
      @sprites["pokemon#{Settings::MAX_PARTY_SIZE + 2}"] = PokemonPartyCancelSprite2.new(@viewport)
    else
      if idle
        @sprites["pokemon#{Settings::MAX_PARTY_SIZE}"] = PokemonPartyBattleBeltSprite.new(@viewport)
      else
        @sprites["pokemon#{Settings::MAX_PARTY_SIZE}"] = PokemonPartyCancelSprite.new(@viewport)
      end
      @sprites["pokemon#{Settings::MAX_PARTY_SIZE + 1}"] = PokemonPartyCancelSprite.new(@viewport)
    end
    @sprites["itemicon1"] = ItemIconSprite.new(192, 352, $Trainer.battlebelt[:med1][0], @viewport)
    @sprites["itemicon1"].tone.set(0,0,0,255) if $Trainer.battlebelt[:med1][1]==0
    @sprites["itemicon1"].z  = @viewport.z + 2
    @sprites["itemicon1"].visible = false if $Trainer.battlebelt[:med1][0]==:NONE || !idle
    @sprites["itemicon2"] = ItemIconSprite.new(272, 352, $Trainer.battlebelt[:med2][0], @viewport)
    @sprites["itemicon2"].tone.set(0,0,0,255) if $Trainer.battlebelt[:med2][1]==0
    @sprites["itemicon2"].z  = @viewport.z + 2
    @sprites["itemicon2"].visible = false if $Trainer.battlebelt[:med2][0]==:NONE || !idle
    @sprites["itemicon3"] = ItemIconSprite.new(352, 352, $Trainer.battlebelt[:combat][0], @viewport)
    @sprites["itemicon3"].tone.set(0,0,0,255) if $Trainer.battlebelt[:combat][1]==0
    @sprites["itemicon3"].z  = @viewport.z + 2
    @sprites["itemicon3"].visible = false if $Trainer.battlebelt[:combat][0]==:NONE || !idle
    # Select first Pokémon
    @activecmd = 0
    @sprites["pokemon0"].selected = true
    pbFadeInAndShow(@sprites) { update }
  end

  def pbChoosePokemon(switching = false, initialsel = -1, canswitch = 0, item_moving = false)
    if @idle && !item_moving # Changed by DemICE 23-Dec-2024 fixing a battle belt issue
      @sprites["itemicon1"].visible=true if $Trainer.battlebelt[:med1][0]!=:NONE
      @sprites["itemicon2"].visible=true if $Trainer.battlebelt[:med2][0]!=:NONE
      @sprites["itemicon3"].visible=true if $Trainer.battlebelt[:combat][0]!=:NONE
    end
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
        numsprites = Settings::MAX_PARTY_SIZE + ((@multiselect) ? 2 : 1)+1
        numsprites.times do |i|
          @sprites["pokemon#{i}"].selected = (i == @activecmd)
        end
      end
      beltsprite = Settings::MAX_PARTY_SIZE + ((@multiselect) ? 1 : 0) # Changed by DemICE 25-Sep-2023
      cancelsprite = Settings::MAX_PARTY_SIZE + ((@multiselect) ? 1 : 0) + 1 # Changed by DemICE 25-Sep-2023
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
      elsif Input.trigger?(Input::ACTION) && canswitch == 1 && @party[@activecmd].is_a?(Pokemon)
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
        elsif @activecmd == beltsprite 
          return -1 if !@idle
          command = 0
            loop do
              command = pbShowBeltCommands([_INTL("Medicine 1: {1}", $Trainer.battlebelt[:med1][2]),
                                              _INTL("Medicine 2: {1}", $Trainer.battlebelt[:med2][2]),
                                              _INTL("Combat: {1}", $Trainer.battlebelt[:combat][2]),
                                              _INTL("Cancel")], command)
              case command
              ### Cancel ###
              when -1, 3
                break
              when 0
                ret = nil
                pbFadeOutIn {
                  scene = PokemonBag_Scene.new
                  screen = PokemonBagScreen.new(scene, $bag)
                  ret = screen.pbChooseItemScreen(proc { |item| ItemHandlers.hasBattleUseOnPokemon(item) })
                }
                if ret
                  itm = GameData::Item.get(ret)
                  tempslot=$Trainer.battlebelt[:med1]
                  $Trainer.battlebelt[:med1]=[ret,1,itm.name] 
                  if $Trainer.battlebelt[:med1]==$Trainer.battlebelt[:med2] && $bag.quantity(ret)<2
                    pbDisplay(_INTL("You do not have enough {1} for both slots.",itm.name))
                    $Trainer.battlebelt[:med1]=tempslot
                  else
                    @sprites["itemicon1"].dispose
                    @sprites["itemicon1"] = ItemIconSprite.new(180, 352, $Trainer.battlebelt[:med1][0], @viewport)
                    @sprites["itemicon1"].z  = @viewport.z + 2
                    @sprites["itemicon1"].visible=true
                    pbRefresh
                  end
                end
              when 1
                ret = nil
                pbFadeOutIn {
                  scene = PokemonBag_Scene.new
                  screen = PokemonBagScreen.new(scene, $bag)
                  ret = screen.pbChooseItemScreen(proc { |item| ItemHandlers.hasBattleUseOnPokemon(item) })
                }
                if ret
                  itm = GameData::Item.get(ret)
                  tempslot=$Trainer.battlebelt[:med2]
                  $Trainer.battlebelt[:med2]=[ret,1,itm.name] 
                  if $Trainer.battlebelt[:med1]==$Trainer.battlebelt[:med2] && $bag.quantity(ret)<2
                    pbDisplay(_INTL("You do not have enough {1} for both slots.",itm.name))
                    $Trainer.battlebelt[:med2]=tempslot
                  else
                    @sprites["itemicon2"].dispose
                    @sprites["itemicon2"] = ItemIconSprite.new(260, 352, $Trainer.battlebelt[:med2][0], @viewport)
                    @sprites["itemicon2"].z  = @viewport.z + 2
                    @sprites["itemicon2"].visible=true
                    pbRefresh
                  end
                end
              when 2
                ret = nil
                pbFadeOutIn {
                  scene = PokemonBag_Scene.new
                  screen = PokemonBagScreen.new(scene, $bag)
                  ret = screen.pbChooseItemScreen(proc { |item| ItemHandlers.hasBattleUseOnBattler(item,true) }) # Changed by DemICE 01-Nov-2023 fixing Guard Spec not able to be put on belt
                }
                if ret
                  itm = GameData::Item.get(ret)
                  $Trainer.battlebelt[:combat]=[ret,1,itm.name] 
                  @sprites["itemicon3"].dispose
                  @sprites["itemicon3"] = ItemIconSprite.new(340, 352, $Trainer.battlebelt[:combat][0], @viewport)
                  @sprites["itemicon3"].z  = @viewport.z + 2
                  @sprites["itemicon3"].visible=true
                  pbRefresh
                end
              end
            end
        elsif @party[@activecmd].is_a?(Pokemon)
          pbPlayDecisionSE
          @sprites["itemicon1"].visible=false
          @sprites["itemicon2"].visible=false
          @sprites["itemicon3"].visible=false
          pbSetHelpText(_INTL("Do what with this Pokémon?"))
          pbRefresh
          return @activecmd
        else
		  return -1
        end
      end
    end
  end

  def pbChangeSelection(key, currentsel)
    numsprites = Settings::MAX_PARTY_SIZE + ((@multiselect) ? 2 : 1) +((@idle) ? 1 : 0) # Changed by DemICE 25-Sep-2023
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
      currentsel = numsprites - 2 if currentsel < 0
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

  def pbShowBeltCommands(commands, index = 0)
    ret = -1
    using(cmdwindow = Window_CommandPokemonColor.new(commands)) {
      cmdwindow.z     = @viewport.z + 1
      cmdwindow.index = index
      pbBottomRight(cmdwindow)
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
end



class PokemonBagScreen
  def pbStartScreen
    @scene.pbStartScene(@bag, $player.party)
    item = nil
    loop do
      item = @scene.pbChooseItem
      break if !item
      itm = GameData::Item.get(item)
      cmdRead     = -1
      cmdUse      = -1
      cmdBelt     = -1
      cmdRegister = -1
      cmdGive     = -1
      cmdToss     = -1
      cmdDebug    = -1
      commands = []
      # Generate command list
      commands[cmdRead = commands.length]       = _INTL("Read") if itm.is_mail?
      if ItemHandlers.hasOutHandler(item) || (itm.is_machine? && $player.party.length > 0)
        if ItemHandlers.hasUseText(item)
          commands[cmdUse = commands.length]    = ItemHandlers.getUseText(item)
        else
          commands[cmdUse = commands.length]    = _INTL("Use")
        end
      end
      commands[cmdGive = commands.length]       = _INTL("Give") if $player.pokemon_party.length > 0 && itm.can_hold?
      # Changed by DemICE 25-Sep-2023
      if ItemHandlers.hasBattleUseOnPokemon(item) || ItemHandlers.hasBattleUseOnBattler(item,true) # Changed by DemICE 01-Nov-2023 fixing Guard Spec not able to be put on belt
        commands[cmdBelt = commands.length] = _INTL("Add to Belt")
      end
      commands[cmdToss = commands.length]       = _INTL("Toss") if !itm.is_important? || ($DEBUG && $BOSSDEV)
      if @bag.registered?(item)
        commands[cmdRegister = commands.length] = _INTL("Deselect")
      elsif pbCanRegisterItem?(item)
        commands[cmdRegister = commands.length] = _INTL("Register")
      end
      commands[cmdDebug = commands.length]      = _INTL("Debug") if ($DEBUG && $BOSSDEV)
      commands[commands.length]                 = _INTL("Cancel")
      # Show commands generated above
      itemname = itm.name
      command = @scene.pbShowCommands(_INTL("{1} is selected.", itemname), commands)
      if cmdRead >= 0 && command == cmdRead   # Read mail
        pbFadeOutIn {
          pbDisplayMail(Mail.new(item, "", ""))
        }
      elsif cmdUse >= 0 && command == cmdUse   # Use item
        useType = itm.field_use
        # ret: 0 = Item wasn't used; 1 = Item used; 2 = Close Bag to use in field
        if useType == 1 # Consumables
          ret = @scene.pbChoosePoke(2, false)
        elsif useType == 3 || useType == 4 || useType == 5 # TM, HM and TR
          machine = itm.move
          movename = GameData::Move.get(machine).name
          pbMessage(_INTL("\\se[PC access]You booted up {1}.\1", itm.name)) {@scene.pbUpdate}
          if pbConfirmMessage(_INTL("Do you want to teach {1} to a Pokémon?", movename)) {@scene.pbUpdate}
            ret = @scene.pbChoosePoke(2, false)
          end
        else
          ret = pbUseItem(@bag, item, @scene)
        end
        break if ret == 2   # End screen
        @scene.pbRefresh
        next
      elsif cmdGive >= 0 && command == cmdGive   # Give item to Pokémon
        if $player.pokemon_count == 0
          @scene.pbDisplay(_INTL("There is no Pokémon."))
        elsif itm.is_important?
          @scene.pbDisplay(_INTL("The {1} can't be held.",itemname))
        else
          @scene.pbChoosePoke(1, false)
        end
      elsif cmdToss >= 0 && command == cmdToss   # Toss item
        qty = @bag.quantity(item)
        if qty > 1
          helptext = _INTL("Toss out how many {1}?", itm.name_plural)
          qty = @scene.pbChooseNumber(helptext, qty)
        end
        if qty > 0
          itemname = itm.name_plural if qty > 1
          if pbConfirm(_INTL("Is it OK to throw away {1} {2}?", qty, itemname))
            pbDisplay(_INTL("Threw away {1} {2}.",qty,itemname))
            @bag.remove(item, qty)
            @scene.pbRefresh
          end
        end
      elsif cmdBelt >= 0 && command == cmdBelt   # Changed by DemICE 25-Sep-2023        
        command = 0
        if  ItemHandlers.hasBattleUseOnPokemon(item)
          loop do
            command = @scene.pbShowCommands(_INTL("Where to place {1}?", itemname),
                                            [_INTL("Slot 1: {1}", $Trainer.battlebelt[:med1][2]),
                                            _INTL("Slot 2: {1}", $Trainer.battlebelt[:med2][2]),
                                            _INTL("Cancel")], command)
            case command
            ### Cancel ###
            when -1, 2
              break
            when 0
              tempslot=$Trainer.battlebelt[:med1]
              $Trainer.battlebelt[:med1]=[itm.id,1,itm.name]
              if $Trainer.battlebelt[:med1]==$Trainer.battlebelt[:med2] && $bag.quantity(itm.id)<2
                pbDisplay(_INTL("You do not have enough {1} for both slots.",itemname))
                $Trainer.battlebelt[:med1]=tempslot
              end
            when 1
              tempslot=$Trainer.battlebelt[:med2]
              $Trainer.battlebelt[:med2]=[itm.id,1,itm.name]
              if $Trainer.battlebelt[:med1]==$Trainer.battlebelt[:med2] && $bag.quantity(itm.id)<2
                pbDisplay(_INTL("You do not have enough {1} for both slots.",itemname))
                $Trainer.battlebelt[:med2]=tempslot
              end
            end
          end
        elsif ItemHandlers.hasBattleUseOnBattler(item,true) # Changed by DemICE 01-Nov-2023 fixing Guard Spec not able to be put on belt
          loop do
            command = @scene.pbShowCommands(_INTL("Swap items?"),
                                            [_INTL("Current item: {1}", $Trainer.battlebelt[:combat][2]),
                                            _INTL("Cancel")], command)
            case command
            ### Cancel ###
            when -1, 1
              break
            when 0
              $Trainer.battlebelt[:combat]=[itm.id,1,itm.name]
            end
          end
        end
      elsif cmdRegister >= 0 && command == cmdRegister   # Register item
        if @bag.registered?(item)
          @bag.unregister(item)
        else
          @bag.register(item)
        end
        @scene.pbRefresh
      elsif cmdDebug >= 0 && command == cmdDebug   # Debug
        command = 0
        loop do
          command = @scene.pbShowCommands(_INTL("Do what with {1}?", itemname),
                                          [_INTL("Change quantity"),
                                           _INTL("Make Mystery Gift"),
                                           _INTL("Cancel")], command)
          case command
          ### Cancel ###
          when -1, 2
            break
          ### Change quantity ###
          when 0
            qty = @bag.quantity(item)
            itemplural = itm.name_plural
            params = ChooseNumberParams.new
            params.setRange(0, Settings::BAG_MAX_PER_SLOT)
            params.setDefaultValue(qty)
            newqty = pbMessageChooseNumber(
              _INTL("Choose new quantity of {1} (max. #{Settings::BAG_MAX_PER_SLOT}).",itemplural),params
              ) { @scene.pbUpdate }
            if newqty > qty
              @bag.add(item, newqty - qty)
            elsif newqty < qty
              @bag.remove(item, qty - newqty)
            end
            @scene.pbRefresh
            break if newqty == 0
          ### Make Mystery Gift ###
          when 1
            pbCreateMysteryGift(1, item)
          end
        end
      end
    end
    ($game_temp.fly_destination) ? @scene.dispose : @scene.pbEndScene
    return item
  end
end


# Pokémon party buttons and menu
#===============================================================================
class PokemonPartyConfirmBattleBeltSprite < Sprite
  attr_reader :selected

  def initialize(text, x, y, narrowbox = false, viewport = nil)
    super(viewport)
    @refreshBitmap = true
    @bgsprite = ChangelingSprite.new(0, 0, viewport)
    if narrowbox
      @bgsprite.addBitmap("desel", "Graphics/Pictures/Party/icon_cancel_narrow")
      @bgsprite.addBitmap("sel", "Graphics/Pictures/Party/icon_cancel_narrow_sel")
    else
      @bgsprite.addBitmap("desel", "Graphics/Pictures/Party/icon_belt")
      @bgsprite.addBitmap("sel", "Graphics/Pictures/Party/icon_belt_sel")
    end
    @bgsprite.changeBitmap("desel")
    @overlaysprite = BitmapSprite.new(@bgsprite.bitmap.width, @bgsprite.bitmap.height, viewport)
    @overlaysprite.z = viewport.z + 1
    pbSetSystemFont(@overlaysprite.bitmap)
    textpos = [[text, 56, (narrowbox) ? 8 : 14, 2, Color.new(248, 248, 248), Color.new(40, 40, 40)]]
    pbDrawTextPositions(@overlaysprite.bitmap, textpos)
    self.x = x
    self.y = y
  end

  def dispose
    @bgsprite.dispose
    @overlaysprite.bitmap.dispose
    @overlaysprite.dispose
    super
  end

  def viewport=(value)
    super
    refresh
  end

  def x=(value)
    super
    refresh
  end

  def y=(value)
    super
    refresh
  end

  def color=(value)
    super
    refresh
  end

  def selected=(value)
    if @selected != value
      @selected = value
      refresh
    end
  end

  def refresh
    if @bgsprite && !@bgsprite.disposed?
      @bgsprite.changeBitmap((@selected) ? "sel" : "desel")
      @bgsprite.x     = self.x
      @bgsprite.y     = self.y
      @bgsprite.z     = 100000
      @bgsprite.color = self.color
    end
    if @overlaysprite && !@overlaysprite.disposed?
      @overlaysprite.x     = self.x
      @overlaysprite.y     = self.y
      @overlaysprite.z     = 100000
      @overlaysprite.color = self.color
    end
  end
end

#===============================================================================
#
#===============================================================================
class PokemonPartyBattleBeltSprite < PokemonPartyConfirmBattleBeltSprite
  def initialize(viewport = nil)
    super(_INTL(""), 153, 320, false, viewport)
  end
end

#===============================================================================
#
#===============================================================================
class PokemonPartyConfirmBeltSprite < PokemonPartyConfirmBattleBeltSprite
  def initialize(viewport = nil)
    super(_INTL(""), 153, 298, true, viewport)
  end
end

#===============================================================================
#
#===============================================================================
class PokemonPartyBattleBeltSprite2 < PokemonPartyConfirmBattleBeltSprite
  def initialize(viewport = nil)
    super(_INTL(""), 153, 338, true, viewport)
  end
end

class Battle
  alias battlebelt_initialize initialize
  def initialize(scene, p1, p2, player, opponent)
    battlebelt_initialize(scene, p1, p2, player, opponent)
    if !wildBattle? && ($PokemonSystem.battle_belt==0 || $Trainer.difficulty_mode>0) && !$game_switches[405]
      hasmegaring=$bag.has?(:MEGARING)
      $usingbelt=true
      $Trainer.bagup=$bag
      $Trainer.beltbag=PokemonBag.new
      $beltquantity=0
      [$Trainer.battlebelt[:med1], $Trainer.battlebelt[:med2], $Trainer.battlebelt[:combat]].each do | beltitem |
        if beltitem[1]>0
          $Trainer.beltbag.add(beltitem[0]) 
          $beltquantity+=1
        end
      end
      $Trainer.beltbag.add(:MEGARING) if hasmegaring
      $bag=$Trainer.beltbag
    end
  end
end

class Battle::Scene
  def pbItemMenu(idxBattler, _firstAction)
    # Fade out and hide all sprites
    visibleSprites = pbFadeOutAndHide(@sprites)
    # Set Bag starting positions
    if @battle.wildBattle? || ($PokemonSystem.battle_belt==1 && $Trainer.difficulty_mode==0) || $game_switches[405]
      oldLastPocket = $bag.last_viewed_pocket
      oldChoices    = $bag.last_pocket_selections.clone
      $bag.last_viewed_pocket     = @bagLastPocket if @bagLastPocket
      $bag.reset_last_selections
    end
    #$bag.last_pocket_selections = @bagChoices if @bagChoices
    # Setting up the party and starting the Bag screen
    partyPos = @battle.pbPartyOrder(idxBattler)
    partyStart, _partyEnd = @battle.pbTeamIndexRangeFromBattlerIndex(idxBattler)
    modParty = @battle.pbPlayerDisplayParty(idxBattler)
    itemScene = PokemonBag_Scene.new
    if @battle.wildBattle? || ($PokemonSystem.battle_belt==1 && $Trainer.difficulty_mode==0) || $game_switches[405]
      itemScene.pbStartScene($bag, modParty, true,
                            proc { |item|
                              useType = GameData::Item.get(item).battle_use
                              next useType && useType > 0
                            }, false, false)
    else
      $bag.reset_last_selections
      itemScene.pbStartScene($bag, modParty, true,
                            proc { |item|
                              useType = GameData::Item.get(item).battle_use
                              next useType && useType > 0
                            }, true)
      #itemScene.pbStartScene($bag, modParty, true, nil, true)
    end
    # Loop while in Bag screen
    wasTargeting = false
    loop do
      # Select an item
      item = itemScene.pbChooseItem
      break if !item
      # Choose a command for the selected item
      item = GameData::Item.get(item)
      itemName = item.name
      useType = item.battle_use
      cmdUse = -1
      commands = []
      commands[cmdUse = commands.length] = _INTL("Use") if useType && useType != 0
      commands[commands.length]          = _INTL("Cancel")
      command = itemScene.pbShowCommands(_INTL("{1} is selected.", itemName), commands)
      next unless cmdUse >= 0 && command == cmdUse   # Use
      # Use types:
      # 0 = not usable in battle
      # 1 = use on Pokémon (lots of items, Blue Flute)
      # 2 = use on Pokémon's move (Ethers)
      # 3 = use on battler (X items, Persim Berry, Red/Yellow Flutes)
      # 4 = use on opposing battler (Poké Balls)
      # 5 = use no target (Poké Doll, Guard Spec., Poké Flute, Launcher items)
      case useType
      when 1, 2, 3   # Use on Pokémon/Pokémon's move/battler
        # Auto-choose the Pokémon/battler whose action is being decided if they
        # are the only available Pokémon/battler to use the item on
        case useType
        when 1   # Use on Pokémon
          if @battle.pbTeamLengthFromBattlerIndex(idxBattler) == 1
            break if yield item.id, useType, @battle.battlers[idxBattler].pokemonIndex, -1, itemScene
          end
        when 3   # Use on battler
          if @battle.pbPlayerBattlerCount == 1
            break if yield item.id, useType, @battle.battlers[idxBattler].pokemonIndex, -1, itemScene
          end
        end
        # Get player's party
        party    = @battle.pbParty(idxBattler)
        partyPos = @battle.pbPartyOrder(idxBattler)
        partyStart, _partyEnd = @battle.pbTeamIndexRangeFromBattlerIndex(idxBattler)
        modParty = @battle.pbPlayerDisplayParty(idxBattler)
        # Start Pokémon selection
        idxParty = -1
        # Loop while in party screen
        loop do
          # Select a Pokémon
          pbPlayDecisionSE; idxParty = itemScene.pbChoosePoke(0,false)
          break if idxParty < 0
          idxPartyRet = -1
          partyPos.each_with_index do |pos, i|
            next if pos != idxParty + partyStart
            idxPartyRet = i
            break
          end
          next if idxPartyRet < 0
          pkmn = party[idxPartyRet]
          next if !pkmn || pkmn.egg?
          idxMove = -1
          if useType == 2   # Use on Pokémon's move
            idxMove = itemScene.pbChooseMove(pkmn,_INTL("Restore which move?"))
            next if idxMove < 0
          end  
          break if yield item.id, useType, idxPartyRet, idxMove, itemScene
        end
        # Cancelled choosing a Pokémon; show the Bag screen again
        break if idxParty >= 0
      when 4   # Use on opposing battler (Poké Balls)
        idxTarget = -1
        if @battle.pbOpposingBattlerCount(idxBattler) == 1
          @battle.allOtherSideBattlers(idxBattler).each { |b| idxTarget = b.index }
          break if yield item.id, useType, idxTarget, -1, itemScene
        else
          wasTargeting = true
          # Fade out and hide Bag screen
          itemScene.pbFadeOutScene
          # Fade in and show the battle screen, choosing a target
          tempVisibleSprites = visibleSprites.clone
          tempVisibleSprites["commandWindow"] = false
          tempVisibleSprites["targetWindow"]  = true
          idxTarget = pbChooseTarget(idxBattler, GameData::Target.get(:Foe), tempVisibleSprites)
          if idxTarget >= 0
            break if yield item.id, useType, idxTarget, -1, self
          end
          # Target invalid/cancelled choosing a target; show the Bag screen again
          wasTargeting = false
          pbFadeOutAndHide(@sprites)
          itemScene.pbFadeInScene
        end
      when 5   # Use with no target
        break if yield item.id, useType, idxBattler, -1, itemScene
      end
    end
    @bagLastPocket = $bag.last_viewed_pocket
    @bagChoices    = $bag.last_pocket_selections.clone
    $bag.last_viewed_pocket     = oldLastPocket
    $bag.last_pocket_selections = oldChoices
    # Close Bag screen
    itemScene.pbEndScene
    # Fade back into battle screen (if not already showing it)
    pbFadeInAndShow(@sprites, visibleSprites) if !wasTargeting
  end
end


class PokemonBag
  def add(item, qty = 1)
    item_data = GameData::Item.try_get(item)
    return false if !item_data
    pocket = ($usingbelt) ? 1 : item_data.pocket
    max_size = max_pocket_size(pocket)
    max_size = @pockets[pocket].length + 1 if max_size < 0   # Infinite size
    ret = ItemStorageHelper.add(@pockets[pocket],
                                max_size, Settings::BAG_MAX_PER_SLOT, item_data.id, qty)
    if ret 
      if $Trainer.battlebelt[:med2][0]==item && $Trainer.battlebelt[:med2][1]==0
        $Trainer.battlebelt[:med2][1]=1
        if qty>1 && $Trainer.battlebelt[:med1][0]==item && $Trainer.battlebelt[:med1][1]==0
          $Trainer.battlebelt[:med1][1]=1
        end
      elsif $Trainer.battlebelt[:med1][0]==item && $Trainer.battlebelt[:med1][1]==0
        $Trainer.battlebelt[:med1][1]=1
      elsif $Trainer.battlebelt[:combat][0]==item && $Trainer.battlebelt[:combat][1]==0
        $Trainer.battlebelt[:combat][1]=1
      end
    end                            
    if ret && Settings::BAG_POCKET_AUTO_SORT[pocket - 1]
      @pockets[pocket].sort! { |a, b| GameData::Item.keys.index(a[0]) <=> GameData::Item.keys.index(b[0]) }
    end
    return ret
  end

  def remove(item, qty = 1)
    item_data = GameData::Item.try_get(item)
    return false if !item_data
    pocket = ($usingbelt) ? 1 : item_data.pocket
    curr_qty = $bag.quantity(item)
    if ItemStorageHelper.remove(@pockets[pocket], item_data.id, qty)
      if $Trainer.battlebelt[:med2][0]==item && $Trainer.battlebelt[:med2][1]==1
        if $usingbelt
          $Trainer.battlebelt[:med2][1]=0 if $bag.quantity(item) < curr_qty
          if qty>1 && $Trainer.battlebelt[:med1][0]==item && $Trainer.battlebelt[:med1][1]==1
            $Trainer.battlebelt[:med1][1]=0 if $bag.quantity(item) < curr_qty
          end
        else
          $Trainer.battlebelt[:med2][1]=0 if $bag.quantity(item) == 0 
          if qty>1 && $Trainer.battlebelt[:med1][0]==item && $Trainer.battlebelt[:med1][1]==1
            $Trainer.battlebelt[:med1][1]=0 if $bag.quantity(item) == 0
          end
        end
      elsif $Trainer.battlebelt[:med1][0]==item && $Trainer.battlebelt[:med1][1]==1
        $Trainer.battlebelt[:med1][1]=0 if $bag.quantity(item)==0
      elsif $Trainer.battlebelt[:combat][0]==item && $Trainer.battlebelt[:combat][1]==1
        $Trainer.battlebelt[:combat][1]=0 if $bag.quantity(item)==0
      end
      return true
    end
  end

  def quantity(item)
    item_data = GameData::Item.try_get(item)
    return 0 if !item_data
    pocket = ($usingbelt) ? 1 : item_data.pocket
    return ItemStorageHelper.quantity(@pockets[pocket], item_data.id)
  end
end

MenuHandlers.add(:party_menu, :switch, {
  "name"      => _INTL("Switch"),
  "order"     => 30,
  "condition" => proc { |screen, party, party_idx| next party.length > 1 },
  "effect"    => proc { |screen, party, party_idx|
    screen.scene.pbSetHelpText(_INTL("Move where?"))
    old_party_idx = party_idx
    party_idx = screen.scene.pbChoosePokemon(true)
    screen.pbSwitch(old_party_idx, party_idx) if party_idx >= 0 && party_idx != old_party_idx
  }
})

module BattleCreationHelperMethods
  module_function
  def after_battle(outcome, can_lose)
    # Changed By DemICE 26-Sep-2023  Battle Belt Mechanic
    if !$Trainer.bagup.nil?
      $usingbelt=false
      $bag=$Trainer.bagup
      $Trainer.bagup=nil
      [$Trainer.battlebelt[:med1], $Trainer.battlebelt[:med2], $Trainer.battlebelt[:combat]].each do | beltitem |
        $bag.remove(beltitem[0]) if beltitem[1]==0
      end  
      if $Trainer.battlebelt[:med1]==$Trainer.battlebelt[:med2]
        $Trainer.battlebelt[:med1][1]=1 if $bag.quantity($Trainer.battlebelt[:med1][0])>0
        $Trainer.battlebelt[:med2][1]=1 if $bag.quantity($Trainer.battlebelt[:med2][0])>1
      else
        $Trainer.battlebelt[:med1][1]=1 if $bag.quantity($Trainer.battlebelt[:med1][0])>0
        $Trainer.battlebelt[:med2][1]=1 if $bag.quantity($Trainer.battlebelt[:med2][0])>0
      end
      $Trainer.battlebelt[:combat][1]=1 if $bag.quantity($Trainer.battlebelt[:combat][0])>0
    end
    # Battle Belt mechanic End.
    $player.party.each do |pkmn|
      pkmn.statusCount = 0 if pkmn.status == :POISON   # Bad poison becomes regular
      pkmn.makeUnmega
      pkmn.makeUnprimal
    end
    if $PokemonGlobal.partner
      $player.heal_party
      $PokemonGlobal.partner[3].each do |pkmn|
        pkmn.heal
        pkmn.makeUnmega
        pkmn.makeUnprimal
      end
    end
    if [2, 5].include?(outcome) && can_lose   # if loss or draw
      $player.party.each { |pkmn| pkmn.heal }
      (Graphics.frame_rate / 4).times { Graphics.update }
    end
    EventHandlers.trigger(:on_end_battle, outcome, can_lose)
    $game_player.straighten
  end
end



module ItemHandlers
  # Changed by DemICE 01-Nov-2023 fixing Guard Spec not able to be put on belt
  def self.hasBattleUseOnBattler(item,belt=false)
    return true if item == :GUARDSPEC && belt
    return !BattleUseOnBattler[item].nil?
  end
end