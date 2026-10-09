if defined?(PluginManager) && !PluginManager.installed?("Encounter Messages")
  PluginManager.register({
    :name    => "Encounter Messages",
    :version => "7.0.0",
    :link    => "https://eeveeexpo.com/resources/1901",
    :credits => "RegalSword"
  })
end

#===============================================================================
# PokemonSystem extensions (adds Wild Battle Messages)
#===============================================================================
class PokemonSystem
  # Use 0 for ON, 1 for OFF
  attr_accessor :showWildMessages

  # Set default value for new option when a new PokemonSystem object is created
  alias _wildmsg_initialize initialize
  def initialize(*args)
    _wildmsg_initialize(*args)   # call the original initialize
    @showWildMessages = 0         # default to ON
  end
end

MenuHandlers.add(:options_menu, :wild_battle_messages, {
  "name"        => _INTL("Encounter Msg"),
  "order"       => 50,
  "type"        => EnumOption,
  "parameters"  => [_INTL("On"), _INTL("Off")],
  "description" => _INTL("Choose whether to see the 'A wild ... appeared!' messages in overworld encounters."),
  "get_proc"    => proc { next $PokemonSystem.showWildMessages }, # returns 0 or 1
  "set_proc"    => proc { |value, _scene|
    if $PokemonSystem
      $PokemonSystem.showWildMessages = value
    end
  }
})

# Always defined, independent of setting
def pbAttemptOverworldEscape(wild_pkmn)
  player_pkmn = $player.first_pokemon
  return true if !player_pkmn
  return true if $bag.has?(:OPENDEMONEYE)

  player_speed = player_pkmn.speed
  enemy_speed  = wild_pkmn.speed

  # puts "[WildBattle] Escape check: player speed #{player_speed}, enemy speed #{enemy_speed}"
  return true if player_speed > enemy_speed

  chance = (player_speed * 128 / enemy_speed) + 30
  chance &= 0xFF

  result = rand(256) < chance
  # puts "[WildBattle] Escape chance: #{chance}, Roll result: #{result}"
  result
end

class WildBattle
  class << self
    alias _run_prompt_start start
  end

  LAND_CAVE_WATER_TYPES = [
    :Land, :LandDay, :LandNight, :LandMorning, :LandAfternoon, :LandEvening,
    :Cave, :CaveDay, :CaveNight, :CaveMorning, :CaveAfternoon, :CaveEvening,
    :Water, :WaterDay, :WaterNight, :WaterMorning, :WaterAfternoon, :WaterEvening,
    :Beach, :BeachDay, :BeachNight, :BeachMorning, :BeachAfternoon, :BeachEvening,
    :Desert, :DesertDay, :DesertNight, :DesertMorning, :DesertAfternoon, :DesertEvening,
    :Surf
  ]

  def self.show_overworld_prompt?
    setting = $PokemonSystem&.showWildMessages
    # puts "[WildBattle] Wild Battle Messages setting currently #{setting == 0 ? 'ON' : 'OFF'}"
    return false unless setting == 0   # only show prompt if 0 = ON
    encounter_type = $game_temp.encounter_type
    encounter_type && LAND_CAVE_WATER_TYPES.include?(encounter_type)
  end

  def self.start(*args, can_override: false)
    foe_party = WildBattle.generate_foes(*args)
    wild_pkmn = foe_party[0]
    # puts "[WildBattle] Wild Battle Messages setting currently #{$PokemonSystem.showWildMessages == 0 ? 'ON' : 'OFF'}"
    # Only show Fight/Run prompt if enabled
    if show_overworld_prompt? && !Settings::LEGEND_LIST.include?(wild_pkmn.species)
      # Create sprite using actual Pokémon data
      sprite = pbDisplayPokemonSprite(
        wild_pkmn.species,
        wild_pkmn.form,
        wild_pkmn.gender,
        wild_pkmn.shiny?,
        wild_pkmn.respond_to?(:shadow?) && wild_pkmn.shadow? # crash
      )
      # Position it (adjust as needed)
      sprite.x = Graphics.width - 192
      sprite.y = Graphics.height - (192)*2
      choice = pbMessage(_INTL("A wild {1} appeared!", wild_pkmn.name), [_INTL("Fight"), _INTL("Run")], 2)
      if choice == 1 && wild_pkmn.shiny?
        if pbConfirmMessageSerious(_INTL("Are you sure you want to run away?"))
          if pbAttemptOverworldEscape(wild_pkmn)
            msg = ($bag.has?(:OPENDEMONEYE)) ? "The Demonic Eye let you run away!" : "Got away safely!"
            pbMessage(_INTL(msg))
            pbDisposeWildPokemonSprite
            $game_temp.encounter_type = nil
            return true
          else
            pbMessage(_INTL("Can't escape!"))
            pbDisposeWildPokemonSprite # attempt to fix sprite lingering after exiting battle
          end
        end
      elsif choice == 1 && !wild_pkmn.shiny?
        if pbAttemptOverworldEscape(wild_pkmn)
          msg = ($bag.has?(:OPENDEMONEYE)) ? "The Demonic Eye let you run away!" : "Got away safely!"
          pbMessage(_INTL(msg))
          pbDisposeWildPokemonSprite
          $game_temp.encounter_type = nil
          return true
        else
          pbMessage(_INTL("Can't escape!"))
          pbDisposeWildPokemonSprite # attempt to fix sprite lingering after exiting battle
        end
      end
    end
    # Normal battle flow always runs, whether setting is ON or OFF
    if foe_party.length == 1 && can_override
      handled = [nil]
      EventHandlers.trigger(:on_calling_wild_battle, wild_pkmn.species, wild_pkmn.level, handled)
      return handled[0] if !handled[0].nil?
    end
    outcome = WildBattle.start_core(*foe_party)
    if foe_party.length == 1 && can_override
      EventHandlers.trigger(:on_wild_battle_end, wild_pkmn.species, wild_pkmn.level, outcome)
    end
    $game_temp.encounter_type = nil
    pbDisposeWildPokemonSprite
    outcome != 2 && outcome != 5
  end
end

# function to display a graphic from Graphics/Pokemon
# v2 uses set_event_follower_sprite as a reference, which in turn (probably) used Following Pokemon Ex as its reference.
def pbDisplayPokemonSprite(species, form = 0, gender = 0, shiny = false, shadow = false, viewport = nil, x = 0, y = 0)
  # Dispose previous sprite if it exists
  if $wild_sprite
    animated = $wild_sprite.instance_variable_get(:@animatedBitmap)
    animated.dispose if animated
    $wild_sprite.dispose
    $wild_sprite = nil
  end

  sprite = Sprite.new(viewport)

  animated = GameData::Species.front_sprite_bitmap(
    species, form, gender, shiny, shadow
  )

  sprite.bitmap = animated.bitmap
  sprite.instance_variable_set(:@animatedBitmap, animated)

  sprite.x = x
  sprite.y = y

  $wild_sprite = sprite
  return sprite
end

# erase method
def pbDisposeWildPokemonSprite
  return if !$wild_sprite

  # Dispose AnimatedBitmap safely
  animated = $wild_sprite.instance_variable_get(:@animatedBitmap)
  animated.dispose if animated

  # Dispose sprite
  $wild_sprite.dispose
  $wild_sprite = nil
end