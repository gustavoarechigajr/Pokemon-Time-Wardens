#===============================================================================
# Android display fix (added to the game only in the Android APK)
#-------------------------------------------------------------------------------
# On PC the "Screen Size" option leaves fullscreen and resizes the window.
# On Android, leaving fullscreen just brings back the status and navigation
# bars over the game, so always stay fullscreen; the engine already scales the
# game to fit the screen.
#===============================================================================
if (System.platform[/Android/] rescue false)
  def pbSetResizeFactor(_factor)
    if !$ResizeInitialized
      Graphics.resize_screen(Settings::SCREEN_WIDTH, Settings::SCREEN_HEIGHT)
      $ResizeInitialized = true
    end
    Graphics.fullscreen = true if !Graphics.fullscreen
  end
end
