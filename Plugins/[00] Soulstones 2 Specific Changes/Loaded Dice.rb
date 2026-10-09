# Update for Loaded Dice
#===============================================================================
# Triple Kick
#===============================================================================
class Battle::Move::HitThreeTimesPowersUpWithEachHit < Battle::Move
  def pbOnStartUse(user, targets)
    @calcBaseDmg = 0
    @accCheckPerHit = !user.hasActiveAbility?(:SKILLLINK) && !user.hasActiveItem?(:LOADEDDICE)
  end
end
#===============================================================================
# Hits 2-5 times.
#===============================================================================
class Battle::Move::HitTwoToFiveTimes < Battle::Move
  def pbNumHits(user, targets)
    hitChances = [
      2, 2, 2, 2, 2, 2, 2,
      3, 3, 3, 3, 3, 3, 3,
      4, 4, 4,
      5, 5, 5
    ]
    r = @battle.pbRandom(hitChances.length)
    r = hitChances.length - 1 if user.hasActiveAbility?(:SKILLLINK)
    chances = hitChances[r]
    chances = 5 - rand(2) if user.hasActiveItem?(:LOADEDDICE)
    return chances
  end
end
#===============================================================================
# Hits 2-5 times in a row. If the move does not fail, increases the user's Speed
# by 1 stage and decreases the user's Defense by 1 stage. (Scale Shot)
#===============================================================================
class Battle::Move::HitTwoToFiveTimesRaiseUserSpd1LowerUserDef1 < Battle::Move
  def pbNumHits(user, targets)
    hitChances = [
      2, 2, 2, 2, 2, 2, 2,
      3, 3, 3, 3, 3, 3, 3,
      4, 4, 4,
      5, 5, 5
    ]
    r = @battle.pbRandom(hitChances.length)
    r = hitChances.length - 1 if user.hasActiveAbility?(:SKILLLINK)
    chances = hitChances[r]
    chances = 5 - rand(2) if user.hasActiveItem?(:LOADEDDICE)
    return chances
  end
end