class Battle::Move
  #=============================================================================
  # Messages upon being hit
  #=============================================================================
  def pbEffectivenessMessage(user, target, numTargets = 1)
    return if target.damageState.disguise || target.damageState.iceFace || target.damageState.teleFace
    if Effectiveness.hyper_effective?(target.damageState.typeMod)
      if numTargets > 1
        @battle.pbDisplay(_INTL("It's hyper effective on {1}!", target.pbThis(true)))
      else
        @battle.pbDisplay(_INTL("It's hyper effective!"))
      end
    elsif Effectiveness.pretty_effective?(target.damageState.typeMod)
      if numTargets > 1
        @battle.pbDisplay(_INTL("It's super effective on {1}!", target.pbThis(true)))
      else
        @battle.pbDisplay(_INTL("It's super effective!"))
      end
    elsif Effectiveness.not_so_effective?(target.damageState.typeMod)
      if numTargets > 1
        @battle.pbDisplay(_INTL("It's not very effective on {1}...", target.pbThis(true)))
      else
        @battle.pbDisplay(_INTL("It's not very effective..."))
      end
    elsif Effectiveness.barely_effective?(target.damageState.typeMod)
      if numTargets > 1
        @battle.pbDisplay(_INTL("It's barely effective on {1}...", target.pbThis(true)))
      else
        @battle.pbDisplay(_INTL("It's barely effective..."))
      end
    end
  end
end



module Effectiveness
  INEFFECTIVE            = 0
  NOT_VERY_EFFECTIVE_ONE = 1
  NORMAL_EFFECTIVE_ONE   = 2
  SUPER_EFFECTIVE_ONE    = 4
  NORMAL_EFFECTIVE       = NORMAL_EFFECTIVE_ONE**3

  module_function

  def immune?(value)
    return value == 0
  end

  def barely_effective?(value)
    return value == 2
  end

  def not_so_effective?(value)
    return value == 4
  end

  def neutral?(value)
    return value == 8
  end

  def pretty_effective?(value)
    return value == 16
  end
  
  def hyper_effective?(value)
    return value == 32
  end
end
