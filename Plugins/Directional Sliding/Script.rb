
module GameData
  class TerrainTag
    attr_reader :slide_up
    attr_reader :slide_right
    attr_reader :slide_down
    attr_reader :slide_left
    
    alias directional_sliding_initialize initialize
    def initialize(hash)
      directional_sliding_initialize(hash)
      @slide_up     = hash[:slide_up]     || false
      @slide_right  = hash[:slide_right]  || false
      @slide_down   = hash[:slide_down]   || false
      @slide_left   = hash[:slide_left]   || false
    end
  end  
end

class PokemonGlobalMetadata
  # Movement
  attr_accessor :sliding_up
  attr_accessor :sliding_down
  attr_accessor :sliding_left
  attr_accessor :sliding_right
  attr_accessor :sliding_combo

  alias directional_sliding_initialize initialize
  def initialize
    directional_sliding_initialize
    @sliding_right = false
    @sliding_up = false
    @sliding_down = false
    @sliding_left = false
    @sliding_combo = 0
  end

end  


GameData::TerrainTag.register({
  :id                     => :SlideUp,
  :id_number              => 31,
  :slide_up               => true,
  :must_walk              => true
})

GameData::TerrainTag.register({
  :id                     => :SlideRight,
  :id_number              => 32,
  :slide_right            => true,
  :must_walk              => true
})

GameData::TerrainTag.register({
  :id                     => :SlideDown,
  :id_number              => 33,
  :slide_down             => true,
  :must_walk              => true
})

GameData::TerrainTag.register({
  :id                     => :SlideLeft,
  :id_number              => 34,
  :slide_left             => true,
  :must_walk              => true
})

GameData::TerrainTag.register({
  :id                     => :CurrentUp,
  :id_number              => 35,
  :slide_up               => true,
  :must_walk              => true,
  :can_surf               => true
})

GameData::TerrainTag.register({
  :id                     => :CurrentRight,
  :id_number              => 36,
  :slide_right            => true,
  :must_walk              => true,
  :can_surf               => true
})

GameData::TerrainTag.register({
  :id                     => :CurrentDown,
  :id_number              => 37,
  :slide_down             => true,
  :must_walk              => true,
  :can_surf               => true
})

GameData::TerrainTag.register({
  :id                     => :CurrentLeft,
  :id_number              => 38,
  :slide_left             => true,
  :must_walk              => true,
  :can_surf               => true
})

def isOnSlidingTile?
  ret=false
  if $game_player.pbTerrainTag.ice ||
    $game_player.pbTerrainTag.slide_up ||
    $game_player.pbTerrainTag.slide_right ||
    $game_player.pbTerrainTag.slide_down ||
    $game_player.pbTerrainTag.slide_left
    ret=true
  end
  return ret
end  

# def pbUpdateSceneMap
#   $scene.miniupdate if $scene.is_a?(Scene_Map) && !pbIsFaded?
# end

def directional_sliding(dir=$game_player.direction)
  return if !isOnSlidingTile?
  case dir
  when "down"
    dir=2
    $PokemonGlobal.sliding_down = true
  when "up"
    dir=8
    $PokemonGlobal.sliding_up = true
  when "right"
    dir=6
    $PokemonGlobal.sliding_right = true
  when "left"
    dir=4
    $PokemonGlobal.sliding_left = true
  end
  $game_temp.followers.update
  $PokemonGlobal.sliding = true
  direction    = dir
  oldwalkanime = $game_player.walk_anime
  $game_player.straighten
  $game_player.walk_anime = false
  first_loop = true
  loop do
    break if !$game_player.can_move_in_direction?(direction)
    break if !isOnSlidingTile?
    $game_player.move_generic(dir)
    $game_temp.followers.move_followers if first_loop
    while $game_player.moving?
      pbUpdateSceneMap
      Graphics.update
      Input.update
    end
    first_loop = false
  end
  $game_player.center($game_player.x, $game_player.y)
  $game_player.straighten
  $game_player.walk_anime = oldwalkanime
  $PokemonGlobal.sliding = false
  $PokemonGlobal.sliding_down = false
  $PokemonGlobal.sliding_up = false
  $PokemonGlobal.sliding_right = false
  $PokemonGlobal.sliding_left = false
  $PokemonGlobal.sliding_combo=0
end

# Auto-move the player over waterfalls and ice
EventHandlers.add(:on_step_taken, :directional_sliding,
  proc { |event|
    next if !$scene.is_a?(Scene_Map)
    next if event != $game_player
    currentTag = $game_player.pbTerrainTag
    # if $PokemonGlobal.sliding_up && $PokemonGlobal.sliding_right && 
    #   $PokemonGlobal.sliding_down && $PokemonGlobal.sliding_left 
    #   $PokemonGlobal.sliding_down = false
    #   $PokemonGlobal.sliding_up = false
    #   $PokemonGlobal.sliding_right = false
    #   $PokemonGlobal.sliding_left = false
    # end
    if currentTag.slide_up && $PokemonGlobal.sliding_combo<94 #&& !$PokemonGlobal.sliding_up 
      $PokemonGlobal.sliding_combo+=1
      directional_sliding("up")
    elsif currentTag.slide_right && $PokemonGlobal.sliding_combo<94 #&& !$PokemonGlobal.sliding_right  
      $PokemonGlobal.sliding_combo+=1
      directional_sliding("right")
    elsif currentTag.slide_down && $PokemonGlobal.sliding_combo<94 #&& !$PokemonGlobal.sliding_down  
      $PokemonGlobal.sliding_combo+=1
      directional_sliding("down")
    elsif currentTag.slide_left && $PokemonGlobal.sliding_combo<94 #&& !$PokemonGlobal.sliding_left  
      $PokemonGlobal.sliding_combo+=1
      directional_sliding("left")
    end
    # $PokemonGlobal.sliding_combo=0 if $PokemonGlobal.sliding_combo>94
    # $PokemonGlobal.sliding_down = false
    # $PokemonGlobal.sliding_up = false
    # $PokemonGlobal.sliding_right = false
    # $PokemonGlobal.sliding_left = false
  }
)