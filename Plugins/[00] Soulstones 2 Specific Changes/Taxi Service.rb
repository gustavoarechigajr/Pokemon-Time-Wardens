# ---------------------
# Taxi Service
# ---------------------
#
  def use_drifblimp
    ret = nil
    pbFadeOutIn(99999) {
      scene = PokemonRegionMap_Scene.new(-1, false)
      screen = PokemonRegionMapScreen.new(scene)
      ret = screen.pbStartFlyScreen
    }
    $game_temp.fly_destination = ret
    $game_temp.in_menu = false
    return false if $game_temp.fly_destination.nil?
    if !pbHiddenMoveAnimation(nil)
		mapinfos = ($RPGVX) ? load_data("Data/MapInfos.rvdata") : load_data("Data/MapInfos.rxdata")
		mapname = "#{mapinfos[$game_temp.fly_destination[0]].name}"
		pbMessage(_INTL("Alright, buckle up {1} ! Drifblim and I are taking you to {2}.",$Trainer.name,mapname))
    end
    $stats.fly_count += 1
    pbFadeOutIn {
      pbSEPlay("PRSFX- Gust")
      $game_temp.player_new_map_id    = $game_temp.fly_destination[0]
      $game_temp.player_new_x         = $game_temp.fly_destination[1]
      $game_temp.player_new_y         = $game_temp.fly_destination[2]
      $game_temp.player_new_direction = 2
      $game_temp.fly_destination = nil
      $scene.transfer_player
      $game_map.autoplay
      $game_map.refresh
      pbWait(Graphics.frame_rate / 4)
    }
    pbEraseEscapePoint
  end
  
  def use_honchkrow_express
    ret = nil
    pbFadeOutIn(99999) {
      scene = PokemonRegionMap_Scene.new(-1, false)
      screen = PokemonRegionMapScreen.new(scene)
      ret = screen.pbStartFlyScreen
    }
    $game_temp.fly_destination = ret
    $game_temp.in_menu = false
    return false if $game_temp.fly_destination.nil?
    if !pbHiddenMoveAnimation(nil)
		mapinfos = ($RPGVX) ? load_data("Data/MapInfos.rvdata") : load_data("Data/MapInfos.rxdata")
		mapname = "#{mapinfos[$game_temp.fly_destination[0]].name}"
		pbMessage(_INTL("Ok, stay still, {1} ! My T.Honchkrow will cast a spell to teleport you to {2}.",$Trainer.name,mapname))
    end
    $stats.fly_count += 1
    pbFadeOutIn {
      pbSEPlay("waypoint")
      $game_temp.player_new_map_id    = $game_temp.fly_destination[0]
      $game_temp.player_new_x         = $game_temp.fly_destination[1]
      $game_temp.player_new_y         = $game_temp.fly_destination[2]
      $game_temp.player_new_direction = 2
      $game_temp.fly_destination = nil
      $scene.transfer_player
      $game_map.autoplay
      $game_map.refresh
      pbWait(Graphics.frame_rate / 4)
    }
    pbEraseEscapePoint
  end