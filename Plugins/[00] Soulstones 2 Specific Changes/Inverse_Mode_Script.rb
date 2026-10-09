module Settings
  INVERSE_MODE_SWITCH = 499
end

module GameData
  class Type
    def effectiveness(other_type)
      return Effectiveness::NORMAL_EFFECTIVE_ONE if !other_type
      if $game_switches[Settings::INVERSE_MODE_SWITCH]
        return Effectiveness::SUPER_EFFECTIVE_ONE if @resistances.include?(other_type) || @immunities.include?(other_type)
        return Effectiveness::NOT_VERY_EFFECTIVE_ONE if @weaknesses.include?(other_type)
      else
        return Effectiveness::SUPER_EFFECTIVE_ONE if @weaknesses.include?(other_type)
        return Effectiveness::NOT_VERY_EFFECTIVE_ONE if @resistances.include?(other_type)
        return Effectiveness::INEFFECTIVE if @immunities.include?(other_type)
      end
      return Effectiveness::NORMAL_EFFECTIVE_ONE
    end
  end
end
