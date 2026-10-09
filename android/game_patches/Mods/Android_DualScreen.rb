#===============================================================================
# Android dual-screen feed (added to the game only in the Android APK)
#-------------------------------------------------------------------------------
# On devices with a second screen (e.g. AYN Thor) the app shows a second game
# screen there: a live copy of the party screen and a journal page (location
# sign, current story objective, chapters, money, clock, game speed).
# While that screen is open the app creates ".tw_dualscreen" in the game
# folder; this script then writes the game state the screen needs to
# ".tw_status.json" whenever it changes. Nothing here runs on single-screen
# devices or on PC.
#===============================================================================
if (System.platform[/Android/] rescue false)
  module AndroidDualScreen
    FLAG     = File.join(Dir.pwd, ".tw_dualscreen")
    OUT      = File.join(Dir.pwd, ".tw_status.json")
    INTERVAL = 20   # frames between checks

    # Same word lists and order as the BW Location Signposts plugin
    SIGN_TYPES = [
      ["town",   :TOWN,   ["town", "safari"]],
      ["city",   :CITY,   ["city"]],
      ["bridge", :BRIDGE, ["bridge"]],
      ["route",  :ROUTE,  ["route", "path"]],
      ["forest", :FOREST, ["forest", "grove"]],
      ["cave",   :CAVE,   ["cave"]],
      ["port",   :PORT,   ["port", "harbor"]],
      ["desert", :DESERT, ["desert"]]
    ]

    @frame  = 0
    @last   = nil
    @broken = false

    module_function

    def json(v)
      case v
      when nil then "null"
      when true, false, Integer then v.to_s
      when Float then v.finite? ? v.round(2).to_s : "0"
      when Array then "[" + v.map { |x| json(x) }.join(",") + "]"
      when Hash then "{" + v.map { |k, x| json(k.to_s) + ":" + json(x) }.join(",") + "}"
      else
        s = v.to_s.dup.force_encoding("UTF-8").scrub("?")
        s = s.gsub(/["\\]/) { |c| "\\" + c }.gsub(/[\x00-\x1f]/) { |c| format("\\u%04x", c.ord) }
        "\"" + s + "\""
      end
    end

    # Row of Graphics/Pictures/statuses for this Pokémon, like the party screen
    def status_icon(pkmn)
      return GameData::Status.count - 1 if pkmn.fainted?
      return GameData::Status.get(pkmn.status).icon_position if pkmn.status != :NONE
      return GameData::Status.count if pkmn.pokerusStage == 1
      return -1
    rescue StandardError
      -1
    end

    def pokemon_entry(pkmn)
      icon = (GameData::Species.icon_filename_from_pokemon(pkmn) rescue nil).to_s
      if pkmn.egg?
        return { "name" => pkmn.name, "egg" => true, "icon" => icon }
      end
      gender = pkmn.genderless? ? 2 : (pkmn.male? ? 0 : 1)
      {
        "name"    => pkmn.name,
        "lv"      => pkmn.level,
        "hp"      => pkmn.hp,
        "maxhp"   => pkmn.totalhp,
        "gender"  => gender,
        "status"  => status_icon(pkmn),
        "shiny"   => (pkmn.shiny? rescue false),
        "item"    => !pkmn.item.nil?,
        "ball"    => (pkmn.poke_ball rescue nil).to_s,
        "fainted" => pkmn.fainted?,
        "icon"    => icon
      }
    end

    def location
      name = ($game_map.name rescue "").to_s
      map_id = $game_map.map_id
      sign = "none"
      SIGN_TYPES.each do |type, const, defaults|
        words = Object.const_defined?(const) ? Object.const_get(const) : defaults
        hit = words.any? do |w|
          w.is_a?(String) ? (name.include?(w) || name.include?(w.sub(/^./) { |m| m.upcase })) : w == map_id
        end
        sign = type if hit
      end
      route_no = (sign == "route") ? name.gsub(/[^0-9]/, "") : ""
      { "name" => name, "sign" => sign, "route_no" => route_no }
    end

    def clock
      now = pbGetTimeNow
      tod = if PBDayNight.isNight?(now) then "Night"
            elsif PBDayNight.isMorning?(now) then "Morning"
            elsif PBDayNight.isEvening?(now) then "Evening"
            else "Day"
            end
      season = (pbGetSeasonName(pbGetSeason) rescue "")
      { "time" => now.strftime("%H:%M"), "tod" => tod, "season" => season.to_s }
    rescue StandardError
      { "time" => "", "tod" => "", "season" => "" }
    end

    def quest
      return nil if !$PokemonGlobal || !$quest_data
      active = $PokemonGlobal.quests.active_quests
      return nil if !active || active.empty?
      q = active.reverse.find { |x| x.story } || active.last
      desc = begin
        $quest_data.getQuestDescription(q.id, q.stage)
      rescue ArgumentError
        $quest_data.getQuestDescription(q.id)
      end
      {
        "name"     => $quest_data.getName(q.id),
        "location" => ($quest_data.getStageLocation(q.id, q.stage) rescue ""),
        "desc"     => desc.to_s.gsub(/\s+/, " ").strip,
        "story"    => q.story ? true : false
      }
    rescue StandardError
      nil
    end

    # Where the player is on the Town Map, worked out like the game's own
    # region map screen (PokemonRegionMap_Scene#pbStartScene)
    def region_map
      meta = $game_map.metadata
      pos = meta ? meta.town_map_position : nil
      return nil if !pos
      data = pbLoadTownMapData[pos[0]]
      return nil if !data
      x, y = pos[1], pos[2]
      size = meta.town_map_size
      if size && size[0] && size[0] > 0
        sqw = size[0]
        sqh = (size[1].length.to_f / size[0]).ceil
        x += ($game_player.x * sqw / $game_map.width).floor if sqw > 1
        y += ($game_player.y * sqh / $game_map.height).floor if sqh > 1
      end
      extras = []
      Settings::REGION_MAP_EXTRAS.each do |g|
        next if g[0] != pos[0] || g[1] <= 0 || !$game_switches[g[1]]
        extras.push([g[2], g[3], "Graphics/Pictures/" + g[4]])
      end
      {
        "region"  => (pbGetMessage(MessageTypes::RegionNames, pos[0]) rescue data[0]).to_s,
        "image"   => "Graphics/Pictures/" + data[1].to_s.sub(/\.png\z/i, ""),
        "x"       => x,
        "y"       => y,
        "player"  => (GameData::TrainerType.player_map_icon_filename($player.trainer_type) rescue "").to_s,
        "extras"  => extras
      }
    rescue StandardError
      nil
    end

    def status
      return { "ingame" => false } if !$player || !$game_map
      badges = (0...18).map { |i| $player.badges[i] ? true : false } rescue []
      {
        "ingame"   => true,
        "player"   => $player.name,
        "money"    => ($player.money rescue 0),
        "badges"   => badges,
        "playtime" => (($stats.play_time rescue 0) || 0).to_i,
        "speed"    => (defined?($GameSpeed) && $GameSpeed) ? $GameSpeed + 1 : 1,
        "location" => location,
        "clock"    => clock,
        "quest"    => quest,
        "map"      => region_map,
        "party"    => ($player.party || []).compact.first(6).map { |p| pokemon_entry(p) }
      }
    end

    def update
      return if @broken
      @frame += 1
      return if @frame % INTERVAL != 0
      return if !File.exist?(FLAG)
      text = json(status)
      return if text == @last
      tmp = OUT + ".tmp"
      File.open(tmp, "wb") { |f| f.write(text) }
      File.rename(tmp, OUT)
      @last = text
    rescue StandardError
      # Never let the second screen break the game
      @broken = true
    end
  end

  module Graphics
    class << self
      alias_method :__tw_dualscreen_update, :update unless method_defined?(:__tw_dualscreen_update)
      def update(*args)
        ret = __tw_dualscreen_update(*args)
        AndroidDualScreen.update
        ret
      end
    end
  end
end
