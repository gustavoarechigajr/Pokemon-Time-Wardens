#===============================================================================
# Other menus.
#===============================================================================
# Adds new options to the Command and Target menus.
#-------------------------------------------------------------------------------
class Battle::Scene::CommandMenu < Battle::Scene::MenuBase
  MODES += [
    [0, 2, 1, 10], # 5 = Fight, Bag, Pokemon, Cheer
  ]
end

class Battle::Scene::TargetMenu < Battle::Scene::MenuBase
  MODES += [
    [0, 2, 1, 10], # 5 = Fight, Bag, Pokemon, Cheer
  ]
end

#===============================================================================
# Battle::Scene rewrites.
#===============================================================================
class Battle::Scene
  #-----------------------------------------------------------------------------
  # Edited for command menu display.
  #-----------------------------------------------------------------------------
  def pbCommandMenu(idxBattler, firstAction)
    shadowTrainer = (GameData::Type.exists?(:SHADOW) && @battle.trainerBattle?)
    runCommand = (shadowTrainer) ? _INTL("Call") : (firstAction) ? _INTL("Run") : _INTL("Cancel")
    hasCheer = defined?(@battle.cheerMode) && @battle.cheerMode
    if hasCheer
      runCommand = _INTL("Cheer")
      mode = 5
    else
	  mode = (shadowTrainer) ? 2 : (firstAction) ? 0 : 1
    end
    msg = (@battle.wildBattle? && @battle.wildBattleMode != :raid) ? _INTL("Action: Quick Throw") : _INTL("Jump Up/Down: Battle Info", @battle.battlers[idxBattler].name)
    cmds = [
      msg,
      _INTL("Fight"),
      _INTL("Bag"),
      _INTL("Pokémon"),runCommand
    ]
    ret = pbCommandMenuEx(idxBattler, cmds, mode)
    ret = 4 if ret == 3 && (shadowTrainer || hasCheer)
    ret = -1 if ret == 3 && (!firstAction && !hasCheer)
    return 3 if ret > 3 && ($DEBUG && Input.press?(Input::CTRL))
    return ret
  end
end
