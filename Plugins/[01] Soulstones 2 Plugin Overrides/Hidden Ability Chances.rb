############################################################
# This script is to adjust hidden ability chances
############################################################

module WildHiddenAbilityPercentage #Hi, I change Wild Encounter Abilities
  Chance = rand(20) < 6 # Changed by Jos so it's 30% chance
end

module GiftHiddenAbilityPercentage #Hi, I change Gift Abilities
  Chance = rand(20) < 6 # Changed by Jos so it's 30% chance
end