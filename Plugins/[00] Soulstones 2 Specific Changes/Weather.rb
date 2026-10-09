# Category has the following effects:
#   - Determines the in-battle weather.
#   - Some abilities reduce the encounter rate in certain categories of weather.
#   - Some evolution methods check the current weather's category.
#   - The :Rain category treats the last listed particle graphic as a water splash rather
#     than a raindrop, which behaves differently.
#   - :Rain auto-waters berry plants.
# Delta values are per second.
# For the tone_proc, strength goes from 0 to RPG::Weather::MAX_SPRITES (60) and
# will typically be the maximum.
module GameData
  class Weather
    attr_reader :id
    attr_reader :id_number
    attr_reader :real_name
    attr_reader :category   # :None, :Rain, :Hail, :Sandstorm, :Sun, :Fog
    attr_reader :graphics   # [[particle file names], [tile file names]]
    attr_reader :particle_delta_x
    attr_reader :particle_delta_y
    attr_reader :particle_delta_opacity
    attr_reader :tile_delta_x
    attr_reader :tile_delta_y
    attr_reader :tone_proc

    DATA = {}

    extend ClassMethods
    include InstanceMethods

    def self.load; end
    def self.save; end

    def initialize(hash)
      @id                     = hash[:id]
      @id_number              = hash[:id_number]
      @real_name              = hash[:id].to_s                || "Unnamed"
      @category               = hash[:category]               || :None
      @particle_delta_x       = hash[:particle_delta_x]       || 0
      @particle_delta_y       = hash[:particle_delta_y]       || 0
      @particle_delta_opacity = hash[:particle_delta_opacity] || 0
      @tile_delta_x           = hash[:tile_delta_x]           || 0
      @tile_delta_y           = hash[:tile_delta_y]           || 0
      @graphics               = hash[:graphics]               || []
      @tone_proc              = hash[:tone_proc]
    end

    def has_particles?
      return @graphics[0] && @graphics[0].length > 0
    end

    def has_tiles?
      return @graphics[1] && @graphics[1].length > 0
    end

    def tone(strength)
      return (@tone_proc) ? @tone_proc.call(strength) : Tone.new(0, 0, 0, 0)
    end
  end
end

#===============================================================================

GameData::Weather.register({
  :id               => :None,
  :id_number        => 0   # Must be 0 (preset RMXP weather)
})

GameData::Weather.register({
  :id               => :Rain,
  :id_number        => 1,   # Must be 1 (preset RMXP weather)
  :category         => :Rain,
  :graphics         => [["rain_1", "rain_2", "rain_3", "rain_4"]],   # Last is splash
  :particle_delta_x => -1200,
  :particle_delta_y => 4800,
  :tone_proc        => proc { |strength|
    next Tone.new(-strength * 3 / 4, -strength * 3 / 4, -strength * 3 / 4, 10)
  }
})

# NOTE: This randomly flashes the screen in RPG::Weather#update.
GameData::Weather.register({
  :id               => :Storm,
  :id_number        => 2,   # Must be 2 (preset RMXP weather)
  :category         => :Rain,
  :graphics         => [["storm_1", "storm_2", "storm_3", "storm_4"]],   # Last is splash
  :particle_delta_x => -4800,
  :particle_delta_y => 4800,
  :tone_proc        => proc { |strength|
    next Tone.new(-strength * 3 / 2, -strength * 3 / 2, -strength * 3 / 2, 20)
  }
})

# NOTE: This alters the movement of snow particles in RPG::Weather#update_sprite_position.
GameData::Weather.register({
  :id               => :Snow,
  :id_number        => 3,   # Must be 3 (preset RMXP weather)
  :category         => :Hail,
  :graphics         => [["hail_1", "hail_2", "hail_3"]],
  :particle_delta_x => -240,
  :particle_delta_y => 240,
  :tone_proc        => proc { |strength|
    next Tone.new(strength / 2, strength / 2, strength / 2, 0)
  }
})

GameData::Weather.register({
  :id               => :Blizzard,
  :id_number        => 4,	
  :category         => :Hail,
  :graphics         => [["blizzard_1", "blizzard_2", "blizzard_3", "blizzard_4"], ["blizzard_tile"]],
  :particle_delta_x => -960,
  :particle_delta_y => 240,
  :tile_delta_x     => -1440,
  :tile_delta_y     => 720,
  :tone_proc        => proc { |strength|
    next Tone.new(strength * 3 / 4, strength * 3 / 4, strength * 3 / 4, 0)
  }
})

GameData::Weather.register({
  :id               => :Sandstorm,
  :id_number        => 5,
  :category         => :Sandstorm,
  :graphics         => [["sandstorm_1", "sandstorm_2", "sandstorm_3", "sandstorm_4"]], #["sandstorm_tile"]], # Changed by Jos 2023-09-03 to make it less hard on the eyes
  :particle_delta_x => -1200,
  :particle_delta_y => 640,
  :tile_delta_x     => -720,
  :tile_delta_y     => 360,
  :tone_proc        => proc { |strength|
    next Tone.new(strength / 2, 0, -strength / 2, 0)
  }
})

GameData::Weather.register({
  :id               => :HeavyRain,
  :id_number        => 6,
  :category         => :Rain,
  :graphics         => [["storm_1", "storm_2", "storm_3", "storm_4"]],   # Last is splash
  :particle_delta_x => -4800,
  :particle_delta_y => 4800,
  :tone_proc        => proc { |strength|
    # next Tone.new(-strength * 3 / 2, -strength * 3 / 2, -strength * 3 / 2, 20) # Changed by Jos 2024-04-28 to modify default heavy rain tint.
	next Tone.new(-strength * 3 / 4, -strength * 3 / 4, -strength * 3 / 4, 10)
  }
})

# NOTE: This alters the screen tone in RPG::Weather#update_screen_tone.
GameData::Weather.register({
  :id               => :Sun,
  :id_number        => 7,
  :category         => :Sun,
  :tone_proc        => proc { |strength|
    next Tone.new(64, 64, 32, 0)
  }
})

# Changed by Jos 2023-02-23 to add new leaves overworld weather
GameData::Weather.register({
  :id               => :Leaves,
  :id_number        => 8,
  :category         => :Leaves,
  :graphics         => [["leaves", "leaves_1", "leaves_2", "leaves_3", "leaves_4"]],
  :particle_delta_x => -120,
  :particle_delta_y => 120,
  :tile_delta_x     => -360,
  :tile_delta_y     => 180,
  :tone_proc        => proc { |strength|
    next Tone.new(strength / 8, strength / 8, strength / 8, 0)
  }
})

# Changed by Jos 2023-02-23 to add new sakura petals overworld weather
GameData::Weather.register({
  :id               => :Sakura,
  :id_number        => 9,
  :category         => :Sakura,
  :graphics         => [["sakura", "sakura_1", "sakura_2", "sakura_3", "sakura_4"]],
  :particle_delta_x => 120,
  :particle_delta_y => 120,
  :tile_delta_x     => -360,
  :tile_delta_y     => 180,
  :tone_proc        => proc { |strength|
    next Tone.new(strength / 8, strength / 8, strength / 8, 0)
  }
})

GameData::Weather.register({
  :id               => :Ash,
  :id_number        => 10,
  :category         => :Ash,
  :graphics         => [["ash_1", "ash_2", "ash_3"]],
  :particle_delta_x => -120,
  :particle_delta_y => 120,
  :tile_delta_x     => -360,
  :tile_delta_y     => 180,
  :tone_proc        => proc { |strength|
    next Tone.new(strength / 2, strength / 2, strength / 2, 0)
  }
})

GameData::Weather.register({
  :id               => :LeavesG,
  :id_number        => 11,
  :category         => :LeavesG,
  :graphics         => [["leaves - green", "leaves_1 - green", "leaves_2 - green", "leaves_3 - green", "leaves_4 - green"]],
  :particle_delta_x => -120,
  :particle_delta_y => 120,
  :tile_delta_x     => -360,
  :tile_delta_y     => 180,
  :tone_proc        => proc { |strength|
    next Tone.new(strength / 8, strength / 8, strength / 8, 0)
  }
})

GameData::Weather.register({
  :id               => :Fog,
  :category         => :Fog,
  :id_number        => 12,
  :tile_delta_x     => -32,
  :tile_delta_y     => 0,
  :graphics         => [nil, ["fog_tile"]]
})

GameData::Weather.register({
  :id               => :Interplanar,
  :id_number        => 13,
  :category         => :Interplanar,
  :graphics         => [["interplanar_1", "interplanar_2", "interplanar_3", "interplanar_4"]],   # Last is splash
  :particle_delta_x => -4800,
  :particle_delta_y => 4800,
  :tone_proc        => proc { |strength|
    next Tone.new(-strength * 3 / 4, -strength * 3 / 4, -strength * 3 / 4, 10)
  }
})

GameData::Weather.register({
  :id               => :FogLeaf,
  :id_number        => 14,
  :category         => :FogLeaf,
  :particle_delta_x => -120,
  :particle_delta_y => 120,
  :tile_delta_x     => 32,
  :tile_delta_y     => 32,
  :graphics         => [["leaves", "leaves_1", "leaves_2", "leaves_3", "leaves_4"], ["fog_tile"]]
})

GameData::Weather.register({
  :id               => :FogLeafG,
  :id_number        => 15,
  :category         => :FogLeafG,
  :particle_delta_x => -120,
  :particle_delta_y => 120,
  :tile_delta_x     => 32,
  :tile_delta_y     => 32,
  :graphics         => [["leaves - green", "leaves_1 - green", "leaves_2 - green", "leaves_3 - green", "leaves_4 - green"], ["fog_tile"]],
})

GameData::Weather.register({
  :id               => :FogAsh,
  :id_number        => 16,
  :category         => :FogAsh,
  :particle_delta_x => -120,
  :particle_delta_y => 120,
  :tile_delta_x     => 32,
  :tile_delta_y     => 32,
  :graphics         => [["ash_1", "ash_2", "ash_3"], ["fog_tile_3"]]
})

GameData::Weather.register({
  :id               => :FogRain,
  :id_number        => 17,
  :category         => :Rain,
  :graphics         => [["rain_1", "rain_2", "rain_3", "rain_4"], ["fog_tile_3"]],   # Last is splash
  :particle_delta_x => -1200,
  :particle_delta_y => 4800,
  :tile_delta_x     => 32,
  :tile_delta_y     => 32,
  :tone_proc        => proc { |strength|
    next Tone.new(-strength * 5 / 10, -strength * 5 / 10, -strength * 5 / 10, 10)
  }
})

# Changed by Jos 2023-02-23 to add new sakura petals overworld weather
GameData::Weather.register({
  :id               => :SakuraFog,
  :id_number        => 18,
  :category         => :SakuraFog,
  :graphics         => [["sakura", "sakura_1", "sakura_2", "sakura_3", "sakura_4"], ["fog_tile_4"]],
  :particle_delta_x => 120,
  :particle_delta_y => 120,
  :tile_delta_x     => 32,
  :tile_delta_y     => 32,
  :tone_proc        => proc { |strength|
    next Tone.new(strength / 8, strength / 8, strength / 8, 0)
  }
})

GameData::Weather.register({
  :id               => :BlueFog,
  :category         => :BlueFog,
  :id_number        => 19,
  :tile_delta_x     => 32,
  :tile_delta_y     => 32,
  :graphics         => [nil, ["fog_tile_4"]],
  :tone_proc        => proc { |strength|
    next Tone.new(strength / 8, strength / 8, strength / 8, 0)
  }
})

GameData::Weather.register({
  :id               => :FogRain2,
  :id_number        => 20,
  :category         => :Rain,
  :graphics         => [["rain_1", "rain_2", "rain_3", "rain_4"], ["fog_tile"]],   # Last is splash
  :particle_delta_x => -1200,
  :particle_delta_y => 4800,
  :tile_delta_x     => 32,
  :tile_delta_y     => 32,
  :tone_proc        => proc { |strength|
    next Tone.new(-strength * 5 / 10, -strength * 5 / 10, -strength * 5 / 10, 10)
  }
})

GameData::Weather.register({
  :id               => :Waves,
  :id_number        => 21,
  :category         => :Waves,
  :particle_delta_x => 0,
  :particle_delta_y => -10,
  :tile_delta_x     => 32,
  :tile_delta_y     => 32,
  :graphics         => [["bubble_1", "bubble_2", "bubble_3", "bubble_4"], ["waves_tile"]],
    :tone_proc        => proc { |strength|
	next Tone.new(0, 0, 0, 0)
  }
})

GameData::Weather.register({
  :id               => :Ashstorm,
  :id_number        => 22,
  :category         => :Sandstorm,
  :graphics         => [["ashstorm_1", "ashstorm_2", "ashstorm_3", "ashstorm_4"]], #["sandstorm_tile"]], # Changed by Jos 2023-09-03 to make it less hard on the eyes
  :particle_delta_x => -1200,
  :particle_delta_y => 640,
  :tile_delta_x     => -720,
  :tile_delta_y     => 360,
  :tone_proc        => proc { |strength|
    next Tone.new(strength / 2, strength / 2, strength / 2, 0)
  }
})

GameData::Weather.register({
  :id               => :Sulfur,
  :category         => :Sulfur,
  :id_number        => 23,
  :tile_delta_x     => 32,
  :tile_delta_y     => 32,
  :graphics         => [nil, ["fog_tile_5"]],
  :tone_proc        => proc { |strength|
    next Tone.new(strength / 8, strength / 8, strength / 8, 0)
  }
})

GameData::Weather.register({
  :id               => :HeavyRainCopy,
  :id_number        => 24,
  :category         => :FakeRain,
  :graphics         => [["storm_1", "storm_2", "storm_3"]],
  :particle_delta_x => -4800,
  :particle_delta_y => 4800,
  :tone_proc        => proc { |strength|
    # next Tone.new(-strength * 3 / 2, -strength * 3 / 2, -strength * 3 / 2, 20) # Changed by Jos 2024-04-28 to modify default heavy rain tint.
	next Tone.new(-strength * 3 / 4, -strength * 3 / 4, -strength * 3 / 4, 10)
  }
})

GameData::Weather.register({
  :id               => :WavesCopy,
  :id_number        => 25,
  :category         => :WavesCopy,
  :particle_delta_x => 0,
  :particle_delta_y => -10,
  :tile_delta_x     => 32,
  :tile_delta_y     => 32,
  :graphics         => [["bubble_1", "bubble_2", "bubble_3", "bubble_4"], ["waves_tile"]],
    :tone_proc        => proc { |strength|
	next Tone.new(0, 0, 0, 0)
  }
})

GameData::Weather.register({
  :id               => :BloodAsh,
  :id_number        => 26,
  :category         => :BloodAsh,
  :particle_delta_x => -120,
  :particle_delta_y => 120,
  :tile_delta_x     => 32,
  :tile_delta_y     => 32,
  :graphics         => [["ash_1", "ash_2", "ash_3"], ["fog_tile_6"]]
})