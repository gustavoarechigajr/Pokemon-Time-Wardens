# THIS ENTIRE SCRIPT HAS BEEN SUPERCEDED BY THE ONE IN THE PLUGIN OVERRIDES FOLDER #

=begin
#===============================================================================
# Essentials Deluxe module.
#===============================================================================
# Set up mid-battle triggers that may be called in a deluxe battle event.
# Add your custom midbattle hash here and you will be able to call upon it with
# the defined symbol, rather than writing out the entire thing in an event.
#-------------------------------------------------------------------------------


module EssentialsDeluxe
################################################################################
# Demo of all possible midbattle triggers.
################################################################################
  #-----------------------------------------------------------------------------
  # Displays speech indicating when each trigger is activated.
  #-----------------------------------------------------------------------------
  DEMO_SPEECH = {
    #---------------------------------------------------------------------------
    # Turn Phase Triggers
    #---------------------------------------------------------------------------
    "turnCommand"             => "Trigger: 'turnCommand'\nCommand Phase start.",
    "turnAttack"              => "Trigger: 'turnAttack'\nAttack Phase start.",
    "turnEnd"                 => "Trigger: 'turnEnd'\nEnd of Round Phase end.",
    #---------------------------------------------------------------------------
    # Move Usage Triggers
    #---------------------------------------------------------------------------
    "move"                    => "Trigger: 'move'\n{1} successfully uses a move.",
    "move_foe"                => "Trigger: 'move_foe'\n{1} successfully uses a move.",
    "move_ally"               => "Trigger: 'move_ally'\n{1} successfully uses a move.",
    "moveDamaging"            => "Trigger: 'moveDamaging'\n{1} successfully uses a damage-dealing move.",
    "moveDamaging_foe"        => "Trigger: 'moveDamaging_foe'\n{1} successfully uses a damage-dealing move.",
    "moveDamaging_ally"       => "Trigger: 'moveDamaging_ally'\n{1} successfully uses a damage-dealing move.",
    "movePhysical"            => "Trigger: 'movePhysical'\n{1} successfully uses a physical move.",
    "movePhysical_foe"        => "Trigger: 'movePhysical_foe'\n{1} successfully uses a physical move.",
    "movePhysical_ally"       => "Trigger: 'movePhysical_ally'\n{1} successfully uses a physical move.",
    "moveSpecial"             => "Trigger: 'moveSpecial'\n{1} successfully uses a special move.",
    "moveSpecial_foe"         => "Trigger: 'moveSpecial_foe'\n{1} successfully uses a special move.",
    "moveSpecial_ally"        => "Trigger: 'moveSpecial_ally'\n{1} successfully uses a special move.",
    "moveStatus"              => "Trigger: 'moveStatus'\n{1} successfully uses a status move.",
    "moveStatus_foe"          => "Trigger: 'moveStatus_foe'\n{1} successfully uses a status move.",
    "moveStatus_ally"         => "Trigger: 'moveStatus_ally'\n{1} successfully uses a status move.",
    #---------------------------------------------------------------------------
    # Attacker Triggers
    #---------------------------------------------------------------------------
    "attackerDamaged"         => "Trigger: 'attackerDamaged'\n{1} dealt damage with an attack.",
    "attackerDamaged_foe"     => "Trigger: 'attackerDamaged_foe'\n{1} dealt damage with an attack.",
    "attackerDamaged_ally"    => "Trigger: 'attackerDamaged_ally'\n{1} dealt damage with an attack.",
    "attackerSubDamaged"      => "Trigger: 'attackerSubDamaged'\n{1} dealt damage to a Substitute.",
    "attackerSubDamaged_foe"  => "Trigger: 'attackerSubDamaged_foe'\n{1} dealt damage to a Substitute.",
    "attackerSubDamaged_ally" => "Trigger: 'attackerSubDamaged_ally'\n{1} dealt damage to a Substitute.",
    "attackerSubBroken"       => "Trigger: 'attackerSubBroken'\n{1} dealt enough damage to break a Substitute.",
    "attackerSubBroken_foe"   => "Trigger: 'attackerSubBroken_foe'\n{1} dealt enough damage to break a Substitute.",
    "attackerSubBroken_ally"  => "Trigger: 'attackerSubBroken_ally'\n{1} dealt enough damage to break a Substitute.",
    "attackerSEdmg"           => "Trigger: 'attackerSEdmg'\n{1}'s attack was super effective.",
    "attackerSEdmg_foe"       => "Trigger: 'attackerSEdmg_foe'\n{1}'s attack was super effective.",
    "attackerSEdmg_ally"      => "Trigger: 'attackerSEdmg_ally'\n{1}'s attack was super effective.",
    "attackerNVEdmg"      	  => "Trigger: 'attackerNVEdmg'\n{1}'s attack was not very effective.",
    "attackerNVEdmg_foe"  	  => "Trigger: 'attackerNVEdmg_foe'\n{1}'s attack was not very effective.",
    "attackerNVEdmg_ally"  	  => "Trigger: 'attackerNVEdmg_ally'\n{1}'s attack was not very effective.",
    "attackerNegated"         => "Trigger: 'attackerNegated'\n{1}'s attack was negated or has no effect.",
    "attackerNegated_foe"     => "Trigger: 'attackerNegated_foe'\n{1}'s attack was negated or has no effect.",
    "attackerNegated_ally"    => "Trigger: 'attackerNegated_ally'\n{1}'s attack was negated or has no effect.",
    "attackerDodged"          => "Trigger: 'attackerDodged'\n{1}'s attack missed.",
    "attackerDodged_foe"      => "Trigger: 'attackerDodged_foe'\n{1}'s attack missed.",
    "attackerDodged_ally"     => "Trigger: 'attackerDodged_ally'\n{1}'s attack missed.",
    "attackerCrit"            => "Trigger: 'attackerCrit'\n{1}'s attack dealt a critical hit.",
    "attackerCrit_foe"        => "Trigger: 'attackerCrit_foe'\n{1}'s attack dealt a critical hit.",
    "attackerCrit_ally"       => "Trigger: 'attackerCrit_ally'\n{1}'s attack dealt a critical hit.",
    "attackerHPHalf"          => "Trigger: 'attackerHPHalf'\n{1}'s HP was 50% or lower after dealing damage.",
    "attackerHPHalf_foe"      => "Trigger: 'attackerHPHalf_foe'\n{1}'s HP was 50% or lower after dealing damage.",
    "attackerHPHalf_ally"     => "Trigger: 'attackerHPHalf_ally'\n{1}'s HP was 50% or lower after dealing damage.",
    "attackerHPHalfLast"      => "Trigger: 'attackerHPHalfLast'\nOnly {1} is left in the party, and its HP was 50% or lower after dealing damage.",
    "attackerHPHalfLast_foe"  => "Trigger: 'attackerHPHalfLast_foe'\nOnly {1} is left in the party, and its HP was 50% or lower after dealing damage.",
    "attackerHPHalfLast_ally" => "Trigger: 'attackerHPHalfLast_ally'\nOnly {1} is left in the party, and its HP was 50% or lower after dealing damage.",
    "attackerHPLow"           => "Trigger: 'attackerHPLow'\n{1}'s HP was 25% or lower after dealing damage.",
    "attackerHPLow_foe"       => "Trigger: 'attackerHPLow_foe'\n{1}'s HP was 25% or lower after dealing damage.",
    "attackerHPLow_ally"      => "Trigger: 'attackerHPLow_ally'\n{1}'s HP was 25% or lower after dealing damage.",
    "attackerHPLowLast"       => "Trigger: 'attackerHPLowLast'\nOnly {1} is left in the party, and its HP was 25% or lower after dealing damage.",
    "attackerHPLowLast_foe"   => "Trigger: 'attackerHPLowLast_foe'\nOnly {1} is left in the party, and its HP was 25% or lower after dealing damage.",
    "attackerHPLowLast_ally"  => "Trigger: 'attackerHPLowLast_ally'\nOnly {1} is left in the party, and its HP was 25% or lower after dealing damage.",
    #---------------------------------------------------------------------------
    # Defender Triggers
    #---------------------------------------------------------------------------
    "defenderDamaged"         => "Trigger: 'defenderDamaged'\n{1} took damage from an attack.",
    "defenderDamaged_foe"     => "Trigger: 'defenderDamaged_foe'\n{1} took damage from an attack.",
    "defenderDamaged_ally"    => "Trigger: 'defenderDamaged_ally'\n{1} took damage from an attack.",
    "defenderSubDamaged"      => "Trigger: 'defenderSubDamaged'\n{1}'s Substitute took damage.",
    "defenderSubDamaged_foe"  => "Trigger: 'defenderSubDamaged_foe'\n{1}'s Substitute took damage.",
    "defenderSubDamaged_ally" => "Trigger: 'defenderSubDamaged_ally'\n{1}'s Substitute took damage.",
    "defenderSubBroken"       => "Trigger: 'defenderSubBroken'\n{1}'s Substitute was broken.",
    "defenderSubBroken_foe"   => "Trigger: 'defenderSubBroken_foe'\n{1}'s Substitute was broken.",
    "defenderSubBroken_ally"  => "Trigger: 'defenderSubBroken_ally'\n{1}'s Substitute was broken.",
    "defenderSEdmg"           => "Trigger: 'defenderSEdmg'\n{1} took super effective damage.",
    "defenderSEdmg_foe"       => "Trigger: 'defenderSEdmg_foe'\n{1} took super effective damage.",
    "defenderSEdmg_ally"      => "Trigger: 'defenderSEdmg_ally'\n{1} took super effective damage.",
    "defenderNVEdmg"      	  => "Trigger: 'defenderNVEdmg'\n{1} took not very effective damage.",
    "defenderNVEdmg_foe"  	  => "Trigger: 'defenderNVEdmg_foe'\n{1} took not very effective damage.",
    "defenderNVEdmg_ally" 	  => "Trigger: 'defenderNVEdmg_ally'\n{1} took not very effective damage.",
    "defenderNegated"         => "Trigger: 'defenderNegated'\n{1} negated damage/effects from an attack due to an effect or immunity.",
    "defenderNegated_foe"     => "Trigger: 'defenderNegated_foe'\n{1} negated damage/effects from an attack due to an effect or immunity.",
    "defenderNegated_ally"    => "Trigger: 'defenderNegated_ally'\n{1} negated damage/effects from an attack due to an effect or immunity.",
    "defenderDodged"          => "Trigger: 'defenderDodged'\n{1} dodged an attack.",
    "defenderDodged_foe"      => "Trigger: 'defenderDodged_foe'\n{1} dodged an attack.",
    "defenderDodged_ally"     => "Trigger: 'defenderDodged_ally'\n{1} dodged an attack.",
    "defenderCrit"            => "Trigger: 'defenderCrit'\n{1} took a critical hit.",
    "defenderCrit_foe"        => "Trigger: 'defenderCrit_foe'\n{1} took a critical hit.",
    "defenderCrit_ally"       => "Trigger: 'defenderCrit_ally'\n{1} took a critical hit.",
    "defenderHPHalf"          => "Trigger: 'defenderHPHalf'\n{1}'s HP fell to 50% or lower after taking damage.",
    "defenderHPHalf_foe"      => "Trigger: 'defenderHPHalf_foe'\n{1}'s HP fell to 50% or lower after taking damage.",
    "defenderHPHalf_ally"     => "Trigger: 'defenderHPHalf_ally'\n{1}'s HP fell to 50% or lower after taking damage.",
    "defenderHPHalfLast"      => "Trigger: 'defenderHPHalfLast'\nOnly {1} is left in the party, and its HP fell to 50% or lower after taking damage.",
    "defenderHPHalfLast_foe"  => "Trigger: 'defenderHPHalfLast_foe'\nOnly {1} is left in the party, and its HP fell to 50% or lower after taking damage.",
    "defenderHPHalfLast_ally" => "Trigger: 'defenderHPHalfLast_ally'\nOnly {1} is left in the party, and its HP fell to 50% or lower after taking damage.",
    "defenderHPLow"           => "Trigger: 'defenderHPLow'\n{1}'s HP fell to 25% or lower after taking damage.",
    "defenderHPLow_foe"       => "Trigger: 'defenderHPLow_foe'\n{1}'s HP fell to 25% or lower after taking damage.",
    "defenderHPLow_ally"      => "Trigger: 'defenderHPLow_ally'\n{1}'s HP fell to 25% or lower after taking damage.",
    "defenderHPLowLast"       => "Trigger: 'defenderHPLowLast'\nOnly {1} is left in the party, and its HP fell to 25% or lower after taking damage.",
    "defenderHPLowLast_foe"   => "Trigger: 'defenderHPLowLast_foe'\nOnly {1} is left in the party, and its HP fell to 25% or lower after taking damage.",
    "defenderHPLowLast_ally"  => "Trigger: 'defenderHPLowLast_ally'\nOnly {1} is left in the party, and its HP fell to 25% or lower after taking damage.",
    #---------------------------------------------------------------------------
    # Switching Triggers
    #---------------------------------------------------------------------------
    "switchOut"               => "Trigger: 'switchOut'\nI intend to switch out an active Pokémon.",
    "switchOut_foe"           => "Trigger: 'switchOut_foe'\nI intend to switch out an active Pokémon.",
    "switchOut_ally"          => "Trigger: 'switchOut_ally'\nI intend to switch out an active Pokémon.",
    "switchIn"                => "Trigger: 'switchIn'\nI intend to switch in a Pokémon.",
    "switchIn_foe"            => "Trigger: 'switchIn_foe'\nI intend to switch in a Pokémon.",
    "switchIn_ally"           => "Trigger: 'switchIn_ally'\nI intend to switch in a Pokémon.",
    "switchInLast"            => "Trigger: 'switchInLast'\nI intend to switch in my final Pokémon.",
    "switchInLast_foe"        => "Trigger: 'switchInLast_foe'\nI intend to switch in my final Pokémon.",
    "switchInLast_ally"       => "Trigger: 'switchInLast_ally'\nI intend to switch in my final Pokémon.",
    "switchSentOut"           => "Trigger: 'switchSentOut'\nI successfully sent out a Pokémon.",
    "switchSentOut_foe"       => "Trigger: 'switchSentOut_foe'\nI successfully sent out a Pokémon.",
    "switchSentOut_ally"      => "Trigger: 'switchSentOut_ally'\nI successfully sent out a Pokémon.",
    "switchSentOutLast"       => "Trigger: 'switchSentOutLast'\nI successfully sent out my final Pokémon.",
    "switchSentOutLast_foe"   => "Trigger: 'switchSentOutLast_foe'\nI successfully sent out my final Pokémon.",
    "switchSentOutLast_ally"  => "Trigger: 'switchSentOutLast_ally'\nI successfully sent out my final Pokémon.",
    #---------------------------------------------------------------------------
    # Other Battler Triggers
    #---------------------------------------------------------------------------
    "fainted"                 => "Trigger: 'fainted'\n{1} fainted.",
    "fainted_foe"             => "Trigger: 'fainted_foe'\n{1} fainted.",
    "fainted_ally"            => "Trigger: 'fainted_ally'\n{1} fainted.",
    "faintedLast"             => "Trigger: 'faintedLast'\n{1} fainted and is my last available Pokémon.",
    "faintedLast_foe"         => "Trigger: 'faintedLast_foe'\n{1} fainted and is the last opposing Pokémon.",
    "faintedLast_ally"        => "Trigger: 'faintedLast_ally'\n{1} fainted and is my last available Pokémon.",
    "statusInflicted"         => "Trigger: 'statusInflicted'\n{1} was inflicted with a status condition.",
    "statusInflicted_foe"     => "Trigger: 'statusInflicted_foe'\n{1} was inflicted with a status condition.",
    "statusInflicted_ally"    => "Trigger: 'statusInflicted_ally'\n{1} was inflicted with a status condition.",
    "endEffect"               => "Trigger: 'endEffect'\nAn effect on {1} has ended.",
    "endEffect_foe"           => "Trigger: 'endEffect_foe'\nAn effect on {1} has ended.",
    "endEffect_ally"          => "Trigger: 'endEffect_ally'\nAn effect on {1} has ended.",
    "endTeamEffect"           => "Trigger: 'endTeamEffect'\nAn effect on {1}'s side of the field has ended.",
    "endTeamEffect_foe"       => "Trigger: 'endTeamEffect_foe'\nAn effect on {1}'s side of the field has ended.",
    "endTeamEffect_ally"      => "Trigger: 'endTeamEffect_ally'\nAn effect on {1}'s side of the field has ended.",
    #---------------------------------------------------------------------------
    # General Battle Triggers (cannot be used with _foe or _ally)
    #---------------------------------------------------------------------------
    "endWeather"              => "Trigger: 'endWeather'\nThe effects of a weather condition has ended.",
    "endTerrain"              => "Trigger: 'endTerrain'\nThe effects of a battle terrain has ended.",
    "endFieldEffect"          => "Trigger: 'endFieldEffect'\nA battlefield effect has ended.",
    "captureAttempt"          => "Trigger: 'captureAttempt'\nI intend to throw a selected Poké Ball.",
    "captureSuccess"          => "Trigger: 'captureSuccess'\nI successfully captured the targeted Pokémon.",
    "captureFailure"          => "Trigger: 'captureFailure'\nI failed to capture the targeted Pokémon.",
    "loss"                    => "Trigger: 'loss'\nThe battle ends in a loss for the player.",
    #---------------------------------------------------------------------------
    # Special Action Triggers
    #---------------------------------------------------------------------------
    "item"                    => "Trigger: 'item'\nI intend to use an item from my inventory.",
    "item_foe"                => "Trigger: 'item_foe'\nI intend to use an item from my inventory.",
    "item_ally"               => "Trigger: 'item_ally'\nI intend to use an item from my inventory.",
    "mega"                    => "Trigger: 'mega'\nI intend to initiate Mega Evolution.",
    "mega_foe"                => "Trigger: 'mega_foe'\nOpponent intends to initiate Mega Evolution.",
    "mega_ally"               => "Trigger: 'mega_ally'\nI intend to initiate Mega Evolution.",
    "primal"                  => "Trigger: 'primal'\nI intend to initiate Primal Reversion.",
    "primal_foe"              => "Trigger: 'primal_foe'\nOpponent intends to initiate Primal Reversion.",
    "primal_ally"             => "Trigger: 'primal_ally'\nI intend to initiate Primal Reversion.",
    #---------------------------------------------------------------------------
    # Plugin Triggers
    #---------------------------------------------------------------------------
    # Z-Move
    "zmove"                   => "Trigger: 'zmove'\nI intend to initiate a Z-Move.",
    "zmove_foe"               => "Trigger: 'zmove_foe'\nOpponent intends to initiate a Z-Move.",
    "zmove_ally"              => "Trigger: 'zmove_ally'\nI intend to initiate a Z-Move.",
    #---------------------------------------------------------------------------
    # Ultra Burst
    "ultra"                   => "Trigger: 'ultra'\nI intend to initiate Ultra Burst.",
    "ultra_foe"               => "Trigger: 'ultra_foe'\nOpponent intends to initiate Ultra Burst.",
    "ultra_ally"              => "Trigger: 'ultra_ally'\nI intend to initiate Ultra Burst.",
    #---------------------------------------------------------------------------
    # Dynamax
    "dynamax"                 => "Trigger: 'dynamax'\nI intend to initiate Dynamax.",
    "dynamax_foe"             => "Trigger: 'dynamax_foe'\nOpponent intends to initiate Dynamax.",
    "dynamax_ally"            => "Trigger: 'dynamax_ally'\nI intend to initiate Dynamax.",
    "gmax"                    => "Trigger: 'gmax'\nI intend to initiate Gigantamax.",
    "gmax_foe"                => "Trigger: 'gmax_foe'\nOpponent intends to initiate Gigantamax.",
    "gmax_ally"               => "Trigger: 'gmax_ally'\nI intend to initiate Gigantamax.",
    #---------------------------------------------------------------------------
    # Battle Styles
    "battleStyle"             => "Trigger: 'battleStyle'\nI intend to initiate a battle style.",
    "battleStyle_foe"         => "Trigger: 'battleStyle_foe'\nOpponent intends to initiate a battle style.",
    "battleStyle_ally"        => "Trigger: 'battleStyle_ally'\nI intend to initiate a battle style.",
    "strongStyle"             => "Trigger: 'strongStyle'\nI intend to initiate Strong Style.",
    "strongStyle_foe"         => "Trigger: 'strongStyle_foe'\nOpponent intends to initiate Strong Style.",
    "strongStyle_ally"        => "Trigger: 'strongStyle_ally'\nI intend to initiate Strong Style.",
    "agileStyle"              => "Trigger: 'agileStyle'\nI intend to initiate Agile Style.",
    "agileStyle_foe"          => "Trigger: 'agileStyle_foe'\nOpponent intends to initiate Agile Style.",
    "agileStyle_ally"         => "Trigger: 'agileStyle_ally'\nI intend to initiate Agile Style.",
    "styleEnd"                => "Trigger: 'styleEnd'\nMy style cooldown expired.",
    "styleEnd_foe"            => "Trigger: 'styleEnd_foe'\nOpponent style cooldown expired.",
    "styleEnd_ally"           => "Trigger: 'styleEnd_ally'\nMy style cooldown expired.",
    #---------------------------------------------------------------------------
    # Terastallization
    "tera"                    => "Trigger: 'tera'\nI intend to initiate Terastallization.",
    "tera_foe"                => "Trigger: 'tera_foe'\nOpponent intends to initiate Terastallization.",
    "tera_ally"               => "Trigger: 'tera_ally'\nI intend to initiate Terastallization.",
    "teraType"                => "Trigger: 'teraType'\nMy Pokémon successfully uses a Tera-boosted move.",
    "teraType_foe"            => "Trigger: 'teraType_foe'\nOpponent successfully uses a Tera-boosted move.",
    "teraType_ally"           => "Trigger: 'teraType_ally'\nMy Pokémon successfully uses a Tera-boosted move.",
    "zodiac"                  => "Trigger: 'zodiac'\nI intend to initiate a Zodiac Power.",
    "zodiac_foe"              => "Trigger: 'zodiac_foe'\nOpponent intends to initiate a Zodiac Power.",
    "zodiac_ally"             => "Trigger: 'zodiac_ally'\nI intend to initiate a Zodiac Power.",
    #---------------------------------------------------------------------------
    # Focus
    "focus"                   => "Trigger: 'focus'\nMy Pokémon intends to harness its focus.",
    "focus_foe"               => "Trigger: 'focus_foe'\nOpponent intends to harness its focus.",
    "focus_ally"              => "Trigger: 'focus_ally'\nMy Pokémon intends to harness its focus.",
    "focusBoss"               => "Trigger: 'focus_boss'\nPokémon harnesses its focus with the Enraged style.",
    "focusEnd"                => "Trigger: 'focusEnd'\nMy Pokemon's Focus was used.",
    "focusEnd_foe"            => "Trigger: 'focusEnd_foe'\nOpponent's Focus was used.",
    "focusEnd_ally"           => "Trigger: 'focusEnd_ally'\nMy Pokemon's Focus was used."
  }
  
  
################################################################################
# Example demo of a generic capture tutorial battle.
################################################################################

  #-----------------------------------------------------------------------------
  # Demo capture tutorial vs. wild Pokemon.
  #-----------------------------------------------------------------------------
  # Suggested Rules:
  #   :noexp      => true,
  #   :nodynamax  => true,
  #   :notera     => true,
  #   :autobattle => true,
  #   :setcapture => :Demo,
  #   :player     => ["Name", Integer]   (Set the name of the teacher of the tutorial, and outfit number for this back sprite)
  #   :party      => [:SPECIES, Integer] (Set the Species & level of the Pokemon the teacher of the tutorial will use (or a Pokemon object))
  #-----------------------------------------------------------------------------
  DEMO_CAPTURE_TUTORIAL = {
    #---------------------------------------------------------------------------
    # General speech events.
    #---------------------------------------------------------------------------
    "turnCommand"         => "Hey! A wild Pokémon!\nPay attention, now. I'll show you how to capture one of your own!",
    "moveDamaging"        => ["Weakening a Pokémon through battle makes them much easier to catch!",
                              "Be careful though - you don't want to knock them out completely!\nYou'll lose your chance if you do!",
                              "Let's try dealing some damage.\nGet 'em, {1}!"],
    "statusInflicted_foe" => [:Opposing, "It's always a good idea to inflict status conditions like Sleep or Paralysis!",
                              "This will really help improve your odds at capturing the Pokémon!"],
    #---------------------------------------------------------------------------
    # Turn 1 - The Pokemon on the player's side will use a status move on the
    #          opponent, if one is available.
    #---------------------------------------------------------------------------
    "turnAttack" => {
      :usemove => [:StatusFoe, 1]
    },
    #---------------------------------------------------------------------------
    # Continuous - Applies Endure effect to wild Pokemon whenever targeted by
    #              a damage-dealing move. Ensures it is not KO'd early.
    #---------------------------------------------------------------------------
    "moveDamaging_repeat" => {
      :battler => :Opposing,
      :effects => [ [PBEffects::Endure, true] ]
    },
    #---------------------------------------------------------------------------
    # Continuous - Checks if the wild Pokemon's HP is low. If so, initiates the
    #              capture sequence.
    #---------------------------------------------------------------------------
    "turnEnd_repeat" => {
      :delay   => ["defenderHPHalf_foe", "defenderHPLow_foe"],
      :useitem => :POKEBALL
    },
    #---------------------------------------------------------------------------
    # Capture speech events.
    #---------------------------------------------------------------------------
    "captureAttempt" => "The Pokémon is weak!\nNow's the time to throw a Poké Ball!",
    "captureSuccess" => "Alright, that's how it's done!",
    #---------------------------------------------------------------------------
    # Capture failed - The wild Pokemon flees if it wasn't captured.
    #---------------------------------------------------------------------------
    "captureFailure" => {
      :speech    => "Drat! I thought I had it...",
      :playSE    => "Battle flee",
      :text      => [:Opposing, "{1} fled!"],
      :endbattle => 3
    }
  }
  

################################################################################
# Demo scenario vs. Gym Leader Opal, as encountered in Pokemon Sword & Shield.
################################################################################

  #-----------------------------------------------------------------------------
  # Demo scenario vs. Gym Leader Opal's quiz battle.
  #-----------------------------------------------------------------------------
  DEMO_VS_OPAL = {
    #---------------------------------------------------------------------------
    # General speech events.
    #---------------------------------------------------------------------------
    "switchInLast_foe"   => "My morning tea is finally kicking in, and not a moment too soon!",
    "gmaxALCREMIE_foe"   => "Are you prepared? I'm going to have some fun with this.",
    "moveGMAXFINALE_foe" => "You lack pink!\nHere, let us give you some!",
    #---------------------------------------------------------------------------
    # Turn 1 - Asks a question at the end of turn 1. Choice 1 lowers the Speed
    #          stat of the player's Pokemon by 2 stages. Choice 2 increases the
    #          Speed stat of the player's Pokemon by 2 stages.
    #---------------------------------------------------------------------------
    "turnEnd_1" => {
      :setchoice => ["Q1", 2],
      :speech    => [:Opposing, "Question!", "You...\nDo you know my nickname?", {
                     "The magic-user" => "Bzzt! Too bad!",
                     "The wizard"     => "Ding ding ding! Congratulations, you're correct."}]
    },
    "choice_Q1_correct" => {
      :stats => [:SPEED, 2]
    },
    "choice_Q1_incorrect" => {
      :stats => [:SPEED, -2]
    },
    #---------------------------------------------------------------------------
    # Turn 3 - Asks a question at the end of turn 3. Choice 1 lowers the Defense
    #          and Sp.Def stats of the player's Pokemon by 2 stages. Choice 2 
    #          increases the Defense and Sp.Def stats of the player's Pokemon by
    #          2 stages.
    #---------------------------------------------------------------------------
    "turnEnd_3" => {
      :setchoice => ["Q2", 2],
      :speech    => [:Opposing, "Question!", "What is my favorite color?", {
                     "Pink"   => "That's what I like to see in other people, but it's not what I like for myself.",
                     "Purple" => "Yes, a nice, deep purple...\nTruly grand, don't you think?"}]
    },
    "choice_Q2_correct" => {
      :stats => [:DEFENSE, 2, :SPECIAL_DEFENSE, 2]
    },
    "choice_Q2_incorrect" => {
      :stats => [:DEFENSE, -2, :SPECIAL_DEFENSE, -2]
    },
    #---------------------------------------------------------------------------
    # Turn 5 - Asks a question at the end of turn 5. Choice 1 increases the
    #          Attack and Sp.Atk stats of the player's Pokemon by 2 stages. 
    #          Choice 2 lowers the Attack and Sp.Atk stats of the player's Pokemon 
    #          by 2 stages.
    #---------------------------------------------------------------------------
    "turnEnd_5" => {
      :setchoice => ["Q3", 1],
      :speech    => [:Opposing, "Question!", "All righty then... How old am I?", {
                     "16 years old" => "Hah!\nI like your answer!",
                     "88 years old" => "Well, you're not wrong. But you could've been a little more sensitive."}]
    },
    "choice_Q3_correct" => {
      :stats => [:ATTACK, 2, :SPECIAL_ATTACK, 2]
    },
    "choice_Q3_incorrect" => {
      :stats => [:ATTACK, -2, :SPECIAL_ATTACK, -2]
    }
  }
  

################################################################################
# Demo scenario vs. AI Sada, as encountered in Pokemon Scarlet.
################################################################################

  #-----------------------------------------------------------------------------
  # Phase 1 - Speech events.
  #-----------------------------------------------------------------------------
  DEMO_VS_SADA_PHASE_1 = {
    "turnCommand"         => [:Opposing, "I don't know who you think you are, but I'm not about to let anyone get in the way of my goals."],
    "attackerDamaged_foe" => "This is the power the ancient past holds.\nSplendid, isn't it?",
    "defenderSEdmg_foe"   => "Now, this is interesting... Child, do you actually understand ancient Pokémon's weaknesses?",
    "attackerSEdmg_foe"   => "Do you imagine you can best the wealth of data at my disposal with your human brain?",
    "defenderCrit_foe"    => "What?! Some sort of error has occurred here...\nRecalculating for critical damage...",
    "attackerCrit_foe"    => "Just as calculated: a critical hit to your Pokémon.\nIt's time you simply gave up, child.",
    "switchInLast_foe"    => "Everything is proceeding within my expectations. I'm afraid the probability of you winning is zero."
  }
  
  #-----------------------------------------------------------------------------
  # Phase 2 - Scripted Koraidon battle.
  #-----------------------------------------------------------------------------
  # Suggested Rules:
  #   :noexp    => true,
  #   :nomoney  => true,
  #   :notera   => true,
  #   :party    => [:KORAIDON, 68]
  #-----------------------------------------------------------------------------
  DEMO_VS_SADA_PHASE_2 = {
    #---------------------------------------------------------------------------
    # Continuous - Applies Endure effect to player's Pokemon when the opponent
    #              uses a damaging move. Ensures the player's Pokemon is not KO'd
    #              even if they fail to select Endure when necessary.
    #---------------------------------------------------------------------------
    "moveDamaging_foe_repeat" => {
      :battler => :Opposing,
      :effects => [ [PBEffects::Endure, true] ]
    },
    #---------------------------------------------------------------------------
    # Continuous - Forces opponent to Taunt every turn after Turn 6. Ensures
    #              the player must eventually defeat the opponent.
    #---------------------------------------------------------------------------
    "turnAttack_repeat" => {
      :delay   => "turnAttack_6",
      :battler => :Opposing,
      :usemove => :TAUNT
    },
    #---------------------------------------------------------------------------
    # Turn 1 - Battle intro; ensures opponent has correct moves. Opponent is
    #          forced to Taunt this turn. Speech event.
    #---------------------------------------------------------------------------
    "turnCommand" => {
      :moves       => [:ENDURE, :FLAMETHROWER, :COLLISIONCOURSE, :TERABLAST],
      :battler     => :Opposing,
      :moves_1     => [:TAUNT, :BULKUP, :FLAMETHROWER, :GIGAIMPACT],
      :blankspeech => [:Anim, :GROWL, :Speaker, {:name => "Koraidon", :skin => 2}, "Grah! Grrrrrraaagh!"]
    }, 
    "turnAttack_1" => {
      :battler => :Opposing,
      :usemove => :TAUNT
    },
    "turnEnd_1" => {
      :blankspeech => [:Speaker, {:name => "Nemona", :skin => 1}, "It changed into its battle form! Let's go, Koraidon - you got this!"]
    },
    #---------------------------------------------------------------------------
    # Turn 2 - Opponent is forced to Flamethrower. Player's side silently given
    #          Safeguard this turn to ensure burn cannot occur. Opponent speech.
    #---------------------------------------------------------------------------
    "turnAttack_2" => {
      :team      => [ [PBEffects::Safeguard, 2] ],
      :battler   => :Opposing,
      :speech    => "You will fall here, within this garden paradise - and achieve nothing in the end.",
      :usemove   => :FLAMETHROWER
    },
    "turnEnd_2" => {
      :team => [ [PBEffects::Safeguard, 0] ]
    },
    #---------------------------------------------------------------------------
    # Turn 3 - Opponent is forced to Bulk Up. Ensures Taunt effect is ended on
    #          Player's Pokemon to setup Endure next turn. Speech events.
    #---------------------------------------------------------------------------
    "turnAttack_3" => {
      :battler => :Opposing,
      :speech  => "You will not be allowed to destroy my paradise. Obstacles to my goals WILL be eliminated.",
      :usemove => :BULKUP
    },
    "turnEnd_3" => {
      :effects     => [ [PBEffects::Taunt, 0, "{1} shook off the taunt!"] ],
      :blankspeech => [:Speaker, {:name => "Penny", :skin => 1}, "Th-this looks like it could be bad! Uh...hang in there, \\PN!"]
    },
    #---------------------------------------------------------------------------
    # Turn 4 - Opponent is forced to Giga Impact. Opponent silently given No Guard
    #          ability this turn to ensure move lands. Player's Pokemon's Attack
    #          increased by 2 stages. Speech events.
    #---------------------------------------------------------------------------
    "turnAttack_4" => {
      :battler => :Opposing,
      :speech  => "The data says I am the superior. Fall, and become a foundation upon which my dream may be built.",
      :ability => :NOGUARD,
      :usemove => :GIGAIMPACT
    },
    "turnEnd_4" => {
      :blankspeech => [:Speaker, {:name => "Arven", :skin => 0}, "You took that hit like a champ! You can do this! I know you can!"],
      :stats       => [:ATTACK, 2],
      :battler     => :Opposing,
      :ability     => :Reset,
    },
    #---------------------------------------------------------------------------
    # Turn 5 - Toggles the availability of Terastallization, assuming its
    #          functionality has been turned off for this battle. Raises Player's
    #          Pokemon's stats by 1 stage if the opponent's HP is low. Speech event.
    #---------------------------------------------------------------------------
    "turnEnd_5" => {
      :blankspeech => [:Speaker, {:name => "Nemona", :skin => 1}, "Oh man, can we really not pull off a win here? This doesn't look good...",
                       :Speaker, {:name => "Penny",  :skin => 1}, "H-hey \\PN! Your Tera Orb is glowing!",
                       :Speaker, {:name => "Arven",  :skin => 0}, "\\PN! Koraidon! Terastallize and finish this off!"],
      :teracharge  => true,
      :lockspecial => :Terastallize,
      :delay       => ["defenderHPHalf", "defenderHPLow"],
      :stats       => [:ATTACK, 1, :DEFENSE, 1, :SPECIAL_ATTACK, 1, :SPECIAL_DEFENSE, 1, :SPEED, 1]
    },
    #---------------------------------------------------------------------------
    # Turn 6 - Raises Player's Pokemon's stats by 1 stage in case it wasn't
    #          triggered on the previous turn. Speech event.
    #---------------------------------------------------------------------------
    "turnEnd_6" => {
      :blankspeech => [:Speaker, {:name => "Penny", :skin => 1}, 
                       "Show'em you won't be pushed around! Time to Terastallize and get in some supereffective hits!"],
      :stats       => [:ATTACK, 1, :DEFENSE, 1, :SPECIAL_ATTACK, 1, :SPECIAL_DEFENSE, 1, :SPEED, 1]
    }
  }
  

################################################################################
# Custom demo scenario vs. wild Pokemon.
################################################################################

  #-----------------------------------------------------------------------------
  # Demo scenario vs. wild Rotom that shifts forms.
  #-----------------------------------------------------------------------------
  # Suggested Rules:
  #   :nocapture => true
  #-----------------------------------------------------------------------------
  DEMO_WILD_ROTOM = {
    #---------------------------------------------------------------------------
    # Turn 1 - Battle intro.
    #---------------------------------------------------------------------------
    "turnCommand" => {
      :text      => [:Opposing, "{1} emited a powerful magnetic pulse!"],
      :anim      => [:CHARGE, :Opposing],
      :playsound => "Anim/Paralyze3",
      :text_1    => "Your Poké Balls short-circuited!\nThey cannot be used this battle!"
    },
    #---------------------------------------------------------------------------
    # Continuous - After taking a supereffective hit, the wild Rotom changes to
    #              a random form and changes its item/ability. HP and status
    #              are also healed.
    #---------------------------------------------------------------------------
    "turnEnd_repeat" => {
      :delay   => "defenderSEdmg_foe",
      :battler => :Opposing,
      :anim    => [:NIGHTMARE, :Self],
      :form    => [:Random, "{1} possessed a new appliance!"],
      :hp      => 4,
      :status  => :NONE,
      :ability => [:MOTORDRIVE, true],
      :item    => [:CELLBATTERY, "{1} equipped a Cell Battery it found in the appliance!"]
    },
    #---------------------------------------------------------------------------
    # Continuous - After the wild Rotom's HP gets low, applies the Charge,
    #              Magnet Rise, and Electric Terrain effects whenever the wild
    #              Rotom takes damage from an attack.
    #---------------------------------------------------------------------------
    "defenderDamaged_foe_repeat" => {
      :delay   => ["defenderHPHalf_foe", "defenderHPLow_foe"],
      :effects => [
        [PBEffects::Charge,     5, "{1} began charging power!"],
        [PBEffects::MagnetRise, 5, "{1} levitated with electromagnetism!"],
      ],
      :terrain => :Electric
    },
    #---------------------------------------------------------------------------
    # Player's Pokemon becomes paralyzed after dealing supereffective damage. 
    #---------------------------------------------------------------------------
    "attackerSEdmg" => {
      :text    => [:Opposing, "{1} emited an electrical pulse out of desperation!"],
      :status  => [:PARALYSIS, true]
    }
  }
  

################################################################################
# Custom demo scenario vs. trainer.
################################################################################

  #-----------------------------------------------------------------------------
  # Demo scenario vs. Rocket Grunt in a collapsing cave.
  #-----------------------------------------------------------------------------
  # Suggested Rules
  #   :nomoney => true,
  #   :canlose => true,
  #-----------------------------------------------------------------------------
  DEMO_COLLAPSING_CAVE = {
    #---------------------------------------------------------------------------
    # Turn 1 - Battle intro.
    #---------------------------------------------------------------------------
    "turnCommand" => {
      :playSE  => "Mining collapse",
      :text    => "The cave ceiling begins to crumble down all around you!",
      :speech  => [:Opposing, "I am not letting you escape!", 
                   "I don't care if this whole cave collapses down on the both of us...haha!"],
      :text_1  => "Defeat your opponent before time runs out!"
    },
    #---------------------------------------------------------------------------
    # Turn 2 - Player's Pokemon takes damage and becomes confused.
    #---------------------------------------------------------------------------
    "turnEnd_2" => {
      :text    => "{1} was struck on the head by a falling rock!",
      :anim    => [:ROCKSMASH, :Self],
      :hp      => -4,
      :status  => :CONFUSION
    },
    #---------------------------------------------------------------------------
    # Turn 3 - Text event.
    #---------------------------------------------------------------------------
    "turnEnd_3" => {
      :text => ["You're running out of time!", 
                "You need to escape immediately!"]
    },
    #---------------------------------------------------------------------------
    # Turn 4 - Battle prematurely ends in a loss.
    #---------------------------------------------------------------------------
    "turnEnd_4" => {
      :text      => ["You failed to defeat your opponent in time!", 
                     "You were forced to flee the battle!"],
      :playsound => "Battle flee",
      :endbattle => 2
    },
    #---------------------------------------------------------------------------
    # Continuous - Text event at the end of each turn.
    #---------------------------------------------------------------------------
    "turnEnd_repeat" => {
      :playsound => "Mining collapse",
      :text      => "The cave continues to collapse all around you!"
    },
    #---------------------------------------------------------------------------
    # Opponent's final Pokemon is healed and increases its defenses when HP is low.
    #---------------------------------------------------------------------------
    "defenderHPLowLast_foe" => {
      :speech  => "My {1} will never give up!",
      :anim    => [:BULKUP, :Self],
      :playcry => true,
      :hp      => [2, "{1} is standing its ground!"],
      :stats   => [:DEFENSE, 2, :SPECIAL_DEFENSE, 2]
    },
    #---------------------------------------------------------------------------
    # Speech event upon losing the battle.
    #---------------------------------------------------------------------------
    "loss" => "Haha...you'll never make it out alive!"
  }
  
  
################################################################################
# Custom demo scenario vs. Quiz Show Host.
################################################################################  
  
  #-----------------------------------------------------------------------------
  # Demo scenario vs. Battle Quizmaster.
  #-----------------------------------------------------------------------------
  # Suggested Rules
  #   :canlose => true,
  #   :noexp => true,
  #   :nomoney => true
  #-----------------------------------------------------------------------------
  DEMO_BATTLE_QUIZMASTER = {
    #---------------------------------------------------------------------------
    # Intro speech event.
    #---------------------------------------------------------------------------
    "turnCommand" => [:Opposing, "Welcome to another episode of Pokémon Battle Quiz!", 
                      "The show where trainers must battle with both Pokémon and trivia at the same time!",
                      "You gain one point each time you answer a question correctly, and a bonus point if you knock out a Pokémon!",
                      "If you can reach six points within six turns, you win a prize!",
                      "Is our new challenger up to the task? Let's hear some noise for \\PN!",
                      :SE, "Anim/Applause", 
                      "Now, \\PN!\nLet us begin!"],
    #---------------------------------------------------------------------------
    # Speech events.
    #---------------------------------------------------------------------------
    "loss"       => "Nice try, kid. On to the next challenger!",
    "variable_1" => [1, :SE, "Pkmn move learnt", "You've earned yourself your first point!", "Keep your eye on the prize!"],
    "variable_2" => [1, :SE, "Pkmn move learnt", "Two points - hey, not bad!", "Can our new challenger keep it going?"],
    "variable_3" => [1, :SE, "Pkmn move learnt", "You've claimed your third point!\nYou're on fire! Keep it up, kid!"],
    "variable_4" => [1, :SE, "Pkmn move learnt", "Four points on the board!\nDo you think you got what it takes to win?"],
    "variable_5" => [1, :SE, "Pkmn move learnt", "Just one more point to go!\nCan our up-and-coming star clear a perfect game?"],
    #---------------------------------------------------------------------------
    # Automatically ends the battle as a win if enough points have been earned.
    #---------------------------------------------------------------------------
    "variable_over_5" => {
      :speech => [1, :SE, "Pkmn move learnt", 
                  "Aaaand there we have it, folks! Point number six!",
                  "Do you know what that means? It looks like we've got a winner!",	  
                  "Let's hear it for our brand new Battle Quiz-wiz - \\PN!",
                  :SE, "Anim/Applause"],
      :text      => "You gracefully bow at the audience to a burst of applause!",
      :endbattle => 1
    },
    #---------------------------------------------------------------------------
    # Continuous - Adds a bonus point whenever the opponent's Pokemon is KO'd.
    #---------------------------------------------------------------------------
    "fainted_foe_repeat" => {
      :setvar => 1
    },
    #---------------------------------------------------------------------------
    # Continuous - Opponent's final Pokemon always Endures damaging moves.
    #---------------------------------------------------------------------------
    "moveDamaging_repeat" => {
      :delay   => "switchSentOutLast_foe",
      :battler => 1,
      :effects => [ [PBEffects::Endure, true] ]
    },
    #---------------------------------------------------------------------------
    # Turn 1 - Multiple choice question. Correct choice boosts the player
    #          Pokemon's Accuracy by 1 stage. Incorrect choices lowers the
    #          player Pokemon's Accuracy by 2 stages and traps them.
    #---------------------------------------------------------------------------
    "turnEnd_1" => {
      :setchoice => ["region", 3],
      :speech    => [:Opposing, :SE, "Voltorb Flip gain coins", 
                     "Time for our first question!",
                     "In which region do new trainers typically have the option to select Charmander as thier first Pokémon?",
                     {"Kalos" => "Ouch, that's a miss, my friend!", 
                      "Johto" => "Close! Well, at least geographically speaking...", 
                      "Kanto" => "Ah, good ol' Kanto!\nWhat a classic! Correct!", 
                      "Galar" => "Unless you're Champion Leon, that's incorrect!\nI'm afraid you're NOT having a champion time!"}]
    },
    "choice_region_correct" => {
      :setvar => 1,
      :playSE => "Anim/Applause",
      :text   => "The crowd politely applauded for you!",
      :stats  => [:ACCURACY, 1]
    },
    "choice_region_incorrect" => {
      :stats   => [:ACCURACY, -2],
      :effects => [ [PBEffects::NoRetreat, true, "{1} became nervous!\nIt may no longer escape!"] ]
    },
    #---------------------------------------------------------------------------
    # Turn 2 - Multiple choice question. Correct choice applies Lucky Chant
    #          effect to the player's side. Incorrect choice replaces the moves
    #          of the player's Pokemon.
    #---------------------------------------------------------------------------
    "turnEnd_2" => {
      :setchoice => ["ball", 4],
      :speech    => [:Opposing, :SE, "Voltorb Flip gain coins", 
                     "It's time for our second question!",
                     "Which type of Poké Ball would be most effective if thrown on the first turn at a wild Metagross?",
                     {"Fast Ball"  => "Perhaps you were a little too fast to answer, because I'm afraid that's incorrect!", 
                      "Love Ball"  => "I'm sorry to break your heart, but that's incorrect!", 
                      "Quick Ball" => "Ah, you're a quick-witted one...\nBut unfortunately, not quite quick enough! You're incorrect!", 
                      "Heavy Ball" => "Not even a Heavy Ball could contain that huge brain of yours! You're correct!"}]
    },
    "choice_ball_correct" => {
      :setvar => 1,
      :playSE => "Anim/Applause",
      :text   => "The crowd began to root for you to win!",
      :team   => [ [PBEffects::LuckyChant, 5, "The Lucky Chant shields {1} from critical hits!"] ]
    },
    "choice_ball_incorrect" => {
      :moves   => [:SPLASH, :METRONOME, nil, nil],
      :text    => "{1} became embarassed and forgot its moves!"
    },
    #---------------------------------------------------------------------------
    # Turn 3 - Branching path question. The player selects one of three topics
    #          that branches off into a different question related to the chosen
    #          topic.
    #---------------------------------------------------------------------------
    "turnEnd_3" => {
      :setchoice => "topic",
      :speech    => [:Opposing, "Ah, we've made it to our wild card round!",
                     "This turn, you may choose one of three topics related to Pokémon.",
                     "Our Quiz-A-Tron 3000 will then generate a stumper of a question related to your chosen topic.",
                     "This will be a simple yes or no question, but it will be worth two points, so choose wisely!",
                     "So then, which topic will it be?", 
                     ["Battling", "Evolution", "Breeding"], 
                     "Interesting choice!", 
                     "Let's see what our Quiz-A-Tron comes up with!"],
      :text      => [:SE, "PC Access", "The Quiz-A-Tron 3000 beeps and whirrs as it prints out a question."]
    },
    #---------------------------------------------------------------------------
    # Battling question - Yes/No question. Correct choice boosts the player
    #                     Pokemon's Attack and Sp.Atk by 1 stage. Incorrect
    #                     choice lowers the player Pokemon's Attack and Sp.Atk
    #                     by 2 stages.
    #---------------------------------------------------------------------------
    "choice_topic_1" => {
      :setchoice => ["battling", 2],
      :speech    => [:Opposing, :SE, "Voltorb Flip gain coins", 
                     "Question time!",
                     "Would the move Nature Power become an Ice-type move if the user is holding a Yache Berry?",
                     {"Yes" => "I'm sorry. I guess not everyone can have a Natural Gift for quizzes...",
                      "No"  => "Hey, looks like you've got a Natural Gift for this!"}]
    },
    "choice_battling_correct" => {
      :setvar => 2,
      :playSE => "Anim/Applause",
      :text   => "The crowd roared with excitement!",
      :hp     => [1, "{1} was energized from the crowd's cheering!"],
      :stats  => [:ATTACK, 1, :SPECIAL_ATTACK, 1]
    },
    "choice_battling_incorrect" => {
      :text  => "{1} became discouraged by the silence of the crowd...",
      :stats => [:ATTACK, -2, :SPECIAL_ATTACK, -2]
    },
    #---------------------------------------------------------------------------
    # Evolution question - Yes/No question. Correct choice boosts the player
    #                      Pokemon's Speed and Evasion by 1 stage. Incorrect
    #                      choice lowers the player Pokemon's Speed and Evasion
    #                      by 2 stages.
    #---------------------------------------------------------------------------
    "choice_topic_2" => {
      :setchoice => ["evolution", 1],
      :speech    => [:Opposing, :SE, "Voltorb Flip gain coins", 
                     "Question time!",
                     "Would holding a Leek item be directly useful in some way with helping a Galarian Farfetch'd evolve?",
                     {"Yes" => "It was critical that you got that question right! Good job!",
                      "No"  => "Oh no! You should have thought about that one more critically..."}]
    },
    "choice_evolution_correct" => {
      :setvar => 2,
      :playSE => "Anim/Applause",
      :text   => "The crowd roared with excitement!",
      :hp     => [1, "{1} was energized from the crowd's cheering!"],
      :stats  => [:SPEED, 1, :EVASION, 1]
    },
    "choice_evolution_incorrect" => {
      :text  => "{1} became discouraged by the silence of the crowd...",
      :stats => [:SPEED, -2, :EVASION, -2]
    },
    #---------------------------------------------------------------------------
    # Breeding question - Yes/No question. Correct choice boosts the player
    #                     Pokemon's Defense and Sp.De by 1 stage. Incorrect
    #                     choice lowers the player Pokemon's Defense and Sp.Def
    #                     by 2 stages.
    #---------------------------------------------------------------------------
    "choice_topic_3" => {
      :setchoice => ["breeding", 1],
      :speech    => [:Opposing, :SE, "Voltorb Flip gain coins", 
                     "Question time!",
                     "Is there a scenario where leaving an Illumise at the day-care would produce Eggs that may hatch into a different species from itself?",
                     {"Yes" => "Whoa! You Volbeat that question without breaking a sweat!",
                      "No"  => "Ouch! Looks you got Volbeat by that question..."}]
    },
    "choice_breeding_correct" => {
      :setvar => 2,
      :playSE => "Anim/Applause",
      :text   => "The crowd roared with excitement!",
      :hp     => [1, "{1} was energized from the crowd's cheering!"],
      :stats  => [:DEFENSE, 1, :SPECIAL_DEFENSE, 1]
    },
    "choice_breeding_incorrect" => {
      :text  => "{1} became discouraged by the silence of the crowd...",
      :stats => [:DEFENSE, -2, :SPECIAL_DEFENSE, -2]
    },
    #---------------------------------------------------------------------------
    # Turn 4 - Final question. 
    #---------------------------------------------------------------------------
    "turnEnd_4" => {
      :setchoice => ["final", 1],
      :speech    => [:Opposing, "I'm afraid we've reached our final round of questions!",
                     "Can our challenger pull out a win here?\nLet's find out!",
                     :SE, "Voltorb Flip gain coins", 
                     "Here it is, the final question:",
                     "When loading Pokémon Essentials in Debug mode and the game window is in focus, how do you manually trigger the game to recompile?",
                     {"Hold the Ctrl key"      => "Yes, it's Ctrl! You got it!\nHey, you must be a pro at this!",
                      "Hold the Shift key"     => "Close! Holding Shift will only recompile plugins!\nThe correct key is Ctrl!",
                      "Hold your face and cry" => "Huh? C'mon now, it's not that hard... Just hold the Ctrl key.",
                      "Ask someone else how"   => "Well now you won't have to, because the answer is 'Hold the Ctrl key'."}]
    },
    "choice_final_correct" => {
      :setvar => 1,
      :playSE => "Anim/Applause",
      :text   => "The crowd gave you a standing ovation!",
      
    },
    "choice_final_incorrect" => {
      :text => "You can hear disappointed murmurings from the crowd...",
      :hp   => [-1, "{1} fainted from embarassment..."]
    },
    #---------------------------------------------------------------------------
    # Turn 6 - Ends the battle as a loss if not enough points have been earned.
    #---------------------------------------------------------------------------
    "turnEnd_6" => {
      :playSE => "Slots stop",
      :speech => [:Opposing, "Oh no! That sound means we've reached the end of our game...",
                  "Our challenger \\PN showed much promise, but came up a tad short in the end.",
                  "But we still had fun, didn't we, folks?", 
                  :SE, "Anim/Applause",
                  "That's right! Well, that's all for today!\nTake a bow, \\PN! You and your Pokémon fought hard!"],
      :text      => "You awkwardly bow at the audience as staff begin to direct you off stage...",
      :endbattle => 2
    }
  }
  
  
################################################################################
# Demo speech displays for use with certain battle mechanics.
################################################################################
  
  #-----------------------------------------------------------------------------
  # Demo trainer speech when triggering Mega Evolution.
  #-----------------------------------------------------------------------------
  DEMO_MEGA_EVOLUTION = {
    "mega_foe"           => ["C'mon, {1}!", "Let's blow them away with Mega Evolution!"],
    "megaGYARADOS_foe"   => "Behold the serpent of the darkest depths!",
    "megaGENGAR_foe"     => "Good luck escaping THIS nightmare!",
    "megaKANGASKHAN_foe" => "Parent and child fight as one!",
    "megaAERODACTYL_foe" => "Prepare yourself for my prehistoric beast!",
    "megaFIRE_foe"       => "Maximum firepower!",
    "megaELECTRIC_foe"   => "Prepare yourself for a mighty force of nature!",
    "megaBUG_foe"        => "Emerge from you caccoon as a mighty warrior!"
  }
  
  #-----------------------------------------------------------------------------
  # Demo trainer speech when triggering Primal Reversion.
  #-----------------------------------------------------------------------------
  DEMO_PRIMAL_REVERSION = {
    "primal_foe"        => "Prepare yourself for an ancient force beyond imagination!",
    "primalKYOGRE_foe"  => "{1}! Let the seas burst forth by your mighty presence!",
    "primalGROUDON_foe" => "{1}! Let the ground crack by your might presence!",
    "primalWATER_foe"   => "{1}! Flood the world with your majesty!",
    "primalGROUND_foe"  => "{1}! Shatter the world with your majesty!"
  }

  #-----------------------------------------------------------------------------
  # Demo trainer speech when triggering ZUD Mechanics. (ZUD Plugin)
  #-----------------------------------------------------------------------------
  DEMO_ZUD_MECHANICS = {
    #---------------------------------------------------------------------------
    # Z-Moves
    "zmove_foe"         => ["Alright, {1}!", "Time to unleash our Z-Power!"],
    "zmoveRAICHU_foe"   => "Surf's up, {1}!",
    "zmoveSNORLAX_foe"  => "Let's flatten 'em, {1}!",
    "zmoveNECROZMA_foe" => "{1}! Let your light burn them to ashes!",
    "zmoveELECTRIC_foe" => "Smite them with a mighty bolt!",
    "zmoveFIGHTING_foe" => "Time for an all-out assault!",
    #---------------------------------------------------------------------------
    # Ultra Burst
    "ultra_foe"         => "Hah! Prepare to witness my {1}'s ultimate form!",
    "ultraNECROZMA_foe" => "{1}! Let your light burst forth!",
    "ultraPSYCHIC_foe"  => "{1}! Unleash your cosmic energies!",
    #---------------------------------------------------------------------------
    # Dynamax
    "dynamax_foe"       => ["No holding back!", "It's time to Dynamax!"],
    "dynamaxWATER_foe"  => "Lets drown them out with a mega-rain storm!",
    "dynamaxFIRE_foe"   => "Lets burn 'em up with the heat of the sun!",
    "gmax_foe"          => "Witness my {1}'s Gigantamax form!",
    "gmaxPIKACHU_foe"   => "Behold my precious chonky-chu!",
    "gmaxMEOWTH_foe"    => "Tower over your competition, {1}!"
  }

  #-----------------------------------------------------------------------------
  # Demo trainer speech when entering Strong/Agile styles. (PLA Battle Styles)
  #-----------------------------------------------------------------------------
  DEMO_BATTLE_STYLES = {
    #---------------------------------------------------------------------------
    # Strong Style
    "strongStyle_foe" => "Let's strike 'em down with all your strength, {1}!",
    "strongStyle_foe_repeat" => {
      :delay  => "styleEnd_foe",
      :speech => ["Let's keep up the pressure!", 
                  "Hit 'em with your Strong Style, {1}!"]
    },
    #---------------------------------------------------------------------------
    # Agile Style
    "agileStyle_foe" => "Let's strike 'em down before they know what hit 'em, {1}!",
    "agileStyle_foe_repeat" => {
      :delay  => "styleEnd_foe",
      :speech => ["Let's keep them on their toes!", 
                  "Hit 'em with your Agile Style, {1}!"]
    }
  }
  
  #-----------------------------------------------------------------------------
  # Demo trainer speech when triggering Terastallization mechanics. (Terastal Phenomenon)
  #-----------------------------------------------------------------------------
  DEMO_TERASTALLIZE = {
    #---------------------------------------------------------------------------
    # Terastallization
    "tera_foe"           => "Let your true self shine forth, {1}!",
    "teraDARK_foe"       => "{1}, let's show them how devious you can really be!",
    "teraGHOST_foe"      => "{1}! It's time for your to ascend to the spirit world!",
    "teraFIRE_foe"       => "Let your fiery rage come through, {1}!",
    #---------------------------------------------------------------------------
    # Tera-Boosted Attack
    "teraType_foe"       => "Now let me show you my {1}'s true power!",
    "teraTypeGRASS_foe"  => "Give them the full force of nature, {1}!",
    "teraTypePOISON_foe" => "{1}'s poison is too potent for you to handle!",
    "teraTypeSTEEL_foe"  => "Taste the cold steel of your defeat!"
  }
  
  #-----------------------------------------------------------------------------
  # Demo trainer speech when triggering the Focus Meter. (Focus Meter System)
  #-----------------------------------------------------------------------------
  DEMO_FOCUS_METER = {
    "focus_foe" => "Focus, {1}!\nWe got this!", 
    "focus_foe_repeat" => {
      :delay  => "focusEnd_foe",
      :speech => "Keep your eye on the prize, {1}!"
    },
    "focusBoss" => "It's time to let loose, {1}!",
    "focusBoss_repeat" => {
      :delay  => "focusEnd_foe",
      :speech => "No mercy! Show them your rage, {1}!"
    }
  }
  
  #-----------------------------------------------------------------------------
  #-----------------------------------------------------------------------------
  #-----------------------------------------------------------------------------
  #-----------------------------------------------------------------------------
  #-----------------------------------------------------------------------------
  #-----------------------------------------------------------------------------
  #-----------------------------------------------------------------------------
  #-----------------------------------------------------------------------------
  #-----------------------------------------------------------------------------
  #-----------------------------------------------------------------------------
  #-----------------------------------------------------------------------------
  # CUSTOM SCRIPT ADDITIONS
  #-----------------------------------------------------------------------------
  #-----------------------------------------------------------------------------
  #-----------------------------------------------------------------------------
  #-----------------------------------------------------------------------------
  #-----------------------------------------------------------------------------
  #-----------------------------------------------------------------------------
  #-----------------------------------------------------------------------------
  #-----------------------------------------------------------------------------
  #-----------------------------------------------------------------------------
  #-----------------------------------------------------------------------------
  #-----------------------------------------------------------------------------
  #
  #
  #-----------------------------------------------------------------------------
  # First fight against Artie 2022-09-24
  # Allows Normal and Fighting type moves to hit Minccino to make sure you're not in an unfair battle.
  #-----------------------------------------------------------------------------

  ARTIE_EUROPA_FOREST = {
    "turnCommand" => {
      :speech  => [:Opposing, "Haha, you won't be able to hit my Minccino!"],
	  :battler => :Opposing,
      :effects => [
        [PBEffects::Foresight, true, "A mysterious force illuminated the battlefield, allowing you to hit Ghost-type Pokemon!"],
      ],
	  :playsound => "Anim/PRSFX- Miracle Eye",
	  :anim    => [:MIRACLEEYE, :Self],
      :speech_1  => [:Opposing, "What was that!? You can hit my Minccino now?!"],
    },
  }

  #-----------------------------------------------------------------------------
  # Jango in Europa Cave 2022-09-24
  # Stealth rock on entry
  #-----------------------------------------------------------------------------

  JANGO_EUROPA_CAVE = {
    "turnCommand" => {
	  :speech  => [:Opposing, "We're in a cave so these rocks ought to come in use!"],
      :battler => :Opposing,
	  :anim => [:STEALTHROCK, :Opposing],
	  :battler_1 => :Self,
	  :team_1 => [
        [PBEffects::StealthRock, true, "Pointed stones float in the air around {1}!"],
      ],
    },
  }

  #-----------------------------------------------------------------------------
  # Wesley in Aurora Resort
  # Increase SpDef by 1 stage on entry
  #-----------------------------------------------------------------------------

  WESLEY_AURIGA_RESORT = {
    "turnCommand" => {
	  :speech  		=> [:Opposing, "I'm toughening my Pokemon up against you!"],
      :battler   	=> :Opposing,
	  :anim      	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_DEFENSE, 1]
    },
  }
  
  #-----------------------------------------------------------------------------
  # Artie in Lyra City
  # Hailing in battle; Initial hit for 25% life and confusion, Artie gets SpDef +1
  #-----------------------------------------------------------------------------

  ARTIE_LYRA_CITY = {
    "turnCommand" => {
	  :speech    	=> [:Opposing, "Aww jeez, I hate it when it hails!"],
	  :battler   	=> :Self,
	  :text      	=> "{1} was struck on the head by a large chunk of hail!",
	  :playsound 	=> "Mining hammer",
	  :hp      		=> -4,
      :status  		=> :CONFUSION,
	  :speech_1  	=> [:Opposing, "Haha! Watch out for the falling hail!", "I'm using the time you're confused to get my team's Special Defense up!"],
      :battler_1   	=> :Opposing,
	  :anim      	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_DEFENSE, 1]
    },
  }
  
  #-----------------------------------------------------------------------------
  # Maximillion in Triton Cave
  # Hailing in battle and set in rules already
  # Increases Attack by 1
  #-----------------------------------------------------------------------------

  MAX_TRITON_CAVE = {
    "turnCommand" => {
	  :speech  		=> [:Opposing, "Time to put you down, pipsqueak!"],
      :battler 		=> :Opposing,
	  :anim    		=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats   		=> [:ATTACK, 1],
	  :speech_1  	=> [:Self, "You'll never get us in the hail!"],
    },
  }

  #-----------------------------------------------------------------------------
  # Artie in front of Telescopium Academy
  # Artie gets Def and SpDef +1
  #-----------------------------------------------------------------------------

  ARTIE_ACADEMY = {
    "turnCommand" => {
	  :speech    	=> [:Opposing, "I'm ready for you!"],
      :battler   	=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1]
    },
  }

  #-----------------------------------------------------------------------------
  # Tormented Espurr in Telescopium Academy
  # Level 30 Espurr with Tormented Ability, knows Crunch, Adamant nature, 31 IVs
  #-----------------------------------------------------------------------------

# The original setup of the Espurr.
	WildBattle.dx_start([:ESPURR, 30], {:outcome => 73 }, {
		:ability => 2, # Tormented
		:moves   => :CRUNCH,
		:nature  => :ADAMANT,		
		:ivs     => 31,
	})


# The midbattle config for the Espurr
  TORMENTED_ESPURR = {
    "turnCommand" => {
      :text        	 => "My curse upon you!",
	  :battler       => :Opposing,
      :anim          => [:CURSE, :Opposing],
      :playsound     => "Anim/Curse",
	  :battler_1     => :Self,
	  :anim_1        => "Common:StatDown",
	  :playsound_1   => "Anim/decrease",
	  :stats_1       => [:ATTACK, -1, :SPECIAL_ATTACK, -1],
      :text_1        => "The curse lowered your attacking stats!"
    },
  }

  #-----------------------------------------------------------------------------
  # Headmaster Maurizio in Telescopium Academy
  # Trick Room in effect
  #-----------------------------------------------------------------------------

  HEADMASTER_ACADEMY0 = {
    "turnCommand" => {
	  :speech    	=> [:Opposing, "I am going to re-orient your perception of reality!"],
	  :anim     	=> [:TRICKROOM],
	  :playsound 	=> "Anim/PRSFX- Trick Room",
	  :field => [ 
		[PBEffects::TrickRoom, 99, "The dimensions were twisted!"],
		],
    },
  }

  HEADMASTER_ACADEMY1 = {
    "turnCommand" => {
	  :speech    	 => [:Opposing, "Why won't you leave me alone!"],
	  :battler       => :Self,
	  :anim          => "Common:StatDown",
	  :playsound     => "Anim/decrease",
	  :stats         => [:DEFENSE, -1, :SPECIAL_DEFENSE, -1],
    },
  }

  HEADMASTER_ACADEMY2 = {
    "turnCommand" => {
	  :speech    	=> [:Opposing, "Show me what you got!"],
      :battler   	=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1, :SPEED, 1]
    },
  }
  
  HEADMASTER_ACADEMY3 = {
    "turnCommand" => {
	  :speech    	=> [:Opposing, "I ought to teach you a lesson!"],
      :battler   	=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1, :SPEED, 1]
    },
  }

  #-----------------------------------------------------------------------------
  # Artie in front of Orion Central City
  # Artie sets up permanent Reflect and Light Screen
  #-----------------------------------------------------------------------------

  ARTIE_ORION = {
    "turnCommand" => {
	  :speech  => [:Opposing, "I'm putting up some protection for my team!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 99, "Artie used Reflect!"]
	  ]
    },
  }

  #-----------------------------------------------------------------------------
  # Drug Trail Gangster Boss
  # Toxic Spikes on entry
  #-----------------------------------------------------------------------------

  DRUG_TRAIL = {
    "turnCommand" => {
	  :speech       => [:Opposing, "I don't fight fair, mate!"],
	  :battler 		=> :Opposing,
	  :anim 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team_1 		=> [
        [PBEffects::ToxicSpikes, 2, "The Gangster dropped Toxic Spikes on your side of the field!"],
      ],
    },
  }
  
  #-----------------------------------------------------------------------------
  # Anomaly Swalot
  # Sets up spikes on entry, +1 Def/SpDef
  #-----------------------------------------------------------------------------

  ANOMALY_SWALOT = {
    "turnCommand" => {
	  :text      	=> "I. AM. INVINCIBLE.",
	  :battler 		=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1],
	  :text_1      	=> "YOU. SHALL. NOT. FLEE.",
	  :anim_1 		=> [:SPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team_1 		=> [
        [PBEffects::Spikes, 3, "The Anomaly covered your side of the field in Spikes!"],
      ],
    },
  }

  #-----------------------------------------------------------------------------
  # Artie on Route 6A
  # Artie sets up permanent Reflect and Light Screen
  #-----------------------------------------------------------------------------

  ARTIE_6A = {
    "turnCommand" => {
	  :speech  => [:Opposing, "I'm putting up some protection for my team!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 99, "Artie used Reflect!"]
	  ]
    },
  }
  
  #-----------------------------------------------------------------------------
  # Christina fights you in Fornax Town Hall
  # Christina sets up a smoke bomb that raises evasion by 1 stage.
  # Turn 2 is a cheap shot that lowers your Atk and SpAtk by 1
  #-----------------------------------------------------------------------------

  CHRISTINA_FORNAX_TOWN = {
    "turnCommand" => {
	  :speech         	=> [:Opposing, "Smoke bomb!"],
	  :battler 			=> :Opposing, # Because the animation for smokescreen is stupid
	  :anim     		=> [:SMOKESCREEN, :Self],
	  :playsound 		=> "Anim/PRSFX- Smokescreen",
	  :anim_1     		=> "Common:StatUp",
	  :stats     		=> [:EVASION, 1],
	  :speech_1       	=> [:Opposing, "Let's see you try and hit me now!"],
    },
    "turnCommand_1" 	=> {
      :speech        		=> [:Opposing, "I don't fight fair!"],
	  :battler       		=> :Opposing,
      :anim          		=> [:BACKSTABBING, :Opposing],
      :battler_1     		=> :Self,
	  :anim_1        		=> "Common:StatDown",
	  :playsound_1   		=> "Anim/decrease",
	  :stats_1       		=> [:ATTACK, -1, :SPECIAL_ATTACK, -1],
      :text_1        		=> "The cheap shot lowered your attacking stats!"
    },
  }


  #-----------------------------------------------------------------------------
  # Priestess Sienna in the Temple of Time (Team #0)
  # Permanent Reflect and Light Screen
  #-----------------------------------------------------------------------------

  SIENNA_TEMPLE0 = {
    "turnCommand" => {
	  :speech  => [:Opposing, "Dialga shields me against evil!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 99, "A force of light set up Reflect on Sienna's side of the field!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Opposing],
	  :team_1 => [
		[PBEffects::LightScreen, 99, "A force of light set up Light Screen on Sienna's side of the field!"],
	  ]
    },
  }

  #-----------------------------------------------------------------------------
  # Priestess Sienna in the Temple of Time (Team #1)
  # Smites you with holy fire (i.e. a burn and lose 25% of life)
  #-----------------------------------------------------------------------------

  SIENNA_TEMPLE1 = {
    "turnCommand" => {
	  :speech    	=> [:Opposing, "The power of Dialga compel you!"],
	  :battler 		=> :Opposing,
	  :anim     	=> [:MYSTICALFIRE, :Opposing],
	  :battler_1   	=> :Self,
	  :text      	=> "{1} was burned by a flicker of holy flame!",
	  :playsound 	=> "Anim/PRSFX- Spite2",
	  :hp      		=> -4,
      :status  		=> :BURN,
	  :speech_1  	=> [:Opposing, "Dialga watches over me. Who watches over you, infidel?"],
      :battler_2   	=> :Opposing,
	  :anim_1      	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1],
    },
  }

  #-----------------------------------------------------------------------------
  # Priestess Sienna in the Temple of Time (Team #2)
  # Raining in battle (refer to battle initiation command for this); Boosts defense + spdef, heals by 25% on turn 2
  #-----------------------------------------------------------------------------

  SIENNA_TEMPLE2 = {
    "turnCommand" => {
	  :speech    			=> [:Opposing, "Lord Dialga will wish away my sins with purifying rain!"],
      :battler   			=> :Opposing,
	  :anim     			=> "Common:StatUp",
	  :playsound 			=> "Anim/increase",
	  :stats     			=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1],
    },
    "turnCommand_1" 	=> {
	  :speech         		=> [:Opposing, "I am one with the jungle!"],
	  :battler 				=> :Opposing,
	  :anim     			=> [:INGRAIN, :Self],
	  :playsound 			=> "Anim/PRSFX- Strength Sap1",
	  :hp      				=> 4,
    },
  }

  #-----------------------------------------------------------------------------
  # Priestess Sienna in the Temple of Time (Team #3)
  # Attack and Speed boost
  #-----------------------------------------------------------------------------
 
  SIENNA_TEMPLE3 = {
    "turnCommand" => {
	  :speech    	=> [:Opposing, "Spirits of the jungle, heed my call!"],
      :battler   	=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1, :SPEED, 1]
    },
    "turnCommand_1" 	=> {
	  :speech    	=> [:Opposing, "The power of Dialga compel you!"],
	  :battler 		=> :Opposing,
	  :anim     	=> [:MYSTICALFIRE, :Opposing],
	  :battler_1   	=> :Self,
	  :text      	=> "{1} was burned by a flicker of holy flame!",
	  :playsound 	=> "Anim/PRSFX- Spite2",
	  :hp      		=> -4,
      :status  		=> :BURN,
    },
  }

  #-----------------------------------------------------------------------------
  # Artie on Route 5B
  # Artie boosts Special Attack and Speed by 1 stage.
  #-----------------------------------------------------------------------------

  ARTIE_5B = {
    "turnCommand" => {
	  :speech    	=> [:Opposing, "My team need some liquid courage!"],
      :battler   	=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1, :SPEED, 1]
    },
  }

  #-----------------------------------------------------------------------------
  # Anomaly Battles in Caverns of Rhea
  # Various
  #-----------------------------------------------------------------------------

  ANOMALY_0 = {
    "attackerDamaged_foe_repeat_random" => {
	  :text      	=> "Leyline Crystals! So delicious!",
	  :playsound 	=> "zbrrdy00",
	  :text_1      	=> "The Anomaly consumed a leyline crystal!",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1]
    },
    "attackerCrit_foe_repeat_random" => {
	  :text      	=> "We are legion!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPEED, 1]
    },
    "defenderHPLow_foe" => {
	  :text      	=> "We feed. We multiply!",
	  :playsound 	=> "zbryes02",
	  :battler 		=> :Self,
	  :anim     	=> [:STOCKPILE, :Self],
	  :playsound_1 	=> "Anim/PRSFX- Recover",
	  :hp      		=> 4
    },
  }
  
  ANOMALY_1 = {
    "attackerSEdmg_foe_repeat_random" => {
	  :text      	=> "We know your weakness!",
	  :playsound 	=> "zbrrdy00",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1]
    },
    "switchSentOut_random" => {
	  :text      	=> "We are impervious!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> [:VENOMDRENCH, :Opposing],
	  :battler_1   	=> :Self,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Venom Drench",
	  :hp      		=> -4,
      :status  		=> :POISON
    },
    "defenderDamaged_foe_repeat_random" => {
	  :text      	=> "*hiss*",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1]
    },
  }
  
  ANOMALY_2 = {
    "attackerNVEdmg_foe_repeat_random" => {
	  :text      	=> "We shall find your weakness!",
	  :playsound 	=> "zbrrdy00",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1]
    },
    "defenderDamaged_foe_repeat_random" => {
	  :text      	=> "We are an endless tide!",
	  :playsound 	=> "zbrrdy00",
      :battler 		=> :Opposing,
	  :anim    		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:SPECIAL_DEFENSE, -1]
    },
    "attackerDodged_foe_repeat_random" => {
	  :text      	=> "You can run, but you cannot hide!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ACCURACY, 1]
    },
  }
  
  ANOMALY_3 = {
    "attackerDamaged_foe_repeat_random" => {
	  :text      	=> "Fear us!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1]
    },
    "defenderDamaged_foe_repeat_random" => {
	  :text      	=> "We are an endless tide!",
	  :playsound 	=> "zbryes02",
      :battler 		=> :Opposing,
	  :anim    		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:SPECIAL_DEFENSE, -1]
    },
    "attackerSEdmg_foe_repeat_random" => {
	  :text      	=> "We are impervious!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> [:VENOMDRENCH, :Self],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Venom Drench",
	  :hp      		=> -4,
      :status  		=> :POISON
    },
  }

  #-----------------------------------------------------------------------------
  # Anomaly Galvantula
  # Sets up toxic spikes on entry, +1 Atk/SpAtk
  #-----------------------------------------------------------------------------

  ANOMALY_GALVANTULA = {
    "turnCommand" => {
	  :text      	=> "MUST. FEED. ON. LEYLINES.",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1],
	  :text_1      	=> "YOU. SHALL. NOT. FLEE.",
	  :anim_1 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team_1 		=> [
        [PBEffects::ToxicSpikes, 2, "The Anomaly covered your side of the field in Toxic Spikes!"],
      ],
    },
    "attackerCrit_foe_repeat_random" => {
	  :text      	=> "We are legion!",
	  :playsound 	=> "zbrrdy00",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPEED, 1]
    },
  }

  #-----------------------------------------------------------------------------
  # Moby the Whale in Route 9B Underwater
  # Level 46 Wailord with Cursed Body Ability, knows Dark Pulse, Modest nature, 31 IVs
  #-----------------------------------------------------------------------------

# The original setup of the Pokemon.
	WildBattle.dx_start([:WAILORD, 46], {:outcome => 73 }, {
		:ability => 2, # Cursed Body
		:name    => "Moby",
		:moves   => :DARKPULSE,
		:nature  => :MODEST,		
		:ivs     => 31,
	}, 
	:WHALE_HUNTING)

# The midbattle config for the Pokemon
  WHALE_HUNTING = {
    "turnCommand" => {
      :playsound     => "Cries/WAILORD",
	  :text          => "The call of the abyss echoes...",
	  :battler       => :Opposing,
      :anim          => [:ELEGY, :Opposing],
      :playsound_1   => "Anim/PRSFX- Perish Song",
	  :battler_1     => :Self,
	  :anim_1        => "Common:StatDown",
	  :playsound_2   => "Anim/decrease",
	  :stats_1       => [:DEFENSE, -1, :SPECIAL_DEFENSE, -1],
      :text_1        => "The sea never forgives. The sea never forgets!"
    },
    "defenderDamaged_foe_repeat_random" => {
	  :text      	=> "I shall bring you to the bottom of the sea!",	  
	  :battler 		=> :Opposing,
	  :anim     	=> [:WATERFALL, :Self],
	  :text_1      	=> "{1} was slammed by a tidal wave!",
	  :playsound_1 	=> "Anim/PRSFX- Waterfall1",
	  :hp      		=> -8
    },
  }

  #-----------------------------------------------------------------------------
  # Artie - Practice Battle near Cassiopeia Oasis
  # Artie increases Evasion, Attack and Accuracy by 1 stage.
  #-----------------------------------------------------------------------------

  ARTIE_OASIS = {
    "turnCommand" => {
	  :speech    	=> [:Opposing, "Ugh! The chip damage from this damn sand is annoying. I can work with it though!"],
      :battler   	=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1, :EVASION, 1, :ACCURACY, 1]
    },
  }

  #-----------------------------------------------------------------------------
  # Anomaly Battles in Temple of Space
  # Various
  #-----------------------------------------------------------------------------

  ANOMALYSPACE_0 = {
    "attackerDamaged_foe_repeat_random" => {
	  :text      	=> "Regenerate vitality!",
	  :playsound 	=> "zbrrdy00",
	  :text_1      	=> "The Anomaly restored its health!",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1]
    },
    "attackerCrit_foe_repeat_random" => {
	  :text      	=> "Chaos reigns!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPEED, 1]
    },
    "defenderHPLow_foe" => {
	  :text      	=> "We endure!",
	  :playsound 	=> "zbryes02",
	  :battler 		=> :Self,
	  :anim     	=> [:STOCKPILE, :Self],
	  :playsound_1 	=> "Anim/PRSFX- Recover",
	  :hp      		=> 4
    },
  }
  
  ANOMALYSPACE_1 = {
    "attackerSEdmg_foe_repeat_random" => {
	  :text      	=> "You can run but you cannot hide!",
	  :playsound 	=> "zbrrdy00",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1]
    },
    "switchSentOut_random" => {
	  :text      	=> "We shall not yield!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> [:VENOMDRENCH, :Opposing],
	  :battler_1   	=> :Self,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Venom Drench",
	  :hp      		=> -4,
      :status  		=> :POISON
    },
    "defenderDamaged_foe_repeat_random" => {
	  :text      	=> "Your reality is ours!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_DEFENSE, 1]
    },
  }
  
  ANOMALYSPACE_2 = {
    "attackerNVEdmg_foe_repeat_random" => {
	  :text      	=> "We shall prevail!",
	  :playsound 	=> "zbrrdy00",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1]
    },
    "defenderDamaged_foe_repeat_random" => {
	  :text      	=> "We cannot be stopped!",
	  :playsound 	=> "zbrrdy00",
      :battler 		=> :Opposing,
	  :anim    		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:SPECIAL_DEFENSE, -1]
    },
    "attackerDodged_foe_repeat_random" => {
	  :text      	=> "We shall catch you!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ACCURACY, 1]
    },
  }
  
  ANOMALYSPACE_3 = {
    "attackerDamaged_foe_repeat_random" => {
	  :text      	=> "The Anomalies come for your world!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1]
    },
    "defenderDamaged_foe_repeat_random" => {
	  :text      	=> "We cannot be defeated!",
	  :playsound 	=> "zbryes02",
      :battler 		=> :Opposing,
	  :anim    		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:SPECIAL_DEFENSE, -1]
    },
    "attackerSEdmg_foe_repeat_random" => {
	  :text      	=> "We hunger, we feed!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> [:VENOMDRENCH, :Self],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Venom Drench",
	  :hp      		=> -4,
      :status  		=> :POISON
    },
  }

  #-----------------------------------------------------------------------------
  # Anomaly Arbok
  # Sets up stealth rock on entry, +1 Def/SpDef. Caustic substance
  #-----------------------------------------------------------------------------

  ANOMALY_ARBOK = {
    "turnCommand" => {
	  :text      	=> "WE. ARE. LEGION.",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1],
	  :text_1      	=> "YOU. SHALL. NOT. ESCAPE.",
	  :battler_1	=> :Opposing,
	  :anim_1 		=> [:STEALTHROCK, :Opposing],
	  :battler_2 	=> :Self,
	  :team_1 		=> [
        [PBEffects::StealthRock, true, "Pointed stones float in the air around {1}!"],
      ],
    },
    "attackerSEdmg_foe_repeat_random" => {
	  :text      	=> "We hunger, we feed!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> [:VENOMDRENCH, :Self],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Venom Drench",
	  :hp      		=> -4,
      :status  		=> :POISON
    },
  }

  #-----------------------------------------------------------------------------
  # Priest Leo and Selene in the Temple of Space (Team #0)
  # Permanent Reflect and Light Screen, Fire tick damage randomly on attack, Critical hits raise speed
  #-----------------------------------------------------------------------------

  TWINS_TEMPLE0 = {
    "turnCommand" => {
	  :speech  => [:Opposing, "Giratina shields us!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 99, "A sinister force set up Reflect on the Twin Priests' side of the field!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Opposing],
	  :team_1 => [
		[PBEffects::LightScreen, 99, "A sinister force set up Light Screen on the Twin Priests' side of the field!"],
	  ]
    },
    "defenderDamaged_foe_repeat_random" => {
	  :text  		=> "By fire be purged!",
	  :battler 		=> :Self,
	  :anim     	=> [:MYSTICALFIRE, :Opposing],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was singed by shadowy flames!",
	  :playsound 	=> "Anim/PRSFX- Spite2",
	  :hp      		=> -8,
    },
    "attackerCrit_foe_repeat_random" => {
	  :text      	=> "Giratina, grant us speed!",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPEED, 1]
    },
  }
  
  TWINS_TEMPLE1 = {
    "turnCommand" => {
	  :speech  => [:Opposing, "We fight for Lord Giratina now! We are his avatars, invader!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 99, "A sinister force set up Reflect on the Twin Priests' side of the field!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Opposing],
	  :team_1 => [
		[PBEffects::LightScreen, 99, "A sinister force set up Light Screen on the Twin Priests' side of the field!"],
	  ]
    },
    "attackerSEdmg_foe_repeat_random" => {
	  :text      	=> "Giratina empowers us!",
	  :battler 		=> :Self,
	  :anim     	=> [:GOOSEBUMP, :Opposing],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was cursed!",
	  :playsound_1 	=> "Anim/goosebump",
	  :hp      		=> -8,
    },
    "defenderHPLowLast_foe" => {
	  :speech      	=> [:Opposing, "Giratina! Save us!"],
	  :battler   	=> :Self,
	  :anim     	=> [:ELEGY, :Self],
	  :hp      		=> 2,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1, :SPECIAL_ATTACK, 1]
    },
  }
  
  TWINS_TEMPLE2 = {
    "turnCommand_repeat_random" => {
	  :speech      	=> [:Opposing, "Giratina! We are your avatars!"],
	  :battler   	=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE,1]
    },
    "defenderHPHalf_foe_repeat_random" => {
	  :text      	=> "The power of Giratina compel you!",
	  :battler 		=> :Self,
	  :anim     	=> [:GOOSEBUMP, :Opposing],
	  :battler_1   	=> :Opposing,
	  :anim_1  		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:ATTACK, -1, :SPECIAL_ATTACK, -1]
    },
    "attackerDodged_foe_repeat_random" => {
	  :text      	=> "Giratina is our master now!",
	  :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPEED, 1, :ACCURACY, 1]
    },
  }
  
  TWINS_TEMPLE3 = {
    "attackerSEdmg_foe_repeat_random" => {
	  :text      	=> "Giratina empowers us!",
	  :battler 		=> :Self,
	  :anim     	=> [:GOOSEBUMP, :Opposing],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was cursed!",
	  :playsound_1 	=> "Anim/goosebump",
	  :hp      		=> -8,
    },
    "defenderDamaged_foe_repeat_random" => {
	  :text      	=> "The Master harbours us!",
	  :battler   	=> :Self,
	  :anim     	=> [:ELEGY, :Self],
	  :hp      		=> 8,
    },
    "attackerNVEdmg_foe_repeat_random" => {
	  :text      	=> "Giratina pierces the veil!",
      :battler 		=> :Opposing,
	  :anim    		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:SPEED, -1]
    },
  }

  #-----------------------------------------------------------------------------
  # Anomaly Battles in the In-Between
  # Various
  #-----------------------------------------------------------------------------

  ANOMALYIB_0 = {
    "attackerDamaged_foe_repeat_random" => {
	  :text      	=> "Regenerate vitality!",
	  :playsound 	=> "zbrrdy00",
	  :text_1      	=> "The Anomaly restored its health!",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1]
    },
    "attackerCrit_foe_repeat_random" => {
	  :text      	=> "Chaos reigns!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPEED, 1]
    },
    "defenderHPLow_foe" => {
	  :text      	=> "We endure!",
	  :playsound 	=> "zbryes02",
	  :battler 		=> :Self,
	  :anim     	=> [:STOCKPILE, :Self],
	  :playsound_1 	=> "Anim/PRSFX- Recover",
	  :hp      		=> 4
    },
  }
  
  ANOMALYIB_1 = {
    "attackerSEdmg_foe_repeat_random" => {
	  :text      	=> "You can run but you cannot hide!",
	  :playsound 	=> "zbrrdy00",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1]
    },
    "switchSentOut_random" => {
	  :text      	=> "We shall not yield!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> [:VENOMDRENCH, :Opposing],
	  :battler_1   	=> :Self,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Venom Drench",
	  :hp      		=> -4,
      :status  		=> :POISON
    },
    "defenderDamaged_foe_repeat_random" => {
	  :text      	=> "We shall conquer!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_DEFENSE, 1]
    },
  }
  
  ANOMALYIB_2 = {
    "attackerNVEdmg_foe_repeat_random" => {
	  :text      	=> "We shall prevail!",
	  :playsound 	=> "zbrrdy00",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1]
    },
    "defenderDamaged_foe_repeat_random" => {
	  :text      	=> "We cannot be stopped!",
	  :playsound 	=> "zbrrdy00",
      :battler 		=> :Opposing,
	  :anim    		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:SPECIAL_DEFENSE, -1]
    },
    "attackerDodged_foe_repeat_random" => {
	  :text      	=> "We shall consume your essence!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ACCURACY, 1]
    },
  }
  
  ANOMALYIB_3 = {
    "attackerDamaged_foe_repeat_random" => {
	  :text      	=> "Mmm... Fresh meat!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1]
    },
    "defenderDamaged_foe_repeat_random" => {
	  :text      	=> "I shall feed today!",
	  :playsound 	=> "zbryes02",
      :battler 		=> :Opposing,
	  :anim    		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:SPECIAL_DEFENSE, -1]
    },
    "attackerSEdmg_foe_repeat_random" => {
	  :text      	=> "We hunger, we feed!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> [:VENOMDRENCH, :Self],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Venom Drench",
	  :hp      		=> -4,
      :status  		=> :POISON
    },
  }

  #-----------------------------------------------------------------------------
  # Anomaly Starmie in the In-Between
  # Sets up stealth rock on entry, +1 Def/SpDef. Caustic substance
  #-----------------------------------------------------------------------------

  ANOMALY_STARMIE = {
    "turnCommand" => {
	  :text      	=> "WE. ARE. LEGION.",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1],
	  :text_1      	=> "YOU. SHALL. NOT. ESCAPE.",
	  :battler_1	=> :Opposing,
	  :anim_1 		=> [:STEALTHROCK, :Opposing],
	  :battler_2 	=> :Self,
	  :team_1 		=> [
        [PBEffects::StealthRock, true, "Pointed stones float in the air around {1}!"],
      ],
    },
    "attackerSEdmg_foe_repeat_random" => {
	  :text      	=> "We hunger, we feed!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> [:VENOMDRENCH, :Self],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Venom Drench",
	  :hp      		=> -4,
      :status  		=> :POISON
    },
  }
  
  #-----------------------------------------------------------------------------
  # Anomaly Starmie in the In-Between
  # Sets up stealth rock on entry, +1 Def/SpDef. Lowers Special Defense and raises Accuracy
  #-----------------------------------------------------------------------------

  ANOMALYVICTIM_IB = {
    "turnCommand" => {
	  :text      	=> "WE. ARE. LEGION.",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1],
	  :text_1     	=> "YOU. SHALL. NOT. ESCAPE.",
	  :battler_1	=> :Opposing,
	  :anim_1 		=> [:STEALTHROCK, :Opposing],
	  :battler_2 	=> :Self,
	  :team_1 		=> [
        [PBEffects::StealthRock, true, "Pointed stones float in the air around {1}!"],
      ],
    },
    "defenderDamaged_foe_repeat_random" => {
	  :text      	=> "We cannot be stopped!",
	  :playsound 	=> "zbrrdy00",
      :battler 		=> :Opposing,
	  :anim    		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:SPECIAL_DEFENSE, -1]
    },
    "attackerDodged_foe_repeat_random" => {
	  :text      	=> "We shall consume your essence!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ACCURACY, 1]
    },
  }
  
  #-----------------------------------------------------------------------------
  # Anomaly Swoobat in the In-Between
  # Sets up stealth rock on entry, +1 Def/SpDef. Caustic substance
  #-----------------------------------------------------------------------------

  ANOMALY_SWOOBAT = {
    "turnCommand" => {
	  :text      	=> "WE. ARE. LEGION.",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1],
	  :text_1      	=> "YOU. SHALL. NOT. ESCAPE.",
	  :battler_1	=> :Opposing,
	  :anim_1 		=> [:STEALTHROCK, :Opposing],
	  :battler_2 	=> :Self,
	  :team_1 		=> [
        [PBEffects::StealthRock, true, "Pointed stones float in the air around {1}!"],
      ],
    },
    "attackerSEdmg_foe_repeat_random" => {
	  :text      	=> "We hunger, we feed!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> [:VENOMDRENCH, :Self],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Venom Drench",
	  :hp      		=> -4,
      :status  		=> :POISON
    },
  }

  #-----------------------------------------------------------------------------
  # Anomaly Group 0 - Weezing and Noivern in the In-Between
  # Sets up stealth rock on entry, +1 Def/SpDef on both sides. Caustic substance
  #-----------------------------------------------------------------------------

  ANOMALYGROUP0_IB = {
    "turnCommand" => {
	  :text      	=> "WE. ARE. LEGION.",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1],
	  :battler_1 	=> :OpposingAlly,
	  :anim_1     	=> "Common:StatUp",
	  :playsound_2 	=> "Anim/increase",
	  :stats_1     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1],
	  :text_1      	=> "YOU. SHALL. NOT. ESCAPE.",
	  :battler_2	=> :Opposing,
	  :anim_2 		=> [:STEALTHROCK, :Opposing],
	  :battler_3 	=> :Self,
	  :team_1 		=> [
        [PBEffects::StealthRock, true, "Pointed stones float in the air around {1}!"],
      ],
    },
    "attackerSEdmg_foe_repeat_random" => {
	  :text      	=> "We hunger, we feed!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> [:VENOMDRENCH, :Self],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Venom Drench",
	  :hp      		=> -4,
      :status  		=> :POISON
    },
  }
  
  #-----------------------------------------------------------------------------
  # Anomaly Group 1 - Misdreavuses
  # Sets up stealth rock on entry, +1 Def/SpDef on both sides. Caustic substance
  #-----------------------------------------------------------------------------

  ANOMALYGROUP1_AT = {
    "turnCommand" => {
	  :text      	=> "WE. ARE. LEGION.",
	  :playsound 	=> "zbrrdy00",
      :battler 		=> :Self,
	  :anim    		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:DEFENSE, -1, :SPECIAL_DEFENSE, -1],
      :battler_1 	=> :Ally,
	  :anim_1	  	=> "Common:StatDown",
	  :playsound_2 	=> "Anim/decrease",
	  :stats   		=> [:DEFENSE, -1, :SPECIAL_DEFENSE, -1],
	  :text_1      	=> "YOU SHALL NEVER RELEASE OUR PRISONERS.",
	  :battler_2	=> :Opposing,
	  :anim_2 		=> [:STEALTHROCK, :Opposing],
	  :battler_3 	=> :Self,
	  :team_1 		=> [
        [PBEffects::StealthRock, true, "Pointed stones float in the air around {1}!"],
      ],
    },
    "attackerSEdmg_foe_repeat_random" => {
	  :text      	=> "We hunger, we feed!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> [:VENOMDRENCH, :Self],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Venom Drench",
	  :hp      		=> -4,
      :status  		=> :POISON
    },
    "attackerCrit_foe_repeat_random" => {
	  :text      	=> "We shall consume you!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim    		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:DEFENSE, -1, :SPECIAL_DEFENSE, -1]
    },
  }
  
  #-----------------------------------------------------------------------------
  # Giratina - Origin Form
  # Sets up Reflect/Light Screen on entry, Lowers your Def/SpDef by 1 and puts you to sleep, 1/4 life on turn 1
  # Super effective attacks result in you losing 1/8 life.
  #-----------------------------------------------------------------------------

  GIRATINA_AT = {
    "turnCommand" => {
	  :text      	=> "You are in my realm now...",
	  :battler 		=> :Opposing,
	  :anim     	=> [:NIGHTDAZE, :Opposing],
	  :playsound 	=> "Anim/PRSFX- Night Daze1",
	  :battler_1   	=> :Self,
	  :hp      		=> -4,
      :status  		=> :SLEEP,
	  :anim_1  		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:DEFENSE, -1, :SPECIAL_DEFENSE, -1],
	  :text_1      	=> "The Sigil empowers me!",
      :battler_2	=> :Opposing,
	  :anim_2 		=> [:REFLECT, :Opposing],
	  :team 		=> [
        [PBEffects::Reflect, 99, "The Antimatter Realm reduces physical damage against Giratina!"]
	  ],
	  :anim_3 		=> [:LIGHTSCREEN, :Opposing],
	  :team_1 		=> [
		[PBEffects::LightScreen, 99, "The Antimatter Realm reduces special damage against Giratina!"],
	  ]
    },
    "attackerSEdmg_foe_repeat" => {
	  :text      	=> "The Antimatter realm shall claim you!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> [:SPITE, :Self],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was hurt by the Antimatter Realm!",
	  :playsound_1 	=> "Anim/PRSFX- Night Daze1",
	  :hp      		=> -8
    },
  }
  
  #-----------------------------------------------------------------------------
  # Anomaly Group 2 - Grapploct and Gyaradoses
  # Toxic Spikes, 1/8 life lost every super effective move,
  #-----------------------------------------------------------------------------

  ANOMALYGROUP2_UT = {
    "turnCommand" => {
	  :text      	=> "The Orb of Creation empowers us!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team_1 		=> [
        [PBEffects::ToxicSpikes, 2, "The Anomaly spread Toxic Spikes on your side of the field!"],
      ],
    },
    "attackerSEdmg_foe_repeat" => {
	  :text      	=> "The Anomaly uses its tentacles to squeeze the life from you!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> [:WRAP, :Self],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was squeezed by the Anomaly's tentacles!",
	  :playsound_1 	=> "Anim/PRSFX- Wrap",
	  :hp      		=> -8
    },
    "switchSentOutLast_foe" => {
	  :text      	=> "We have roamed these seas for 1500 years!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1]
    },
  }
  
  #-----------------------------------------------------------------------------
  # Anomaly Interplanar Storms on EG Trainer Teams 
  #-----------------------------------------------------------------------------

  ANOMALYIPSTORM_0 = {
    "switchSentOutLast_foe" => {
	  :speech      	=> [:Opposing, "It's time I put you in the ground once and for all!"],
	  :battler 		=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1]
    },
  }

  ANOMALYIPSTORM_1 = {
    "switchSentOutLast_foe" => {
	  :speech      	=> [:Opposing, "I won't lose to you!"],
	  :battler 		=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1, :SPEED, 1]
    },
  }
  
  ANOMALYIPSTORM_2 = {
    "switchSentOutLast_foe" => {
	  :speech      	=> [:Opposing, "The Ethereal Guild will be victorious!"],
	  :battler 		=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1, :SPEED, 1]
    },
  }
  
  ANOMALYIPSTORM_3 = {
    "switchSentOutLast_foe" => {
	  :speech      	=> [:Opposing, "You got into the fight with the wrong person!"],
	  :battler 		=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1, :SPECIAL_DEFENSE, 1]
    },
  }
  
  ANOMALYIPSTORM_4 = {
    "switchSentOutLast_foe" => {
	  :speech      	=> [:Opposing, "I still have one ace up my sleeve!"],
	  :battler 		=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1, :DEFENSE, 1]
    },
  }

  #-----------------------------------------------------------------------------
  # Anomaly Hoopa on Route 13B
  # Sets up stealth rock on entry, +1 Def/SpDef. Caustic substance
  #-----------------------------------------------------------------------------

  ANOMALYHOOPA_IPS = {
    "turnCommand" => {
	  :text      	=> "WE. ARE. UNSTOPPABLE.",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1],
	  :text_1      	=> "YOU. SHALL. DIE.",
	  :battler_1	=> :Opposing,
	  :anim_1 		=> [:STEALTHROCK, :Opposing],
	  :battler_2 	=> :Self,
	  :team_1 		=> [
        [PBEffects::StealthRock, true, "Pointed stones float in the air around {1}!"],
      ],
    },
    "attackerSEdmg_foe_repeat_random" => {
	  :text      	=> "We hunger, we feed!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> [:VENOMDRENCH, :Self],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Venom Drench",
	  :hp      		=> -4,
      :status  		=> :POISON
    },
  }

  #-----------------------------------------------------------------------------
  # Anomaly Battles in the Callisto Lake and EG Underwater Base
  # Various
  #-----------------------------------------------------------------------------

  ANOMALYCALLISTO_0 = {
    "attackerDamaged_foe_repeat_random" => {
	  :text      	=> "Regenerate vitality!",
	  :playsound 	=> "zbrrdy00",
	  :text_1      	=> "The Anomaly restored its health!",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1]
    },
    "attackerCrit_foe_repeat_random" => {
	  :text      	=> "Chaos reigns!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPEED, 1]
    },
    "defenderHPLow_foe" => {
	  :text      	=> "We endure!",
	  :playsound 	=> "zbryes02",
	  :battler 		=> :Self,
	  :anim     	=> [:STOCKPILE, :Self],
	  :playsound_1 	=> "Anim/PRSFX- Recover",
	  :hp      		=> 4
    },
  }
  
  ANOMALYCALLISTO_1 = {
    "attackerSEdmg_foe_repeat_random" => {
	  :text      	=> "You can run but you cannot hide!",
	  :playsound 	=> "zbrrdy00",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1]
    },
    "switchSentOut_random" => {
	  :text      	=> "We shall not yield!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> [:VENOMDRENCH, :Opposing],
	  :battler_1   	=> :Self,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Venom Drench",
	  :hp      		=> -4,
      :status  		=> :POISON
    },
    "defenderDamaged_foe_repeat_random" => {
	  :text      	=> "We shall conquer!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_DEFENSE, 1]
    },
  }
  
  ANOMALYCALLISTO_2 = {
    "attackerNVEdmg_foe_repeat_random" => {
	  :text      	=> "We shall prevail!",
	  :playsound 	=> "zbrrdy00",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1]
    },
    "defenderDamaged_foe_repeat_random" => {
	  :text      	=> "We cannot be stopped!",
	  :playsound 	=> "zbrrdy00",
      :battler 		=> :Opposing,
	  :anim    		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:SPECIAL_DEFENSE, -1]
    },
    "attackerDodged_foe_repeat_random" => {
	  :text      	=> "We shall consume your essence!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ACCURACY, 1]
    },
  }
  
  ANOMALYCALLISTO_3 = {
    "attackerDamaged_foe_repeat_random" => {
	  :text      	=> "Mmm... Fresh meat!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1]
    },
    "defenderDamaged_foe_repeat_random" => {
	  :text      	=> "I shall feed today!",
	  :playsound 	=> "zbryes02",
      :battler 		=> :Opposing,
	  :anim    		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:SPECIAL_DEFENSE, -1]
    },
    "attackerSEdmg_foe_repeat_random" => {
	  :text      	=> "We hunger, we feed!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> [:VENOMDRENCH, :Self],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Venom Drench",
	  :hp      		=> -4,
      :status  		=> :POISON
    },
  }

  #-----------------------------------------------------------------------------
  # Priest Leo and Selene in the Temple of Space (Team #0)
  # Permanent Reflect and Light Screen, Fire tick damage randomly on attack, Critical hits raise speed
  #-----------------------------------------------------------------------------

  EGANOMALY_CHRISTINA0 = {
    "turnCommand" => {
	  :speech  => [:Opposing, "The power of the void empowers us!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 99, "A sinister force set up Reflect on Christina's side of the field!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Opposing],
	  :team_1 => [
		[PBEffects::LightScreen, 99, "A sinister force set up Light Screen on Christina's side of the field!"],
	  ]
    },
    "defenderDamaged_foe_repeat_random" => {
	  :text  		=> "The power of the void will claim you!",
	  :battler 		=> :Self,
	  :anim     	=> [:DARKVOID, :Opposing],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was singed by the void!",
	  :playsound 	=> "Anim/PRSFX- Spite2",
	  :hp      		=> -8,
    },
    "attackerCrit_foe_repeat_random" => {
	  :text      	=> "You shall be assimilated!",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPEED, 1]
    },
  }
  
  EGANOMALY_CHRISTINA1 = {
    "turnCommand" => {
	  :speech  => [:Opposing, "Give up and surrender to our legions!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 99, "A sinister force set up Reflect on Christina's side of the field!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Opposing],
	  :team_1 => [
		[PBEffects::LightScreen, 99, "A sinister force set up Light Screen on Christina's side of the field!"],
	  ]
    },
    "attackerSEdmg_foe_repeat_random" => {
	  :text      	=> "It is only a matter of time before you capitulate!",
	  :battler 		=> :Self,
	  :anim     	=> [:GOOSEBUMP, :Opposing],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was cursed!",
	  :playsound_1 	=> "Anim/goosebump",
	  :hp      		=> -8,
    },
    "defenderHPLowLast_foe" => {
	  :speech      	=> [:Opposing, "The power of chaos shall defend this host's Pokemon!"],
	  :battler   	=> :Self,
	  :anim     	=> [:ELEGY, :Self],
	  :hp      		=> 2,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1, :SPECIAL_ATTACK, 1]
    },
  }
  
  EGANOMALY_CHRISTINA2 = {
    "turnCommand_repeat_random" => {
	  :speech      	=> [:Opposing, "I grow. I evolve. I adapt!"],
	  :battler   	=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE,1]
    },
    "defenderHPHalf_foe_repeat_random" => {
	  :text      	=> "The void shall claim you in due time!",
	  :battler 		=> :Self,
	  :anim     	=> [:GOOSEBUMP, :Opposing],
	  :battler_1   	=> :Opposing,
	  :anim_1  		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:ATTACK, -1, :SPECIAL_ATTACK, -1]
    },
    "attackerDodged_foe_repeat_random" => {
	  :text      	=> "You cannot escape the powers of chaos!",
	  :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPEED, 1, :ACCURACY, 1]
    },
  }
  
  EGANOMALY_CHRISTINA3 = {
    "attackerSEdmg_foe_repeat_random" => {
	  :text      	=> "Who dares resist the encroaching void?!",
	  :battler 		=> :Self,
	  :anim     	=> [:GOOSEBUMP, :Opposing],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was cursed!",
	  :playsound_1 	=> "Anim/goosebump",
	  :hp      		=> -8,
    },
    "defenderDamaged_foe_repeat_random" => {
	  :text      	=> "We can sustain ourselves without limit!",
	  :battler   	=> :Self,
	  :anim     	=> [:ELEGY, :Self],
	  :hp      		=> 8,
    },
    "attackerNVEdmg_foe_repeat_random" => {
	  :text      	=> "You shall make a fine host body!",
      :battler 		=> :Opposing,
	  :anim    		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:SPEED, -1]
    },
  }
  
  TWINS_TEMPLE0 = {
    "turnCommand" => {
	  :speech  => ["Palkia will light the way for us!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 99, "A force of light set up Reflect on the Twin Priests' side of the field!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Opposing],
	  :team_1 => [
		[PBEffects::LightScreen, 99, "A force of light set up Light Screen on the Twin Priests' side of the field!"],
	  ]
    },
    "defenderDamaged_foe_repeat_random" => {
	  :text  		=> "By fire be purged!",
	  :battler 		=> :Self,
	  :anim     	=> [:MYSTICALFIRE, :Opposing],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was singed by holy fire!",
	  :playsound 	=> "Anim/PRSFX- Spite2",
	  :hp      		=> -8,
    },
    "attackerCrit_foe_repeat_random" => {
	  :text      	=> "Palkia blesses us!",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPEED, 1]
    },
  }
  
  TWINS_TEMPLE1 = {
    "turnCommand" => {
	  :speech  => ["We fight for Lord Palkia! You shall not defile this temple, invader!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 99, "A force of light set up Reflect on the Twin Priests' side of the field!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Opposing],
	  :team_1 => [
		[PBEffects::LightScreen, 99, "A force of light set up Light Screen on the Twin Priests' side of the field!"],
	  ]
    },
    "attackerSEdmg_foe_repeat_random" => {
	  :text      	=> "Palkia fights on our side!",
	  :battler 		=> :Self,
	  :anim     	=> [:PURGE, :Opposing],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was smited!",
	  :playsound_1 	=> "Anim/handofgod",
	  :hp      		=> -8,
    },
    "defenderHPLowLast" => {
	  :speech      	=> ["Palkia! Save us!"],
	  :battler   	=> :Self,
	  :anim     	=> [:HALLOWEDGROUND, :Self],
	  :hp      		=> 2,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1, :SPECIAL_ATTACK, 1]
    },
  }
  
  TWINS_TEMPLE2 = {
    "turnCommand_repeat_random" => {
	  :speech      	=> ["Palkia! Protect us from evil!"],
	  :battler   	=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE,1]
    },
    "defenderHPHalf_foe_repeat_random" => {
	  :text      	=> "Palkia rebukes you!",
	  :battler 		=> :Self,
	  :anim     	=> [:PURGE, :Opposing],
	  :battler_1   	=> :Opposing,
	  :anim_1  		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:ATTACK, -1, :SPECIAL_ATTACK, -1]
    },
    "attackerDodged_foe_repeat_random" => {
	  :text      	=> "Palkia will guide us!",
	  :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPEED, 1, :ACCURACY, 1]
    },
  }
  
  TWINS_TEMPLE3 = {
    "attackerSEdmg_foe_repeat_random" => {
	  :text      	=> "Palkia fights on our side!",
	  :battler 		=> :Self,
	  :anim     	=> [:PURGE, :Opposing],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was smited!",
	  :playsound_1 	=> "Anim/handofgod",
	  :hp      		=> -8,
    },
    "defenderDamaged_foe_repeat_random" => {
	  :text      	=> "Your lack of faith shall be your undoing!",
	  :battler   	=> :Self,
	  :anim     	=> [:HALLOWEDGROUND, :Self],
	  :hp      		=> 8,
    },
    "attackerNVEdmg_foe_repeat_random" => {
	  :text      	=> "Palkia renders you vulnerable!",
      :battler 		=> :Opposing,
	  :anim    		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:SPEED, -1]
    },
  }

  TEST_BATTLE = {
    "turnCommand" => {
      :speech  => ["Haha, you won't be able to hit my Minccino!"],
	  :battler => :Opposing,
      :effects => [
        [PBEffects::Foresight, true, "Enemy Pokemon were identified!"],
      ],
	  :playsound => "Anim/PRSFX- Miracle Eye",
	  :anim    => [:MIRACLEEYE, :Self],
      :speech_1  => ["Hey, what the hell!? You can hit my Minccino now! No fair!"],
    },
    "turnCommand" => {
	  :speech  => [:Opposing, "Fine, time to cheat a little!"],
      :battler => :Opposing,
	  :anim => [:STEALTHROCK, :Self],
	  :team => [
        [PBEffects::StealthRock, true, "Pointed stones float in the air around {1}!"],
      ],
#	  :field => [ 
#		[PBEffects::TrickRoom, 99, "The dimensions were twisted!"],
#		[PBEffects::MagicRoom, 99, "All Pokémon's held items lost their effects!"],
#		[PBEffects::WonderRoom, 99, "Defense and Sp. Def stats are swapped"],
#		[PBEffects::Gravity, 99, "Gravity intensified!"],
#		]
	  :anim_1 => [:STICKYWEB],
	  :team_1 => [
        [PBEffects::StickyWeb, true, "You got sticky webbed!"],
      ],
    },
    "turnCommand_2" => {
      :speech  => [:Opposing, "Time to power up!"],
	  :battler_2 => :Opposing,
	  :stats   => [:DEFENSE, 2, :SPECIAL_DEFENSE, 2]
    },
#    "turnEnd" => {
#      :effects => [
#        [PBEffects::Foresight, true, "Enemy Pokemon were identified!"],
#      ],
#	  :playsound => "Anim/PRSFX- Miracle Eye",
#	  :anim    => [:MIRACLEEYE, :Opposing],
#      :speech  => ["Hey, what the hell!? You can hit my Minccino now! No fair!"],
#	  :stats   => [:DEFENSE, 2, :SPECIAL_DEFENSE, 2]
#    }    
  }
end
=end