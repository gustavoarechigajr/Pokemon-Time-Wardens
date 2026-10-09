#===============================================================================
# Android fixes (added to the game only in the Android APK)
#===============================================================================
if (System.platform[/Android/] rescue false)
  #-----------------------------------------------------------------------------
  # Display: on PC the "Screen Size" option leaves fullscreen and resizes the
  # window. On Android, leaving fullscreen just brings back the status and
  # navigation bars over the game, so always stay fullscreen; the engine
  # already scales the game to fit the screen.
  #-----------------------------------------------------------------------------
  def pbSetResizeFactor(_factor)
    if !$ResizeInitialized
      Graphics.resize_screen(Settings::SCREEN_WIDTH, Settings::SCREEN_HEIGHT)
      $ResizeInitialized = true
    end
    Graphics.fullscreen = true if !Graphics.fullscreen
  end

  #-----------------------------------------------------------------------------
  # Quicksave: the "Updated Quicksave" plugin (Jump Down button on the map,
  # R2 on a controller) and the raid den scene call Scene_Map.pbSaveScreen,
  # which doesn't exist, so pressing it crashed the game. Open the game's
  # normal save screen instead.
  #-----------------------------------------------------------------------------
  class Scene_Map
    def self.pbSaveScreen
      # The global save screen (a bare call here would recurse into this method)
      TOPLEVEL_BINDING.receiver.send(:pbSaveScreen)
      true   # the save screen reports success or failure itself
    end
  end
end
