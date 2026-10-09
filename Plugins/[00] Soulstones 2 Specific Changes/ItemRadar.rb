### Credits to Pokemon Reborn SWM - Item Radar Mod ###

EventHandlers.add(:on_player_step_taken, :item_radar,
  proc {
    next if !$bag.has?(:LIVESUPPORTON)
    $game_screen.aUpdateRadar
  }
)

ItemHandlers::UseInField.add(:ITEMFINDER, proc { |item|
  $game_screen.aToggleRadar
  $game_screen.aUpdateRadar
  
  next true
})

class Game_Screen
  attr_accessor   :aItemsFoundVisible
  
  def aCheckItemsFoundDefined
    if !defined?(@aItemsFoundVisible)
      @aItemsFoundVisible = false
    end
    if @aItemsFoundVisible
      if !defined?($aItemsFound) || $aItemsFound.disposed?
        $aItemsFound = Sprite.new(nil)
        $aItemsFound.bitmap = Bitmap.new(Graphics.width,Graphics.height)
        $aItemsFound.ox = 0
        $aItemsFound.oy = 0
        $aItemsFound.z = 9998
        $aItemsFound.visible = true
      end
    end
    return @aItemsFoundVisible
  end
  
  def aCheckScroll(adX, adY)
    if aCheckItemsFoundDefined
      $aItemsFound.ox = ($game_player.real_x/Game_Map::XSUBPIXEL)-(($game_player.x-adX)*32)
      $aItemsFound.oy = ($game_player.real_y/Game_Map::YSUBPIXEL)-(($game_player.y-adY)*32)
    end
  end
  
  def aToggleRadar
    @aItemsFoundVisible = !@aItemsFoundVisible
    if aCheckItemsFoundDefined
      Kernel.pbMessage("The ITEMFINDER is now ON.")
    else
      if defined?($aItemsFound)
        if !$aItemsFound.disposed?
          $aItemsFound.dispose
        end
      end
      Kernel.pbMessage("The ITEMFINDER is now OFF.")
    end
  end
  
  def aUpdateRadar
    if aCheckItemsFoundDefined
      aItemsFoundBitmap=AnimatedBitmap.new(_INTL("Graphics/Pictures/ItemRadar"))
      playerX=$game_player.x
      playerY=$game_player.y
      aOffsetX = ((Graphics.width-32)/2)
      aOffsetY = ((Graphics.height-32)/2)
      $aItemsFound.bitmap = Bitmap.new(Graphics.width,Graphics.height)
      $aItemsFound.ox = 0
      $aItemsFound.oy = 0
      #Find and print items
      for event in $game_map.events.values
        next if event.name!="HiddenItem"
        next if (playerX-event.x).abs>=8
        next if (playerY-event.y).abs>=6
        next if $game_self_switches[[$game_map.map_id,event.id,"A"]]
        next if $game_self_switches[[$game_map.map_id,event.id,"B"]]
        next if $game_self_switches[[$game_map.map_id,event.id,"C"]]
        next if $game_self_switches[[$game_map.map_id,event.id,"D"]]
        #Print items
        $aItemsFound.bitmap.blt(aOffsetX+(event.x-playerX)*32, aOffsetY+(event.y-playerY)*32, aItemsFoundBitmap.bitmap, aItemsFoundBitmap.bitmap.rect)
      end
    end
  end
end

class Game_Map
  XSUBPIXEL = 4
  YSUBPIXEL = 4

  def scroll_down(distance)
    self.display_y+=distance
    $game_screen.aCheckScroll(0, +1) #####MODDED
  end

  def scroll_left(distance)
    self.display_x-=distance
    $game_screen.aCheckScroll(-1, 0) #####MODDED
  end

  def scroll_right(distance)
    self.display_x+=distance
    $game_screen.aCheckScroll(+1, 0) #####MODDED
  end

  def scroll_up(distance)
    self.display_y-=distance
    $game_screen.aCheckScroll(0, -1) #####MODDED
  end
end