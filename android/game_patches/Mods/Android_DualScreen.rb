#===============================================================================
# Android dual-screen status feed (added to the game only in the Android APK)
#-------------------------------------------------------------------------------
# On devices with a second screen (e.g. AYN Thor) the app shows a live info
# panel there. While that panel is open, the app creates ".tw_dualscreen" in
# the game folder; this script then writes the player's status to
# ".tw_status.json" whenever it changes, and the panel displays it.
# Nothing here runs on single-screen devices or on PC.
#===============================================================================
if (System.platform[/Android/] rescue false)
  module AndroidDualScreen
    FLAG     = File.join(Dir.pwd, ".tw_dualscreen")
    OUT      = File.join(Dir.pwd, ".tw_status.json")
    INTERVAL = 30   # frames between checks (~0.5 s)

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

    def pokemon_entry(pkmn)
      egg = pkmn.egg?
      icon = (GameData::Species.icon_filename_from_pokemon(pkmn) rescue nil)
      status = egg ? "NONE" : (pkmn.status rescue :NONE).to_s
      {
        "name"   => egg ? "Egg" : pkmn.name,
        "lv"     => egg ? 0 : pkmn.level,
        "hp"     => egg ? 0 : pkmn.hp,
        "maxhp"  => egg ? 0 : pkmn.totalhp,
        "status" => status,
        "egg"    => egg,
        "shiny"  => (pkmn.shiny? rescue false),
        "icon"   => icon.to_s
      }
    end

    def status
      return { "ingame" => false } if !$player || !$game_map
      party = ($player.party || []).compact.map { |p| pokemon_entry(p) }
      {
        "ingame" => true,
        "player" => $player.name,
        "map"    => ($game_map.name rescue ""),
        "money"  => ($player.money rescue 0),
        "badges" => ($player.badge_count rescue 0),
        "time"   => (($stats.play_time rescue 0) || 0).to_i,
        "party"  => party
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
      # Never let the info panel break the game
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
