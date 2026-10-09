

class Game_Player < Game_Character

    def can_run?
        return @move_speed > 3 if @move_route_forcing
        return false if $game_temp.in_menu || $game_temp.in_battle ||
        $game_temp.message_window_showing || pbMapInterpreterRunning?
        return false if !$player.has_running_shoes && !$PokemonGlobal.diving &&
        !$PokemonGlobal.surfing && !$PokemonGlobal.bicycle || $PokemonGlobal.rockclimbing
        return false if jumping?
        # Changed by Jos 2023-01-11 to prevent you slowing your walk speed while in grass
        #    return false if pbTerrainTag.must_walk
        return ($PokemonSystem.runstyle == 1) ^ Input.press?(Input::BACK)
    end

    alias ss2_set_movement_type set_movement_type
    def set_movement_type(type)
        ss2_set_movement_type(type)
        case type
        when :diving, :diving_fast, :diving_jumping, :diving_stopped
        # Changed by Jos 2023-01-12 to make dive speed faster
        self.move_speed = 4 if !@move_route_forcing
        end  
    end

end  