#===============================================================================
# Android dual-screen support (added to the game only in the Android APK)
#-------------------------------------------------------------------------------
# On devices with a second screen (e.g. AYN Thor) the app draws a second game
# screen there (party, summaries, journal, map, route, battle controls...).
#
#   game -> screen : while ".tw_dualscreen" exists in the game folder, the
#                    current game state is written to ".tw_status.json".
#   screen -> game : the screen drops command files ".tw_cmd_*.txt" (simple
#                    "key=value" lines) into the game folder. Commands run
#                    only where they are safe:
#                      - anywhere: game speed, text entry
#                      - battle menus: pick a command / move (applied exactly
#                        like a button press, so every game rule still applies)
#                      - free roaming on the map: menu, party swap, items,
#                        Fly, save, Repel, registered key items
#
# Nothing here runs on single-screen devices or on PC.
#===============================================================================
if (System.platform[/Android/] rescue false)
  module AndroidDualScreen
    FLAG       = File.join(Dir.pwd, ".tw_dualscreen")
    OUT        = File.join(Dir.pwd, ".tw_status.json")
    CMD_GLOB   = File.join(Dir.pwd, ".tw_cmd_*.txt")
    CMD_EXPIRE = 8.0   # seconds a queued command waits for a safe moment

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
    REPELS = [:MAXREPEL, :SUPERREPEL, :REPEL]
    STAT_KEYS = [:HP, :ATTACK, :DEFENSE, :SPECIAL_ATTACK, :SPECIAL_DEFENSE, :SPEED]

    @frame      = 0
    @last       = nil
    @broken     = false
    @active     = false
    @map_queue  = []
    @battle_pick = nil
    @forced     = {}
    @text_ops   = []
    @log        = []
    @toast      = nil
    @toast_id   = 0
    @cache      = {}

    class << self
      attr_accessor :battle_scene, :battle_menu, :entry_scene
      attr_reader :forced

      def active?; @active; end

      #-------------------------------------------------------------------------
      # JSON (the engine has no json library)
      #-------------------------------------------------------------------------
      def json(v)
        case v
        when nil then "null"
        when true, false, Integer then v.to_s
        when Float then v.finite? ? v.round(3).to_s : "0"
        when Symbol then json(v.to_s)
        when Array then "[" + v.map { |x| json(x) }.join(",") + "]"
        when Hash then "{" + v.map { |k, x| json(k.to_s) + ":" + json(x) }.join(",") + "}"
        else
          s = v.to_s.dup.force_encoding("UTF-8").scrub("?")
          s = s.gsub(/["\\]/) { |c| "\\" + c }.gsub(/[\x00-\x1f]/) { |c| format("\\u%04x", c.ord) }
          "\"" + s + "\""
        end
      end

      def toast(text)
        @toast_id += 1
        @toast = { "id" => @toast_id, "text" => text.to_s }
      end

      #-------------------------------------------------------------------------
      # Context
      #-------------------------------------------------------------------------
      def in_battle?
        ($game_temp && $game_temp.in_battle) || !@battle_scene.nil?
      end

      # Free roaming on the map: no event, message, menu or movement running
      def map_safe?
        return false if !$scene.is_a?(Scene_Map) || !$game_temp || !$game_player
        return false if $game_temp.in_battle || $game_temp.in_menu || $game_temp.message_window_showing
        return false if pbMapInterpreterRunning? || $game_player.moving? || $game_player.move_route_forcing
        true
      end

      def context
        return "title" if !$player || !$game_map
        return "battle" if in_battle?
        return "entry" if @entry_scene
        return "map" if map_safe?
        "busy"
      end

      #-------------------------------------------------------------------------
      # Status
      #-------------------------------------------------------------------------
      def type_info(type)
        t = GameData::Type.get(type)
        { "id" => t.id.to_s, "name" => t.name, "icon" => t.icon_position }
      rescue StandardError
        { "id" => type.to_s, "name" => type.to_s, "icon" => 0 }
      end

      def move_info(m)
        data = GameData::Move.get(m.id) rescue nil
        {
          "id"    => m.id.to_s,
          "name"  => m.name,
          "type"  => type_info(m.type),
          "pp"    => m.pp,
          "maxpp" => m.total_pp,
          "power" => (data ? data.base_damage : 0),
          "acc"   => (data ? data.accuracy : 0),
          "cat"   => (data ? data.category : 2),
          "desc"  => (data ? data.description : "")
        }
      end

      # Row of Graphics/Pictures/statuses for this Pokémon, like the party screen
      def status_icon(pkmn)
        return GameData::Status.count - 1 if pkmn.fainted?
        return GameData::Status.get(pkmn.status).icon_position if pkmn.status != :NONE
        return GameData::Status.count if pkmn.pokerusStage == 1
        -1
      rescue StandardError
        -1
      end

      def pokemon_entry(pkmn)
        icon = (GameData::Species.icon_filename_from_pokemon(pkmn) rescue nil).to_s
        return { "name" => pkmn.name, "egg" => true, "icon" => icon,
                 "steps" => (pkmn.steps_to_hatch rescue 0) } if pkmn.egg?
        front = (GameData::Species.front_sprite_filename(pkmn.species, pkmn.form, pkmn.gender, pkmn.shiny?) rescue nil).to_s
        ability = pkmn.ability
        nature = pkmn.nature
        e = {
          "name"     => pkmn.name,
          "species"  => pkmn.speciesName,
          "lv"       => pkmn.level,
          "hp"       => pkmn.hp,
          "maxhp"    => pkmn.totalhp,
          "gender"   => pkmn.genderless? ? 2 : (pkmn.male? ? 0 : 1),
          "status"   => status_icon(pkmn),
          "shiny"    => (pkmn.shiny? rescue false),
          "item"     => !pkmn.item.nil?,
          "item_name"=> (pkmn.item ? pkmn.item.name : ""),
          "ball"     => (pkmn.poke_ball rescue nil).to_s,
          "fainted"  => pkmn.fainted?,
          "icon"     => icon,
          "front"    => front,
          "types"    => pkmn.types.map { |t| type_info(t) },
          "ability"  => (ability ? ability.name : ""),
          "ability_desc" => (ability ? ability.description : ""),
          "nature"   => (nature ? nature.name : ""),
          "exp_frac" => ((pkmn.exp_fraction rescue 0.0) || 0.0).to_f,
          "stats"    => [pkmn.totalhp, pkmn.attack, pkmn.defense, pkmn.spatk, pkmn.spdef, pkmn.speed],
          "ivs"      => STAT_KEYS.map { |s| (pkmn.iv[s] rescue 0) },
          "evs"      => STAT_KEYS.map { |s| (pkmn.ev[s] rescue 0) },
          "moves"    => pkmn.moves.map { |m| move_info(m) }
        }
        e
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
        { "name" => name, "sign" => sign, "route_no" => route_no, "id" => map_id }
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

      def quest_entry(q, done = nil)
        desc = begin
          $quest_data.getQuestDescription(q.id, q.stage)
        rescue ArgumentError
          $quest_data.getQuestDescription(q.id)
        end
        {
          "name"     => $quest_data.getName(q.id),
          "location" => ($quest_data.getStageLocation(q.id, q.stage) rescue ""),
          "desc"     => desc.to_s.gsub(/\s+/, " ").strip,
          "stage"    => q.stage,
          "stages"   => ($quest_data.getMaxStagesForQuest(q.id) rescue 0),
          "story"    => q.story ? true : false,
          "done"     => done
        }
      rescue StandardError
        nil
      end

      def quest
        return nil if !$PokemonGlobal || !$quest_data
        active = $PokemonGlobal.quests.active_quests
        return nil if !active || active.empty?
        quest_entry(active.reverse.find { |x| x.story } || active.last)
      rescue StandardError
        nil
      end

      def quests
        return [] if !$PokemonGlobal || !$quest_data
        q = $PokemonGlobal.quests
        key = [q.active_quests.map { |x| [x.id, x.stage] }, q.completed_quests.size, q.failed_quests.size]
        return @cache[:quests] if @cache[:quests_key] == key
        list = q.active_quests.reverse.map { |x| quest_entry(x, false) } +
               q.completed_quests.reverse.map { |x| quest_entry(x, true) }
        @cache[:quests_key] = key
        @cache[:quests] = list.compact.first(40)
      rescue StandardError
        []
      end

      # Where the player is on the Town Map, like PokemonRegionMap_Scene
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
        can_fly = (pbCanFly?(nil, false) rescue false) ? true : false
        points = (data[2] || []).map do |pt|
          heal = pt[4] && pt[4] > 0
          visited = heal && $PokemonGlobal.visitedMaps[pt[4]]
          [pt[0], pt[1], pt[2].to_s, (heal && visited) ? true : false]
        end
        {
          "region"  => (pbGetMessage(MessageTypes::RegionNames, pos[0]) rescue data[0]).to_s,
          "index"   => pos[0],
          "image"   => "Graphics/Pictures/" + data[1].to_s.sub(/\.png\z/i, ""),
          "x"       => x,
          "y"       => y,
          "player"  => (GameData::TrainerType.player_map_icon_filename($player.trainer_type) rescue "").to_s,
          "extras"  => extras,
          "points"  => points,
          "can_fly" => can_fly
        }
      rescue StandardError
        nil
      end

      def encounters
        map_id = $game_map.map_id
        version = ($PokemonGlobal.encounter_version rescue 0)
        key = [map_id, version]
        key += [pbGetTimeNow.hour] rescue nil
        return @cache[:enc] if @cache[:enc_key] == key
        enc = GameData::Encounter.get(map_id, version) rescue nil
        groups = []
        now = pbGetTimeNow rescue Time.now
        times = {
          "Morning"   => (PBDayNight.isMorning?(now) rescue false),
          "Afternoon" => (PBDayNight.isAfternoon?(now) rescue false),
          "Evening"   => (PBDayNight.isEvening?(now) rescue false),
          "Day"       => (PBDayNight.isDay?(now) rescue false),
          "Night"     => (PBDayNight.isNight?(now) rescue false)
        }
        if enc
          enc.types.each do |type, slots|
            # "LandMorning" -> "Land", "Morning": only show the current time's list
            words = type.to_s.gsub(/([a-z])([A-Z])/, '\\1 \\2').split(" ")
            time_word = words.last if times.key?(words.last)
            next if time_word && !times[time_word]
            totals = Hash.new(0)
            levels = {}
            slots.each do |chance, species, min, max|
              totals[species] += chance
              lo, hi = levels[species] || [min, max || min]
              levels[species] = [[lo, min].min, [hi, max || min].max]
            end
            sum = [totals.values.sum, 1].max
            entries = totals.sort_by { |_, c| -c }.map do |species, c|
              sp = GameData::Species.get(species) rescue nil
              next nil if !sp
              owned = ($player.owned?(sp.species) rescue false)
              seen = owned || ($player.seen?(sp.species) rescue false)
              {
                "name"  => seen ? sp.name : "???",
                "icon"  => (GameData::Species.icon_filename(sp.species, sp.form) rescue "").to_s,
                "seen"  => seen ? true : false,
                "owned" => owned ? true : false,
                "pct"   => (c * 100.0 / sum).round,
                "lv"    => levels[species][0] == levels[species][1] ? levels[species][0].to_s : "#{levels[species][0]}-#{levels[species][1]}"
              }
            end.compact
            label = words.join(" ")
            label = label.sub(" #{time_word}", " (#{time_word})") if time_word
            groups.push({ "type" => label, "entries" => entries })
          end
        end
        @cache[:enc_key] = key
        @cache[:enc] = groups
      rescue StandardError
        []
      end

      def heal_items
        return [] if !$bag
        list = []
        ($bag.pockets[2] || []).each do |item, qty|
          next if !ItemHandlers.hasUseOnPokemon(item)
          data = GameData::Item.get(item)
          list.push({ "id" => data.id.to_s, "name" => data.name, "qty" => qty,
                      "icon" => (GameData::Item.icon_filename(data.id) rescue "").to_s })
        end
        list
      rescue StandardError
        []
      end

      def quick_items
        return {} if !$bag
        reg = ($bag.registered_items || []).map do |item|
          data = GameData::Item.try_get(item)
          next nil if !data
          { "id" => data.id.to_s, "name" => data.name, "icon" => (GameData::Item.icon_filename(data.id) rescue "").to_s }
        end.compact
        repel = REPELS.find { |r| GameData::Item.exists?(r) && $bag.has?(r) }
        {
          "registered" => reg,
          "repel" => repel ? { "id" => repel.to_s, "name" => GameData::Item.get(repel).name, "qty" => $bag.quantity(repel),
                               "steps" => ($PokemonGlobal.repel rescue 0) } : nil
        }
      rescue StandardError
        {}
      end

      def battler_types(b)
        (b.pbTypes(true) rescue b.pokemon.types).map { |t| type_info(t) }
      end

      def battle_state
        scene = @battle_scene
        return nil if !scene
        battle = scene.instance_variable_get(:@battle)
        return nil if !battle
        menu = @battle_menu
        foes = []
        allies = []
        battle.battlers.each do |b|
          next if !b || b.fainted? && b.hp <= 0 && !b.pokemon
          next if !b.pokemon
          stages = {}
          (b.stages || {}).each { |k, v| stages[k.to_s] = v if v != 0 }
          info = {
            "index"  => b.index,
            "name"   => b.name,
            "lv"     => b.level,
            "hp"     => b.hp,
            "maxhp"  => b.totalhp,
            "status" => (b.status == :NONE ? -1 : (GameData::Status.get(b.status).icon_position rescue -1)),
            "types"  => battler_types(b),
            "stages" => stages,
            "icon"   => (GameData::Species.icon_filename_from_pokemon(b.displayPokemon) rescue "").to_s,
            "fainted"=> b.fainted?
          }
          if b.opposes?
            info.delete("hp") ; info.delete("maxhp")
            info["hp_frac"] = b.totalhp > 0 ? (b.hp.to_f / b.totalhp) : 0.0
            foes.push(info)
          else
            allies.push(info)
          end
        end
        st = {
          "menu"  => menu ? menu[:kind].to_s : "none",
          "foes"  => foes,
          "allies"=> allies
        }
        if menu
          st["battler"] = menu[:battler]
          if menu[:kind] == :command
            st["commands"] = menu[:texts] || []
            st["cmd_mode"] = menu[:mode] || 0
          elsif menu[:kind] == :fight
            b = battle.battlers[menu[:battler]]
            targets = battle.battlers.select { |o| o && !o.fainted? && o.opposes?(menu[:battler]) }
            st["moves"] = (b ? b.moves : []).map do |m|
              next nil if !m || !m.id
              data = GameData::Move.get(m.id) rescue nil
              eff = targets.map do |t|
                begin
                  v = Effectiveness.calculate(m.type, *t.pbTypes(true))
                  data && data.category == 2 ? "status" :
                    Effectiveness.ineffective?(v) ? "none" :
                    Effectiveness.super_effective?(v) ? "super" :
                    Effectiveness.not_very_effective?(v) ? "weak" : "normal"
                rescue StandardError
                  "normal"
                end
              end
              { "name" => m.name, "type" => type_info(m.type), "pp" => m.pp, "maxpp" => m.total_pp,
                "power" => (data ? data.base_damage : 0), "acc" => (data ? data.accuracy : 0),
                "cat" => (data ? data.category : 2), "eff" => eff }
            end.compact
            st["can_special"] = menu[:special] ? true : false
            st["can_shift"] = (battle.pbCanShift?(menu[:battler]) rescue false) ? true : false
          end
        end
        st
      rescue StandardError
        nil
      end

      def status
        return { "ingame" => false, "context" => "title", "log" => @log, "toast" => @toast } if !$player || !$game_map
        badges = (0...18).map { |i| $player.badges[i] ? true : false } rescue []
        st = {
          "ingame"   => true,
          "context"  => context,
          "player"   => $player.name,
          "money"    => ($player.money rescue 0),
          "badges"   => badges,
          "playtime" => (($stats.play_time rescue 0) || 0).to_i,
          "speed"    => (defined?($GameSpeed) && $GameSpeed) ? $GameSpeed + 1 : 1,
          "location" => location,
          "clock"    => clock,
          "quest"    => quest,
          "quests"   => quests,
          "map"      => region_map,
          "party"    => ($player.party || []).compact.first(6).map { |p| pokemon_entry(p) },
          "heal"     => heal_items,
          "quick"    => quick_items,
          "route"    => encounters,
          "log"      => @log,
          "toast"    => @toast
        }
        st["battle"] = battle_state if in_battle?
        if @entry_scene
          h = @entry_scene.instance_variable_get(:@helper)
          st["entry"] = { "text" => (h ? h.text : ""), "max" => @entry_scene.instance_variable_get(:@maxlength).to_i,
                          "min" => @entry_scene.instance_variable_get(:@minlength).to_i }
        end
        st
      end

      def write_status
        text = json(status)
        return if text == @last
        tmp = OUT + ".tmp"
        File.open(tmp, "wb") { |f| f.write(text) }
        File.rename(tmp, OUT)
        @last = text
      end

      #-------------------------------------------------------------------------
      # Commands
      #-------------------------------------------------------------------------
      def read_commands
        files = Dir.glob(CMD_GLOB).sort
        files.each do |f|
          cmd = {}
          begin
            File.read(f).each_line do |line|
              k, v = line.chomp.split("=", 2)
              cmd[k] = v if k && v
            end
          rescue StandardError
          end
          File.delete(f) rescue nil
          dispatch(cmd) if cmd["cmd"]
        end
      end

      def dispatch(cmd)
        case cmd["cmd"]
        when "speed"
          if defined?($GameSpeed) && defined?(SPEEDUP_STAGES)
            $GameSpeed = ($GameSpeed + 1) % SPEEDUP_STAGES.size
          end
        when "battle_command", "battle_move", "battle_back", "battle_special", "battle_shift"
          if in_battle?
            @battle_pick = { cmd: cmd["cmd"], index: cmd["index"].to_i, at: Time.now }
          else
            toast(_INTL("That's only for battles."))
          end
        when "type", "backspace", "enter"
          @text_ops.push(cmd) if @entry_scene
        else
          if in_battle?
            toast(_INTL("You can't do that during a battle."))
          else
            cmd["at"] = Time.now
            @map_queue.push(cmd)
          end
        end
      end

      # Runs queued map commands once the player is free (called from Scene_Map)
      def run_map_commands
        return if @map_queue.empty?
        now = Time.now
        @map_queue.reject! do |c|
          if now - c["at"] > CMD_EXPIRE
            toast(_INTL("You can't do that right now."))
            true
          else
            false
          end
        end
        return if @map_queue.empty? || !map_safe?
        cmd = @map_queue.shift
        begin
          run_map_command(cmd)
        rescue StandardError => e
          toast(_INTL("That didn't work."))
          echoln("Second screen command #{cmd['cmd']} failed: #{e.message}") rescue nil
        end
        @last = nil   # refresh the screen right away
      end

      def run_map_command(cmd)
        party = $player.party
        case cmd["cmd"]
        when "menu"
          if $game_system.menu_disabled
            toast(_INTL("The menu can't be opened right now."))
          else
            $game_temp.menu_calling = true
          end
        when "swap"
          a, b = cmd["a"].to_i, cmd["b"].to_i
          return if a == b || !party[a] || !party[b]
          party[a], party[b] = party[b], party[a]
          pbSEPlay("GUI party switch") rescue nil
          (FollowingPkmn.refresh(false) rescue nil) if defined?(FollowingPkmn)
          toast(_INTL("Swapped {1} and {2}.", party[b].name, party[a].name))
        when "use_item"
          item = cmd["item"].to_s.to_sym
          pkmn = party[cmd["pkmn"].to_i]
          return if !pkmn || !GameData::Item.exists?(item) || !$bag.has?(item)
          use_item_on(item, pkmn)
        when "fly"
          fly_to(cmd["x"].to_i, cmd["y"].to_i)
        when "save"
          pbSaveScreen
        when "repel"
          repel = REPELS.find { |r| GameData::Item.exists?(r) && $bag.has?(r) }
          repel ? pbUseItem($bag, repel) : toast(_INTL("You don't have any Repels."))
        when "key_item"
          item = cmd["item"].to_s.to_sym
          if GameData::Item.exists?(item) && $bag.has?(item)
            pbUseKeyItemInField(item)
          end
        end
      end

      # Same as using an item from the party screen (pbUseItemOnPokemon),
      # with the messages shown on the main screen.
      def use_item_on(item, pkmn)
        itm = GameData::Item.get(item)
        if pkmn.egg?
          pbMessage(_INTL("It won't have any effect."))
          return
        end
        scene = PartyAdapter.new
        ret = ItemHandlers.triggerUseOnPokemon(item, 1, pkmn, scene)
        if ret && itm.consumed_after_use?
          $bag.remove(item, 1)
          pbMessage(_INTL("You used your last {1}.", itm.name)) if !$bag.has?(item)
        end
      end

      def fly_to(x, y)
        meta = $game_map.metadata
        pos = meta ? meta.town_map_position : nil
        data = pos ? pbLoadTownMapData[pos[0]] : nil
        point = data ? (data[2] || []).find { |pt| pt[0] == x && pt[1] == y && pt[4] && pt[4] > 0 } : nil
        if !point || !$PokemonGlobal.visitedMaps[point[4]]
          toast(_INTL("You can't fly there."))
          return
        end
        if !pbCanFly?(nil, true)
          return
        end
        return if !pbConfirmMessage(_INTL("Fly to {1}?", point[2]))
        $game_temp.fly_destination = [point[4], point[5], point[6]]
        pbFlyToNewLocation
      end

      #-------------------------------------------------------------------------
      # Battle input: choose a menu entry exactly like a button press
      #-------------------------------------------------------------------------
      def apply_battle_pick
        pick = @battle_pick
        return if !pick
        if Time.now - pick[:at] > CMD_EXPIRE
          @battle_pick = nil
          return
        end
        menu = @battle_menu
        scene = @battle_scene
        return if !menu || !scene
        sprites = scene.instance_variable_get(:@sprites)
        case pick[:cmd]
        when "battle_command"
          return if menu[:kind] != :command
          cw = sprites["commandWindow"]
          return if !cw
          cw.index = pick[:index]
          @forced[Input::USE] = true
        when "battle_move", "battle_back", "battle_special", "battle_shift"
          return if menu[:kind] != :fight
          case pick[:cmd]
          when "battle_move"
            fw = sprites["fightWindow"]
            return if !fw
            fw.index = pick[:index]
            @forced[Input::USE] = true
          when "battle_back" then @forced[Input::BACK] = true
          when "battle_special" then @forced[Input::ACTION] = true
          when "battle_shift" then @forced[Input::SPECIAL] = true
          end
        end
        @battle_pick = nil
      end

      #-------------------------------------------------------------------------
      # Text entry (naming screen, cursor mode)
      #-------------------------------------------------------------------------
      def apply_text_ops(scene)
        return if @text_ops.empty?
        helper = scene.instance_variable_get(:@helper)
        return if !helper
        max = scene.instance_variable_get(:@maxlength).to_i
        while (op = @text_ops.shift)
          case op["cmd"]
          when "type"
            op["text"].to_s.each_char do |ch|
              break if max > 0 && helper.length >= max
              helper.insert(ch)
            end
          when "backspace"
            helper.delete
          when "enter"
            scene.instance_variable_set(:@cursorpos, PokemonEntryScene2::OK) rescue nil
            (scene.instance_variable_get(:@sprites)["cursor"].setCursorPos(PokemonEntryScene2::OK) rescue nil)
            @forced[Input::USE] = true
          end
        end
        scene.pbUpdateOverlay rescue nil
        @last = nil
      end

      #-------------------------------------------------------------------------
      # Text history
      #-------------------------------------------------------------------------
      def log_message(msg)
        return if !msg.is_a?(String) || !@active
        text = msg.dup
        speaker = nil
        text = text.gsub(/\\xn\[(.*?)\]/i) { speaker = $1; "" }
        text = text.gsub(/\\pn/i) { $player ? $player.name : "" }
        text = text.gsub(/\\v\[(\d+)\]/i) { ($game_variables[$1.to_i] rescue "").to_s }
        text = text.gsub(/\\[a-z]+\[[^\]]*\]/i, "").gsub(/\\[a-z.!|^<>]+/i, "").gsub(/<[^>]+>/, "")
        text = text.gsub(/[\x00-\x1f]/, " ").gsub(/\s+/, " ").strip
        return if text.empty?
        entry = speaker ? "#{speaker}: #{text}" : text
        return if @log.last == entry
        @log.push(entry)
        @log.shift while @log.size > 30
      end

      #-------------------------------------------------------------------------
      # Per-frame hooks
      #-------------------------------------------------------------------------
      def on_graphics_update
        return if @broken
        @frame += 1
        if (@frame % 10) == 0
          @active = File.exist?(FLAG)
          read_commands if @active
        end
        return if !@active
        interval = (in_battle? || @entry_scene) ? 6 : 20
        write_status if (@frame % interval) == 0
      rescue StandardError => e
        # Never let the second screen break the game
        @broken = true
        echoln("Second screen disabled: #{e.class}: #{e.message}") rescue nil
      end

      def on_input_update
        @forced.clear
        apply_battle_pick if @battle_pick
      rescue StandardError
        @battle_pick = nil
      end
    end

    # Stands in for the party screen when an item is used from the second
    # screen; messages appear on the main screen.
    class PartyAdapter
      def pbDisplay(msg); pbMessage(msg); end
      def pbConfirm(msg); pbConfirmMessage(msg); end
      def pbChooseNumber(_text, _max, _initial = 1); 1; end
      def pbChooseMove(pkmn, helptext, index = 0)
        cmds = pkmn.moves.map { |m| "#{m.name} (#{m.pp}/#{m.total_pp})" }
        pbMessage(helptext, cmds, -1, nil, index)
      end
      def scene; self; end
      def method_missing(*_args); nil; end
      def respond_to_missing?(*_args); true; end
    end
  end

  #-----------------------------------------------------------------------------
  # Hooks
  #-----------------------------------------------------------------------------
  module Graphics
    class << self
      alias_method :__tw_dualscreen_update, :update unless method_defined?(:__tw_dualscreen_update)
      def update(*args)
        ret = __tw_dualscreen_update(*args)
        AndroidDualScreen.on_graphics_update
        ret
      end
    end
  end

  module AndroidDualScreenInput
    def update(*args)
      ret = super
      AndroidDualScreen.on_input_update
      ret
    end

    # A forced button counts as pressed for the frame it is forced in
    def trigger?(button)
      return true if AndroidDualScreen.forced[button]
      super
    end
  end
  Input.singleton_class.prepend(AndroidDualScreenInput)

  class Scene_Map
    alias_method :__tw_dualscreen_map_update, :update unless method_defined?(:__tw_dualscreen_map_update)
    def update(*args)
      __tw_dualscreen_map_update(*args)
      AndroidDualScreen.run_map_commands if $scene == self && AndroidDualScreen.active?
    end
  end

  module AndroidDualScreenBattle
    def pbStartBattle(battle)
      AndroidDualScreen.battle_scene = self
      super
    end

    def pbEndBattle(*args)
      ret = super
      AndroidDualScreen.battle_scene = nil
      AndroidDualScreen.battle_menu = nil
      ret
    end

    def pbCommandMenuEx(idxBattler, texts, mode = 0)
      AndroidDualScreen.battle_menu = { kind: :command, battler: idxBattler, texts: texts.map { |t| t.to_s.gsub("\n", " ") }, mode: mode }
      super
    ensure
      AndroidDualScreen.battle_menu = nil
    end

    def pbFightMenu(idxBattler, *args, &block)
      special = args.first ? true : false
      begin
        special ||= (@battle.pbCanMegaEvolve?(idxBattler) rescue false)
      rescue StandardError
      end
      AndroidDualScreen.battle_menu = { kind: :fight, battler: idxBattler, special: special }
      super
    ensure
      AndroidDualScreen.battle_menu = nil
    end
  end
  Battle::Scene.prepend(AndroidDualScreenBattle)

  module AndroidDualScreenEntry
    def pbStartScene(*args)
      AndroidDualScreen.entry_scene = self
      super
    end

    def pbUpdate(*args)
      ret = super
      AndroidDualScreen.apply_text_ops(self)
      ret
    end

    def pbEndScene(*args)
      AndroidDualScreen.entry_scene = nil
      super
    end
  end
  PokemonEntryScene2.prepend(AndroidDualScreenEntry)

  # Text history: record each message as it is shown
  alias __tw_dualscreen_message_display pbMessageDisplay
  def pbMessageDisplay(msgwindow, message, *args, &block)
    (AndroidDualScreen.log_message(message) rescue nil)
    __tw_dualscreen_message_display(msgwindow, message, *args, &block)
  end
end
