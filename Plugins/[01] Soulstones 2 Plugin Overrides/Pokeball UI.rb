#===============================================================================
# Poke Ball UI.
#===============================================================================
class Battle::Scene
  alias pokeball_pbInitSprites pbInitSprites
  def pbInitSprites
    pokeball_pbInitSprites
    @pokeball_path = "Graphics/Plugins/Enhanced UI/Battle UI/"
    @pokeballUIToggle = nil    
    @sprites["pokeballUI"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    @sprites["pokeballUI"].z = 300
    @sprites["pokeballUI"].visible = false
    pbSetSmallFont(@sprites["pokeballUI"].bitmap)
    @pokeballUIOverlay = @sprites["pokeballUI"].bitmap
    ballY = @sprites["messageBox"].y - 56
    5.times do |i|
      case i
        when 0 then ballX = 64
        when 1 then ballX = 146
        when 2 then ballX = 256
        when 3 then ballX = 366
        when 4 then ballX = 448
      end
      @sprites["ball_icon#{i}"] = ItemIconSprite.new(ballX, ballY, nil, @viewport)
      @sprites["ball_icon#{i}"].visible = false
      @sprites["ball_icon#{i}"].z = 300
    end
  end

  def pbCommandMenuEx(idxBattler, texts, mode = 0)
    has_info  = PluginManager.installed?("Enhanced UI")
    can_focus = PluginManager.installed?("Focus Meter System")
    pbShowWindow(COMMAND_BOX)
    cw = @sprites["commandWindow"]
    cw.setTexts(texts)
    cw.setIndexAndMode(@lastCmd[idxBattler], mode)
    pbSelectBattler(idxBattler)
    ret = -1
    loop do
      oldIndex = cw.index
      pbUpdate(cw)
      if Input.trigger?(Input::LEFT)
        cw.index -= 1 if (cw.index & 1) == 1
      elsif Input.trigger?(Input::RIGHT)
        cw.index += 1 if (cw.index & 1) == 0
      elsif Input.trigger?(Input::UP)
        cw.index -= 2 if (cw.index & 2) == 2
      elsif Input.trigger?(Input::DOWN)
        cw.index += 2 if (cw.index & 2) == 0
      end
      pbPlayCursorSE if cw.index != oldIndex
      if Input.trigger?(Input::USE)
        pbPlayDecisionSE
        ret = cw.index
        @lastCmd[idxBattler] = ret
        pbHidePluginUI if can_focus && ret > 0
        break
      elsif Input.trigger?(Input::BACK) && mode == 0 && @battle.wildBattle?
        if cw.index == 3
          pbPlayDecisionSE
          ret = cw.index
          @lastCmd[idxBattler] = ret
          pbHidePluginUI if can_focus && ret > 0
          break
        else
          cw.index = 3
        end
      elsif Input.trigger?(Input::BACK) && mode > 0
        pbPlayCancelSE
        break
      elsif Input.triggerex?(:V) || Input.trigger?(Input::SPECIAL) # Changed by DemICE 16-Oct-2023 toggle stat stages boosts on/off
        if $statBoostsToggle
          $statBoostsToggle = false
          pbPlayDecisionSE
          pbTutorialWindow(
           _INTL("Toggled Stat Stages visibility ON."),
           @scene)
        else
          $statBoostsToggle = true
          pbPlayCancelSE
          pbTutorialWindow(
           _INTL("Toggled Stat Stages visibility OFF."),
         @scene)
        end
        break
      elsif Input.trigger?(Input::F9) && ($DEBUG && $BOSSDEV)
        pbPlayDecisionSE
        pbHidePluginUI
        ret = -2
        break
      elsif Input.trigger?(Input::ACTION) && @battle.wildBattle? && @battle.wildBattleMode != :raid
        pbHideFocusPanel
        pbHideBattleInfo
        if pbToggleBallInfo(idxBattler)
          ret = 1
          break
        end
      elsif has_info && (Input.triggerex?(Settings::BATTLE_INFO_KEY) || Input.trigger?(Input::JUMPUP))
        pbHideFocusPanel
        pbToggleBattleInfo
      elsif can_focus && Input.triggerex?(Settings::FOCUS_PANEL_KEY)
        pbHideBattleInfo
        pbToggleFocusPanel
      end
    end
    return ret
  end

  #-----------------------------------------------------------------------------
  # Utility for updating UI elements.
  #-----------------------------------------------------------------------------
  def pbUpdateInfoSprites
    @sprites["leftarrow"].update
    @sprites["rightarrow"].update
    @sprites.each_key do |key|
      next if !key.include?("info_icon")
      next if @sprites[key].disposed?
      @sprites[key].update
    end
  end
 
  #-----------------------------------------------------------------------------
  # Utilities for displaying UI elements.
  #-----------------------------------------------------------------------------
  def pbHideInfoUI
    return if pbInSafari?
    @pokeballUIToggle = nil
    @sprites["pokeballUI"].visible = false
    @pokeballUIOverlay.clear
    # @battle.allBattlers.each do |b|
      # @sprites["info_icon#{b.index}"].visible = false
    # end
    5.times { |i| pbUpdateBallIcon(i, nil, true) }
  end
  
  #-----------------------------------------------------------------------------
  # Toggles the visibility of the Poke Ball selection menu.
  #-----------------------------------------------------------------------------
  def pbToggleBallInfo(idxBattler)
    return false if pbInSafari?
    return false if !@battle.pbCanUsePokeBall?(idxBattler) && @battle.wildBattleMode != :raid
    ballPocket = $bag.get_ball_pocket
    return false if $bag.get_ball_pocket < 0
    pbHideInfoUI if @pokeballUIToggle != :ball
    @pokeballUIToggle = (@pokeballUIToggle.nil?) ? :ball : nil
    (@pokeballUIToggle) ? pbSEPlay("GUI party switch") : pbPlayCloseMenuSE
    @sprites["pokeballUI"].visible = !@pokeballUIToggle.nil?
    return pbSelectBallInfo(idxBattler, ballPocket)
  end
  
  #-----------------------------------------------------------------------------
  # Updates a Poke Ball icon.
  #-----------------------------------------------------------------------------
  def pbUpdateBallIcon(index, item, blank = false)
    @sprites["ball_icon#{index}"].item = item
    @sprites["ball_icon#{index}"].visible = true
    if blank
      @sprites["ball_icon#{index}"].blankzero = true
      pbShowOutline("ball_icon#{index}", false)
    else
      @sprites["ball_icon#{index}"].blankzero = false
      pbUpdateOutline("ball_icon#{index}", item)
      pbShowOutline("ball_icon#{index}", true)
    end
  end
  
  #-----------------------------------------------------------------------------
  # Draws the Poke Ball menu.
  #-----------------------------------------------------------------------------
  def pbUpdateBallSelection(items, index, showDesc = false)
    @pokeballUIOverlay.clear
    return if @pokeballUIToggle != :ball
    ypos = @sprites["messageBox"].y - 128
    imagePos = [[@pokeball_path + "pokeball_bg", 0, ypos]]
    imagePos.push([@pokeball_path + "pokeball_desc", 0, ypos - 69]) if showDesc
    textY = (showDesc) ? ypos - 55 : ypos + 14
    action = (showDesc) ? _INTL("ACT: Hide") : _INTL("ACT: Details")
    item = GameData::Item.try_get(items[index][0])
    name = (item) ? _INTL("{1}", item.name) : _INTL("Return")
    desc = (item) ? item.description : _INTL("Return to the command menu.")
    textPos = [
      [_INTL("USE: Throw"), 50, textY, 2, BASE_LIGHT],
      [action, Graphics.width - 50, textY, 2, BASE_LIGHT],
      [name, Graphics.width / 2, textY, 2, BASE_LIGHT, SHADOW_LIGHT, :outline]
    ]
    ballY = @sprites["messageBox"].y - 25
    range = ((index - 2)..(index + 2)).to_a
    range.each_with_index do |pos, i|
      if pos < 0 || pos > items.length - 1
        pbUpdateBallIcon(i, nil, true)
      else
        try_item = items[pos][0]
        pbUpdateBallIcon(i, try_item)
        if try_item
          x = @sprites["ball_icon#{i}"].x
          x += 2 if i == index
          text_colors = (pos == index) ? [BASE_LIGHT, SHADOW_LIGHT, :outline] : [BASE_DARK, SHADOW_DARK]
          textPos.push([items[pos][1].to_s, x, ballY, 2, *text_colors])
        end
      end
    end
    pbDrawImagePositions(@pokeballUIOverlay, imagePos)
    pbDrawTextPositions(@pokeballUIOverlay, textPos)
    drawTextEx(@pokeballUIOverlay, 10, ypos - 21, Graphics.width - 10, 2, 
      desc, BASE_DARK, SHADOW_DARK) if showDesc
  end
  
  #-----------------------------------------------------------------------------
  # Handles the controls for the Poke Ball menu.
  #-----------------------------------------------------------------------------
  def pbSelectBallInfo(idxBattler, pocket)
    return false if @pokeballUIToggle != :ball
    # pbHideUIPrompt
    useBall = false
    showDesc = false
    items = $bag.pockets[pocket].clone
    items.push([nil])
    items.unshift([nil])
    index = $bag.last_viewed_index(pocket) + 1
    maxIdx = items.length - 1
    battler = @battle.battlers[idxBattler].pbDirectOpposing(true)
    pbUpdateBallSelection(items, index, showDesc)
    @sprites["leftarrow"].x = 174
    @sprites["leftarrow"].y = @sprites["ball_icon0"].y
    @sprites["rightarrow"].x = 298
    @sprites["rightarrow"].y = @sprites["ball_icon0"].y
    loop do
      pbUpdate
      pbUpdateInfoSprites
      dorefresh = false
      item = items[index][0]
      @sprites["leftarrow"].visible = index > 0
      @sprites["rightarrow"].visible = index < maxIdx
      if Input.trigger?(Input::USE)
        if !item
          pbPlayCloseMenuSE
          break
        end
        pbPlayDecisionSE
        if ItemHandlers.triggerCanUseInBattle(item, battler.pokemon, battler, nil, true, @battle, self) && @battle.wildBattleMode != :raid
          useBall = @battle.pbRegisterItem(idxBattler, item, battler.index)
          $bag.set_last_viewed_index(pocket, index - 1)
          break
        elsif ItemHandlers.triggerCanUseInBattle(item, battler.pokemon, battler, nil, true, @battle, self) && @battle.wildBattleMode == :raid
          useBall = item
          $bag.set_last_viewed_index(pocket, index - 1)
          break
        end
        pbShowWindow(COMMAND_BOX)
      elsif Input.trigger?(Input::ACTION)
        showDesc = !showDesc
        pbPlayDecisionSE
        dorefresh = true
      elsif Input.trigger?(Input::BACK)
        pbPlayCloseMenuSE
        break
      elsif Input.repeat?(Input::LEFT)
        index -= 1
        index = maxIdx if index < 0
        pbPlayCursorSE
        dorefresh = true
      elsif Input.repeat?(Input::RIGHT) 
        index += 1
        index = 0 if index > maxIdx
        pbPlayCursorSE
        dorefresh = true
      elsif Input.trigger?(Input::JUMPUP) && index > 0
        index = 0
        pbPlayCursorSE
        dorefresh = true
      elsif Input.trigger?(Input::JUMPDOWN) && index < maxIdx
        index = maxIdx
        pbPlayCursorSE
        dorefresh = true
      end
      if dorefresh
        pbUpdateBallSelection(items, index, showDesc)
      end
    end
    pbHideInfoUI
    @sprites["leftarrow"].visible = false
    @sprites["rightarrow"].visible = false
    # pbRefreshUIPrompt(idxBattler) if !useBall
    return useBall
  end
end


#===============================================================================
# Battle utilities.
#===============================================================================
class Battle
  #-----------------------------------------------------------------------------
  # Utility for checking if Poke Balls are usable.
  #-----------------------------------------------------------------------------
  def pbCanUsePokeBall?(idxBattler)
    return false if pbInSafari? || pbInBugContest?
    return false if !@internalBattle
    return false if @disablePokeBalls
    return false if trainerBattle?
    return false if $bag.get_ball_pocket < 0
    idxBattler = idxBattler.index if idxBattler.respond_to?("index")
    return false if !pbOwnedByPlayer?(idxBattler || 0)
    return false if pbOpposingBattlerCount(idxBattler || 0) > 1
    allSameSideBattlers(idxBattler || 0).each do |b|
      return false if @choices[b.index][0] != :None
    end
    return true
  end
  
  #-----------------------------------------------------------------------------
  # Aliased to end the command phase if a Poke Ball was selected.
  #-----------------------------------------------------------------------------
  alias enhanced_pbItemMenu pbItemMenu
  def pbItemMenu(idxBattler, firstAction)
    return true if @choices[idxBattler][0] == :UseItem
    return enhanced_pbItemMenu(idxBattler, firstAction)
  end
end


#===============================================================================
# Bag utilities.
#===============================================================================
class PokemonBag
  def get_ball_pocket
    @pockets.each_with_index do |p, i|
      next if p.empty?
      next if !GameData::Item.get(p[0][0]).is_poke_ball?
      return i
    end
    return -1
  end
end

class PokemonSystem
  # Use 0 for ON, 1 for OFF
  attr_accessor :battlePartyMode

  # Set default value for new option when a new PokemonSystem object is created
  alias _battpartymode_initialize initialize
  def initialize(*args)
    _battpartymode_initialize(*args)   # call the original initialize
    @battlePartyMode = 0         # default to ON
  end
end

MenuHandlers.add(:options_menu, :quick_party_toggle, {
  "name"        => _INTL("Battle Party"),
  "order"       => 50,
  "type"        => EnumOption,
  "parameters"  => [_INTL("Quick"), _INTL("Classic")],
  "description" => _INTL("Switch between Classic and Quick Party Menu in battle."),
  "get_proc"    => proc { next $PokemonSystem.battlePartyMode }, # returns 0 or 1
  "set_proc"    => proc { |value, _scene|
    if $PokemonSystem
      $PokemonSystem.battlePartyMode = value
    end
  }
})

class Battle
  def pbPartyMenu(idxBattler)
    ret = -1
    if @debug
      ret = @battleAI.pbDefaultChooseNewEnemy(idxBattler, pbParty(idxBattler))
    else
      bat_part_mode = ($PokemonSystem.battlePartyMode.nil?) ? 1 : $PokemonSystem.battlePartyMode
      if bat_part_mode == 0
        ret = pbTogglePartyInfo(idxBattler, false, true, true)
      else
        ret = pbPartyScreen(idxBattler, false, true, true)
      end
    end
    return ret >= 0
  end

  def pbSwitchInBetween(idxBattler, checkLaxOnly = false, canCancel = false)
    bat_part_mode = ($PokemonSystem.battlePartyMode.nil?) ? 1 : $PokemonSystem.battlePartyMode
    if bat_part_mode == 0
      return pbTogglePartyInfo(idxBattler, checkLaxOnly, canCancel) if pbOwnedByPlayer?(idxBattler)
    else
      return pbPartyScreen(idxBattler, checkLaxOnly, canCancel) if pbOwnedByPlayer?(idxBattler)
    end
    return @battleAI.pbDefaultChooseNewEnemy(idxBattler, pbParty(idxBattler))
  end

  def pbTogglePartyInfo(idxBattler, checkLaxOnly = false, canCancel = false, shouldRegister = false)
    ret, idxParty = @scene.pbTogglePartyInfo(idxBattler, canCancel) 
    if ret != -1
      partyScene = nil
      if checkLaxOnly
        ret = -1 if !pbCanSwitchLaxPartyInfo?(idxBattler, idxParty, @scene)
      elsif !pbCanSwitchPartyInfo?(idxBattler, idxParty, @scene)
        ret = -1
      end
      if shouldRegister && (idxParty < 0 || !pbRegisterSwitch(idxBattler, idxParty))
        ret = -1
      end
    end
    return ret
  end

  def pbCanSwitchLaxPartyInfo?(idxBattler, idxParty, partyScene = nil)
    return true if idxParty < 0
    party = pbParty(idxBattler)
    return false if idxParty >= party.length
    return false if !party[idxParty]
    if party[idxParty].egg?
      pbDisplayBrief(_INTL("An Egg can't battle!"))
      return false
    end
    if !pbIsOwner?(idxBattler, idxParty)
      if partyScene
        owner = pbGetOwnerFromPartyIndex(idxBattler, idxParty)
        pbDisplayBrief(_INTL("You can't switch {1}'s Pokémon with one of yours!",
                                   owner.name))
      end
      return false
    end
    if party[idxParty].is_a?(Pokemon)
      if party[idxParty].fainted?
        pbDisplayBrief(_INTL("{1} has no energy left to battle!", party[idxParty].name))
        return false
      end
    end
    if pbFindBattler(idxParty, idxBattler)
      pbDisplayBrief(_INTL("{1} is already in battle!", party[idxParty].name))
      return false
    end
    return true
  end

  def pbCanSwitchPartyInfo?(idxBattler, idxParty = -1, partyScene = nil)
    return false if !pbCanSwitchLax?(idxBattler, idxParty, partyScene)
    allSameSideBattlers(idxBattler).each do |b|
      next if choices[b.index][0] != :SwitchOut || choices[b.index][1] != idxParty
      pbDisplayBrief(_INTL("{1} has already been selected.", pbParty(idxBattler)[idxParty].name))
      return false
    end
    battler = @battlers[idxBattler]
    return true if battler.fainted?
    if battler.abilityActive? &&
       Battle::AbilityEffects.triggerCertainSwitching(battler.ability, battler, self)
      return true
    end
    if battler.itemActive? &&
       Battle::ItemEffects.triggerCertainSwitching(battler.item, battler, self)
      return true
    end
    return true if Settings::MORE_TYPE_EFFECTS && (battler.pbHasType?(:GHOST) || battler.hasActiveAbility?(:RUNAWAY))
    if battler.trappedInBattle?
      pbDisplayBrief(_INTL("{1} can't be switched out!", battler.pbThis))
      return false
    end
    allOtherSideBattlers(idxBattler).each do |b|
      next if !b.abilityActive?
      if Battle::AbilityEffects.triggerTrappingByTarget(b.ability, battler, b, self)
        pbDisplayBrief(_INTL("{1}'s {2} prevents switching!", b.pbThis, b.abilityName))
        return false
      end
    end
    allOtherSideBattlers(idxBattler).each do |b|
      next if !b.itemActive?
      if Battle::ItemEffects.triggerTrappingByTarget(b.item, battler, b, self)
        pbDisplayBrief(_INTL("{1}'s {2} prevents switching!", b.pbThis, b.itemName))
        return false
      end
    end
    return true
  end

  def pbDisplayConfirmUpper(msg, showDesc)
    return @scene.pbDisplayConfirmMessageUpper(msg, showDesc)
  end

  def pbCreateLookupBattler(pkmn, idxParty)
    fake_pkmn = Battler.new(self, 0)
    fake_pkmn.pbInitPokemon(pkmn, idxParty)
    return fake_pkmn
  end
end

class Battle::Scene
  alias pokeparty_pbInitSprites pbInitSprites
  def pbInitSprites
    pokeparty_pbInitSprites
    pbSetSmallFont(@sprites["pokeballUI"].bitmap)
    @pokeballUIOverlay = @sprites["pokeballUI"].bitmap
    ballY = @sprites["messageBox"].y - 52
    menu_file_path = "Graphics/Pictures/Voltseon's Pause Menu/"
    @hpbar   = AnimatedBitmap.new(menu_file_path + "overlayHp")
    @expbar  = AnimatedBitmap.new(menu_file_path + "overlayExp")
    @status  = AnimatedBitmap.new(menu_file_path + "overlayStatus")
    @infobmp = Bitmap.new(menu_file_path + "overlayInfo")

    5.times do |i|
      case i
        when 0 then ballX = 64
        when 1 then ballX = 146
        when 2 then ballX = 256
        when 3 then ballX = 366
        when 4 then ballX = 448
      end
      spacing = (Graphics.width/8) * i

      @sprites["party_icon#{i}"] = PokemonIconSprite.new(nil, @viewport) # ItemIconSprite.new(ballX, ballY, nil, @viewport)
      @sprites["party_icon#{i}"].setOffset(PictureOrigin::CENTER)
      @sprites["party_icon#{i}"].visible = false
      @sprites["party_icon#{i}"].x = ballX
      @sprites["party_icon#{i}"].y = ballY
      @sprites["party_icon#{i}"].z = 300

      @sprites["party_info#{i}"] = BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
      @sprites["party_info#{i}"].x = ballX-18
      @sprites["party_info#{i}"].y = ballY+30
      @sprites["party_info#{i}"].visible = false
      @sprites["party_info#{i}"].z = 300
      # @sprites["party_info#{i}"].bitmap.blt(spacing + (Graphics.width/8) + 16, Graphics.height/2 - 102, @infobmp, Rect.new(0, 0, @infobmp.width, @infobmp.height))

    end
  end

  def pbHidePartyInfoUI
    return if pbInSafari?
    @pokeballUIToggle = nil
    @sprites["pokeballUI"].visible = false
    @pokeballUIOverlay.clear
    5.times { |i| pbUpdatePartyIcon(i, nil, true) }
  end
  
  def pbTogglePartyInfo(idxBattler, canCancel = false)
    pbHidePartyInfoUI if @pokeballUIToggle != :ball
    @pokeballUIToggle = (@pokeballUIToggle.nil?) ? :ball : nil
    (@pokeballUIToggle) ? pbSEPlay("GUI party switch") : pbPlayCloseMenuSE
    @sprites["pokeballUI"].visible = !@pokeballUIToggle.nil?
    ret = pbSelectPartyInfo(idxBattler, canCancel)
    return ret
  end

  def pbSelectPartyInfo(idxBattler, canCancel)
    return false if @pokeballUIToggle != :ball
    useBall = false
    showDesc = false
    partyPos = @battle.pbPartyOrder(idxBattler)
    partyStart, _partyEnd = @battle.pbTeamIndexRangeFromBattlerIndex(idxBattler)
    modParty = @battle.pbPlayerDisplayParty(idxBattler)
    modParty.push(nil)
    modParty.unshift(nil)
    case idxBattler
      when 0; index = 1
      when 2; index = 2
      when 4; index = 3
      else;   index = 1
    end
    maxIdx = modParty.length - 1
    pbUpdatePartySelection(modParty, index, showDesc)
    loop do
      pbUpdate
      pbUpdateInfoSprites
      dorefresh = false
      if Input.trigger?(Input::USE)
        if [0,modParty.length-1].include?(index) && !canCancel
          pbPlayBuzzerSE()
        elsif [0,modParty.length-1].include?(index) && canCancel
          pbPlayDecisionSE
          useBall = -1, -1
          pbShowWindow(COMMAND_BOX)
          break
        elsif modParty[index].is_a?(Pokemon)
          if modParty[index].fainted?
            @battle.pbDisplay(_INTL("{1} has no energy left to battle!", modParty[index].name))
          elsif modParty[index].egg?
            @battle.pbDisplay(_INTL("An Egg can't battle!"))
          else
            pbPlayDecisionSE
            idxPartyRet = -1
            partyPos.each_with_index do |pos, i|
              next if pos != (index-1) + partyStart
              idxPartyRet = i
              break
            end
            preselect_index = false
            @battle.allSameSideBattlers(idxBattler).each do |b|
              next if @battle.choices[b.index][0] != :SwitchOut || @battle.choices[b.index][1] != idxPartyRet
              preselect_index = true
            end
            if @battle.pbFindBattler(idxPartyRet, idxBattler)
              @battle.pbDisplay(_INTL("{1} is already in battle!", modParty[index].name))
            elsif preselect_index
              @battle.pbDisplay(_INTL("{1} has already been selected.", modParty[index].name))
            else
              if @battle.pbDisplayConfirmUpper(_INTL("Would you like to switch in {1}",modParty[index].name), showDesc)
                useBall = idxPartyRet, idxPartyRet
                pbShowWindow(COMMAND_BOX)
                break 
              end
            end
          end
        end
      elsif Input.trigger?(Input::SPECIAL)
        showDesc = !showDesc
        pbPlayDecisionSE
        dorefresh = true
      elsif Input.trigger?(Input::ACTION) && !modParty[index].is_a?(Pokemon)
        pbPlayBuzzerSE
        dorefresh = true
      elsif Input.trigger?(Input::ACTION) && modParty[index].is_a?(Pokemon)
        pbPlayDecisionSE
        $donteditEVs = true
        pbPartySummary(index, modParty, true)
        dorefresh = true
      elsif Input.trigger?(Input::BACK) && !canCancel
        pbPlayBuzzerSE()
      elsif Input.trigger?(Input::BACK) && canCancel
        pbPlayCloseMenuSE
        useBall = -1, -1
        break
      elsif Input.repeat?(Input::LEFT)
        index -= 1
        index = maxIdx-1 if index < 1
        pbPlayCursorSE
        dorefresh = true
      elsif Input.repeat?(Input::RIGHT)
        index += 1
        index = 1 if index > maxIdx-1
        pbPlayCursorSE
        dorefresh = true
      elsif Input.trigger?(Input::JUMPUP) && index > 0
        index = 1
        pbPlayCursorSE
        dorefresh = true
      elsif Input.trigger?(Input::JUMPDOWN) && index < maxIdx
        index = maxIdx-1
        pbPlayCursorSE
        dorefresh = true
      end
      if dorefresh
        $donteditEVs = false
        pbUpdatePartySelection(modParty, index, showDesc)
      end
    end
    pbHidePartyInfoUI
    return useBall
  end

  def pbUpdatePartyIcon(index, pkmn, blank = false)
    @sprites["party_icon#{index}"].pokemon = pkmn
    @sprites["party_icon#{index}"].visible = true
    if pkmn.is_a?(Pokemon)
      # @sprites["party_icon#{index}"].pbSetParams(pkmn.species, pkmn.gender, pkmn.form)
      @sprites["party_info#{index}"].visible = true
      @sprites["party_info#{index}"].bitmap.blt(0, 0, @infobmp, Rect.new(0, 0, @infobmp.width, @infobmp.height))
      # Health
      if pkmn.hp>0
        w = (pkmn.hp * 32 * 1.0)/pkmn.totalhp
        w = 1 if w<1
        w = ((w/2).round) * 2
        hpzone = 0
        hpzone = 1 if pkmn.hp<=(pkmn.totalhp/2).floor
        hpzone = 2 if pkmn.hp<=(pkmn.totalhp/4).floor
        hprect = Rect.new(0, hpzone * 4, w, 4)
        @sprites["party_info#{index}"].bitmap.blt(2, 2, @hpbar.bitmap, hprect)
      end
      # EXP
      if pkmn.exp>0
        minexp = pkmn.growth_rate.minimum_exp_for_level(pkmn.level)
        currentexp = minexp-pkmn.exp
        maxexp = minexp-pkmn.growth_rate.minimum_exp_for_level(pkmn.level + 1)
        w = (currentexp * 24 * 1.0)/maxexp
        w = 1 if w < 1.0
        w = 0 if w.is_a?(Float) && w.nan?
        w = ((w/2).round) * 2 if w > 0 # I heard Pokémon Beekeeper was good
        exprect = Rect.new(0, 0, w, 2)
        @sprites["party_info#{index}"].bitmap.blt(6, 8, @expbar.bitmap, exprect)
      end
      # Status
      status = -1
      if pkmn.fainted?
        status = GameData::Status.count - 1
      elsif pkmn.status != :NONE
        status = GameData::Status.get(pkmn.status).icon_position
      elsif pkmn.pokerusStage == 1
        status = GameData::Status.count
      end
      # status -= 0
      if status >= 0
        statusrect = Rect.new(0,8*status,8,8)
        @sprites["party_icon#{index}"].bitmap.blt(56, 56, @status.bitmap, statusrect)
      end
    else
      # @sprites["party_icon#{index}"].pbSetParams(:RETURN, 0, 0)
      @sprites["party_icon#{index}"].visible = false
      @sprites["party_info#{index}"].visible = false
    end
  end

  def pbUpdatePartySelection(modParty, index, showDesc = false)
    @pokeballUIOverlay.clear
    return if @pokeballUIToggle != :ball
    ypos = @sprites["messageBox"].y - 128
    imagePos = [[@pokeball_path + "pokeball_bg", 0, ypos]]
    imagePos.push([@pokeball_path + "pokeball_desc", 0, ypos - 69]) if showDesc
    textY = (showDesc) ? ypos - 55 : ypos + 14
    action = (showDesc) ? _INTL("ACT: Summary") : _INTL("SPC: Extra")
    pkmn = modParty[index]
    name = (pkmn) ? _INTL("{1} [Lv.{2}]", pkmn.name, pkmn.level) : _INTL("Return")
    desc = (pkmn) ? pkmn.name : _INTL("Return to the command menu.")
    textPos = [
      [_INTL("USE: Switch"), 50, textY, 2, BASE_LIGHT],
      [action, Graphics.width - 50, textY, 2, BASE_LIGHT],
      [name, Graphics.width / 2, textY, 2, BASE_LIGHT, SHADOW_LIGHT, :outline]
    ]
    # ballY = @sprites["messageBox"].y - 25
    range = ((index - 2)..(index + 2)).to_a
    range.each_with_index do |pos, i|
      new_pos = pos
      new_pos += 6 if pos <= 0
      new_pos -= 6 if pos >= 7
      try_pkmn = modParty[new_pos]
      pbUpdatePartyIcon(i, try_pkmn)
      if try_pkmn
        x = @sprites["party_icon#{i}"].x
        x += 2 if i == index
        text_colors = (new_pos == index) ? [BASE_LIGHT, SHADOW_LIGHT, :outline] : [BASE_DARK, SHADOW_DARK]
      end
    end
    pbDrawImagePositions(@pokeballUIOverlay, imagePos)
    pbDrawTextPositions(@pokeballUIOverlay, textPos)
    # Type Match-up Data
    if showDesc
      matchups = []
      fake_pkmn = @battle.pbCreateLookupBattler(pkmn, index)
      for mv in 0...pkmn.moves.length
        base_move_data = pkmn.moves[mv]
        move_data = Battle::Move.from_pokemon_move(@battle, base_move_data)
        matchups.push([move_data, []])
      end
      for mt in 0...matchups.length
        @battle.allBattlers.each do |b|   # Other battlers no longer attracted to self
          next if !b
          next if !b.index.odd?
          move = matchups[mt][0]
          type_matchup = move.pbCalcTypeModUI(move.type, fake_pkmn, b)
          matchups[mt][1].push(type_matchup)
        end
      end
      # drawTextEx(@pokeballUIOverlay, 10, ypos - 21, Graphics.width - 10, 2, desc, BASE_DARK, SHADOW_DARK) if showDesc
      move_index = 0
      matchup_cords = {:cord_x => [10,(Graphics.width/2)+10,10,(Graphics.width/2)+10], :cord_y => [ypos - 21, ypos - 21, ypos, ypos]}
      for mu in 0...matchups.length
        move_data = matchups[mu]
        if move_data[1].length > 1
          move_text = ""
          move_text += "[x]" if move_data[1][0] == 0
          move_text += "[--]" if move_data[1][0] == 2
          move_text += "[-]" if move_data[1][0] == 4
          move_text += "[o]" if move_data[1][0] == 8
          move_text += "[+]" if move_data[1][0] == 16
          move_text += "[++]" if move_data[1][0] == 32
          move_text += " #{move_data[0].name} "
          move_text += "[x]" if move_data[1][1] == 0
          move_text += "[--]" if move_data[1][1] == 2
          move_text += "[-]" if move_data[1][1] == 4
          move_text += "[o]" if move_data[1][1] == 8
          move_text += "[+]" if move_data[1][1] == 16
          move_text += "[++]" if move_data[1][1] == 32
          drawTextEx(@pokeballUIOverlay, matchup_cords[:cord_x][mu], matchup_cords[:cord_y][mu], Graphics.width - 10, 2, move_text, BASE_DARK, SHADOW_DARK)
        else
          move_text = ""
          move_text += "[x]" if move_data[1][0] == 0
          move_text += "[--]" if move_data[1][0] == 2
          move_text += "[-]" if move_data[1][0] == 4
          move_text += "[o]" if move_data[1][0] == 8
          move_text += "[+]" if move_data[1][0] == 16
          move_text += "[++]" if move_data[1][0] == 32
          move_text += " #{move_data[0].name}"
          drawTextEx(@pokeballUIOverlay, matchup_cords[:cord_x][mu], matchup_cords[:cord_y][mu], Graphics.width - 10, 2, move_text, BASE_DARK, SHADOW_DARK)
        end
        move_index += 1
      end
    end
  end

  def pbPartySummary(pkmnid, party, inbattle = false)
    oldsprites = pbFadeOutAndHide(@sprites)
    scene = PokemonSummary_Scene.new
    screen = PokemonSummaryScreen.new(scene, inbattle)
    screen.pbStartScreen(party, pkmnid)
    yield if block_given?
    pbFadeInAndShow(@sprites, oldsprites)
  end

  def pbDisplayConfirmMessageUpper(msg, showDesc)
    return pbShowCommandsUpper(msg, [_INTL("Yes"), _INTL("No")], 1, showDesc) == 0
  end

  def pbShowCommandsUpper(msg, commands, defaultValue, showDesc)
    pbWaitMessage
    pbShowWindow(MESSAGE_BOX)
    dw = @sprites["messageWindow"]
    dw.text = msg
    cw = Window_CommandPokemon.new(commands)
    cw.height   = Graphics.height - dw.height if cw.height > Graphics.height - dw.height
    cw.x        = Graphics.width - cw.width
    cw.y        = (showDesc) ? 0 : 64 #Graphics.height - cw.height - dw.height
    cw.z        = dw.z + 1
    cw.index    = 0
    cw.viewport = @viewport
    PBDebug.log(msg)
    Kernel.tts(msg)
    lastreadmsg = nil
    loop do
      cw.visible = (!dw.busy?)
      pbUpdate(cw)
      dw.update
      currmsg = commands[cw.index]
      if lastreadmsg != currmsg
       lastreadmsg = currmsg
       Kernel.tts(currmsg)
      end
      if Input.trigger?(Input::BACK) && defaultValue >= 0
        if dw.busy?
          pbPlayDecisionSE if dw.pausing?
          dw.resume
        else
          cw.dispose
          dw.text = ""
          return defaultValue
        end
      elsif Input.trigger?(Input::USE)
        if dw.busy?
          pbPlayDecisionSE if dw.pausing?
          dw.resume
        else
          cw.dispose
          dw.text = ""
          return cw.index
        end
      end
    end
  end
end
