

#-------------------------------------------------------------------------------
# Command window compatibility.
#-------------------------------------------------------------------------------
class Battle::Scene
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
      elsif Input.trigger?(Input::BACK) && mode > 0
        pbPlayCancelSE
        break 
      elsif Input.triggerex?(:V) || Input.trigger?(Input::AUX2) # Changed by DemICE 16-Oct-2023 toggle stat stages boosts on/off
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
end
