class PokemonGlobalMetadata
  attr_accessor :liveSupportHp
  attr_accessor :liveSupportPp
  attr_accessor :liveSupportStatus

  alias live_support_initialize initialize
  def initialize
    live_support_initialize
    @liveSupportHp=0
    @liveSupportPp=0
    @liveSupportStatus=0
  end
end    



ItemHandlers::UseInField.add(:LIVESUPPORTON, proc { |item|
  $bag.replace_item(:LIVESUPPORTON, :LIVESUPPORTOFF)
  pbMessage(_INTL("Live Support has been turned off."))
  next true
})

ItemHandlers::UseInField.add(:LIVESUPPORTOFF, proc { |item|
  $bag.replace_item(:LIVESUPPORTOFF, :LIVESUPPORTON)
  pbMessage(_INTL("Live Support has been turned on."))
  next true
})

EventHandlers.add(:on_player_step_taken, :live_support_hp,
  proc {
    next if !$bag.has?(:LIVESUPPORTON)
    $PokemonGlobal.liveSupportHp = 0 if !$PokemonGlobal.liveSupportHp
    $PokemonGlobal.liveSupportHp += 1 + ($game_variables[221] * 2) # Changed by DemICE 30-Nov-2024 Live Support upgrade
    next if $PokemonGlobal.liveSupportHp < 5
    $player.party.each do |pkmn|
      pkmn.hp += 1
      pkmn.hp += pkmn.totalhp/100 * $game_variables[221] # Changed by DemICE 30-Nov-2024 Live Support upgrade
    end
    $PokemonGlobal.liveSupportHp = 0
  }
)

# Changed by Jos 2023-05-29 to disable PP recovery on live support because it invalidated PP recovery items
# Changed by DemICE 30-Nov-2024 reenabled as an AP upgrade.
# Updated by PDM20 04-Dec-2024 to fix wrong unlock bug
EventHandlers.add(:on_player_step_taken, :live_support_pp,
  proc {
    next if $game_variables[221] != 2
    next if !$bag.has?(:LIVESUPPORTON)
    $PokemonGlobal.liveSupportPp = 0 if !$PokemonGlobal.liveSupportPp
    $PokemonGlobal.liveSupportPp += 1
    next if $PokemonGlobal.liveSupportPp < 25
    $player.party.each do |pkmn|
      pkmn.moves.each do |move|
        move.pp+=1
      end
    end
    $PokemonGlobal.liveSupportPp = 0
  }
)

EventHandlers.add(:on_player_step_taken, :live_support_status,
  proc {
    next if !$bag.has?(:LIVESUPPORTON)
    $PokemonGlobal.liveSupportStatus = 0 if !$PokemonGlobal.liveSupportStatus
    $PokemonGlobal.liveSupportStatus += 1 + $game_variables[221] # Changed by DemICE 30-Nov-2024 Live Support upgrade
    next if $PokemonGlobal.liveSupportStatus < 100
    $player.party.each do |pkmn|
      pkmn.status=:NONE
    end
    $PokemonGlobal.liveSupportStatus = 0
  }
)