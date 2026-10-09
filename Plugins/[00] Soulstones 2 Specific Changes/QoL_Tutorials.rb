# Changed by DemICE 02-Oct-2023 adding tutorials to the game.
class PokemonSystem
    attr_accessor :qol_tutorials

    alias qol_tutorials_initialize initialize
    def initialize
        qol_tutorials_initialize
        reset_tutorials
    end
    
    def reset_tutorials
        @qol_tutorials = {
            :battle_ui      => false,
            :quicksave      => false,
            :bag_sorting    => false,
            :ev_alloc       => false,
            :move_remind    => false,
            :hall_of_fame   => false,
			:runic_slab     => false,
			:raid_dens      => false
        } 
    end

end


def pbBattleUITutorial
  pbTutorialWindow(_INTL("M button: View the effectiveness of your moves against the opponents and general information about the moves.\nN button: Select a battler to view its typing, stat changes, and active effects."))
end

def pbQuickSaveTutorial
  pbTutorialWindow(_INTL("You can Quick Save by pressing S."))
end

def pbBagSortingTutorial
  pbTutorialWindow(_INTL("You can sort items alphabetically by pressing V."))
end

def pbEVAllocTutorial
  pbTutorialWindow(_INTL("You can manually allocate EVs by pressing the USE button.\nDefault: C, Space.\nEV pool and EV cap per stat increase with every level up to a maximum of 512 and 252 respectively.\nEVs are automatically increased in the two stats with the most EVs every time a level is gained."))
end

def pbMoveRemindTutorial
  pbTutorialWindow(_INTL("You can remember moves known beforehand, or that have been attempted to be learned, by pressing the ACTION button.\nDefault: Shift, Z."))
end


def pbHallOfFameTutorial
  pbTutorialWindow(_INTL("You can toggle between general Hall of Fame information and Pokemon-Specific information with the ACTION button (default: Z, Shift)."))
end

def pbRunicSlabTutorial
  pbTutorialWindow(_INTL("Upon finding a Rune Item in the overworld, the Runic Slab will allow you to equip a Rune Item to a Pokemon similar to a Z-Crystal from Canon. Pokemon holding an Ability Rune will have their natural ability overridden and cannot hold other items including Mega Stones. Open the Runic Slab and view the runes you have collected from your Key Items pocket. Only one Pokemon may have an Ability Rune."))
end

def pbRaidDensTutorial
  pbTutorialWindow(_INTL("Select areas will have a Raid Den where you can confront a boss-level Pokemon on a 3v1 basis. Raid Bosses have higher HP and attack twice per turn. Raid Den Pokemon rank from 1-7 with higher ranks being stronger. They will be set encounters with random rewards earned on clearing them. The den resets daily unless you have a Raid Bait to manually reset it. First time clears have a unique reward. Subsequent attempts may have a different encounter local to the area."))
end

def pbQolTutorials(entry="")
  $PokemonSystem.reset_tutorials if $PokemonSystem.qol_tutorials.nil?
  case entry
    when "BattleUI"
      pbBattleUITutorial if !$PokemonSystem.qol_tutorials[:battle_ui]
	  $PokemonSystem.qol_tutorials[:battle_ui] = true
    when "QuickSave"
      pbQuickSaveTutorial if !$PokemonSystem.qol_tutorials[:quicksave]
      $PokemonSystem.qol_tutorials[:quicksave] = true
    when "BagSorting"
      pbBagSortingTutorial if !$PokemonSystem.qol_tutorials[:bag_sorting]
      $PokemonSystem.qol_tutorials[:bag_sorting] = true
    when "EVAlloc"
      pbEVAllocTutorial if !$PokemonSystem.qol_tutorials[:ev_alloc]
      $PokemonSystem.qol_tutorials[:ev_alloc] = true
    when "MoveRemind"
      pbMoveRemindTutorial if !$PokemonSystem.qol_tutorials[:move_remind]
      $PokemonSystem.qol_tutorials[:move_remind] = true
    when "HallOfFame"
      pbHallOfFameTutorial if !$PokemonSystem.qol_tutorials[:hall_of_fame]
      $PokemonSystem.qol_tutorials[:hall_of_fame] = true
    when "RunicSlab"
      pbRunicSlabTutorial if !$PokemonSystem.qol_tutorials[:runic_slab]
      $PokemonSystem.qol_tutorials[:runic_slab] = true
    when "RaidDens"
      pbRaidDensTutorial if !$PokemonSystem.qol_tutorials[:raid_dens]
      $PokemonSystem.qol_tutorials[:raid_dens] = true
  end
end

def pbTutorialWindow(text, scene = nil)
  window = Window_AdvancedTextPokemon.new(text)
  window.width = Graphics.width
  window.x     = 0#Graphics.width - window.width
  window.y     = (Graphics.height - window.height)/2
  window.z     = 99999
  pbPlayDecisionSE
  pbWait(400)
  Kernel.tts(text)
  loop do
    Graphics.update
    Input.update
    window.update
    scene&.pbUpdate
    break if Input.trigger?(Input::USE)
  end
  window.dispose
end
