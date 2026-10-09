class PokemonStorage
  def pbStoreCaught(pkmn)
    if Settings::HEAL_STORED_POKEMON && @currentBox >= 0
      old_ready_evo = pkmn.ready_to_evolve
      pkmn.heal
      pkmn.ready_to_evolve = old_ready_evo
    end
    maxPokemon(@currentBox).times do |i|
      if self[@currentBox, i].nil?
        self[@currentBox, i] = pkmn
        return @currentBox
      end
    end
    self.maxBoxes.times do |j|
      maxPokemon(j).times do |i|
        nextbox = j
        if $PokemonSystem.storage_memory != nil
          nextbox = (@currentBox+j < self.maxBoxes-1 && $PokemonSystem.storage_memory==1) ? @currentBox+j : (@currentBox+j)-@currentBox
        end
        next unless self[nextbox, i].nil?
        self[nextbox, i] = pkmn
        @currentBox = nextbox
        return @currentBox
      end
    end
    return -1
  end
end

class PokemonSystem
  # Use 0 for Off, 1 for On
  attr_accessor :storage_memory

  # Set default value for new option when a new PokemonSystem object is created
  alias _storage_initialize initialize
  def initialize(*args)
    _storage_initialize(*args)   # call the original initialize
    @storage_memory = 0         # default to Off
  end
end

MenuHandlers.add(:options_menu, :box_memory, {
  "name"        => _INTL("Storage Memory"),
  "order"       => 50,
  "type"        => EnumOption,
  "parameters"  => [_INTL("Off"), _INTL("On")],
  "description" => _INTL("Toggles if caught Pokemon get stored in the first able box or the next box."),
  "get_proc"    => proc { next $PokemonSystem.storage_memory }, # returns 0 or 1
  "set_proc"    => proc { |value, _scene|
    if $PokemonSystem
      $PokemonSystem.storage_memory = value
    end
  }
})
