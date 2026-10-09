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
      :speech_1  => [:Self, "What was that!? You can hit my Minccino now?!"],
    },
  }

  #-----------------------------------------------------------------------------
  # Jango in Europa Cave 2022-09-24
  # Standard: Increases Attack/Sp.Atk by 1 stage
  # Adept+: Stealth rock on entry
  #-----------------------------------------------------------------------------

  JANGO_EUROPA_CAVE_STD = {
    "turnCommand" => {
	  :speech  		=> [:Opposing, "I'm coming for you, pipsqueak!"],
      :battler   	=> :Opposing,
	  :anim      	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1, :SPECIAL_ATTACK, 1]
    },
  }

  JANGO_EUROPA_CAVE = {
    "turnCommand" => {
	  :speech  => [:Opposing, "Watch out for these jagged rocks!"],
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
  # Standard: Increase SpDef by 1 stage on entry
  # Adept+: Also sets 1 layer of Spikes
  #-----------------------------------------------------------------------------

  WESLEY_AURIGA_RESORT_STD = {
    "turnCommand" => {
	  :speech  		=> [:Opposing, "I'm toughening my Pokemon up against you!"],
      :battler   	=> :Opposing,
	  :anim      	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_DEFENSE, 1]
    },
  }

  WESLEY_AURIGA_RESORT = {
    "turnCommand" => {
      :speech          	=> [:Opposing, "I was ready for you!"],
      :battler     		=> :Opposing,
	  :anim         	=> [:SPIKES, :Opposing],
      :battler_1     	=> :Self,
      :team         	=> [
        [PBEffects::Spikes, 1, "Wesley threw down a layer of spikes on your side of the field!"],
      ],
    },
  }
  
  #-----------------------------------------------------------------------------
  # Artie in Lyra City
  # Standard: Hailing in battle, Artie gets SpDef +1
  # Adept+: Hailing in battle; Initial hit for 25% life and confusion, Artie gets SpDef +1
  #-----------------------------------------------------------------------------

  ARTIE_LYRA_CITY_STD = {
    "turnCommand" => {
	  :speech    	=> [:Opposing, "Aww jeez, I hate it when it hails! I need to get my Special Defense up!"],
      :battler   	=> :Opposing,
	  :anim      	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_DEFENSE, 1]
    },
  }

  ARTIE_LYRA_CITY = {
    "turnCommand" => {
	  :speech    	=> [:Opposing, "Aww jeez, I hate it when it hails!"],
	  :battler   	=> :Self,
	  :text      	=> "{1} was struck on the head by a large chunk of hail!",
	  :playsound 	=> "Mining hammer",
	  :hp      		=> -8,
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
  # Standard: Slows you down by 1 stage
  # Adept: Hailing in battle and set in rules already, Increases Attack by 1
  #-----------------------------------------------------------------------------

  MAX_TRITON_CAVE_STD = {
    "turnCommand" => {
      :speech  		=> [:Opposing, "I'm tired of your interfering!"],
	  :battler       => :Opposing,
      :anim          => [:ICYWIND, :Opposing],
	  :battler_1     => :Self,
	  :anim_1        => "Common:StatDown",
	  :playsound     => "Anim/decrease",
	  :stats         => [:SPEED, -1],
      :text          => "The icy wind lowered your speed!"
    },
  }

  MAX_TRITON_CAVE = {
    "turnCommand" => {
	  :speech  		=> [:Opposing, "I'm tired of your interfering!"],
      :battler 		=> :Opposing,
	  :anim    		=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats   		=> [:ATTACK, 1],
	  :speech_1  	=> [:Self, "You'll never get us in the hail!"],
    },
  }

  #-----------------------------------------------------------------------------
  # Artie in front of Telescopium Academy
  # Standard: Artie gets Def and SpDef +1
  # Adept+: Artie gets Def and SpDef +1
  #-----------------------------------------------------------------------------

  ARTIE_ACADEMY_STD = {
    "turnCommand" => {
	  :speech    	=> [:Opposing, "I'm ready for you!"],
      :battler   	=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1]
    },
  }
  
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
  # Level 22 Espurr with Tormented Ability, knows Crunch, Adamant nature, 31 IVs
  #-----------------------------------------------------------------------------

=begin
# The original setup of the Espurr.
	WildBattle.dx_start([:ESPURR, 22], {:outcome => 73 }, {
		:ability => 2, # Tormented
		:moves   => :CRUNCH,
		:nature  => :ADAMANT,		
		:ivs     => 31,
	})
=end

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
  # Team 0: Trick Room (Standard: you also get -1 Speed).
  # Team 1: 1/16 HP drain at the end of every turn for five turns (Adept: 1/8 and doesn't run out).
  # Team 2: Enemy gets +1 SpAtk/Spe (Adept: enemy +1 SpAtk/Spe on entry for 5 turns).
  # Team 3: You get -1 Def/SpDef (Adept: you get -1 Def/SpDef every 3 turns).
  #-----------------------------------------------------------------------------

  HEADMASTER_ACADEMY0_STD = {
    "turnCommand" => {
      :speech  		 => [:Opposing, "I wish to test your strength!"],
	  :anim          => [:TRICKROOM],
	  :playsound 	=> "Anim/PRSFX- Trick Room",
	  :battler_1     => :Self,
	  :anim_1        => "Common:StatDown",
	  :playsound     => "Anim/decrease",
	  :stats         => [:SPEED, -1],
      :text          => "An ethereal force slowed you down!"
    },
  }

  HEADMASTER_ACADEMY1_STD = {
    "turnCommand" => {
	  :speech    	 => [:Opposing, "Why won't you leave me alone!"],
	  :text    		=> "Maurizio's regrets summon a ghastly aura that constantly saps your health and replenishes the opponents' for five turns!",	  
	  :anim     	=> [:PERISHSONG],
    },
	"turnEnd_repeat" => {	  
	  :ignore   	=> "turnCommand_6",
	  :battler   	=> :Self,
	  :anim     	=> [:DREAMEATER, :Self],
	  :playsound 	=> "Anim/goosebump",
	  :hp      		=> -16,	  
	  :battler_1 	=> :Opposing,
	  :hp_1     		=> 16,
    },
  }

  HEADMASTER_ACADEMY2_STD = {
    "turnCommand" => {
	  :speech    	=> [:Opposing, "Show me what you got!"],
      :battler   	=> :Opposing,
	  :anim_1     	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1, :SPEED, 1]
    },
  }
  
  HEADMASTER_ACADEMY3_STD = {
    "turnCommand" => {
	  :speech    	=> [:Opposing, "I ought to teach you a lesson!"],
      :battler   	=> :Self,
	  :anim_1         => "Common:StatDown",
	  :playsound     => "Anim/decrease",
	  :stats     	=> [:DEFENSE, -1, :SPECIAL_DEFENSE, -1]
    },
  }

  #-----------------------------------------------------------------------------
 
  HEADMASTER_ACADEMY0 = {
    "turnCommand" => {
	  :speech    	=> [:Opposing, "I am going to re-orient your perception of reality!"],
	  :anim     	=> [:TRICKROOM],
	  :playsound 	=> "Anim/PRSFX- Trick Room",
	  :field => [ 
		[PBEffects::TrickRoom, 5, "The dimensions were twisted!"],
		],
    },
  }

  HEADMASTER_ACADEMY1 = {
    "turnCommand" => {
	  :speech    	 => [:Opposing, "Why won't you leave me alone!"],
	  :text    		=> "Maurizio's regrets summon a ghastly aura that constantly saps your health and replenishes the opponents'!",	  
	  :anim     	=> [:PERISHSONG],
    },
	"turnEnd_repeat" => {	  
	  :battler   	=> :Self,
	  :anim     	=> [:DREAMEATER, :Self],
	  :playsound 	=> "Anim/goosebump",
	  :hp      		=> -8,	  
	  :battler_1 	=> :Opposing,
	  :hp_1     		=> 8,
    },
  }

  HEADMASTER_ACADEMY2 = {
    "turnCommand" => {
	  :speech    	=> [:Opposing, "Show me what you got!"],	  
	  :text    		=> "Maurizio invokes a magic circle that buffs his pokemon on entry for five turns!",
	  :anim         => [:LUCKYCHANT, :Opposing],	  
      :battler   	=> :Opposing,
	  :anim_1     	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1, :SPEED, 1]
    },
	"switchSentOut_foe_repeat" => {	  
	  :ignore   	=> "turnEnd_5",
	  :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1, :SPEED, 1]
    },
	"turnEnd_5" => {	
	  :text    	=> "The magic circle fizzles and disappears!"
	},
  }
  
  HEADMASTER_ACADEMY3 = {
    "turnCommand" => {
	  :speech    	=> [:Opposing, "I ought to teach you a lesson!"],	  
	  :text    		=> "Maurizio conjures a dark mist that lowers your defenses every three turns!",
	  :anim         => [:HAZE, :Self],
      :battler   	=> :Self,
	  :anim_1         => "Common:StatDown",
	  :playsound     => "Anim/decrease",
	  :stats     	=> [:DEFENSE, -1, :SPECIAL_DEFENSE, -1]
    },
	"turnEnd_every_3" => {	 
	  :battler   	=> :Self,
	  :anim         => [:HAZE, :Self],
	  :anim_1        => "Common:StatDown",
	  :playsound     => "Anim/decrease",
	  :stats     	=> [:DEFENSE, -1, :SPECIAL_DEFENSE, -1]
    },
  }

  #-----------------------------------------------------------------------------
  # Artie in front of Orion Central City
  # Standard: Artie raises Defense by 1 stage. 
  # Adept+: Artie sets up 5 turns of Reflect 
  #-----------------------------------------------------------------------------

  ARTIE_ORION_STD = {
    "turnCommand" => {
	  :speech    	=> [:Opposing, "I'm ready for you!"],
      :battler   	=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1]
    },
  }

  ARTIE_ORION = {
    "turnCommand" => {
	  :speech  => [:Opposing, "I'm putting up some protection for my team!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 5, "Artie used Reflect!"]
	  ]
    },
  }

  #-----------------------------------------------------------------------------
  # Rakanishu the Fallen Demon
  # Level 25 T.Morgrem with Irredeemable Ability, knows Brutal Swing, Adamant nature, 31 IVs
  # Standard: Takes off 1/8 life. Harsh Sun Weather (set up in event code)
  # Adept+: Burns you and takes off 1/8 life. Harsh Sun Weather (set up in event code)
  #-----------------------------------------------------------------------------

  MASTER_PRISON_STD = {
    "turnCommand" => {
	  :anim     	=> [:SUNNYDAY],
	  :text    		=> "The sun shall bolster me! Burn, burn, BURN!!!",
	  :battler 		=> :Opposing,
	  :anim_1     	=> [:MYSTICALFIRE, :Opposing],
	  :battler_1   	=> :Self,
	  :text_1      	=> "{1} was burned by hellfire!",
	  :playsound 	=> "Anim/PRSFX- Spite2",
	  :hp      		=> -8
    },
  }

  MASTER_PRISON = {
    "turnCommand" => {
	  :anim     	=> [:SUNNYDAY],
	  :text    		=> "The sun shall bolster me! Burn, burn, BURN!!!",
	  :battler 		=> :Opposing,
	  :anim_1     	=> [:MYSTICALFIRE, :Opposing],
	  :battler_1   	=> :Self,
	  :text_1      	=> "{1} was burned by hellfire!",
	  :playsound 	=> "Anim/PRSFX- Spite2",
	  :hp      		=> -8,
      :status  		=> :BURN
    },
  }

  #-----------------------------------------------------------------------------
  # Les Miserables Worker Kramer
  # Standard: Enemy Evasion up on entry
  # Adept+: Enemy evasion up on entry and confuses you
  #-----------------------------------------------------------------------------

  LES_MISERABLES_STD = {
    "turnCommand" => {
	  :speech         	=> [:Opposing, "Smoke bomb! Let's see you try and hit me after this!"],
	  :battler 			=> :Opposing, # Because the animation for smokescreen is stupid
	  :anim     		=> [:SMOKESCREEN, :Self],
	  :playsound 		=> "Anim/PRSFX- Smokescreen",
	  :anim_1     		=> "Common:StatUp",
	  :stats     		=> [:EVASION, 1],	  
    },
  }

  LES_MISERABLES = {
    "turnCommand" => {
	  :speech         	=> [:Opposing, "Smoke bomb! Let's see you try and hit me after this!"],
	  :battler 			=> :Opposing, # Because the animation for smokescreen is stupid
	  :anim     		=> [:SMOKESCREEN, :Self],
	  :playsound 		=> "Anim/PRSFX- Smokescreen",
	  :anim_1     		=> "Common:StatUp",
	  :stats     		=> [:EVASION, 1],	  
    },
    "turnCommand_1" => {
	  :speech    	=> [:Self, "I'll stop you in your tracks!"],
	  :battler   	=> :Self,
	  :text      	=> "The henchmen threw a large box at {1}, striking it on its head!",
	  :playsound 	=> "Mining hammer",
	  :hp      		=> -8,
      :status  		=> :CONFUSION
    },
  }

  #-----------------------------------------------------------------------------
  # Drug Trail Gangster Boss
  # Standard: Poisons you on entry
  # Adept+: Toxic Spikes on entry
  #-----------------------------------------------------------------------------

  DRUG_TRAIL_STD = {
    "turnCommand" => {
      :speech  		=> [:Opposing, "I don't fight fair!"],
	  :battler       => :Opposing,
	  :anim     	=> [:VENOMDRENCH, :Opposing],
	  :battler_1   	=> :Self,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Venom Drench",
      :status  		=> :POISON
    },
  }

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
  # Standard: Sets up 1 layer of spikes on entry
  # Adept+: Sets up 3 layers of spikes on entry, Ingrain on self
  #-----------------------------------------------------------------------------

  ANOMALY_SWALOT_STD = {
    "turnCommand" => {
      :text          	=> "YOU. SHALL. NOT. FLEE.",
      :battler   		=> :Opposing,
	  :anim         	=> [:SPIKES, :Opposing],
      :battler_1   		=> :Self,
      :team         	=> [
        [PBEffects::Spikes, 1, "The Anomaly covered your side of the field in Spikes!"],
      ],
    },
  }

  ANOMALY_SWALOT = {
    "turnCommand" => {
      :text          	=> "I. AM. INFALLIBLE.",
      :battler         	=> :Opposing,
      :anim         	=> [:INGRAIN, :Self],
      :playsound     	=> "Anim/PRSFX- Ingrain1",
      :effects 			=> [[PBEffects::Ingrain, true]],
      :text_1          	=> "YOU. SHALL. NOT. FLEE.",
      :anim_1         	=> [:SPIKES, :Opposing],
      :battler_1     	=> :Self,
      :team_1         	=> [
        [PBEffects::Spikes, 3, "The Anomaly covered your side of the field in Spikes!"],
      ],
    },
  }

  #-----------------------------------------------------------------------------
  # Artie on Route 6A
  # Standard: Artie raises Defense by 1 stage.
  # Adept+: Artie sets up 5 turns of Reflect 
  #-----------------------------------------------------------------------------

  ARTIE_6A_STD = {
    "turnCommand" => {
	  :speech    	=> [:Opposing, "I'm ready for you!"],
      :battler   	=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1]
    },
  }

  ARTIE_6A = {
    "turnCommand" => {
	  :speech  => [:Opposing, "I'm putting up some protection for my team!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 5, "Artie used Reflect!"]
	  ]
    },
  }
  
  #-----------------------------------------------------------------------------
  # Christina fights you in Fornax Town Hall
  # Standard: Christina sets up a smoke bomb that raises evasion by 1 stage
  # Adept+: Christina sets up a smoke bomb that raises evasion by 1 stage, Turn 2 is a cheap shot that lowers your Atk and SpAtk by 1
  #-----------------------------------------------------------------------------

  CHRISTINA_FORNAX_TOWN_STD = {
    "turnCommand" => {
	  :speech         	=> [:Opposing, "Smoke bomb! Let's see you try and hit me after this!"],
	  :battler 			=> :Opposing, # Because the animation for smokescreen is stupid
	  :anim     		=> [:SMOKESCREEN, :Self],
	  :playsound 		=> "Anim/PRSFX- Smokescreen",
	  :anim_1     		=> "Common:StatUp",
	  :stats     		=> [:EVASION, 1],	  
    },
  }

  CHRISTINA_FORNAX_TOWN = {
    "turnCommand" => {
	  :speech         	=> [:Opposing, "Smoke bomb! Let's see you try and hit me after this!"],
	  :battler 			=> :Opposing, # Because the animation for smokescreen is stupid
	  :anim     		=> [:SMOKESCREEN, :Self],
	  :playsound 		=> "Anim/PRSFX- Smokescreen",
	  :anim_1     		=> "Common:StatUp",
	  :stats     		=> [:EVASION, 1],	  
    },
    "turnCommand_1" 	=> {
      :speech        		=> [:Self, "I don't fight fair!"],
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
  # T.Gothitelle Avatar in Indus Shrine
  # Level 36 T.Gothitelle (doubles) with her team
  #-----------------------------------------------------------------------------

  RUINED_RIDDLES_STD = {
    "turnCommand" => {
      :text        	 => "You shall never escape this place!",
	  :battler       => :Opposing,
      :anim          => [:CURSE, :Opposing],
      :playsound     => "Anim/Curse",
	  :battler_1     => :Self,
	  :anim_1        => "Common:StatDown",
	  :playsound_1   => "Anim/decrease",
	  :stats_1       => [:SPEED, -1],
      :text_1        => "The Avatar of T.Gothitelle petrified you, lowering your speed!"
    },
  }

  RUINED_RIDDLES = {
    "turnCommand" => {
      :text        	 => "You shall never escape this place!",
	  :battler       => :Opposing,
      :anim          => [:CURSE, :Opposing],
      :playsound     => "Anim/Curse",
	  :battler_1     => :Self,
	  :anim_1        => "Common:StatDown",
	  :playsound_1   => "Anim/decrease",
	  :stats_1       => [:SPEED, -1],
      :text_1        => "The Avatar of T.Gothitelle petrified you, lowering your speed!"
    },
    "turnCommand_1" => {
	  :speech    	=> [:Opposing, "The flame will consume you!"],
	  :battler 		=> :Opposing,
	  :anim     	=> [:MYSTICALFIRE, :Opposing],
	  :battler_1   	=> :Self,
	  :text      	=> "{1} was burned by soul fire!",
	  :playsound 	=> "Anim/PRSFX- Spite2",
	  :hp      		=> -8,
      :status  		=> :BURN
    },
  }

  #-----------------------------------------------------------------------------
  # Priestess Sienna in the Temple of Time (Team #0)
  # Standard: Boosts Def/SpDef by 1
  # Adept+: Reflect and Light Screen
  #-----------------------------------------------------------------------------

  SIENNA_TEMPLE0_STD = {
    "turnCommand" => {
	  :speech    	=> [:Opposing, "Dialga shields me against evil!"],
      :battler   	=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1]
    },
  }

  SIENNA_TEMPLE0 = {
    "turnCommand" => {
	  :speech  => [:Opposing, "Dialga shields me against evil!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 5, "A force of light set up Reflect on Sienna's side of the field!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Opposing],
	  :team_1 => [
		[PBEffects::LightScreen, 5, "A force of light set up Light Screen on Sienna's side of the field!"],
	  ]
    },
  }

  #-----------------------------------------------------------------------------
  # Priestess Sienna in the Temple of Time (Team #1)
  # Standard: Smites you with holy fire (i.e. a burn and lose 12.5% of life)
  # Adept+: Smites you with holy fire (i.e. a burn and lose 12.5% of life), and deals 1/8th to all mons you switch in
  #-----------------------------------------------------------------------------

  SIENNA_TEMPLE1_STD = {
    "turnCommand" => {
	  :speech    	=> [:Opposing, "Dialga watches over me. Who watches over you, infidel?"],
	  :battler 		=> :Opposing,
	  :anim     	=> [:MYSTICALFIRE, :Opposing],
	  :battler_1   	=> :Self,
	  :text      	=> "{1} was burned by a flicker of holy flame!",
	  :playsound 	=> "Anim/PRSFX- Spite2",
	  :hp      		=> -8,
      :status  		=> :BURN
    },
  }

  SIENNA_TEMPLE1 = {
    "turnCommand" => {
	  :speech    	=> [:Opposing, "Dialga watches over me. Who watches over you, infidel?"],
	  :battler 		=> :Opposing,
	  :anim     	=> [:MYSTICALFIRE, :Opposing],
	  :battler_1   	=> :Self,
	  :text      	=> "{1} was burned by a flicker of holy flame!",
	  :playsound 	=> "Anim/PRSFX- Spite2",
	  :hp      		=> -8,
      :status  		=> :BURN,
	  :text_1      	=> "The leftover flames will hurt any Pokémon you send in!",
    },
	"switchSentOut_repeat" => {	  
	  :battler   	=> :Self,
	  :anim     	=> [:EMBER, :Self],
	  :playsound 	=> "Anim/PRSFX- Spite2",
	  :hp      		=> -8
    },
  }

  #-----------------------------------------------------------------------------
  # Priestess Sienna in the Temple of Time (Team #2)
  # Standard: Boosts Def/SpDef by 1
  # Adept+: Raining in battle (refer to battle initiation command for this); Boosts defense + spdef and gains Aqua Ring; Aqua Ring is reapplied on any switch in.
  #-----------------------------------------------------------------------------

  SIENNA_TEMPLE2_STD = {
    "turnCommand" => {
	  :speech    			=> [:Opposing, "Lord Dialga will wash away my sins with purifying rain!"],
      :battler   			=> :Opposing,
	  :anim     			=> "Common:StatUp",
	  :playsound 			=> "Anim/increase",
	  :stats     			=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1]
    },
  }

  SIENNA_TEMPLE2 = {
    "turnCommand" => {
	  :speech    			=> [:Opposing, "Lord Dialga will wash away my sins with purifying rain!"],
      :battler   			=> :Opposing,
	  :anim     			=> "Common:StatUp",
	  :playsound 			=> "Anim/increase",
	  :stats     			=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1],
	  :text      	=> "Healing waters envelop all of Sienna's Pokémon!",
	  :battler_1         	=> :Opposing,
      :anim_1         	=> [:AQUARING, :Self],
      :effects 			=> [[PBEffects::AquaRing, true]]
    },
	"switchSentOut_foe_repeat" => {	  
	  :battler         	=> :Self,
      :anim         	=> [:AQUARING, :Self],
      :effects 			=> [[PBEffects::AquaRing, true]]
    },
  }

  #-----------------------------------------------------------------------------
  # Priestess Sienna in the Temple of Time (Team #3)
  # Standard: Attack and Speed boost
  # Adept+: Attack and Speed boost, and Curses you at the end of every 3rd turn
  #-----------------------------------------------------------------------------
 
  SIENNA_TEMPLE3_STD = {
    "turnCommand" => {
	  :speech    	=> [:Opposing, "I am one with the jungle!"],
      :battler   	=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1, :SPEED, 1]
    },
  }

  SIENNA_TEMPLE3 = {
    "turnCommand" => {
	  :speech    	=> [:Opposing, "I am one with the jungle!"],
      :battler   	=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1, :SPEED, 1],
	  :speech_1    	=> [:Opposing, "Spirits of the jungle, heed my call!"],
	  :text      	=> "The jungle spirits will Curse you every three turns!",	 
    },
	"turnEnd_every_3" => {	
	  :battler 		=> :Self,
	  :anim     	=> [:CURSE, :Self],
	  :playsound 	=> "Anim/PRSFX- Curse",
      :effects	 	=> [[PBEffects::Curse, true]],
    },
  }

  #-----------------------------------------------------------------------------
  # Artie on Route 5B
  # Standard: Artie boosts Special Attack/Speed by 1 stage.
  # Adept+: Artie boosts Special Attack by 1 stage and Tailwind.
  #-----------------------------------------------------------------------------

  ARTIE_5B_STD = {
    "turnCommand" => {
	  :speech    	=> [:Opposing, "My team needs some liquid courage!"],
      :battler   	=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1, :SPEED, 1]
    },
  }

  ARTIE_5B = {
    "turnCommand" => {
	  :speech    		=> [:Opposing, "My team needs some liquid courage!"],
      :battler   		=> :Opposing,
	  :anim     		=> "Common:StatUp",
	  :playsound 		=> "Anim/increase",
	  :stats     		=> [:SPECIAL_ATTACK, 1],
      :anim_1         	=> [:TAILWIND, :Opposing],
	  :team => [ 
		[PBEffects::Tailwind, 4, "The wind is blowing in Artie's team's favour!"],
		]
    },
  }
  
  #-----------------------------------------------------------------------------
  # Contraband Technology Side Quest
  # Thunder Wave, lower defenses and take off 1/8 life.
  # Enraged Pokemon will lower your attacking stats
  #-----------------------------------------------------------------------------

  CONTRABAND_TECH = {
    "turnCommand" => {
	  :speech    		=> [:Opposing, "After I am finished with you, I will steal your identity for daring to trifle with me!"],
	  :battler   		=> :Self,
	  :anim	        	=> [:THUNDERWAVE, :Self],
	  :hp      			=> -8,
      :status  			=> [:PARALYSIS, true],
	  :anim_1        	=> "Common:StatDown",
	  :playsound_1   	=> "Anim/decrease",
	  :stats_1       	=> [:DEFENSE, -1, :SPECIAL_DEFENSE, -1],
	  :text_1    		=> "Your defenses fall and you are paralyzed!",
    },
  }
  
  CONTRABAND_TECH_ENRAGED = {
    "turnCommand" => {
	  :text	    		=> "The enraged Pokemon intimidate you!",
	  :battler   		=> :Self,
	  :anim_1        	=> "Common:StatDown",
	  :playsound_1   	=> "Anim/decrease",
	  :stats_1       	=> [:ATTACK, -1, :SPECIAL_ATTACK, -1],
    },
  }
  
  #-----------------------------------------------------------------------------
  # Family Affairs Side Quest
  # Takes off 1/8 of your life and lower speed
  #-----------------------------------------------------------------------------

  FAMILY_AFFAIRS = {
    "turnCommand" => {
	  :speech    		=> [:Opposing, "I will break your legs, punk!"],
	  :battler   		=> :Self,
	  :anim	        	=> [:BRICKBREAK, :Self],
	  :hp      			=> -8,
	  :anim_1        	=> "Common:StatDown",
	  :playsound_1   	=> "Anim/decrease",
	  :stats_1       	=> [:SPEED, -1],
	  :text_1    		=> "The Gang Leader slows you down!",
    },
  }
  
  #-----------------------------------------------------------------------------
  # Anomaly Battles in Caverns of Rhea
  # Various
  #-----------------------------------------------------------------------------

  ANOMALY_0 = {
    "attackerDamaged_foe_random" => {
	  :text      	=> "Leyline Crystals! So delicious!",
	  :playsound 	=> "zbrrdy00",
	  :text_1      	=> "The Anomaly consumed a leyline crystal!",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1]
    },
    "attackerCrit_foe_random" => {
	  :text      	=> "We are legion!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1]
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
    "attackerSEdmg_foe_random" => {
	  :text      	=> "We know your weakness!",
	  :playsound 	=> "zbrrdy00",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1]
    },
    "switchSentOut_foe_random" => {
	  :text      	=> "We shall not yield!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Self,
	  :anim     	=> [:VENOMDRENCH, :Opposing],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Venom Drench",
	  :hp      		=> -8,
      :status  		=> :POISON
    },
    "defenderDamaged_foe_random" => {
	  :text      	=> "*hiss*",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1]
    },
  }
  
  ANOMALY_2 = {
    "attackerNVEdmg_foe_random" => {
	  :text      	=> "We shall find your weakness!",
	  :playsound 	=> "zbrrdy00",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1]
    },
    "defenderDamaged_foe_random" => {
	  :text      	=> "We are an endless tide!",
	  :playsound 	=> "zbrrdy00",
      :battler 		=> :Opposing,
	  :anim    		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:SPECIAL_DEFENSE, -1]
    },
    "attackerDodged_foe_random" => {
	  :text      	=> "You can run, but you cannot hide!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ACCURACY, 1]
    },
  }
  
  ANOMALY_3 = {
    "attackerDamaged_foe_random" => {
	  :text      	=> "Fear us!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1]
    },
    "defenderDamaged_foe_random" => {
	  :text      	=> "We are an endless tide!",
	  :playsound 	=> "zbryes02",
      :battler 		=> :Opposing,
	  :anim    		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:SPECIAL_DEFENSE, -1]
    },
    "attackerSEdmg_foe_random" => {
	  :text      	=> "We are impervious!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> [:VENOMDRENCH, :Self],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Venom Drench",
	  :hp      		=> -8,
      :status  		=> :POISON
    },
  }

  #-----------------------------------------------------------------------------
  # Anomaly Galvantula
  # Standard: Sets up poisonous substance on entry.
  # Adept+: Sets up toxic spikes on entry, +Def/SpDef +1, +1 Speed on crit
  #-----------------------------------------------------------------------------

  ANOMALY_GALVANTULA_STD = {
    "turnCommand" => {
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :text      	=> "YOU. SHALL. NOT. FLEE.",
	  :anim 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team 		=> [
        [PBEffects::ToxicSpikes, 1, "The Anomaly drenched your side of the field in a poisonous substance!"],
      ],
    },
  }

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
    "attackerCrit_foe_random" => {
	  :text      	=> "We are legion!",
	  :playsound 	=> "zbrrdy00",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1]
    },
  }

  #-----------------------------------------------------------------------------
  # Moby the Whale in Route 9B Underwater
  # Level 46 Wailord with Cursed Body Ability, knows Dark Pulse, Modest nature, 31 IVs
  #-----------------------------------------------------------------------------

=begin
# The original setup of the Pokemon.
	WildBattle.dx_start([:WAILORD, 46], {:outcome => 73 }, {
		:ability => 2, # Tormented
		:name    => "Moby",
		:moves   => :DARKPULSE,
		:nature  => :MODEST,		
		:ivs     => 31,
	}, 
:WHALE_HUNTING)
=end

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
    "defenderDamaged_foe_random" => {
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
  # Standard: Artie increases Evasion and Accuracy by 1 stage.
  # Adept+: Artie increases Evasion, Attack and Accuracy by 1 stage.
  #-----------------------------------------------------------------------------

  ARTIE_OASIS_STD = {
    "turnCommand" => {
	  :speech    	=> [:Opposing, "Ugh! The sand is making it hard for me to see you but it means you'll have the same issue!"],
      :battler   	=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:EVASION, 1, :ACCURACY, 1]
    },
  }

  ARTIE_OASIS = {
    "turnCommand" => {
	  :speech    	=> [:Opposing, "Ugh! The chip damage from this damn sand is annoying. I can work with it though!"],
      :battler   	=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1, :EVASION, 1, :ACCURACY, 1]
    },
  }

  #-----------------------------------------------------------------------------
  # Anomaly Battles in Temple of Space
  # Various
  #-----------------------------------------------------------------------------

  ANOMALYSPACE_0 = {
    "attackerDamaged_foe_random" => {
	  :text      	=> "Regenerate vitality!",
	  :playsound 	=> "zbrrdy00",
	  :text_1      	=> "The Anomaly gathered its energy!",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1]
    },
    "attackerCrit_foe_random" => {
	  :text      	=> "Chaos reigns!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1]
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
    "attackerSEdmg_foe_random" => {
	  :text      	=> "You can run but you cannot hide!",
	  :playsound 	=> "zbrrdy00",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1]
    },
    "switchSentOut_foe_random" => {
	  :text      	=> "We shall not yield!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Self,
	  :anim     	=> [:VENOMDRENCH, :Opposing],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Venom Drench",
	  :hp      		=> -8,
      :status  		=> :POISON
    },
    "defenderDamaged_foe_random" => {
	  :text      	=> "Your reality is ours!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_DEFENSE, 1]
    },
  }
  
  ANOMALYSPACE_2 = {
    "attackerNVEdmg_foe_random" => {
	  :text      	=> "We shall prevail!",
	  :playsound 	=> "zbrrdy00",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1]
    },
    "defenderDamaged_foe_random" => {
	  :text      	=> "We cannot be stopped!",
	  :playsound 	=> "zbrrdy00",
      :battler 		=> :Opposing,
	  :anim    		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:SPECIAL_DEFENSE, -1]
    },
    "attackerDodged_foe_random" => {
	  :text      	=> "We shall catch you!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ACCURACY, 1]
    },
  }
  
  ANOMALYSPACE_3 = {
    "attackerDamaged_foe_random" => {
	  :text      	=> "The Anomalies come for your world!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1]
    },
    "defenderDamaged_foe_random" => {
	  :text      	=> "We cannot be defeated!",
	  :playsound 	=> "zbryes02",
      :battler 		=> :Opposing,
	  :anim    		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:SPECIAL_DEFENSE, -1]
    },
    "attackerSEdmg_foe_random" => {
	  :text      	=> "We hunger, we feed!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> [:VENOMDRENCH, :Self],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Venom Drench",
	  :hp      		=> -8,
      :status  		=> :POISON
    },
  }

  #-----------------------------------------------------------------------------
  # Anomaly Arbok
  # Standard: Sets up stealth rock on entry
  # Adept+: Sets up stealth rock on entry, +1 Def/SpDef. Caustic substance
  #-----------------------------------------------------------------------------

  ANOMALY_ARBOK_STD = {
    "turnCommand" => {
	  :playsound 	=> "zbrrdy00",
	  :text      	=> "YOU. SHALL. NOT. ESCAPE.",
	  :battler		=> :Opposing,
	  :anim 		=> [:STEALTHROCK, :Opposing],
	  :battler_1 	=> :Self,
	  :team_1 		=> [
        [PBEffects::StealthRock, true, "Pointed stones float in the air around {1}!"],
      ],
    },
  }

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
    "attackerSEdmg_foe_random" => {
	  :text      	=> "We hunger, we feed!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> [:VENOMDRENCH, :Self],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Venom Drench",
	  :hp      		=> -8,
      :status  		=> :POISON
    },
  }

  #-----------------------------------------------------------------------------
  # Priest Leo and Selene in the Temple of Space (Team #0)
  # Standard: Reflect and Light Screen (3 turns)
  # Adept+: Reflect and Light Screen (5 turns), ally takes 1/8th tick damage once on taking damage, enemies raise their Speed when they land crits
  #-----------------------------------------------------------------------------

  TWINS_TEMPLE0_STD = {
    "turnCommand" => {
	  :speech  => [:Opposing, "Giratina shields us!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 3, "A sinister force set up Reflect on the Twin Priests' side of the field!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Opposing],
	  :team_1 => [
		[PBEffects::LightScreen, 3, "A sinister force set up Light Screen on the Twin Priests' side of the field!"],
	  ]
    },
  }

  TWINS_TEMPLE0 = {
    "turnCommand" => {
	  :speech  => [:Opposing, "Giratina shields us!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 5, "A sinister force set up Reflect on the Twin Priests' side of the field!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Opposing],
	  :team_1 => [
		[PBEffects::LightScreen, 5, "A sinister force set up Light Screen on the Twin Priests' side of the field!"],
	  ]
    },
    "defenderDamaged_foe" => {
	  :speech  => [:Opposing, "By fire be purged!"],
	  :battler 		=> :Self,
	  :anim     	=> [:MYSTICALFIRE, :Opposing],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was singed by shadowy flames!",
	  :playsound 	=> "Anim/PRSFX- Spite2",
	  :hp      		=> -8,
    },
    "attackerCrit_foe" => {
	  :speech  => [:Opposing, "Giratina, grant us speed!"],
	  :text      	=> "Enemies become faster upon landing crits!",
    },
    "attackerCrit_foe_repeat" => {
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPEED, 1],
    },
  }

  #-----------------------------------------------------------------------------
  # Priest Leo and Selene in the Temple of Space (Team #1)
  # Standard: Reflect and Light Screen (3 turns)
  # Adept+: Reflect and Light Screen (5 turns), 1/8th damage to you when they attack once randomly, Atk/SpAtk boost on final team member.
  #-----------------------------------------------------------------------------
  
  TWINS_TEMPLE1_STD = {
    "turnCommand" => {
	  :speech  => [:Opposing, "We fight for Lord Giratina now! We are his avatars, invader!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 3, "A sinister force set up Reflect on the Twin Priests' side of the field!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Opposing],
	  :team_1 => [
		[PBEffects::LightScreen, 3, "A sinister force set up Light Screen on the Twin Priests' side of the field!"],
	  ]
    },
  }

  TWINS_TEMPLE1 = {
    "turnCommand" => {
	  :speech  => [:Opposing, "We fight for Lord Giratina now! We are his avatars, invader!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 5, "A sinister force set up Reflect on the Twin Priests' side of the field!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Opposing],
	  :team_1 => [
		[PBEffects::LightScreen, 5, "A sinister force set up Light Screen on the Twin Priests' side of the field!"],
	  ]
    },
    "attackerDamaged_foe_random" => {
	  :speech      	=> [:Self, "Giratina empowers us!"],
	  :anim     	=> [:GOOSEBUMP, :Opposing],
	  :battler   	=> :Opposing,
	  :text      	=> "{1} was cursed!",
	  :playsound 	=> "Anim/goosebump",
	  :hp      		=> -8,
    },
    "switchSentOutLast_foe" => {
	  :speech      	=> [:Self, "Giratina! Save us!"],
	  :battler   	=> :Self,
	  :anim     	=> [:ELEGY, :Self],
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1, :SPECIAL_ATTACK, 1],
    },
  }

  #-----------------------------------------------------------------------------
  # Priest Leo and Selene in the Temple of Space (Team #2)
  # Standard: Def/SpDef Boost on both enemies, enemy SpAtk boost on 50% HP once, Acc boost if enemy dodges once.
  # Adept+: Def/SpDef Boost on both enemies, Atk/SpAtk boost each time an enemy drops to 50% HP (except last one), Spe/Acc boost on final team member.
  #-----------------------------------------------------------------------------

  TWINS_TEMPLE2_STD = {
    "turnCommand" => {
	  :speech      	=> [:Opposing, "Giratina! We are your avatars!"],
	  :battler   	=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1],	  
	  :battler_1 	=> :OpposingAlly,
	  :anim_1     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats_1     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1]
    },
    "defenderHPHalf_foe" => {
	  :speech      	=> [:Self, "The power of Giratina compel you!"],
	  :battler 		=> :Self,
	  :anim     	=> [:STOCKPILE, :Self],
	  :battler_1   	=> :Self,
	  :anim_1     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats   		=> [:SPECIAL_ATTACK, 1]
    },
    "attackerDodged_foe" => {
	  :speech      	=> [:Self, "Giratina is our master now!"],
	  :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ACCURACY, 1]
    },
  }  
  
  TWINS_TEMPLE2 = {
    "turnCommand" => {
	  :speech      	=> [:Opposing, "Giratina! We are your avatars!"],
	  :battler   	=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1],	  
	  :battler_1 	=> :OpposingAlly,
	  :anim_1     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats_1     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1],
    },
    "defenderHPHalf_foe" => {
	  :speech      	=> [:Self, "The power of Giratina compel you!"],
	  :text      	=> "Dark forces will empower foes when they drop to low HP!",
    },
    "defenderHPHalf_foe_repeat" => {
	  :battler 		=> :Self,
	  :anim     	=> [:STOCKPILE, :Self],
	  :battler_1   	=> :Self,
	  :anim_1     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats   		=> [:ATTACK, 1, :SPECIAL_ATTACK, 1],
    },
    "switchSentOutLast_foe" => {
	  :speech      	=> [:Self, "Giratina is our master now!"],
	  :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1, :SPECIAL_ATTACK, 1],
    },
  }

  #-----------------------------------------------------------------------------
  # Priest Leo and Selene in the Temple of Space (Team #3)
  # Standard: Enemy heals 1/10 health randomly after an attack once, both allies lose 1/10 health after the first foe faints. Both allies Atk/SpAtk/Spe down on last enemy.
  # Adept+: Enemies heal 1/10 health after every attack, both allies lose 1/10 health when each foe faints (except last one). Both allies Atk/SpAtk/Spe down on last enemy.
  #-----------------------------------------------------------------------------

  TWINS_TEMPLE3_STD = {
    "fainted_foe" => {
	  :speech      	=> [:Self, "Fear Giratina's power!"],
	  :text      	=> "Giratina's rage damages allies!",
	  :battler   	=> :Opposing,
	  :playsound 	=> "Anim/goosebump",
	  :hp      		=> -10,
	  :battler_1 	=> :OpposingAlly,
	  :playsound_1 	=> "Anim/goosebump",
	  :hp_1     	=> -10,
    },
    "defenderDamaged_random" => {
	  :speech      	=> [:Opposing, "The Master harbours us!"],
	  :battler   	=> :Opposing,
	  :anim     	=> [:ELEGY, :Self],
	  :hp      		=> 10,
    },
	"switchSentOutLast_foe" => {
	  :speech      	=> [:Self, "Master's gaze shall pierce the veil!"],
      :battler 		=> :Opposing,
	  :anim    		=> "Common:StatDown",
	  :playsound 	=> "Anim/decrease",
	  :stats   		=> [:SPEED, -1, :ATTACK, -1, :SPECIAL_ATTACK, -1],
	  :battler_1 	=> :OpposingAlly,
	  :anim_1   	=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats_1     	=> [:SPEED, -1, :ATTACK, -1, :SPECIAL_ATTACK, -1]
    },
  }
  
  TWINS_TEMPLE3 = {
    "fainted_foe" => {
	  :speech      	=> [:Self, "Fear Giratina's power!"],
	  :text      	=> "Giratina's rage damages both allies when an enemy faints!",
    },   
    "defenderDamaged" => {
	  :speech      	=> [:Opposing, "The Master harbours us!"],
	  :text     	=> "Giratina's mercy heals enemies when they attack!",
	  :anim     	=> [:ELEGY, :Self],
    },
	"switchSentOutLast_foe" => {
	  :speech      	=> [:Self, "Master's gaze shall pierce the veil!"],
      :battler 		=> :Opposing,
	  :anim    		=> "Common:StatDown",
	  :playsound 	=> "Anim/decrease",
	  :stats   		=> [:SPEED, -1, :ATTACK, -1, :SPECIAL_ATTACK, -1],
	  :battler_1 	=> :OpposingAlly,
	  :anim_1   	=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats_1     	=> [:SPEED, -1, :ATTACK, -1, :SPECIAL_ATTACK, -1]
    },
    "fainted_foe_repeat" => {
	  :battler   	=> :Opposing,
	  :playsound 	=> "Anim/goosebump",
	  :hp      		=> -10,
	  :battler_1 	=> :OpposingAlly,
	  :playsound_1 	=> "Anim/goosebump",
	  :hp_1     	=> -10,
    },   
	"defenderDamaged_repeat" => {
	  :battler   	=> :Opposing,
	  :hp      		=> 10,
    },
  }

  #-----------------------------------------------------------------------------
  # Anomaly Battles in the In-Between
  # Various
  #-----------------------------------------------------------------------------

  ANOMALYIB_0 = {
    "attackerDamaged_foe_random" => {
	  :text      	=> "Regenerate vitality!",
	  :playsound 	=> "zbrrdy00",
	  :text_1      	=> "The Anomaly gathered its energy!",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1]
    },
    "attackerCrit_foe_random" => {
	  :text      	=> "Chaos reigns!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1]
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
    "attackerSEdmg_foe_random" => {
	  :text      	=> "You can run but you cannot hide!",
	  :playsound 	=> "zbrrdy00",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1]
    },
    "switchSentOut_foe_random" => {
	  :text      	=> "We shall not yield!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Self,
	  :anim     	=> [:VENOMDRENCH, :Opposing],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Venom Drench",
	  :hp      		=> -8,
      :status  		=> :POISON
    },
    "defenderDamaged_foe_random" => {
	  :text      	=> "We shall conquer!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_DEFENSE, 1]
    },
  }
  
  ANOMALYIB_2 = {
    "attackerNVEdmg_foe_random" => {
	  :text      	=> "We shall prevail!",
	  :playsound 	=> "zbrrdy00",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1]
    },
    "defenderDamaged_foe_random" => {
	  :text      	=> "We cannot be stopped!",
	  :playsound 	=> "zbrrdy00",
      :battler 		=> :Opposing,
	  :anim    		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:SPECIAL_DEFENSE, -1]
    },
    "attackerDodged_foe_random" => {
	  :text      	=> "We shall consume your essence!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ACCURACY, 1]
    },
  }
  
  ANOMALYIB_3 = {
    "attackerDamaged_foe_random" => {
	  :text      	=> "Mmm... Fresh meat!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1]
    },
    "defenderDamaged_foe_random" => {
	  :text      	=> "I shall feed today!",
	  :playsound 	=> "zbryes02",
      :battler 		=> :Opposing,
	  :anim    		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:SPECIAL_DEFENSE, -1]
    },
    "attackerSEdmg_foe_random" => {
	  :text      	=> "We hunger, we feed!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> [:VENOMDRENCH, :Self],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Venom Drench",
	  :hp      		=> -8,
      :status  		=> :POISON
    },
  }

  #-----------------------------------------------------------------------------
  # Anomaly Starmie in the In-Between
  # Standard: Sets up stealth rock on entry
  # Adept+: Sets up stealth rock on entry, +1 Def/SpDef. Caustic substance
  #-----------------------------------------------------------------------------

  ANOMALY_STARMIE_STD = {
    "turnCommand" => {
	  :playsound 	=> "zbrrdy00",
	  :text      	=> "YOU. SHALL. NOT. ESCAPE.",
	  :battler		=> :Opposing,
	  :anim 		=> [:STEALTHROCK, :Opposing],
	  :battler_1 	=> :Self,
	  :team_1 		=> [
        [PBEffects::StealthRock, true, "Pointed stones float in the air around {1}!"],
      ],
    },
  }

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
    "attackerSEdmg_foe_random" => {
	  :text      	=> "We hunger, we feed!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> [:VENOMDRENCH, :Self],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Venom Drench",
	  :hp      		=> -8,
      :status  		=> :POISON
    },
  }
  
  #-----------------------------------------------------------------------------
  # Infested Cultist in the In-Between
  # Standard: Sets up stealth rock on entry
  # Adept+: Sets up stealth rock on entry, +1 Def/SpDef. Lowers Special Defense and raises Accuracy
  #-----------------------------------------------------------------------------

  ANOMALYVICTIM_IB_STD = {
    "turnCommand" => {
	  :playsound 	=> "zbrrdy00",
	  :text      	=> "YOU. SHALL. NOT. ESCAPE.",
	  :battler		=> :Opposing,
	  :anim 		=> [:STEALTHROCK, :Opposing],
	  :battler_1 	=> :Self,
	  :team_1 		=> [
        [PBEffects::StealthRock, true, "Pointed stones float in the air around {1}!"],
      ],
    },
  }

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
    "defenderDamaged_foe_random" => {
	  :text      	=> "We cannot be stopped!",
	  :playsound 	=> "zbrrdy00",
      :battler 		=> :Opposing,
	  :anim    		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:SPECIAL_DEFENSE, -1]
    },
    "attackerDodged_foe_random" => {
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
  # Standard: Sets up stealth rock on entry
  # Adept+: Sets up stealth rock on entry, +1 Def/SpDef. Caustic substance
  #-----------------------------------------------------------------------------

  ANOMALY_SWOOBAT_STD = {
    "turnCommand" => {
	  :playsound 	=> "zbrrdy00",
	  :text      	=> "YOU. SHALL. NOT. ESCAPE.",
	  :battler		=> :Opposing,
	  :anim 		=> [:STEALTHROCK, :Opposing],
	  :battler_1 	=> :Self,
	  :team_1 		=> [
        [PBEffects::StealthRock, true, "Pointed stones float in the air around {1}!"],
      ],
    },
  }

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
    "attackerSEdmg_foe_random" => {
	  :text      	=> "We hunger, we feed!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> [:VENOMDRENCH, :Self],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Venom Drench",
	  :hp      		=> -8,
      :status  		=> :POISON
    },
  }

  #-----------------------------------------------------------------------------
  # Anomaly Group 0 - Weezing and Noivern in the In-Between
  # Standard: Sets up stealth rock on entry
  # Adept+: Sets up stealth rock on entry, +1 Def/SpDef on both sides. Caustic substance
  #-----------------------------------------------------------------------------

  ANOMALYGROUP0_IB_STD = {
    "turnCommand" => {
	  :playsound 	=> "zbrrdy00",
	  :text      	=> "YOU. SHALL. NOT. ESCAPE.",
	  :battler		=> :Opposing,
	  :anim 		=> [:STEALTHROCK, :Opposing],
	  :battler_1 	=> :Self,
	  :team_1 		=> [
        [PBEffects::StealthRock, true, "Pointed stones float in the air around {1}!"],
      ],
    },
  }

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
    "attackerSEdmg_foe_random" => {
	  :text      	=> "We hunger, we feed!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> [:VENOMDRENCH, :Self],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Venom Drench",
	  :hp      		=> -8,
      :status  		=> :POISON
    },
  }
  
  #-----------------------------------------------------------------------------
  # Anomaly Group 1 - Misdreavuses in Ezreal's Prison
  # Standard: Sets up stealth rock on entry
  # Adept+: Sets up stealth rock on entry, -1 Def/SpDef for your side (double battle). Caustic substance, Def/SpDef drop on crit
  #-----------------------------------------------------------------------------

  ANOMALYGROUP1_AT_STD = {
    "turnCommand" => {
	  :playsound 	=> "zbrrdy00",
	  :text      	=> "YOU. SHALL. NOT. ESCAPE.",
	  :battler		=> :Opposing,
	  :anim 		=> [:STEALTHROCK, :Opposing],
	  :battler_1 	=> :Self,
	  :team_1 		=> [
        [PBEffects::StealthRock, true, "Pointed stones float in the air around {1}!"],
      ],
    },
  }

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
	  :stats_1 		=> [:DEFENSE, -1, :SPECIAL_DEFENSE, -1],
	  :text_1      	=> "YOU SHALL NEVER RELEASE OUR PRISONER.",
	  :battler_2	=> :Opposing,
	  :anim_2 		=> [:STEALTHROCK, :Opposing],
	  :battler_3 	=> :Self,
	  :team_1 		=> [
        [PBEffects::StealthRock, true, "Pointed stones float in the air around {1}!"],
      ],
    },
    "attackerSEdmg_foe_random" => {
	  :text      	=> "We hunger, we feed!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> [:VENOMDRENCH, :Self],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Venom Drench",
	  :hp      		=> -8,
      :status  		=> :POISON
    },
    "attackerCrit_foe_random" => {
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
  # Standard: Reflect/Light Screen on entry (3 turns)
  # Adept+: Reflect/Light Screen on entry (5 turns), Lowers your Def/SpDef by 1 and puts you to sleep, 1/4 life. Deals 1/8 damage when hit with a S/E attack
  #-----------------------------------------------------------------------------

  GIRATINA_AT_STD = {
    "turnCommand" => {
	  :text      	=> "You are in my realm now...",
      :battler 		=> :Opposing,
	  :anim 		=> [:REFLECT, :Opposing],
	  :team 		=> [
        [PBEffects::Reflect, 3, "The Antimatter Realm reduces physical damage against Giratina!"]
	  ],
	  :anim_1 		=> [:LIGHTSCREEN, :Opposing],
	  :team_1 		=> [
		[PBEffects::LightScreen, 3, "The Antimatter Realm reduces special damage against Giratina!"],
	  ]
    },
  }

  GIRATINA_AT = {
    "turnCommand" => {
	  :text      	=> "You are in my realm now...",
	  :battler 		=> :Opposing,
	  :anim     	=> [:NIGHTDAZE, :Opposing],
	  :playsound 	=> "Anim/PRSFX- Night Daze1",
	  :battler_1   	=> :Self,
	  :hp      		=> -8,
      :status  		=> :SLEEP,
	  :anim_1  		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:DEFENSE, -1, :SPECIAL_DEFENSE, -1],
	  :text_1      	=> "The Sigil empowers me!",
      :battler_2	=> :Opposing,
	  :anim_2 		=> [:REFLECT, :Opposing],
	  :team 		=> [
        [PBEffects::Reflect, 5, "The Antimatter Realm reduces physical damage against Giratina!"]
	  ],
	  :anim_3 		=> [:LIGHTSCREEN, :Opposing],
	  :team_1 		=> [
		[PBEffects::LightScreen, 5, "The Antimatter Realm reduces special damage against Giratina!"],
	  ]
    },
    "attackerSEdmg_foe" => {
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
  # Standard: Poisonous Substance.
  # Adept+: Toxic Spikes, 1/8 life lost on a super effective. On switch in of last enemy, +Def/SpDef by 1
  #-----------------------------------------------------------------------------

  ANOMALYGROUP2_UT_STD = {
    "turnCommand" => {
	  :text      	=> "The Orb of Creation empowers us!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team_1 		=> [
        [PBEffects::ToxicSpikes, 1, "The Anomaly spread a poisonous substance on your side of the field!"],
      ],
    },
  }

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
    "attackerSEdmg_foe" => {
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
  # Mischievous Zoroark in Charon Ice Tunnels (Segment after 12B)
  # Level 60 Zoroark with Moxie Ability, knows Psychic Fangs, Adamant nature, 31 IVs
  #-----------------------------------------------------------------------------

=begin
# The original setup of the Pokemon.
	WildBattle.dx_start([:ZOROARK, 60], {:outcome => 73 }, {
		:ability => 1, # Moxie
		:moves   => :PSYCHICFANGS,
		:nature  => :ADAMANT,		
		:ivs     => 31,
	}, 
:MISCHIEVOUS_ZOROARK)
=end

# The midbattle config for the Pokemon
  MISCHIEVOUS_ZOROARK = {
    "turnCommand" => {
      :text        	 => "The Boreal Guardian shall not return!",
	  :battler       => :Opposing,
      :anim          => [:CURSE, :Opposing],
      :playsound     => "Anim/Curse",
	  :battler_1     => :Self,
	  :anim_1        => "Common:StatDown",
	  :playsound_1   => "Anim/decrease",
	  :stats_1       => [:ATTACK, -1, :SPECIAL_ATTACK, -1],
      :text_1        => "The curse lowered your attacking stats!"
    },
    "defenderDamaged_foe_random" => {
	  :text      	=> "The Boreal Guardian holds no power here!",	  
	  :battler 		=> :Opposing,
	  :anim     	=> [:AVALANCHE, :Self],
	  :text_1      	=> "{1} was maimed by falling ice!",
	  :playsound_1 	=> "Anim/PRSFX- Avalanche",
	  :hp      		=> -8
    },
  }
  
  #-----------------------------------------------------------------------------
  # Ninetales Boreal Guardian in Route 11A (Backtrack to Route 11A)
  # Level 60 Ninetales with Charisma Ability, knows Solar Flare, Modest nature, 31 IVs
  #-----------------------------------------------------------------------------

=begin
# The original setup of the Pokemon.
	WildBattle.dx_start([:NINETALES, 60], {:outcome => 73 }, {
		:ability => 1, # Charisma
		:moves   => :SOLARFLARE,
		:nature  => :MODEST,		
		:ivs     => 31,
	}, 
:BOREAL_GUARDIAN)
=end

# The midbattle config for the Pokemon
  BOREAL_GUARDIAN = {
    "turnCommand" => {
	  :text    		=> "You desecrate this sacred forest!",
	  :battler 		=> :Opposing,
	  :anim     	=> [:MYSTICALFIRE, :Opposing],
	  :battler_1   	=> :Self,
	  :text      	=> "{2} was burned by a mystical flame!",
	  :playsound 	=> "Anim/PRSFX- Spite2",
      :status  		=> :BURN
    },
    "defenderDamaged_foe_random" => {
	  :text      	=> "The icy wind shall claim you and leave no body!",	  
	  :battler 		=> :Opposing,
	  :anim     	=> [:ICYWIND, :Self],
	  :anim_1        => "Common:StatDown",
	  :playsound_1   => "Anim/decrease",
	  :stats_1       => [:SPEED, -1],
      :text_1        => "The icy wind slowed you!"
    },
  }

  #-----------------------------------------------------------------------------
  # Anomaly Interplanar Storms on EG Trainer Teams 
  #-----------------------------------------------------------------------------

  ANOMALYIPSTORM_0 = {
    "switchSentOutLast_foe" => {
	  :speech      	=> [:Self, "It's time I put you in the ground once and for all!"],
	  :battler 		=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1]
    },
  }

  ANOMALYIPSTORM_1 = {
    "switchSentOutLast_foe" => {
	  :speech      	=> [:Self, "I won't lose to you!"],
	  :battler 		=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1, :SPECIAL_ATTACK, 1]
    },
  }
  
  ANOMALYIPSTORM_2 = {
    "switchSentOutLast_foe" => {
	  :speech      	=> [:Self, "The Ethereal Guild will be victorious!"],
	  :battler 		=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1, :ATTACK, 1]
    },
  }
  
  ANOMALYIPSTORM_3 = {
    "switchSentOutLast_foe" => {
	  :speech      	=> [:Self, "You got into a fight with the wrong person!"],
	  :battler 		=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1, :SPECIAL_DEFENSE, 1]
    },
  }
  
  ANOMALYIPSTORM_4 = {
    "switchSentOutLast_foe" => {
	  :speech      	=> [:Self, "I still have one ace up my sleeve!"],
	  :battler 		=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1, :DEFENSE, 1]
    },
  }

  #-----------------------------------------------------------------------------
  # Anomaly Hoopa on Route 13B
  # Standard: Sets up screens on entry (3 turns)
  # Adept+: Sets up screens on entry (5 turns). Caustic substance
  #-----------------------------------------------------------------------------

  ANOMALYHOOPA_IPS_STD = {
    "turnCommand" => {
	  :text      	=> "WE. ARE. UNSTOPPABLE.",
	  :battler 		=> :Opposing,
	  :anim 		=> [:REFLECT, :Opposing],
	  :team 		=> [
        [PBEffects::Reflect, 3, "The Anomaly erects a barrier to reduce physical damage against it!"]
	  ],
	  :anim_1 		=> [:LIGHTSCREEN, :Opposing],
	  :team_1 		=> [
		[PBEffects::LightScreen, 3, "The Anomaly erects a barrier to reduce special damage against it!"],
	  ]
    },
  }

  ANOMALYHOOPA_IPS = {
    "turnCommand" => {
	  :text      	=> "WE. ARE. UNSTOPPABLE.",
	  :battler 		=> :Opposing,
	  :anim 		=> [:REFLECT, :Opposing],
	  :team 		=> [
        [PBEffects::Reflect, 5, "The Anomaly erects a barrier to reduce physical damage against it!"]
	  ],
	  :anim_1 		=> [:LIGHTSCREEN, :Opposing],
	  :team_1 		=> [
		[PBEffects::LightScreen, 5, "The Anomaly erects a barrier to reduce special damage against it!"],
	  ]
    },
    "attackerSEdmg_foe_random" => {
	  :text      	=> "We hunger, we feed!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> [:VENOMDRENCH, :Self],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Venom Drench",
	  :hp      		=> -8,
      :status  		=> :POISON
    },
  }

  #-----------------------------------------------------------------------------
  # Vultures Overhead Side Quest
  # Paragon Valley - Sandstorm (through weather effect in the area) and Tailwind
  # Paragon Cactus - Sunny Day, 1/8 health and Burn
  # Paragon Sand - Sandstorm, increases evasion, lowers your accuracy
  # Poisonous Substance and Curse lowering your attacking stats.
  #-----------------------------------------------------------------------------

  PARAGON_VALLEY = {
    "turnCommand" => {
	  :speech 			=> [:Speaker, :PARAGON, "Desert spirits of the valley, bless me with the grace of the wind!"],
      :battler   		=> :Opposing,
      :anim_1         	=> [:TAILWIND, :Opposing],
	  :team => [ 
		[PBEffects::Tailwind, 4, "The wind is blowing in the paragon's favour!"],
		]
    },
  }

  PARAGON_SUN = {
    "turnCommand" => {
	  :anim     	=> [:SUNNYDAY],
	  :speech 		=> [:Speaker, :PARAGON, "The sun favours me this day!"],
	  :battler 		=> :Opposing,
	  :anim_1     	=> [:MYSTICALFIRE, :Opposing],
	  :battler_1   	=> :Self,
	  :text      	=> "{1} was burned by the sun!",
	  :playsound 	=> "Anim/PRSFX- Spite2",
	  :hp      		=> -8,
      :status  		=> :BURN
    },
  }

  PARAGON_SAND = {
    "turnCommand" => {
	  :battler   	=> :Opposing,
	  :anim     	=> [:SANDSTORM],
	  :speech 		=> [:Speaker, :PARAGON, "The sand shelters me. I am blessed!"],
	  :anim_1     	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:EVASION, 1,],
      :battler_1   	=> :Self,
	  :anim_2     	=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats_1     	=> [:ACCURACY, -1,]
    },
  }

  VULTURES_OVERHEAD = {
    "turnCommand" => {
	  :text       	=> "My corruption taints all!",
	  :battler 		=> :Opposing,
	  :anim 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team 		=> [
        [PBEffects::ToxicSpikes, 1, "The corrupted avatar spreads its toxic corruption to your side of the field!"],
      ],
	  :battler_2     => :Opposing,
      :anim_1        => [:CURSE, :Opposing],
      :playsound_1   => "Anim/Curse",
	  :battler_3     => :Self,
	  :anim_2        => "Common:StatDown",
	  :playsound_2   => "Anim/decrease",
	  :stats         => [:ATTACK, -1, :SPECIAL_ATTACK, -1],
      :text_1        => "The curse lowered your attacking stats!"
    },
  }

  #-----------------------------------------------------------------------------
  # Anomaly Battles in the Callisto Lake and EG Underwater Base
  # Various
  #-----------------------------------------------------------------------------

  ANOMALYCALLISTO_0 = {
    "attackerDamaged_foe_random" => {
	  :text      	=> "Regenerate vitality!",
	  :playsound 	=> "zbrrdy00",
	  :text_1      	=> "The Anomaly gathered its energy!",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1]
    },
    "attackerCrit_foe_random" => {
	  :text      	=> "Chaos reigns!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1]
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
    "attackerSEdmg_foe_random" => {
	  :text      	=> "You can run but you cannot hide!",
	  :playsound 	=> "zbrrdy00",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1]
    },
    "switchSentOut_foe_random" => {
	  :text      	=> "We shall not yield!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Self,
	  :anim     	=> [:VENOMDRENCH, :Opposing],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Venom Drench",
	  :hp      		=> -8,
      :status  		=> :POISON
    },
    "defenderDamaged_foe_random" => {
	  :text      	=> "We shall conquer!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_DEFENSE, 1]
    },
  }
  
  ANOMALYCALLISTO_2 = {
    "attackerNVEdmg_foe_random" => {
	  :text      	=> "We shall prevail!",
	  :playsound 	=> "zbrrdy00",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1]
    },
    "defenderDamaged_foe_random" => {
	  :text      	=> "We cannot be stopped!",
	  :playsound 	=> "zbrrdy00",
      :battler 		=> :Opposing,
	  :anim    		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:SPECIAL_DEFENSE, -1]
    },
    "attackerDodged_foe_random" => {
	  :text      	=> "We shall consume your essence!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ACCURACY, 1]
    },
  }
  
  ANOMALYCALLISTO_3 = {
    "attackerDamaged_foe_random" => {
	  :text      	=> "Mmm... Fresh meat!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1]
    },
    "defenderDamaged_foe_random" => {
	  :text      	=> "I shall feed today!",
	  :playsound 	=> "zbryes02",
      :battler 		=> :Opposing,
	  :anim    		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:SPECIAL_DEFENSE, -1]
    },
    "attackerSEdmg_foe_random" => {
	  :text      	=> "We hunger, we feed!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> [:VENOMDRENCH, :Self],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Venom Drench",
	  :hp      		=> -8,
      :status  		=> :POISON
    },
  }

  #-----------------------------------------------------------------------------
  # EG Anomaly Christina (Team #0)
  # Standard: Reflect and Light Screen (3 turns)
  # Adept+: Reflect and Light Screen (5 turns), first time you deal damage Atk/SpAtk are lowered, enemy gets +1 Spe/Acc on first switch in
  #-----------------------------------------------------------------------------

  EGANOMALY_CHRISTINA0_STD = {
    "turnCommand" => {
	  :speech  => [:Opposing, "The void empowers us!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 3, "A sinister force set up Reflect on Christina's side of the field!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Opposing],
	  :team_1 => [
		[PBEffects::LightScreen, 3, "A sinister force set up Light Screen on Christina's side of the field!"],
	  ]
    },
  }

  EGANOMALY_CHRISTINA0 = {
    "turnCommand" => {
	  :speech  => [:Opposing, "The void empowers us!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 5, "A sinister force set up Reflect on Christina's side of the field!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Opposing],
	  :team_1 => [
		[PBEffects::LightScreen, 5, "A sinister force set up Light Screen on Christina's side of the field!"],
	  ]
    },
    "defenderDamaged_foe" => {
	  :speech  => [:Self, "The power of the void will claim you!"],
	  :battler 		=> :Opposing,
	  :anim     	=> "Common:StatDown",
	  :playsound 	=> "Anim/decrease",
	  :stats     	=> [:ATTACK, -1, :SPECIAL_ATTACK, -1]
    },
    "switchSentOut_foe" => {
	  :speech  => [:Self, "You shall be assimilated!"],
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:SPEED, 1, :ACCURACY, 1]
    },
  }

  #-----------------------------------------------------------------------------
  # EG Anomaly Christina (Team #1)
  # Standard: Reflect and Light Screen (3 turns).
  # Adept+: Reflect and Light Screen (5 turns), 1/4 chip damage on start of third turn, +3 Def/SpDef on last pokémon
  #-----------------------------------------------------------------------------

  EGANOMALY_CHRISTINA1_STD = {
    "turnCommand" => {
	  :speech  	=> [:Opposing, "Give up and surrender to our legions!"],
      :battler 	=> :Opposing,
	  :anim 	=> [:REFLECT, :Opposing],
	  :team 	=> [
        [PBEffects::Reflect, 3, "A sinister force set up Reflect on Christina's side of the field!"]
	  ],
	  :anim_1 	=> [:LIGHTSCREEN, :Opposing],
	  :team_1 	=> [
		[PBEffects::LightScreen, 3, "A sinister force set up Light Screen on Christina's side of the field!"],
	  ]
    },
  }
  
  EGANOMALY_CHRISTINA1 = {
    "turnCommand" => {
	  :speech  	=> [:Opposing, "Give up and surrender to our legions!"],
      :battler 	=> :Opposing,
	  :anim 	=> [:REFLECT, :Opposing],
	  :team 	=> [
        [PBEffects::Reflect, 5, "A sinister force set up Reflect on Christina's side of the field!"]
	  ],
	  :anim_1 	=> [:LIGHTSCREEN, :Opposing],
	  :team_1 	=> [
		[PBEffects::LightScreen, 5, "A sinister force set up Light Screen on Christina's side of the field!"],
	  ]
    },
    "turnCommand_3" => {
	  :speech  	=> [:Opposing, "It is only a matter of time before you capitulate!"],
	  :anim     	=> [:DARKVOID, :Self],
	  :battler   	=> :Self,
	  :text      	=> "{1} was singed by the void!",
	  :playsound 	=> "Anim/PRSFX- Spite2",
	  :hp      		=> -4,
    },
    "switchSentOutLast_foe" => {
	  :speech      	=> [:Self, "The power of chaos shall protect my Pokémon!"],
	  :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 3, :SPECIAL_DEFENSE, 3]
    },
  }

  #-----------------------------------------------------------------------------
  # EG Anomaly Christina (Team #2)
  # Standard: Gains Endure for the first turn, 1/8 chip at random after dealing damage once, Atk/SpAtk/Spe boost the first time one of your mons faints
  # Adept+: Gains Endure for the first turn and every third turn thereafter, 1/8 chip every time you deal damage, Atk/SpAtk/Spe boost the first time one of your mons faints
  #-----------------------------------------------------------------------------
  
  EGANOMALY_CHRISTINA2_STD = {
    "turnCommand" => {
	  :speech  	=> [:Opposing, "We can sustain ourselves without limit!"],
      :battler 	=> :Opposing,
	  :anim     	=> [:ENDURE, :Self],
	  :playsound 	=> "Anim/PRSFX- Endure",
      :effects	=> [[PBEffects::Endure, true]],
    },	
    "attackerDamaged_random" => {
	  :speech  	=> [:Opposing, "Who dares resist the encroaching void?!"],
	  :battler 		=> :Self,
	  :anim     	=> [:GOOSEBUMP, :Self],
	  :text      	=> "{1} was cursed!",
	  :playsound 	=> "Anim/goosebump",
	  :hp      		=> -8,
    },
    "fainted" => {
	  :text      	=> "You shall make a fine host body!",
      :battler 		=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats   		=> [:ATTACK, 1, :SPECIAL_ATTACK, 1, :SPEED, 1]
    },
  }

  EGANOMALY_CHRISTINA2 = {
    "turnCommand" => {
	  :speech  	=> [:Opposing, "We can sustain ourselves without limit!"],
	  :text      	=> "Christina's Pokémon will Endure any attacks at the start of every third turn!",
      :battler 	=> :Opposing,
	  :anim     	=> [:ENDURE, :Self],
	  :playsound 	=> "Anim/PRSFX- Endure",
      :effects	=> [[PBEffects::Endure, true]],
    },	
	"turnCommand_every_3" => {	
	  :battler 		=> :Opposing,
	  :anim     	=> [:ENDURE, :Self],
	  :playsound 	=> "Anim/PRSFX- Endure",
      :effects	=> [[PBEffects::Endure, true]],
    },
    "attackerDamaged" => {
	  :speech  	=> [:Opposing, "Who dares resist the encroaching void?!"],
	  :text      	=> "Your Pokémon will take damage every time they attack!",
    },
	"attackerDamaged_repeat" => {
	  :battler   	=> :Self,
	  :playsound 	=> "Anim/goosebump",
	  :hp      		=> -8,
    },
    "fainted" => {
	  :text      	=> "You shall make a fine host body!",
      :battler 		=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats   		=> [:ATTACK, 1, :SPECIAL_ATTACK, 1, :SPEED, 1]
    },
  }
  
 #-----------------------------------------------------------------------------
  # EG Anomaly Christina (Team #3)
  # Standard: Raises Def/SpDef at start, lowers Atk/SpAtk of the first mon you switch in, hurts you for 1/4 if you negate an attack once.
  # Adept+: Raises Def/SpDef at start and every time an enemy gets damaged, lowers Atk/SpAtk of the first mon you switch in, hurts you for 1/4 every time you negate an attack.
  #-----------------------------------------------------------------------------

  EGANOMALY_CHRISTINA3_STD = {
    "turnCommand" => {
	  :speech      	=> [:Opposing, "I grow. I evolve. I adapt!"],
	  :battler   	=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE,1]
    },
	"switchSentOut" => {	  
	  :speech      	=> [:Opposing, "The void shall claim you in due time!"],
	  :battler   	=> :Self,
	  :anim     	=> "Common:StatDown",
	  :playsound 	=> "Anim/decrease",
	  :stats     	=> [:ATTACK, -1, :SPECIAL_ATTACK, -1]
    },
    "defenderNegated" => {
	  :speech      	=> [:Opposing, "You cannot escape the powers of chaos!"],
	  :battler   	=> :Self,
	  :hp      		=> -4,
    },
  }
  
  EGANOMALY_CHRISTINA3 = {
    "turnCommand" => {
	  :speech      	=> [:Opposing, "I grow. I evolve. I adapt!"],
	  :text      	=> "Christina's Pokémon will have their defenses increased each time they're hit!",
	  :battler   	=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE,1]
    },
	"defenderDamaged_foe_repeat" => {
	  :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE,1]
    },
	"switchSentOut" => {	  
	  :speech      	=> [:Opposing, "The void shall claim you in due time!"],
	  :battler   	=> :Self,
	  :anim     	=> "Common:StatDown",
	  :playsound 	=> "Anim/decrease",
	  :stats     	=> [:ATTACK, -1, :SPECIAL_ATTACK, -1]
    },
    "defenderNegated" => {
	  :speech      	=> [:Opposing, "You cannot escape the powers of chaos!"],
	  :text      	=> "You will lose HP whenever you negate damage from an attack!",
    },
	"defenderNegated_repeat" => {
	  :battler   	=> :Self,
	  :hp      		=> -4,
    },
  }

  #-----------------------------------------------------------------------------
  # EG Admin Claude (Team #0)
  # Standard: Poisonous Substance on entry
  # Adept+: Toxic Spikes and Sticky Web on entry, throws a concoction at you on crit hits that burns you and takes off 1/4 life once.
  # Heal himself on being damaged by 1/8 when being hit at random once
  #-----------------------------------------------------------------------------

  EGADMIN_CLAUDE0_STD = {
    "turnCommand" => {
	  :speech       => [:Opposing, "You're in my laboratory now!"],
	  :battler 		=> :Opposing,
	  :anim 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team 		=> [
        [PBEffects::ToxicSpikes, 1, "The Mad Scientist dropped a poisonous substance on your side of the field!"],
      ],
    },	
  }

  EGADMIN_CLAUDE0 = {
    "turnCommand" => {
	  :speech       => [:Opposing, "You're in my laboratory now!"],
	  :battler 		=> :Opposing,
	  :anim 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team 		=> [
        [PBEffects::ToxicSpikes, 2, "The Mad Scientist dropped Toxic Spikes on your side of the field!"],
      ],
	  :battler_2 	=> :Opposing,
	  :anim_1 		=> [:STICKYWEB, :Opposing],
	  :battler_3 	=> :Self,
	  :team_1 		=> [
        [PBEffects::StickyWeb, true, "The Mad Scientist dropped a sticky substance on your side of the field!"],
      ],
    },	
    "attackerCrit_foe_random" => {
	  :text      	=> "I'll incinerate you with my chemicals!",
	  :battler 		=> :Self,
	  :anim     	=> [:CONCOCTION, :Opposing],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Acid",
	  :hp      		=> -8,
      :status  		=> :BURN
    },
    "defenderDamaged_foe_random" => {
	  :speech         		=> [:Self, "My experiments have been successful!"],
	  :battler 				=> :Self,
	  :anim     			=> [:GROWTH, :Self],
	  :playsound 			=> "Anim/PRSFX- Strength Sap1",
	  :hp      				=> 8,
    },
  }

  #-----------------------------------------------------------------------------
  # EG Admin Claude (Team #1)
  # Standard: Poisonous Substance on entry
  # Adept+: Toxic Spikes and Sticky Web on entry, lowers defense at random when he deals damage once, and +1 Def/SpDef if he misses once at random.
  #-----------------------------------------------------------------------------
  
  EGADMIN_CLAUDE1_STD = {
    "turnCommand" => {
	  :speech       => [:Opposing, "You're in my laboratory now!"],
	  :battler 		=> :Opposing,
	  :anim 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team 		=> [
        [PBEffects::ToxicSpikes, 1, "The Mad Scientist dropped a poisonous substance on your side of the field!"],
      ],
    },	
  }

  EGADMIN_CLAUDE1 = {
    "turnCommand" => {
	  :speech       => [:Opposing, "You're in my laboratory now!"],
	  :battler 		=> :Opposing,
	  :anim 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team 		=> [
        [PBEffects::ToxicSpikes, 2, "The Mad Scientist dropped Toxic Spikes on your side of the field!"],
      ],
	  :battler_2 	=> :Opposing,
	  :anim_1 		=> [:STICKYWEB, :Opposing],
	  :battler_3 	=> :Self,
	  :team_1 		=> [
        [PBEffects::StickyWeb, true, "The Mad Scientist dropped a sticky substance on your side of the field!"],
      ],
    },
    "attackerDamaged_foe_random" => {
	  :text      	=> "You shall eventually yield to the might of the Ethereal Guild!",
      :battler 		=> :Opposing,
	  :anim    		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:DEFENSE, -1]
    },
    "attackerDodged_foe_random" => {
	  :text      	=> "You can run but you cannot hide!",
	  :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1]
    },
  }

  #-----------------------------------------------------------------------------
  # EG Admin Claude (Team #2)
  # Standard: Poisonous Substance on entry
  # Adept+: Toxic Spikes and Sticky Web on entry, lowers atk/spatk on low life, +1 attack at random on attack once.
  #-----------------------------------------------------------------------------

  EGADMIN_CLAUDE2_STD = {
    "turnCommand" => {
	  :speech       => [:Opposing, "You're in my laboratory now!"],
	  :battler 		=> :Opposing,
	  :anim 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team 		=> [
        [PBEffects::ToxicSpikes, 1, "The Mad Scientist dropped a poisonous substance on your side of the field!"],
      ],
    },	
  }

  EGADMIN_CLAUDE2 = {
    "turnCommand" => {
	  :speech       => [:Opposing, "You're in my laboratory now!"],
	  :battler 		=> :Opposing,
	  :anim 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team 		=> [
        [PBEffects::ToxicSpikes, 2, "The Mad Scientist dropped Toxic Spikes on your side of the field!"],
      ],
	  :battler_2 	=> :Opposing,
	  :anim_1 		=> [:STICKYWEB, :Opposing],
	  :battler_3 	=> :Self,
	  :team_1 		=> [
        [PBEffects::StickyWeb, true, "The Mad Scientist dropped a sticky substance on your side of the field!"],
      ],
    },
    "defenderHPHalf_foe_random" => {
	  :text      	=> "You don't stand a chance!",
	  :battler 		=> :Self,
	  :anim     	=> [:GOOSEBUMP, :Opposing],
	  :battler_1   	=> :Opposing,
	  :anim_1  		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:ATTACK, -1, :SPECIAL_ATTACK, -1]
    },
    "attackerDamaged_foe_random" => {
	  :text      	=> "I don't fight fair!",
	  :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1]
    },
  }

  #-----------------------------------------------------------------------------
  # EG Admin Claude (Team #3)
  # Standard: Poisonous Substance on entry
  # Adept+: Toxic Spikes and Sticky Web on entry, lowers your spdef when damaged at random once, caustic substance after dealing damage once at random.
  #-----------------------------------------------------------------------------

  EGADMIN_CLAUDE3_STD = {
    "turnCommand" => {
	  :speech       => [:Opposing, "You're in my laboratory now!"],
	  :battler 		=> :Opposing,
	  :anim 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team 		=> [
        [PBEffects::ToxicSpikes, 1, "The Mad Scientist dropped a poisonous substance on your side of the field!"],
      ],
    },	
  }

  EGADMIN_CLAUDE3 = {
    "turnCommand" => {
	  :speech       => [:Opposing, "You're in my laboratory now!"],
	  :battler 		=> :Opposing,
	  :anim 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team 		=> [
        [PBEffects::ToxicSpikes, 2, "The Mad Scientist dropped Toxic Spikes on your side of the field!"],
      ],
	  :battler_2 	=> :Opposing,
	  :anim_1 		=> [:STICKYWEB, :Opposing],
	  :battler_3 	=> :Self,
	  :team_1 		=> [
        [PBEffects::StickyWeb, true, "The Mad Scientist dropped a sticky substance on your side of the field!"],
      ],
    },
    "defenderDamaged_foe_random" => {
	  :text      	=> "You shall never rescue the prisoners!",
      :battler 		=> :Opposing,
	  :anim    		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:SPECIAL_DEFENSE, -1]
    },
    "attackerDamaged_foe_random" => {
	  :text      	=> "Here, enjoy this chemical bomb!",
	  :battler 		=> :Opposing,
	  :anim     	=> [:VENOMDRENCH, :Self],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Venom Drench",
	  :hp      		=> -8,
      :status  		=> :POISON
    },
  }

  #-----------------------------------------------------------------------------
  # EG Admin Claude (Team #4)
  # Standard and Adept: Reflect/Light Screen. No difference between difficulties.
  #-----------------------------------------------------------------------------

  EGADMIN_DIALGA = {
    "turnCommand" => {
	  :speech 		=> [:Speaker, :PRIESTS_Leo_Selene, "\\PN, we're channelling our energy to help you!"],
      :battler 		=> :Self,
	  :anim => 		[:REFLECT, :Self],
	  :team => 		[
        [PBEffects::Reflect, 5, "Leo and Selene's power set up a Reflect barrier on your side of the field!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Self],
	  :team_1 => [
		[PBEffects::LightScreen, 5, "Leo and Selene's power set up a Light Screen barrier on your side of the field!"],
	  ],
    },
  }

  #-----------------------------------------------------------------------------
  # Draco City Attack on EG Trainer Teams
  #-----------------------------------------------------------------------------

  EGDRACO_0 = {
    "switchSentOutLast_foe" => {
	  :speech      	=> [:Self, "It's time I put you in the ground once and for all!"],
	  :battler 		=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1]
    },
  }

  EGDRACO_1 = {
    "switchSentOutLast_foe" => {
	  :speech      	=> [:Self, "I won't lose to you!"],
	  :battler 		=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1, :DEFENSE, 1]
    },
  }
  
  EGDRACO_2 = {
    "switchSentOutLast_foe" => {
	  :speech      	=> [:Self, "The Ethereal Guild will be victorious!"],
	  :battler 		=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1, :SPECIAL_DEFENSE, 1]
    },
  }
  
  EGDRACO_3 = {
    "switchSentOutLast_foe" => {
	  :speech      	=> [:Self, "You got into a fight with the wrong person!"],
	  :battler 		=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1, :SPECIAL_DEFENSE, 1]
    },
  }
  
  EGDRACO_4 = {
    "switchSentOutLast_foe" => {
	  :speech      	=> [:Self, "I still have one ace up my sleeve!"],
	  :battler 		=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1, :DEFENSE, 1]
    },
  }

  #-----------------------------------------------------------------------------
  # EG Harry and Marv
  # Standard: Poison on entry and 1 layer of Spikes
  # Adept+: Toxic Spikes and Stealth Rock on entry
  #-----------------------------------------------------------------------------

  EG_HARRYMARV_STD = {
    "turnCommand" => {
	  :speech       	=> [:Opposing, "You think we gonna let you off easy?"],
	  :battler 			=> :Opposing,
	  :anim 			=> [:TOXICSPIKES, :Opposing],
	  :battler_1 		=> :Self,
	  :team 			=> [
        [PBEffects::ToxicSpikes, 1, "The Ethereal Guild Captains dropped a poisonous substance on your side of the field!"],
      ],
	  :battler_2 		=> :Opposing,
      :anim_1         	=> [:SPIKES, :Opposing],
      :battler_3   		=> :Self,
      :team_1         	=> [
        [PBEffects::Spikes, 1, "The Ethereal Guild Captains dropped a layer of spikes on your side of the field!"],
      ],
    },
  }

  EG_HARRYMARV = {
    "turnCommand" => {
	  :speech       => [:Opposing, "You think we gonna let you off easy?"],
	  :battler 		=> :Opposing,
	  :anim 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team 		=> [
        [PBEffects::ToxicSpikes, 2, "The Ethereal Guild Captains dropped Toxic Spikes on your side of the field!"],
      ],
	  :battler_2 	=> :Opposing,
	  :anim_1 		=> [:STEALTHROCK, :Opposing],
	  :battler_3 	=> :Self,
	  :team_1 		=> [
        [PBEffects::StealthRock, true, "Pointed stones float in the air around {1}!"],
      ],
    },
  }

  #-----------------------------------------------------------------------------
  # Rampaging Coalossal in Deimos Caves L4
  # Standard: Lowers Def/SpDef by 1, causes 1/8 damage to first team member that enters, and confuses.
  #-----------------------------------------------------------------------------

  RAMPAGING_COALOSSAL = {
    "turnCommand" => {
	  :text	    		=> "The Coalossal's rampage causes a rock slide!",
	  :battler   		=> :Self,
	  :anim	        	=> [:ROCKSLIDE, :Self],
	  :hp      			=> -8,
      :status  			=> :CONFUSION,
	  :anim_1        	=> "Common:StatDown",
	  :playsound_1   	=> "Anim/decrease",
	  :stats_1       	=> [:DEFENSE, -1, :SPECIAL_DEFENSE, -1],
	  :text_1    		=> "Your defenses fall and you are confused from the rock slide!",
    },
  }

  #-----------------------------------------------------------------------------
  # Anomaly Meganium in Deimos Caves (Side Quest)
  # Standard: Sets up screens on entry (3 turns)
  # Adept+: Sets up screens on entry (5 turns). Caustic substance
  #-----------------------------------------------------------------------------

  ANOMALYMEGANIUM_DC_STD = {
    "turnCommand" => {
	  :text      	=> "WE. ARE. UNSTOPPABLE.",
	  :battler 		=> :Opposing,
	  :anim 		=> [:REFLECT, :Opposing],
	  :team 		=> [
        [PBEffects::Reflect, 3, "The Anomaly erects a barrier to reduce physical damage against it!"]
	  ],
	  :anim_1 		=> [:LIGHTSCREEN, :Opposing],
	  :team_1 		=> [
		[PBEffects::LightScreen, 3, "The Anomaly erects a barrier to reduce special damage against it!"],
	  ]
    },
  }

  ANOMALYMEGANIUM_DC = {
    "turnCommand" => {
	  :text      	=> "WE. ARE. UNSTOPPABLE.",
	  :battler 		=> :Opposing,
	  :anim 		=> [:REFLECT, :Opposing],
	  :team 		=> [
        [PBEffects::Reflect, 5, "The Anomaly erects a barrier to reduce physical damage against it!"]
	  ],
	  :anim_1 		=> [:LIGHTSCREEN, :Opposing],
	  :team_1 		=> [
		[PBEffects::LightScreen, 5, "The Anomaly erects a barrier to reduce special damage against it!"],
	  ]
    },
    "attackerSEdmg_foe_random" => {
	  :text      	=> "We hunger, we feed!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> [:VENOMDRENCH, :Self],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Venom Drench",
	  :hp      		=> -8,
      :status  		=> :POISON
    },
  }

  #-----------------------------------------------------------------------------
  # Artie on Route 16B
  # Standard: Raises Def/SpDef by 1
  # Adept+: Artie sets up 5 turns of Reflect and Light Screen
  #-----------------------------------------------------------------------------

  ARTIE_16B_STD = {
    "turnCommand" => {
	  :speech    	=> [:Opposing, "I'm ready for you!"],
      :battler   	=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1]
    },
  }


  ARTIE_16B = {
    "turnCommand" => {
	  :speech  => [:Opposing, "I'm putting up some protection for my team!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 5, "Artie used Reflect!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Opposing],
	  :team_1 => [
		[PBEffects::LightScreen, 5, "Artie used Light Screen!"],
	  ]
    },
  }

  #-----------------------------------------------------------------------------
  # The Pied Piper Inteleon in Route 17B
  # Level 68 Pied Piper with Cacophony Ability, knows Perish Song, Modest nature, 31 IVs
  #-----------------------------------------------------------------------------

=begin
# The original setup of the Pokemon.
	WildBattle.dx_start([:INTELEON, 68], {:outcome => 73 }, {
		:ability => 2, # Cacophony
		:name    => "Pied Piper",
		:moves   => :PERISHSONG,
		:nature  => :MODEST,		
		:ivs     => 31,
	}, 
:PIED_PIPER)
=end

# The midbattle config for the Pokemon
  PIED_PIPER = {
    "turnCommand" => {
      :playsound     => "Cries/INTELEON",
	  :text          => "The children will never be found again...",
	  :battler       => :Opposing,
      :anim          => [:PERISHSONG, :Opposing],
      :playsound_1   => "Anim/PRSFX- Perish Song",
	  :battler_1     => :Self,
	  :anim_1        => "Common:StatDown",
	  :playsound_2   => "Anim/decrease",
	  :stats_1       => [:ATTACK, -1, :SPECIAL_ATTACK, -1],
      :text_1        => "I demand recompense!"
    },
    "defenderDamaged_foe_random" => {
	  :text      	=> "How dare you break your promises!",	  
	  :battler 		=> :Opposing,
	  :anim     	=> [:LIQUIDVOICE, :Self],
	  :text_1      	=> "{1} was charmed by a song of the ocean!",
	  :playsound_1 	=> "Anim/PRSFX- Waterfall1",
	  :hp      		=> -8
    },
  }

  #-----------------------------------------------------------------------------
  # Avatar of Time in Altar of Time
  # Standard: Trick Room in effect for 3 turns
  # Adept+: Trick Room in effect for 5 turns and heals once for 1/8 life
  #-----------------------------------------------------------------------------

  AVATAR_TIME_STD = {
    "turnCommand" => {
	  :speech    	=> [:Opposing, "Time is my domain!"],
	  :anim     	=> [:TRICKROOM],
	  :playsound 	=> "Anim/PRSFX- Trick Room",
	  :field => [ 
		[PBEffects::TrickRoom, 3, "The dimensions were twisted!"],
		],
    },
  }

  AVATAR_TIME = {
    "turnCommand" => {
	  :speech    	=> [:Opposing, "Time is my domain!"],
	  :anim     	=> [:TRICKROOM],
	  :playsound 	=> "Anim/PRSFX- Trick Room",
	  :field => [ 
		[PBEffects::TrickRoom, 5, "The dimensions were twisted!"],
		],
    },
    "defenderDamaged_foe_random" => {
	  :text      	=> "I shall rewind time in my favour!",
	  :battler   	=> :Self,
	  :anim     	=> [:AGILITY, :Self],
	  :hp      		=> 8,
    },
  }
  
  #-----------------------------------------------------------------------------
  # Avatar of Space in Altar of Space
  # Standard: Trick Room in effect for 3 turns
  # Adept+: Trick Room in effect for 5 turns and heals once for 1/8 life
  #-----------------------------------------------------------------------------

  AVATAR_SPACE_STD = {
    "turnCommand" => {
	  :speech    	=> [:Opposing, "I shall warp space to my control!"],
	  :anim     	=> [:TRICKROOM],
	  :playsound 	=> "Anim/PRSFX- Trick Room",
	  :field => [ 
		[PBEffects::TrickRoom, 3, "The dimensions were twisted!"],
		],
    },
  }

  AVATAR_SPACE = {
    "turnCommand" => {
	  :speech    	=> [:Opposing, "I shall warp space to my control!"],
	  :anim     	=> [:TRICKROOM],
	  :playsound 	=> "Anim/PRSFX- Trick Room",
	  :field => [ 
		[PBEffects::TrickRoom, 5, "The dimensions were twisted!"],
		],
    },
    "defenderDamaged_foe_random" => {
	  :text      	=> "The cosmos heals me!",
	  :battler   	=> :Self,
	  :anim     	=> [:LUNARDANCE, :Self],
	  :hp      		=> 8,
    },
  }
  
  #-----------------------------------------------------------------------------
  # Simulacrum Ezreal in the Altar of Creation
  # Standard: Reflect/Light Screen in effect for 3 turns
  # Adept+: Reflect/Light Screen in effect for 5 turns and smites once
  #-----------------------------------------------------------------------------

  SIMULACRUM_EZREAL_STD = {
    "turnCommand" => {
	  :speech  => [:Opposing, "I am the guardian of this Temple and it shall defend me!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 3, "The Simulacrum put up a Reflect barrier!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Opposing],
	  :team_1 => [
		[PBEffects::LightScreen, 3, "The Simulacrum put up a Light Screen barrier!"],
	  ]
    },
  }

  SIMULACRUM_EZREAL = {
    "turnCommand" => {
	  :speech  => [:Opposing, "I am the guardian of this Temple and it shall defend me!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 5, "The Simulacrum put up a Reflect barrier!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Opposing],
	  :team_1 => [
		[PBEffects::LightScreen, 5, "The Simulacrum put up a Light Screen barrier!"],
	  ]
    },
    "attackerSEdmg_foe_random" => {
	  :text      	=> "The spirits condemn you, outlander!",
	  :battler 		=> :Self,
	  :anim     	=> [:PURGE, :Opposing],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was smited!",
	  :playsound_1 	=> "Anim/handofgod",
	  :hp      		=> -8,
    },
  }

  #-----------------------------------------------------------------------------
  # Anomaly Battles in the Spires of Antimatter, Time and Space
  # Various
  #-----------------------------------------------------------------------------

  SPIRE_ANOMALY0 = {
    "attackerDamaged_foe_random" => {
	  :text      	=> "Regenerate vitality!",
	  :playsound 	=> "zbrrdy00",
	  :text_1      	=> "The Anomaly gathered its energy!",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1]
    },
    "attackerCrit_foe_random" => {
	  :text      	=> "Chaos reigns!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1]
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
  
  SPIRE_ANOMALY1 = {
    "attackerSEdmg_foe_random" => {
	  :text      	=> "You can run but you cannot hide!",
	  :playsound 	=> "zbrrdy00",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1]
    },
    "switchSentOut_foe_random" => {
	  :text      	=> "We shall not yield!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Self,
	  :anim     	=> [:VENOMDRENCH, :Opposing],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Venom Drench",
	  :hp      		=> -8,
      :status  		=> :POISON
    },
    "defenderDamaged_foe_random" => {
	  :text      	=> "We shall conquer!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_DEFENSE, 1]
    },
  }
  
  SPIRE_ANOMALY2 = {
    "attackerNVEdmg_foe_random" => {
	  :text      	=> "We shall prevail!",
	  :playsound 	=> "zbrrdy00",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1]
    },
    "defenderDamaged_foe_random" => {
	  :text      	=> "We cannot be stopped!",
	  :playsound 	=> "zbrrdy00",
      :battler 		=> :Opposing,
	  :anim    		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:SPECIAL_DEFENSE, -1]
    },
    "attackerDodged_foe_random" => {
	  :text      	=> "We shall consume your essence!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ACCURACY, 1]
    },
  }
  
  SPIRE_ANOMALY3 = {
    "attackerDamaged_foe_random" => {
	  :text      	=> "Mmm... Fresh meat!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1]
    },
    "defenderDamaged_foe_random" => {
	  :text      	=> "I shall feed today!",
	  :playsound 	=> "zbryes02",
      :battler 		=> :Opposing,
	  :anim    		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:SPECIAL_DEFENSE, -1]
    },
    "attackerSEdmg_foe_random" => {
	  :text      	=> "We hunger, we feed!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> [:VENOMDRENCH, :Self],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Venom Drench",
	  :hp      		=> -8,
      :status  		=> :POISON
    },
  }

  #-----------------------------------------------------------------------------
  # Anomaly Horde Battle in the Spire of Antimatter
  # Standard: Sets up reflect/light screen (3 turns)
  # Adept+: Sleeps you, lowers Def/SpDef by 1 and sets up reflect/light screen (5 turns)
  #-----------------------------------------------------------------------------

  ANOMALY_HORDE_STD = {
    "turnCommand" => {
	  :text      	=> "Our power will consume you!",
      :battler 		=> :Opposing,
	  :anim 		=> [:REFLECT, :Opposing],
	  :team 		=> [
        [PBEffects::Reflect, 3, "The Anomalies manifest a barrier against physical attacks!"]
	  ],
	  :anim_1 		=> [:LIGHTSCREEN, :Opposing],
	  :team_1 		=> [
		[PBEffects::LightScreen, 3, "The Anomalies manifest a barrier against special attacks!"],
	  ]
    },
  }

  ANOMALY_HORDE = {
    "turnCommand" => {
	  :text      	=> "Our power will consume you!",
	  :battler 		=> :Opposing,
	  :anim     	=> [:NIGHTDAZE, :Opposing],
	  :playsound 	=> "Anim/PRSFX- Night Daze1",
	  :battler_1   	=> :Self,
	  :hp      		=> -8,
      :status  		=> :SLEEP,
	  :anim_1  		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:DEFENSE, -1, :SPECIAL_DEFENSE, -1],
	  :text_1      	=> "We are impervious in this realm!",
      :battler_2	=> :Opposing,
	  :anim_2 		=> [:REFLECT, :Opposing],
	  :team 		=> [
        [PBEffects::Reflect, 5, "The Anomalies manifest a barrier against physical attacks!"]
	  ],
	  :anim_3 		=> [:LIGHTSCREEN, :Opposing],
	  :team_1 		=> [
		[PBEffects::LightScreen, 5, "The Anomalies manifest a barrier against special attacks!"],
	  ]
    },
    "attackerSEdmg_foe" => {
	  :text      	=> "I cannot deny my horde fresh meat when it wanders so willingly into our midst!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> [:SPITE, :Self],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was hurt by the Anomalies' eerie aura!",
	  :playsound_1 	=> "Anim/PRSFX- Night Daze1",
	  :hp      		=> -8
    },
  }

  #-----------------------------------------------------------------------------
  # Anomaly battles from corpses in the Spire of Time
  # Varies
  #-----------------------------------------------------------------------------

  ANOMALYTIME_0 = {
    "attackerDamaged_foe_random" => {
	  :text      	=> "Regenerate vitality!",
	  :playsound 	=> "zbrrdy00",
	  :text_1      	=> "The Anomaly gathered its energy!",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1]
    },
    "attackerCrit_foe_random" => {
	  :text      	=> "Chaos reigns!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1]
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
  
  ANOMALYTIME_1 = {
    "attackerSEdmg_foe_random" => {
	  :text      	=> "You can run but you cannot hide!",
	  :playsound 	=> "zbrrdy00",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1]
    },
    "switchSentOut_foe_random" => {
	  :text      	=> "We shall not yield!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Self,
	  :anim     	=> [:VENOMDRENCH, :Opposing],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Venom Drench",
	  :hp      		=> -8,
      :status  		=> :POISON
    },
    "defenderDamaged_foe_random" => {
	  :text      	=> "We shall conquer!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_DEFENSE, 1]
    },
  }
  
  ANOMALYTIME_2 = {
    "attackerNVEdmg_foe_random" => {
	  :text      	=> "We shall prevail!",
	  :playsound 	=> "zbrrdy00",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1]
    },
    "defenderDamaged_foe_random" => {
	  :text      	=> "We cannot be stopped!",
	  :playsound 	=> "zbrrdy00",
      :battler 		=> :Opposing,
	  :anim    		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:SPECIAL_DEFENSE, -1]
    },
    "attackerDodged_foe_random" => {
	  :text      	=> "We shall consume your essence!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ACCURACY, 1]
    },
  }
  
  ANOMALYTIME_3 = {
    "attackerDamaged_foe_random" => {
	  :text      	=> "Mmm... Fresh meat!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1]
    },
    "defenderDamaged_foe_random" => {
	  :text      	=> "I shall feed today!",
	  :playsound 	=> "zbryes02",
      :battler 		=> :Opposing,
	  :anim    		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:SPECIAL_DEFENSE, -1]
    },
    "attackerSEdmg_foe_random" => {
	  :text      	=> "We hunger, we feed!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> [:VENOMDRENCH, :Self],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Venom Drench",
	  :hp      		=> -8,
      :status  		=> :POISON
    },
  }

  #-----------------------------------------------------------------------------
  # Battle with EG Anomaly Soldier 0
  # Standard: Poisonous Substance, 1 layer of spikes
  # Adept+: Toxic Spikes and Stealth Rock. Random chip on S/E damage, when defender is low heals 25%
  #-----------------------------------------------------------------------------

  EGANOMALY_SOLDIER_STD = {
    "turnCommand" => {
	  :speech       	=> [:Opposing, "You think we gonna let you off easy?"],
	  :battler 			=> :Opposing,
	  :anim 			=> [:TOXICSPIKES, :Opposing],
	  :battler_1 		=> :Self,
	  :team 			=> [
        [PBEffects::ToxicSpikes, 1, "The Absorbed Soldier spread a poisonous substance on your side of the field!"],
      ],
	  :battler_2 		=> :Opposing,
      :anim_1         	=> [:SPIKES, :Opposing],
      :battler_3   		=> :Self,
      :team_1         	=> [
        [PBEffects::Spikes, 1, "The Absorbed Soldier dropped a layer of spikes on your side of the field!"],
      ],
    },
  }

  EGANOMALY_SOLDIER = {
    "turnCommand" => {
	  :speech       => [:Opposing, "Infest and multiply!"],
	  :battler 		=> :Opposing,
	  :anim 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team 		=> [
        [PBEffects::ToxicSpikes, 2, "The Absorbed Soldier spread some Toxic Spikes on your side of the field!"],
      ],
	  :battler_2 	=> :Opposing,
	  :anim_1 		=> [:STEALTHROCK, :Opposing],
	  :battler_3 	=> :Self,
	  :team_1 		=> [
        [PBEffects::StealthRock, true, "Pointed stones float in the air around {1}!"],
      ],
    },
    "attackerSEdmg_foe_random" => {
	  :text      	=> "I cannot deny my horde fresh meat when it wanders so willingly into our midst!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> [:SPITE, :Self],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was hurt by the Anomalies' eerie aura!",
	  :playsound_1 	=> "Anim/PRSFX- Night Daze1",
	  :hp      		=> -8
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

  #-----------------------------------------------------------------------------
  # Spires of Creation EG Trainer Teams
  #-----------------------------------------------------------------------------

  EGSPIRES_0 = {
    "switchSentOutLast_foe" => {
	  :speech      	=> [:Self, "It's time I put you in the ground once and for all!"],
	  :battler 		=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1]
    },
  }

  EGSPIRES_1 = {
    "switchSentOutLast_foe" => {
	  :speech      	=> [:Self, "I won't lose to you!"],
	  :battler 		=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1, :DEFENSE, 1]
    },
  }
  
  EGSPIRES_2 = {
    "switchSentOutLast_foe" => {
	  :speech      	=> [:Self, "The Ethereal Guild will be victorious!"],
	  :battler 		=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1, :SPECIAL_DEFENSE, 1]
    },
  }
  
  EGSPIRES_3 = {
    "switchSentOutLast_foe" => {
	  :speech      	=> [:Self, "You got into a fight with the wrong person!"],
	  :battler 		=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1, :SPECIAL_DEFENSE, 1]
    },
  }
  
  EGSPIRES_4 = {
    "switchSentOutLast_foe" => {
	  :speech      	=> [:Self, "I still have one ace up my sleeve!"],
	  :battler 		=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1, :DEFENSE, 1]
    },
  }

  #-----------------------------------------------------------------------------
  # Battle with EG Captain in Spire of Space
  # Standard: Poisonous Substance and 1 layer of spikes
  # Adept+: Toxic Spikes and Stealth Rock, When you dodge +1 spd/accuracy, and then drop atk/spatj when defender is on half health or lower.
  #-----------------------------------------------------------------------------

  EGCAPTAIN_SPACE_STD = {
    "turnCommand" => {
	  :speech       	=> [:Opposing, "You think we gonna let you off easy?"],
	  :battler 			=> :Opposing,
	  :anim 			=> [:TOXICSPIKES, :Opposing],
	  :battler_1 		=> :Self,
	  :team 			=> [
        [PBEffects::ToxicSpikes, 1, "The Ethereal Guild Captain spread a poisonous substance on your side of the field!"],
      ],
	  :battler_2 		=> :Opposing,
      :anim_1         	=> [:SPIKES, :Opposing],
      :battler_3   		=> :Self,
      :team_1         	=> [
        [PBEffects::Spikes, 1, "The Ethereal Guild Captain dropped a layer of spikes on your side of the field!"],
      ],
    },
  }

  EGCAPTAIN_SPACE = {
    "turnCommand" => {
	  :speech       => [:Opposing, "Angelo cannot be stopped!"],
	  :battler 		=> :Opposing,
	  :anim 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team 		=> [
        [PBEffects::ToxicSpikes, 2, "The Ethereal Guild Captain spread some Toxic Spikes on your side of the field!"],
      ],
	  :battler_2 	=> :Opposing,
	  :anim_1 		=> [:STEALTHROCK, :Opposing],
	  :battler_3 	=> :Self,
	  :team_1 		=> [
        [PBEffects::StealthRock, true, "Pointed stones float in the air around {1}!"],
      ],
    },
    "attackerDodged_foe_random" => {
	  :text      	=> "You cannot escape the might of my Anomaly slaves!",
	  :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1]
    },
    "defenderHPHalf_foe_random" => {
	  :text      	=> "I shall quash you, pest!",
	  :battler 		=> :Self,
	  :anim     	=> [:GOOSEBUMP, :Opposing],
	  :battler_1   	=> :Opposing,
	  :anim_1  		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:ATTACK, -1, :SPECIAL_ATTACK, -1]
    },
  }

  #-----------------------------------------------------------------------------
  # Final Main Game Battle with Angelo in the Remnants of the Origin
  # Standard: Reflect/Light Screen in effect for 3 turns but you get screens for 5 turns
  # Adept+: Reflect/Light Screen in effect for 5 turns and heals/damages you once
  #-----------------------------------------------------------------------------

  EGADMIN_ANGELO0_STD = {
    "turnCommand" => {
	  :speech 				=> [:Speaker, :TIMEWARDEN_Cara, "\\PN, I'm channelling the energy of the Soulstone to help you!"],
      :battler 				=> :Self,
	  :anim 				=> [:REFLECT, :Self],
	  :team 				=> [
        [PBEffects::Reflect, 5, "Cara's Soulstone set up a Reflect barrier on your side of the field!"]
	  ],
	  :anim_1 				=> [:LIGHTSCREEN, :Self],
	  :team_1 				=> [
		[PBEffects::LightScreen, 5, "Cara's Soulstone set up a Light Screen barrier on your side of the field!"],
	  ],
	  :speech_1				=> [:Opposing, "My artificial Sigils shall shield me!"],
      :battler_1			=> :Opposing,
	  :anim_2 				=> [:REFLECT, :Opposing],
	  :team_2 				=> [
        [PBEffects::Reflect, 3, "Angelo put up a Reflect barrier!"]
	  ],
	  :anim_3 				=> [:LIGHTSCREEN, :Opposing],
	  :team_3 				=> [
		[PBEffects::LightScreen, 3, "Angelo put up a Light Screen barrier!"],
	  ]
    },
  }

  EGADMIN_ANGELO0 = {
    "turnCommand" => {
	  :speech  => [:Opposing, "My artificial Sigils shall shield me!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 5, "Angelo put up a Reflect barrier!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Opposing],
	  :team_1 => [
		[PBEffects::LightScreen, 5, "Angelo put up a Light Screen barrier!"],
	  ]
    },
    "attackerSEdmg_foe_random" => {
	  :text      	=> "I am destined for greatness. You are just an obstacle in the way!",
	  :battler 		=> :Self,
	  :anim     	=> [:PURGE, :Opposing],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was struck by the Sigils!",
	  :playsound_1 	=> "Anim/handofgod",
	  :hp      		=> -8,
    },
    "defenderDamaged_foe_random" => {
	  :text      	=> "I can command the Sigils to do my will!",
	  :battler   	=> :Self,
	  :anim     	=> [:LUNARDANCE, :Self],
	  :hp      		=> 8,
    },
  }
  
  #-----------------------------------------------------------------------------
  # Final Main Game Battle with Angelo in the Remnants of the Origin
  # Standard: Reflect/Light Screen in effect for 3 turns but you get screens for 5 turns
  # Adept+: Reflect/Light Screen in effect for 5 turns and drops your stats once
  #-----------------------------------------------------------------------------

  EGADMIN_ANGELO1_STD = {
    "turnCommand" => {
	  :speech 				=> [:Speaker, :TIMEWARDEN_Cara, "\\PN, I'm channelling the energy of the Soulstone to help you!"],
      :battler 				=> :Self,
	  :anim 				=> [:REFLECT, :Self],
	  :team 				=> [
        [PBEffects::Reflect, 5, "Cara's Soulstone set up a Reflect barrier on your side of the field!"]
	  ],
	  :anim_1 				=> [:LIGHTSCREEN, :Self],
	  :team_1 				=> [
		[PBEffects::LightScreen, 5, "Cara's Soulstone set up a Light Screen barrier on your side of the field!"],
	  ],
	  :speech_1				=> [:Opposing, "My artificial Sigils shall shield me!"],
      :battler_1			=> :Opposing,
	  :anim_2 				=> [:REFLECT, :Opposing],
	  :team_2 				=> [
        [PBEffects::Reflect, 3, "Angelo put up a Reflect barrier!"]
	  ],
	  :anim_3 				=> [:LIGHTSCREEN, :Opposing],
	  :team_3 				=> [
		[PBEffects::LightScreen, 3, "Angelo put up a Light Screen barrier!"],
	  ]
    },
  }

  EGADMIN_ANGELO1 = {
    "turnCommand" => {
	  :speech  => [:Opposing, "My artificial Sigils shall shield me!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 5, "Angelo put up a Reflect barrier!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Opposing],
	  :team_1 => [
		[PBEffects::LightScreen, 5, "Angelo put up a Light Screen barrier!"],
	  ]
    },
    "defenderDamaged_foe_random" => {
	  :text      	=> "Your defeat is nigh!",
      :battler 		=> :Opposing,
	  :anim    		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:DEFENSE, -1, :SPECIAL_DEFENSE, 1]
    },
    "defenderHPHalf_foe_random" => {
	  :text      	=> "I shall quash you, pest!",
	  :battler 		=> :Self,
	  :anim     	=> [:GOOSEBUMP, :Opposing],
	  :battler_1   	=> :Opposing,
	  :anim_1  		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:ATTACK, -1, :SPECIAL_ATTACK, -1]
    },
  }

  #-----------------------------------------------------------------------------
  # Final Main Game Battle with Angelo in the Remnants of the Origin
  # Standard: Poisonous Substance, and 1 layer of spikes
  # Adept+: Toxic Spikes/Stealth Rock in effect and heals/damages you once
  #-----------------------------------------------------------------------------

  EGADMIN_ANGELO2_STD = {
    "turnCommand" => {
	  :speech 				=> [:Speaker, :TIMEWARDEN_Cara, "\\PN, I'm channelling the energy of the Soulstone to help you!"],
      :battler 				=> :Self,
	  :anim 				=> [:REFLECT, :Self],
	  :team 				=> [
        [PBEffects::Reflect, 5, "Cara's Soulstone set up a Reflect barrier on your side of the field!"]
	  ],
	  :anim_1 				=> [:LIGHTSCREEN, :Self],
	  :team_1 				=> [
		[PBEffects::LightScreen, 5, "Cara's Soulstone set up a Light Screen barrier on your side of the field!"],
	  ],
	  :speech_1       		=> [:Opposing, "I will do whatever it takes to win!"],
	  :battler_1 			=> :Opposing,
	  :anim_2 				=> [:TOXICSPIKES, :Opposing],
	  :battler_2 			=> :Self,
	  :team_2 				=> [
        [PBEffects::ToxicSpikes, 1, "Angelo spread a poisonous substance on your side of the field!"],
      ],
	  :battler_3 			=> :Opposing,
      :anim_3         		=> [:SPIKES, :Opposing],
      :battler_4   			=> :Self,
      :team_3         		=> [
        [PBEffects::Spikes, 1, "Angelo dropped a layer of spikes on your side of the field!"],
      ],
    },
  }

  EGADMIN_ANGELO2 = {
    "turnCommand" => {
	  :speech       => [:Opposing, "I will do whatever it takes to win!"],
	  :battler 		=> :Opposing,
	  :anim 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team 		=> [
        [PBEffects::ToxicSpikes, 2, "Angelo spread some Toxic Spikes on your side of the field!"],
      ],
	  :battler_2 	=> :Opposing,
	  :anim_1 		=> [:STEALTHROCK, :Opposing],
	  :battler_3 	=> :Self,
	  :team_1 		=> [
        [PBEffects::StealthRock, true, "Pointed stones float in the air around {1}!"],
      ],
    },
    "attackerSEdmg_foe_random" => {
	  :text      	=> "I am destined for greatness. You are just an obstacle in the way!",
	  :battler 		=> :Self,
	  :anim     	=> [:PURGE, :Opposing],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was struck by the Sigils!",
	  :playsound_1 	=> "Anim/handofgod",
	  :hp      		=> -8,
    },
    "defenderDamaged_foe_random" => {
	  :text      	=> "I can command the Sigils to do my will!",
	  :battler   	=> :Self,
	  :anim     	=> [:LUNARDANCE, :Self],
	  :hp      		=> 8,
    },
  }
  
  #-----------------------------------------------------------------------------
  # Final Main Game Battle with Angelo in the Remnants of the Origin
  # Standard: Poisonous Substance, and 1 layer of spikes but you get 5 turns of screens
  # Adept+: Toxic Spikes/Stealth Rock in effect and drops your stats once.
  #-----------------------------------------------------------------------------

  EGADMIN_ANGELO3_STD = {
    "turnCommand" => {
	  :speech 				=> [:Speaker, :TIMEWARDEN_Cara, "\\PN, I'm channelling the energy of the Soulstone to help you!"],
      :battler 				=> :Self,
	  :anim 				=> [:REFLECT, :Self],
	  :team 				=> [
        [PBEffects::Reflect, 5, "Cara's Soulstone set up a Reflect barrier on your side of the field!"]
	  ],
	  :anim_1 				=> [:LIGHTSCREEN, :Self],
	  :team_1 				=> [
		[PBEffects::LightScreen, 5, "Cara's Soulstone set up a Light Screen barrier on your side of the field!"],
	  ],
	  :speech_1       		=> [:Opposing, "I will do whatever it takes to win!"],
	  :battler_1 			=> :Opposing,
	  :anim_2 				=> [:TOXICSPIKES, :Opposing],
	  :battler_2 			=> :Self,
	  :team_2 				=> [
        [PBEffects::ToxicSpikes, 1, "Angelo spread a poisonous substance on your side of the field!"],
      ],
	  :battler_3 			=> :Opposing,
      :anim_3         		=> [:SPIKES, :Opposing],
      :battler_4   			=> :Self,
      :team_3         		=> [
        [PBEffects::Spikes, 1, "Angelo dropped a layer of spikes on your side of the field!"],
      ],
    },
  }

  EGADMIN_ANGELO3 = {
    "turnCommand" => {
	  :speech       => [:Opposing, "I will do whatever it takes to win!"],
	  :battler 		=> :Opposing,
	  :anim 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team 		=> [
        [PBEffects::ToxicSpikes, 2, "Angelo spread some Toxic Spikes on your side of the field!"],
      ],
	  :battler_2 	=> :Opposing,
	  :anim_1 		=> [:STEALTHROCK, :Opposing],
	  :battler_3 	=> :Self,
	  :team_1 		=> [
        [PBEffects::StealthRock, true, "Pointed stones float in the air around {1}!"],
      ],
    },
    "defenderDamaged_foe_random" => {
	  :text      	=> "Your defeat is nigh!",
      :battler 		=> :Opposing,
	  :anim    		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:DEFENSE, -1, :SPECIAL_DEFENSE, -1]
    },
    "defenderHPHalf_foe_random" => {
	  :text      	=> "I shall quash you, pest!",
	  :battler 		=> :Self,
	  :anim     	=> [:GOOSEBUMP, :Opposing],
	  :battler_1   	=> :Opposing,
	  :anim_1  		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:ATTACK, -1, :SPECIAL_ATTACK, -1]
    },
  }

  #-----------------------------------------------------------------------------
  # Final Main Game Battle with Angelo's Anomaly team
  # Standard: +Atk/SpAtk on Crit, but you get screens for 5 turns
  # Adept+: +Atk/SpAtk on Crit, one-time chip on SE damage, and +Speed/Accuracy when you dodge.
  #-----------------------------------------------------------------------------

  EGADMIN_ANOMALIES_STD = {
    "turnCommand" => {
	  :speech 				=> [:Speaker, :TIMEWARDEN_Cara, "\\PN, I'm channelling the energy of the Soulstone to help you!"],
      :battler 				=> :Self,
	  :anim 				=> [:REFLECT, :Self],
	  :team 				=> [
        [PBEffects::Reflect, 5, "Cara's Soulstone set up a Reflect barrier on your side of the field!"]
	  ],
	  :anim_1 				=> [:LIGHTSCREEN, :Self],
	  :team_1 				=> [
		[PBEffects::LightScreen, 5, "Cara's Soulstone set up a Light Screen barrier on your side of the field!"],
	  ],
    },
    "attackerCrit_foe_random" => {
	  :text      	=> "The Anomalies shall finish you off once and for all!",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1, :SPECIAL_ATTACK, 1]
    },
  }

  EGADMIN_ANOMALIES = {
    "attackerCrit_foe_random" => {
	  :text      	=> "The Anomalies shall finish you off once and for all!",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1, :SPECIAL_ATTACK, 1]
    },
    "attackerSEdmg_foe_random" => {
	  :text      	=> "It is only a matter of time before you capitulate!",
	  :battler 		=> :Self,
	  :anim     	=> [:GOOSEBUMP, :Opposing],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was cursed!",
	  :playsound_1 	=> "Anim/goosebump",
	  :hp      		=> -8,
    },
    "attackerDodged_foe_random" => {
	  :text      	=> "You cannot escape the might of my Anomaly slaves!",
	  :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1]
    },
  }
  
  #-----------------------------------------------------------------------------
  # Final Main Game Battle with Angelo's team of Arceus and the Creation Trio
  # Standard: No boosts for Angelo's final battle. You just benefit from Reflect/Light Screen
  # Adept+: One-time hit on S/E damage, and then one-time drop to Atk/SpAtk when defender is at half HP
  #-----------------------------------------------------------------------------

  EGADMIN_GODS_STD = {
    "turnCommand" => {
	  :speech 		=> [:Speaker, :TIMEWARDEN_Cara, "\\PN, I'm channelling the energy of the Soulstone to help you!"],
      :battler 		=> :Self,
	  :anim => 		[:REFLECT, :Self],
	  :team => 		[
        [PBEffects::Reflect, 5, "Cara's Soulstone set up a Reflect barrier on your side of the field!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Self],
	  :team_1 => [
		[PBEffects::LightScreen, 5, "Cara's Soulstone set up a Light Screen barrier on your side of the field!"],
	  ],
    },
  }

  EGADMIN_GODS = {
    "turnCommand" => {
	  :speech 		=> [:Speaker, :TIMEWARDEN_Cara, "\\PN, I'm channelling the energy of the Soulstone to help you!"],
      :battler 		=> :Self,
	  :anim => 		[:REFLECT, :Self],
	  :team => 		[
        [PBEffects::Reflect, 5, "Cara's Soulstone set up a Reflect barrier on your side of the field!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Self],
	  :team_1 => [
		[PBEffects::LightScreen, 5, "Cara's Soulstone set up a Light Screen barrier on your side of the field!"],
	  ],
    },
    "attackerSEdmg_foe_random" => {
	  :text      	=> "I shall use the Gods to seal my victory!",
	  :battler 		=> :Self,
	  :anim     	=> [:PURGE, :Opposing],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was struck by the Sigils!",
	  :playsound_1 	=> "Anim/handofgod",
	  :hp      		=> -8,
    },
    "defenderHPHalf_foe_random" => {
	  :text      	=> "Why won't you roll over and die!?",
	  :battler 		=> :Self,
	  :anim     	=> [:GOOSEBUMP, :Opposing],
	  :battler_1   	=> :Opposing,
	  :anim_1  		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:ATTACK, -1, :SPECIAL_ATTACK, -1]
    },
  }

  #-----------------------------------------------------------------------------
  # Practice Battles between Artie, Caitlin, Cara and Aki during Main Game Epilogue
  # Standard: Enemy foe sets up 3 turns of Reflect and Light Screen
  # Adept+: Enemy foe sets up 5 turns of Reflect and Light Screen
  #-----------------------------------------------------------------------------

  MAINGAME_PRACTICEBATTLE_STD = {
    "turnCommand" => {
	  :speech  => [:Opposing, "I'm putting up some protection for my team!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 3, "Your foe set up a Reflect barrier!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Opposing],
	  :team_1 => [
		[PBEffects::LightScreen, 3, "Your foe set up a Light Screen barrier!"],
	  ]
    },
  }

  MAINGAME_PRACTICEBATTLE = {
    "turnCommand" => {
	  :speech  => [:Opposing, "I'm putting up some protection for my team!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 5, "Your foe set up a Reflect barrier!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Opposing],
	  :team_1 => [
		[PBEffects::LightScreen, 5, "Your foe set up a Light Screen barrier!"],
	  ]
    },
  }
  
  #-----------------------------------------------------------------------------
  # Practice Battles for Anime 
  # Standard: Trick room is triggered every 5 turns (effectively permanent unless you remove it)
  # Adept+: Magic Room is applied in addition (effectively permanent unless you remove it).
  #-----------------------------------------------------------------------------

  MAINGAME_PRACTICEBATTLE_ANIME = {
    "turnCommand_repeat" => {
    :battler => :Self,
      :trickroomShift => 0,
    },
  }
  
  MAINGAME_PRACTICEBATTLE_ANIME_STD = {
    "turnCommand_repeat" => {
    :battler => :Self,
      :trickroomShift => 0,
    },
  }
  
  
  #-----------------------------------------------------------------------------
  # Practice Battles for Hypertox (Misty Terrain)
  # Standard: Misty Terrain
  # Adept+: Misty Terrain and boosts def/spdef by 1 stage
  #-----------------------------------------------------------------------------

  MAINGAME_PRACTICEBATTLE_HYPERTOX = {
    "turnCommand" => {
	  :speech       	 => [:Opposing, "*Cough* Damnit, these goggles are fogging up!"],
	  :battler		 	 => :Self,
	  :terrain		 	 => :Misty,
	  :playsound	 	 => "Anim/PRSFX- Misty Terrain",
	  :anim	     		 => [:MISTYTERRAIN],
      :battler_2   		=> :Opposing,
	  :anim_2     		=> "Common:StatUp",
	  :playsound_2 		=> "Anim/increase",
	  :stats_2     		=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1]
    },
  }

  MAINGAME_PRACTICEBATTLE_HYPERTOX_STD = {
    "turnCommand" => {
	  :speech       	 => [:Opposing, "*Cough* Damnit, these goggles are fogging up!"],
	  :battler		 	 => :Self,
	  :terrain		 	 => :Misty,
	  :playsound	 	 => "Anim/PRSFX- Misty Terrain",
	  :anim	     		 => [:MISTYTERRAIN],
	  :speech_1			 => [:Opposing, "I can't see a damn thing!"]
    },
  }

  #-----------------------------------------------------------------------------
  # Practice Battles for Rexy (Tailwind)
  # Standard: Tailwind
  # Adept+: Tailwind
  #-----------------------------------------------------------------------------

  MAINGAME_PRACTICEBATTLE_REXY = {
    "turnCommand" => {
	  :speech 			=> [:Opposing, "Be prepared to be blown away!"],
      :battler   		=> :Opposing,
      :anim         	=> [:TAILWIND, :Opposing],
	  :team => [ 
		[PBEffects::Tailwind, 4, "The wind is blowing in the enemy team's favour!"],
		]
    },
  }  

  MAINGAME_PRACTICEBATTLE_REXY_STD = {
    "turnCommand" => {
	  :speech 			=> [:Opposing, "Be prepared to be blown away!"],
      :battler   		=> :Opposing,
      :anim         	=> [:TAILWIND, :Opposing],
	  :team => [ 
		[PBEffects::Tailwind, 4, "The wind is blowing in the enemy team's favour!"],
		]
    },
  }  
  
  #-----------------------------------------------------------------------------
  # Practice Battles for MissNyakura (+2 accuracy and Tailwind)
  # Standard: Tailwind
  # Adept+: +2 Accuracy and Tailwind
  #-----------------------------------------------------------------------------

  MAINGAME_PRACTICEBATTLE_MISS = {
    "turnCommand" => {
	  :speech 			=> [:Opposing, "Yay, it's looking like a windy day!"],
      :battler   		=> :Opposing,
      :anim         	=> [:TAILWIND, :Opposing],
	  :team => [ 
		[PBEffects::Tailwind, 4, "The wind is blowing in the enemy team's favour!"],
		],
      :battler_1   		=> :Opposing,
	  :anim_1     		=> "Common:StatUp",
	  :playsound_1 		=> "Anim/increase",
	  :stats_1     		=> [:ACCURACY, 2],
      :battler_2   		=> :OpposingAlly,
	  :anim_2     		=> "Common:StatUp",
	  :playsound_2 		=> "Anim/increase",
	  :stats_2     		=> [:ACCURACY, 2]
    },
  }

  MAINGAME_PRACTICEBATTLE_MISS_STD = {
    "turnCommand" => {
	  :speech 			=> [:Opposing, "Yay, it's looking like a windy day!"],
      :battler   		=> :Opposing,
      :anim         	=> [:TAILWIND, :Opposing],
	  :team => [ 
		[PBEffects::Tailwind, 4, "The wind is blowing in the enemy team's favour!"],
		]
    },
  }

  #-----------------------------------------------------------------------------
  # Practice Battles for Attea (Different Effect)
  # Standard: Sets up gravity (3 turns)
  # Adept+: Sets up gravity (5 turns) and sleeps first enemy
  #-----------------------------------------------------------------------------

  MAINGAME_PRACTICEBATTLE_ATTEA_STD = {
    "turnCommand" => {
	  :speech  		=> [:Opposing, "Everyone is coming crash down to earth!"],
	  :anim    		=> [:GRAVITY],
	  :field 		=> [ 
		[PBEffects::Gravity, 3, "Gravity intensified!"]
	  ]
    },
  }

  MAINGAME_PRACTICEBATTLE_ATTEA = {
    "turnCommand" => {
	  :speech  => [:Opposing, "Everyone is coming crash down to earth!"],
	  :anim    => [:GRAVITY],
	  :field => [ 
		[PBEffects::Gravity, 5, "Gravity intensified!"]
	  ],
	  :battler 		=> :Opposing,
	  :anim_1     	=> [:NIGHTDAZE, :Opposing],
	  :playsound 	=> "Anim/PRSFX- Night Daze1",
	  :battler_1   	=> :Self,
      :status  		=> :SLEEP
    },
  }

  #-----------------------------------------------------------------------------
  # Practice Battles for Yoshi (Special Dialogue)
  # Standard: Enemy foe sets up 3 turns of Reflect and Light Screen
  # Adept+: Enemy foe sets up 5 turns of Reflect and Light Screen
  #-----------------------------------------------------------------------------

  MAINGAME_PRACTICEBATTLE_YOSHI_STD = {
    "turnCommand" => {
	  :speech  => [:Opposing, "The best offense is a good defense! Or in this case, both are good!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 3, "Your foe set up a Reflect barrier!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Opposing],
	  :team_1 => [
		[PBEffects::LightScreen, 3, "Your foe set up a Light Screen barrier!"],
	  ]
    },
  }

  MAINGAME_PRACTICEBATTLE_YOSHI = {
    "turnCommand" => {
	  :speech  => [:Opposing, "The best offense is a good defense! Or in this case, both are good!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 5, "Your foe set up a Reflect barrier!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Opposing],
	  :team_1 => [
		[PBEffects::LightScreen, 5, "Your foe set up a Light Screen barrier!"],
	  ]
    },
  }

  #-----------------------------------------------------------------------------
  # Ronnie in Mt. Titania
  # Weather is hailing and Aurora Veil gets set up for 3/5 turns.
  #-----------------------------------------------------------------------------

  RONNIE_MTTITANIA_STD = {
    "turnCommand" => {
	  :speech  => [:Opposing, "I love the snow!"],
      :battler => :Opposing,
	  :anim => [:AURORAVEIL, :Opposing],
	  :team => [
        [PBEffects::AuroraVeil, 3, "Ronnie put up an Aurora Veil barrier!"]
	  ]
    },
  }

  RONNIE_MTTITANIA = {
    "turnCommand" => {
	  :speech  => [:Opposing, "I love the snow!"],
      :battler => :Opposing,
	  :anim => [:AURORAVEIL, :Opposing],
	  :team => [
        [PBEffects::AuroraVeil, 5, "Ronnie put up an Aurora Veil barrier!"]
	  ]
    },
  }

  #-----------------------------------------------------------------------------
  # Trapped Soldiers Side Quest
  # Standard: Anomalies will lay down a sticky web
  # Adept+: Sticky web, sleep your lead and remove 1/8 life.
  #-----------------------------------------------------------------------------

  TRAPPED_SOLDIERS_STD = {
    "turnCommand" => {
	  :playsound 	=> "zbrrdy00",
	  :text      	=> "YOU. SHALL. NOT. ESCAPE.",
	  :battler		=> :Opposing,
	  :anim 		=> [:STICKYWEB, :Opposing],
	  :battler_1 	=> :Self,
	  :team_1 		=> [
        [PBEffects::StickyWeb, true, "The Anomalies laid a sticky substance on your side of the field!"],
      ],
    },
  }

  TRAPPED_SOLDIERS = {
    "turnCommand" => {
	  :text      	=> "You cannot escape us...",
	  :battler 		=> :Opposing,
	  :anim     	=> [:NIGHTDAZE, :Opposing],
	  :playsound 	=> "Anim/PRSFX- Night Daze1",
	  :battler_1   	=> :Self,
	  :hp      		=> -8,
      :status  		=> :SLEEP,
	  :battler_2 	=> :Opposing,
	  :anim_1 		=> [:STICKYWEB, :Opposing],
	  :battler_3 	=> :Self,
	  :team_1 		=> [
        [PBEffects::StickyWeb, true, "The Anomalies laid a sticky substance on your side of the field!"],
      ],
    },
  }
  
  #-----------------------------------------------------------------------------
  # Trapped Soldiers Side Quest - Adria the Boss
  # Standard: Poisonous Substance.
  # Adept+: Sticky web and toxic spikes.
  #-----------------------------------------------------------------------------

  ADRIA_SHADOWMOON_MARSH_STD = {
    "turnCommand" => {
	  :speech       => [:Opposing, "I must defeat you to secure my own free will!"],
	  :battler 		=> :Opposing,
	  :anim 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team 		=> [
        [PBEffects::ToxicSpikes, 1, "Adria the Witch dropped a poisonous substance on your side of the field!"],
      ],
    },	
  }

  ADRIA_SHADOWMOON_MARSH = {
    "turnCommand" => {
	  :speech       => [:Opposing, "I must defeat you to secure my own free will!"],
	  :battler 		=> :Opposing,
	  :anim 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team 		=> [
        [PBEffects::ToxicSpikes, 2, "Adria the Witch dropped Toxic Spikes on your side of the field!"],
      ],
	  :battler_2 	=> :Opposing,
	  :anim_1 		=> [:STICKYWEB, :Opposing],
	  :battler_3 	=> :Self,
	  :team_1 		=> [
        [PBEffects::StickyWeb, true, "Adria the Witch dropped a sticky substance on your side of the field!"],
      ],
    },	
  }
  
  #-----------------------------------------------------------------------------
  # Christina - Shadowmoon Marsh
  # Weather is Raining
  # Standard: Burns both of your leads.
  # Adept+: Burns both of your leads, and lowers their defense and spdef stats by 1 each.
  #-----------------------------------------------------------------------------

  CHRISTINA_SHADOWMOON_STD = {
    "turnCommand" => {
	  :speech    	=> [:Opposing, "My master has blessed me with unfathomable power!"],
	  :battler 		=> :Opposing,
	  :anim     	=> [:MYSTICALFIRE, :Opposing],
	  :battler_1   	=> :Self,
	  :text      	=> "{2}'s team were burned by a shroud of temporal energy!",
	  :playsound 	=> "Anim/PRSFX- Spite2",
      :status  		=> :BURN,
	  :battler_2   	=> :Ally,
	  :status_1		=> :BURN
    },
  }

  CHRISTINA_SHADOWMOON = {
    "turnCommand" => {
	  :speech    	=> [:Opposing, "My master has blessed me with unfathomable power!"],
	  :battler 		=> :Opposing,
	  :anim     	=> [:MYSTICALFIRE, :Opposing],
	  :battler_1   	=> :Self,
	  :text      	=> "{2}'s team were burned by a shroud of temporal energy!",
	  :playsound 	=> "Anim/PRSFX- Spite2",
      :status  		=> :BURN,
	  :battler_2  	=> :Self,
	  :anim_1      	=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats       	=> [:DEFENSE, -1, :SPECIAL_DEFENSE, -1],
	  :battler_3   	=> :Ally,
	  :status_1		=> :BURN,
	  :stats_1      => [:DEFENSE, -1, :SPECIAL_DEFENSE, -1]
    },
  }

  #-----------------------------------------------------------------------------
  # Protector Statues in Eridanus Tunnels
  # Level 78-79 Simipours or Gliscors, Adamant Nature, 31 IVs
  # Simipours and Gliscor know specific moves
  #-----------------------------------------------------------------------------

=begin
# The original setup of the Simipour.
	WildBattle.dx_start([:SIMIPOUR, 78], {:outcome => 73 }, {
	  :ability => 1, # Unaware
	  :moves   => [:CATAPULT, :TITANHAMMER, :PSYSTRIKE, :IRONHEAD],
	  :nature  => :ADAMANT,
	  :ivs     => 31,
	}, 
	:PROTECTOR_STATUETTE)

# The original setup of the Gliscor.	
	WildBattle.dx_start([:GLISCOR, 78], {:outcome => 73 }, {
	  :ability => 1, # Unaware
	  :moves   => [:CRUNCH, :OUTRAGE, :STONEEDGE, :HAMMERARM],
	  :nature  => :ADAMANT,
	  :ivs     => 31,
	}, 
	:PROTECTOR_STATUETTE)
=end

# The midbattle config for the statuette Pokemon
  PROTECTOR_STATUETTE = {
    "turnCommand" => {
      :text        	 => "You shall never find our city, intruder!",
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
  # A Witch's Ramblings Side Quest - Casper the Chained Spirit
  # Standard: Sticky web.
  # Adept+: Sticky web and attacking curse.
  #-----------------------------------------------------------------------------

  CASPER_SECRETCHAMBER_STD = {
    "turnCommand" => {
	  :speech       => [:Opposing, "This chamber shall be our shared tomb!"],
	  :playsound    => "Evil Laugh2",
	  :battler 		=> :Opposing,
	  :anim 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team 		=> [
        [PBEffects::ToxicSpikes, 1, "The chamber has a corrosive substance on your side of the field!"],
      ],
    },	
  }

  CASPER_SECRETCHAMBER = {
    "turnCommand" => {
	  :speech       => [:Opposing, "This chamber shall be our shared tomb!"],
	  :playsound    => "Evil Laugh2",
	  :battler 		=> :Opposing,
	  :anim 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team 		=> [
        [PBEffects::ToxicSpikes, 1, "The chamber has a corrosive substance on your side of the field!"],
      ],
	  :battler_2     => :Opposing,
      :anim_1        => [:CURSE, :Opposing],
      :playsound_1   => "Anim/Curse",
	  :battler_3     => :Self,
	  :anim_2        => "Common:StatDown",
	  :playsound_2   => "Anim/decrease",
	  :stats         => [:ATTACK, -1, :SPECIAL_ATTACK, -1],
      :text_1        => "The curse lowered your attacking stats!"
    },
  }

  #-----------------------------------------------------------------------------
  # Destroyer Wugtrio in Eridanus Tunnels
  # Lowers SpAtk by 1 Stage and burns you.
  # Lowers SpAtk by 1 stage, burns and takes out 1/4 life.
  #-----------------------------------------------------------------------------

  DESTROYER_WUGTRIO_STD = {
    "turnCommand" => {
	  :text        	 => "Must eliminate all threats!",
	  :battler 		 => :Opposing,
	  :anim          => [:MAGNETBOMB, :Opposing],
	  :battler_1     => :Self,
	  :anim_2        => "Common:StatDown",
	  :playsound_2   => "Anim/decrease",
	  :stats         => [:SPECIAL_ATTACK, -1],
      :status  		 => :BURN
    },
  }

  DESTROYER_WUGTRIO = {
    "turnCommand" => {
	  :text        	 => "Must eliminate all threats!",
	  :battler 		 => :Opposing,
	  :anim          => [:MAGNETBOMB, :Opposing],
	  :battler_1     => :Self,
	  :anim_2        => "Common:StatDown",
	  :playsound_2   => "Anim/decrease",
	  :stats         => [:SPECIAL_ATTACK, -1],
      :status  		 => :BURN,
      :hp      		=> -4
    },
  }

  #-----------------------------------------------------------------------------
  # Anomaly Wishiwashi
  # Standard: +1 SpAtk and Poisonous Substance
  # Adept+: +1 SpAtk and Toxic Spikes; heals 1/4 life when on low life
  #-----------------------------------------------------------------------------

  ANOMALYGROUP_ERIDANUS_TRENCH_STD = {
    "turnCommand" => {
	  :text      	=> "We shall bring your drowned corpse to the Master!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1],
	  :anim_1 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team_1 		=> [
        [PBEffects::ToxicSpikes, 1, "The Anomaly covered your side of the field in a poisonous substance!"],
      ],
    },
  }

  ANOMALYGROUP_ERIDANUS_TRENCH = {
    "turnCommand" => {
	  :text      	=> "We shall bring your drowned corpse to the Master!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1],
	  :anim_1 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team_1 		=> [
        [PBEffects::ToxicSpikes, 2, "The Anomaly covered your side of the field in Toxic Spikes!"],
      ],
    },
    "defenderHPLow_foe" => {
	  :text         		=> "I shall feast on your bones!",
	  :battler 				=> :Self,
	  :anim     			=> [:INGRAIN, :Self],
	  :playsound 			=> "Anim/PRSFX- Strength Sap1",
	  :hp      				=> 4,
	}
  }

#-----------------------------------------------------------------------------
  # Anomaly Battles in the Science District Attack
  # Various
  #-----------------------------------------------------------------------------

  SCIENCEDISTRICT_ANOMALY0 = {
    "attackerDamaged_foe_random" => {
	  :text      	=> "Regenerate vitality!",
	  :playsound 	=> "zbrrdy00",
	  :text_1      	=> "The Anomaly gathered its energy!",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1]
    },
    "attackerCrit_foe_random" => {
	  :text      	=> "Chaos reigns!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1]
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
  
  SCIENCEDISTRICT_ANOMALY1 = {
    "attackerSEdmg_foe_random" => {
	  :text      	=> "You can run but you cannot hide!",
	  :playsound 	=> "zbrrdy00",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1]
    },
    "switchSentOut_foe_random" => {
	  :text      	=> "We shall not yield!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Self,
	  :anim     	=> [:VENOMDRENCH, :Opposing],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Venom Drench",
	  :hp      		=> -8,
      :status  		=> :POISON
    },
    "defenderDamaged_foe_random" => {
	  :text      	=> "We shall conquer!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_DEFENSE, 1]
    },
  }
  
  SCIENCEDISTRICT_ANOMALY2 = {
    "attackerNVEdmg_foe_random" => {
	  :text      	=> "We shall prevail!",
	  :playsound 	=> "zbrrdy00",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1]
    },
    "defenderDamaged_foe_random" => {
	  :text      	=> "We cannot be stopped!",
	  :playsound 	=> "zbrrdy00",
      :battler 		=> :Opposing,
	  :anim    		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:SPECIAL_DEFENSE, -1]
    },
    "attackerDodged_foe_random" => {
	  :text      	=> "We shall consume your essence!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ACCURACY, 1]
    },
  }
  
  SCIENCEDISTRICT_ANOMALY3 = {
    "attackerDamaged_foe_random" => {
	  :text      	=> "Mmm... Fresh meat!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1]
    },
    "defenderDamaged_foe_random" => {
	  :text      	=> "I shall feed today!",
	  :playsound 	=> "zbryes02",
      :battler 		=> :Opposing,
	  :anim    		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:SPECIAL_DEFENSE, -1]
    },
    "attackerSEdmg_foe_random" => {
	  :text      	=> "We hunger, we feed!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> [:VENOMDRENCH, :Self],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Venom Drench",
	  :hp      		=> -8,
      :status  		=> :POISON
    },
  }

  #-----------------------------------------------------------------------------
  # Anomaly Swalot in Libram Dungeon for Magical Beasts Quest
  # Standard: Sets up 1 layer of spikes on entry
  # Adept+: Sets up 3 layers of spikes on entry, Ingrain on self
  #-----------------------------------------------------------------------------

  MAGICAL_BEASTS_STD = {
    "turnCommand" => {
      :text          	=> "PAIN. AGONY. SUFFERING.",
      :battler   		=> :Opposing,
	  :anim         	=> [:SPIKES, :Opposing],
      :battler_1   		=> :Self,
      :team         	=> [
        [PBEffects::Spikes, 1, "The Anomaly covered your side of the field in Spikes!"],
      ],
    },
  }

  MAGICAL_BEASTS = {
    "turnCommand" => {
      :text          	=> "YOU SHALL SUFFER TOO!",
      :battler         	=> :Opposing,
      :anim         	=> [:INGRAIN, :Self],
      :playsound     	=> "Anim/PRSFX- Ingrain1",
      :effects 			=> [[PBEffects::Ingrain, true]],
      :text_1          	=> "YOU. SHALL. NOT. FLEE.",
      :anim_1         	=> [:SPIKES, :Opposing],
      :battler_1     	=> :Self,
      :team_1         	=> [
        [PBEffects::Spikes, 3, "The Anomaly covered your side of the field in Spikes!"],
      ],
    },
  }

  #-----------------------------------------------------------------------------
  # Conclave Member Aldric Darkmoor (Team #0)
  # Standard: Poisonous Substance
  # Adept+: Toxic Spikes and Sticky Web on entry. Throws a concoction at you on turn 3 that burns you and takes off 1/8 life.
  # Curses you whenever two enemies faint.
  #-----------------------------------------------------------------------------

  CONCLAVE_ALDRIC0_STD = {
    "turnCommand" => {
	  :speech       => [:Opposing, "I'll maim you before I let anyone escape my Dungeon!"],
	  :battler 		=> :Opposing,
	  :anim 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team 		=> [
        [PBEffects::ToxicSpikes, 1, "Aldric flooded your side of the field with a poisonous substance!"],
      ],
    },	
  }

  CONCLAVE_ALDRIC0 = {
    "turnCommand" => {
	  :speech       => [:Opposing, "I'll maim you before I let anyone escape my Dungeon!"],
	  :battler 		=> :Opposing,
	  :anim 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team 		=> [
        [PBEffects::ToxicSpikes, 2, "Aldric dropped Toxic Spikes on your side of the field!"],
      ],
	  :battler_2 	=> :Opposing,
	  :anim_1 		=> [:STICKYWEB, :Opposing],
	  :battler_3 	=> :Self,
	  :team_1 		=> [
        [PBEffects::StickyWeb, true, "Aldric dropped a sticky substance on your side of the field!"],
      ],
    },	
    "turnCommand_3" => {
	  :speech       => [:Opposing, "I'll burn you alive!"],
	  :battler 		=> :Opposing,
	  :anim     	=> [:CONCOCTION, :Opposing],
	  :battler_1   	=> :Self,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Acid",
	  :hp      		=> -8,
      :status  		=> :BURN
    },
    "fainted_foe" => {
	  :speech         		=> [:Self, "You will never escape this place alive!"],
	  :text     		 	=> "Vengeful spirits Curse you every time two enemies faint!",
    },
	"fainted_foe_repeat" => {
	  :setvar => 1,
	},
	"variable_2" => {
	  :battler 				=> :Opposing,
	  :anim     			=> [:CURSE, :Self],
	  :playsound		 	=> "Anim/PRSFX- Curse",
      :effects				=> [[PBEffects::Curse, true]],
    },
	"variable_4" => {
	  :battler 				=> :Opposing,
	  :anim     			=> [:CURSE, :Self],
	  :playsound		 	=> "Anim/PRSFX- Curse",
      :effects				=> [[PBEffects::Curse, true]],
    },
  }
  
  #-----------------------------------------------------------------------------
  # Conclave Member Aldric Darkmoor (Team #1)
  # Standard: Poisonous Substance
  # Adept+: Toxic Spikes and Sticky Web on entry. Your mons will have their Ability supressed on switch-in.
  # Last mon will get all their five stats increased and gain Safeguard for 8 turns.
  #-----------------------------------------------------------------------------

  CONCLAVE_ALDRIC1_STD = {
    "turnCommand" => {
	  :speech       => [:Opposing, "I'll maim you before I let anyone escape my Dungeon!"],
	  :battler 		=> :Opposing,
	  :anim 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team 		=> [
        [PBEffects::ToxicSpikes, 1, "Aldric flooded your side of the field with a poisonous substance!"],
      ],
    },	
  }

  CONCLAVE_ALDRIC1 = {
    "turnCommand" => {
	  :speech       => [:Opposing, "I'll maim you before I let anyone escape my Dungeon!"],
	  :battler 		=> :Opposing,
	  :anim 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team 		=> [
        [PBEffects::ToxicSpikes, 2, "Aldric dropped Toxic Spikes on your side of the field!"],
      ],
	  :battler_2 	=> :Opposing,
	  :anim_1 		=> [:STICKYWEB, :Opposing],
	  :battler_3 	=> :Self,
	  :team_1 		=> [
        [PBEffects::StickyWeb, true, "Aldric dropped a sticky substance on your side of the field!"],
      ],
    },
	"switchSentOut" => {
	  :speech 		=> [:Opposing, "I'll beat you within an inch of your life!"],
	  :text      	=> "Aldric summons a caustic substance that will nullify your Pokémon's Ability on entry!",
    },
	"switchSentOut_repeat" => {
	  :battler 		=> :Self,
	  :playsound  	=> "Anim/PRSFX- Gastro Acid",
	  :anim     	=> [:GASTROACID, :Self],
	  :effects    	=> [ [PBEffects::GastroAcid, 99],],
    },
    "switchSentOutLast_foe" => {
	  :speech 		=> [:Self, "NO! I must persevere!"],
	  :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1, :SPECIAL_ATTACK, 1, :DEFENSE, 1, :SPECIAL_DEFENSE, 1, :SPEED, 1],
	  :anim_1    	=> [:SAFEGUARD, :Self],
	  :playsound_1 	=> "Anim/PRSFX- Safeguard",
      :team  	=> [[PBEffects::Safeguard, 8]],
    },    
  }

  #-----------------------------------------------------------------------------
  # Conclave Member Aldric Darkmoor (Team #2)
  # Standard: Poisonous Substance
  # Adept+: Toxic Spikes and Sticky Web on entry, resets Grassy Terrain every turn. Your mons will be Heal Blocked for 99 turns on switch-in.
  # Enemies will have their Atk/SpAtk/Spe boosted every four turns.
  #-----------------------------------------------------------------------------

  CONCLAVE_ALDRIC2_STD = {
    "turnCommand" => {
	  :speech       => [:Opposing, "I'll maim you before I let anyone escape my Dungeon!"],
	  :battler 		=> :Opposing,
	  :anim 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team 		=> [
        [PBEffects::ToxicSpikes, 1, "Aldric flooded your side of the field with a poisonous substance!"],
      ],
    },	
  }

  CONCLAVE_ALDRIC2 = {
    "turnCommand" => {
	  :speech       => [:Opposing, "I'll maim you before I let anyone escape my Dungeon!"],
	  :battler 		=> :Opposing,
	  :anim 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team 		=> [
        [PBEffects::ToxicSpikes, 2, "Aldric dropped Toxic Spikes on your side of the field!"],
      ],
	  :battler_2 	=> :Opposing,
	  :anim_1 		=> [:STICKYWEB, :Opposing],
	  :battler_3 	=> :Self,
	  :team_1 		=> [
        [PBEffects::StickyWeb, true, "Aldric dropped a sticky substance on your side of the field!"],
      ],
    },	
	"turnEnd" => {	  
	  :speech 		=> [:Opposing, "The Grass won't ever wither with my magic!"],
	  :anim     	=> [:GRASSYTERRAIN],
    },
	"turnEnd_repeat" => {	  
	  :terrain 		=> :Grassy,
    },
    "switchSentOut" => {
	  :speech 		=> [:Opposing, "I'll make an example out of you, cur!"],
	  :text      	=> "Aldric will hex your Pokémon on entry with a Heal Block curse!",
    },
	"switchSentOut_repeat" => {
	  :battler 		=> :Self,
	  :playsound  	=> "Anim/PRSFX- Heal Block",
	  :anim     		=> [:HEALBLOCK, :Self],
	  :effects    	=> [ [PBEffects::HealBlock, 99],],
    },
	"turnCommand_4" => {
	  :speech 		=> [:Opposing, "The Conclave will be victorious!"],
	  :text      	=> "Aldric's Pokémon will have their offenses and Speed boosted every four turns!",
    },
	"turnCommand_every_4" => {
	  :battler   	=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1, :SPECIAL_ATTACK, 1, :SPEED, 1]
    },
  }

  #-----------------------------------------------------------------------------
  # Conclave Member Aldric Darkmoor (Team #3)
  # Standard: Poisonous Substance
  # Adept+: Toxic Spikes and Sticky Web on entry, resets Sun every turn. Enemies get 1/4 heal and +1 to both defenses every third turn.
  # Last mon will lower your Atk/SpAtk/Spe by 3 stages.
  #-----------------------------------------------------------------------------
  
  CONCLAVE_ALDRIC3_STD = {
    "turnCommand" => {
	  :speech       => [:Opposing, "I'll maim you before I let anyone escape my Dungeon!"],
	  :battler 		=> :Opposing,
	  :anim 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team 		=> [
        [PBEffects::ToxicSpikes, 1, "Aldric flooded your side of the field with a poisonous substance!"],
      ],
    },	
  }

  CONCLAVE_ALDRIC3 = {
    "turnCommand" => {
	  :speech       => [:Opposing, "I'll maim you before I let anyone escape my Dungeon!"],
	  :battler 		=> :Opposing,
	  :anim 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team 		=> [
        [PBEffects::ToxicSpikes, 2, "Aldric dropped Toxic Spikes on your side of the field!"],
      ],
	  :battler_2 	=> :Opposing,
	  :anim_1 		=> [:STICKYWEB, :Opposing],
	  :battler_3 	=> :Self,
	  :team_1 		=> [
        [PBEffects::StickyWeb, true, "Aldric dropped a sticky substance on your side of the field!"],
      ],
    },
	"turnEnd" => {	  
	  :speech 		=> [:Opposing, "The Sun won't extinguish under my ritual!"],
	  :anim     	=> [:SUNNYDAY],
    },
	"turnEnd_repeat" => {	  
	  :weather		=> :Sun,
    },
    "turnCommand_3" => {
	  :speech 		=> [:Opposing, "Slow and steady wins the race!"],
	  :text      	=> "Aldric's magic will heal and bolster the enemy's defenses every three turns!",
    },
	"turnCommand_every_3" => {
	  :battler 			=> :Opposing,
	  :anim     		=> [:GROWTH, :Opposing],
	  :playsound 		=> "Anim/PRSFX- Strength Sap1",
	  :hp      			=> 4,	  
	  :anim_1     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1]
    },
	"switchSentOutLast_foe" => {
	  :speech      	=> [:Self, "There's no escaping me, Revolution mongrel!"],
	  :battler 		=> :Self,
	  :anim     	=> [:GOOSEBUMP, :Opposing],
	  :battler_1   	=> :Opposing,
	  :anim_1  		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:ATTACK, -3, :SPECIAL_ATTACK, -3, :SPEED, -3]
    },
  }

  #-----------------------------------------------------------------------------
  # Aether Mine Superintendents
  # Level 1 - Rock Slide that removes 1/4 health, lowers Atk/SpAtk and confuses on first turn
  # Level 1 Standard - Rock Slide that removes 1/4 health
  # Level 1 MBD is also used for the Lights in the Deep Side Quest
  # Level 2 - Stealth Rocks + Defense/SpDef boost for lead.
  # Level 2 Standard - Stealth Rocks
  # Level 3 - Tailwind, boosts for enemy on low health, and last mon on team
  # Level 3 Standard - Tailwind
  #-----------------------------------------------------------------------------

  AETHER_SUPERINTENDENT1 = {
    "turnCommand" => {
	  :speech      	 => [:Opposing, "I'm at home in the mines. You're in my territory now!"],
	  :battler 		 => :Opposing,
	  :anim          => [:ROCKSLIDE, :Opposing],
	  :battler_1     => :Self,
	  :anim_1        => "Common:StatDown",
	  :playsound_1   => "Anim/decrease",
	  :stats_1       => [:ATTACK, -1],
      :status_1 	 => :CONFUSION,
      :hp_1 		 => -4
    },
  }
  
  AETHER_SUPERINTENDENT1_STD = {
    "turnCommand" => {
	  :speech      	 => [:Opposing, "I'm at home in the mines. You're in my territory now!"],
	  :battler 		 => :Opposing,
	  :anim          => [:ROCKSLIDE, :Opposing],
	  :battler_1     => :Self,
	  :anim_1        => "Common:StatDown",
	  :playsound_1   => "Anim/decrease",
      :hp_1 		 => -4
    },
  }

  AETHER_SUPERINTENDENT2 = {
    "turnCommand" => {
	  :speech       => [:Opposing, "Beware where you step. You're in a mine known for safety issues!"],
	  :battler 		=> :Opposing,
	  :anim 		=> [:STEALTHROCK, :Opposing],
	  :battler_1 	=> :Self,
	  :team_1 		=> [
        [PBEffects::StealthRock, true, "Pointed stones float in the air around {1}!"],
      ],
	  :speech_2     => [:Opposing, "Make sure you have adequate protection!"],
	  :battler_2	=> :Opposing,
	  :anim_2     	=> "Common:StatUp",
	  :playsound_2 	=> "Anim/increase",
	  :stats_2     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1]
    },
  }
  
  AETHER_SUPERINTENDENT2_STD = {
    "turnCommand" => {
	  :speech       => [:Opposing, "Beware where you step. You're in a mine known for safety issues!"],
	  :battler 		=> :Opposing,
	  :anim 		=> [:STEALTHROCK, :Opposing],
	  :battler_1 	=> :Self,
	  :team_1 		=> [
        [PBEffects::StealthRock, true, "Pointed stones float in the air around {1}!"],
      ],
    },
  }

  AETHER_SUPERINTENDENT3 = {
    "turnCommand" => {
	  :speech 			=> [:Opposing, "I will make your life miserable!"],
      :battler   		=> :Opposing,
      :anim_1         	=> [:TAILWIND, :Opposing],
	  :team => [ 
		[PBEffects::Tailwind, 4, "The wind is blowing in the enemy's favour!"],
		]
    },
    "switchSentOutLast_foe" => {
	  :speech      	=> [:Self, "You got into a fight with the wrong person!"],
	  :battler 		=> :Self,
	  :anim    		=> [:BIDE, :Self],
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1, :ACCURACY, 1]
    },
    "defenderHPLow_foe" => {
      :speech  		=> "I'll take you out once and for all!",
      :anim    		=> [:SWORDSDANCE, :Self],
      :playcry 		=> true,
      :hp      		=> [4, "{1} is preparing its attack!"],
      :stats   		=> [:ATTACK, 1, :SPECIAL_ATTACK, 1, :ACCURACY, 1]
    },
  }
  
  AETHER_SUPERINTENDENT3_STD = {
    "turnCommand" => {
	  :speech 			=> [:Opposing, "I will make your life miserable!"],
      :battler   		=> :Opposing,
      :anim_1         	=> [:TAILWIND, :Opposing],
	  :team => [ 
		[PBEffects::Tailwind, 4, "The wind is blowing in the enemy's favour!"],
		]
    },
  }

  #-----------------------------------------------------------------------------
  # Conclave Grigori
  # Team 0: Digging Mons
  # Standard MBD: Permanent Sandstorm, 3 layers of spikes
  # Adept+ only: All of the above + Stealth rocks. Your Spe/Eva is lowered every three turns.

  # Team 1 - Doubles: Brutes and Brawlers
  # Standard MBD: Rock slide at start that does 1/8 damage to both of your leads. Boosts Atk for one enemy lead, Def for the other. 
  # Adept+ only: Rock slide at start and every three turns thereafter that does 1/8 damage to both of your mons. Boosts Atk/Def for both enemy leads.

  # Team 2 - Doubles: Substance Abuse
  # Standard MBD: Poisonous Substance, both your leads get Confused.
  # Adept+ only: Toxic Spikes, both your leads lose 1/8 health and get confused and poisoned. Automatic loss at the end of turn 12.

  # Team 3: Crystalline Theme
  # Standard MBD: SpAtk/SpDef boost for enemy lead
  # Adept+ only: The above + your lead loses 1/4 health and is Confused. Your Acc is lowered every time an enemy switches in.
  #-----------------------------------------------------------------------------

  CONCLAVE_GRIGORI0_STD = {
    "turnCommand" => {
      :speech          	=> [:Opposing, "This Mine is a death trap by design!"],	  
	  :battler     		=> :Opposing,
	  :anim_1         	=> [:SPIKES, :Opposing],
      :battler_1     	=> :Self,
      :team         	=> [
        [PBEffects::Spikes, 3, "Grigori dropped two layers of spikes on your side of the field!"],
      ],
    },
  }
  
  CONCLAVE_GRIGORI0 = {
    "turnCommand" => {
      :speech          	=> [:Opposing, "This Mine is a death trap by design!"],
	  :battler_1   		=> :Opposing,	  
	  :anim_1         	=> [:SPIKES, :Opposing],
      :battler_2     	=> :Self,
      :team_2         	=> [
        [PBEffects::Spikes, 3, "Grigori dropped three layers of spikes on your side of the field!"],
      ],
	  :battler_3 	=> :Opposing,
	  :anim_3 		=> [:STEALTHROCK, :Opposing],
	  :battler_4 	=> :Self,
	  :team_4 		=> [
        [PBEffects::StealthRock, true, "Pointed stones float in the air around {1}!"],
      ],
    },	
    "turnCommand_3" => {
	  :speech 		=> [:Opposing, "Your mistake was thinking you could outmaneuver me in my territory!"],
	  :text      	 => "Hidden pitfalls litter the field, your Speed and Evasion will lower every three turns!",
	  :anim 		=> [:EARTHQUAKE, :Self],
    },
	"turnCommand_every_3" => {
	  :battler   	=> :Self,
	  :anim         => "Common:StatDown",
	  :playsound    => "Anim/decrease",
	  :stats     	=> [:SPEED, -1, :EVASION, -1]
    },
  }

  CONCLAVE_GRIGORI1_STD = {
    "turnCommand" => {
	  :speech      	 => [:Opposing, "I own these mines and I know how to bring it down around you rats!"],
	  :battler 		 => :Opposing,
	  :anim          => [:ROCKSLIDE, :Opposing],
	  :battler_1     => :Self,
      :hp_1 		 => -8,
	  :battler_2     => :Ally,
      :hp_2 		 => -8,
	  :speech_3   	 => [:Opposing, "Behold my team's unparalleled strength!"],
	  :battler_3	 => :Opposing,
	  :anim_3     	 => "Common:StatUp",
	  :playsound_3 	 => "Anim/increase",
	  :stats_3     	 => [:ATTACK, 1],
	  :battler_4	 => :OpposingAlly,
	  :anim_4     	 => "Common:StatUp",
	  :playsound_4 	 => "Anim/increase",
	  :stats_4     	 => [:DEFENSE, 1]
    },
  }

  CONCLAVE_GRIGORI1 = {
    "turnCommand" => {
	  :speech      	 => [:Opposing, "I own these mines and I know how to bring it down around you rats!"],
	  :text      	 => "Rock Slides will damage both your Pokémon every three turns!",
	  :battler 		 => :Opposing,
	  :anim          => [:ROCKSLIDE, :Opposing],
	  :battler_1     => :Self,
      :hp_1 		 => -8,
	  :battler_2     => :Ally,
      :hp_2 		 => -8,
	  :speech_3   	 => [:Opposing, "Behold my team's unparalleled strength!"],
	  :battler_3	 => :Opposing,
	  :anim_3     	 => "Common:StatUp",
	  :playsound_3 	 => "Anim/increase",
	  :stats_3     	 => [:ATTACK, 1, :DEFENSE, 1],
	  :battler_4	 => :OpposingAlly,
	  :anim_4     	 => "Common:StatUp",
	  :playsound_4 	 => "Anim/increase",
	  :stats_4     	 => [:ATTACK, 1, :DEFENSE, 1]
    },
	"turnCommand_every_3" => {
	  :anim          => [:ROCKSLIDE, :Self],
	  :battler_1     => :Self,
      :hp_1 		 => -8,
	  :battler_2     => :Ally,
      :hp_2 		 => -8,
    },
  }

  CONCLAVE_GRIGORI2_STD = {
    "turnCommand" => {
	  :speech       => [:Opposing, "I have all sorts of death traps down here!"],
	  :battler 		=> :Opposing,
	  :anim 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team 		=> [
        [PBEffects::ToxicSpikes, 1, "Grigori dropped a poisonous substance on your side of the field!"],
      ],
	  :battler_2	 => :Opposing,
	  :anim_2        => [:POISONGAS, :Opposing],
	  :battler_3     => :Self,
      :status_3 	 => :CONFUSION,
	  :battler_4     => :Ally,
      :status_4 	 => :CONFUSION
    },
  }
  
  CONCLAVE_GRIGORI2 = {
    "turnCommand" => {
	  :speech       => [:Opposing, "I have all sorts of death traps down here!"],
	  :battler 		=> :Opposing,
	  :anim 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team 		=> [
        [PBEffects::ToxicSpikes, 2, "Grigori dropped some Toxic Spikes on your side of the field!"],
      ],
	  :battler_2	 => :Opposing,
	  :anim_2        => [:POISONGAS, :Opposing],
	  :battler_3     => :Self,
      :status_3 	 => :CONFUSION,
	  :status_4 	 => :POISON,
      :hp_4 		 => -8,
	  :battler_5     => :Ally,
      :status_5 	 => :CONFUSION,
	  :status_6 	 => :POISON,
      :hp_6 		 => -8
    },
	"turnCommand_2" => {
	  :speech       => [:Opposing, "Let's see how long you can last!"],
	  :text         => "Noxious gas starts filling your side of the field, you need to finish this battle within 12 turns!"
    },
	"turnEnd_12" => {
      :text      => "You pass out as the area fills with gas...",
      :endbattle => 2
    }
  }
  
  CONCLAVE_GRIGORI3_STD = {
    "turnCommand" => {
	  :speech      	 => [:Opposing, "Look at all the pretty lights!"],
	  :battler		 => :Opposing,
	  :anim     	 => "Common:StatUp",
	  :playsound 	 => "Anim/increase",
	  :stats     	 => [:SPECIAL_ATTACK, 1, :SPECIAL_DEFENSE, 1]
    },
  }

  CONCLAVE_GRIGORI3 = {
    "turnCommand" => {
	  :speech      	 => [:Opposing, "Look at all the pretty lights!"],
	  :battler		 => :Opposing,
	  :anim     	 => "Common:StatUp",
	  :playsound 	 => "Anim/increase",
	  :stats     	 => [:SPECIAL_ATTACK, 1, :SPECIAL_DEFENSE, 1],
	  :battler_2	 => :Opposing,
	  :anim_2        => [:BEJEWELED, :Opposing],
	  :battler_3     => :Self,
      :status_3 	 => :CONFUSION,
      :hp_4 		 => -4
    },
	"switchSentOut_foe" => {
	  :speech      	=> [:Self, "Be dazzled by my team's radiance!"],
	  :text      	=> "Your accuracy will be lowered each time an enemy switches in!",
    },
	"switchSentOut_foe_repeat" => {
	  :battler   	=> :Opposing,
	  :anim         => "Common:StatDown",
	  :playsound    => "Anim/decrease",
	  :stats     	=> [:ACCURACY, -1]
    },
  }

  #-----------------------------------------------------------------------------
  # Corrupted Musharna and Porygon-Zs in Libram City Power Plant
  #-----------------------------------------------------------------------------

=begin
# The original setup of the Pokemon.
	WildBattle.dx_start([:PORYGONZ, 85], {:outcome => 73 }, {
	  :ability => 1, # Download
	}, 
	:POWER_PLAY)

	WildBattle.dx_start([:MUSHARNA, 85], {:outcome => 73 }, {
	  :ability => 0, # Download
	}, 
	:POWER_PLAY)
=end

# The midbattle config for the Pokemon
  POWER_PLAY = {
    "turnCommand" => {
      :text          => "@LL Y0uR b@$E @RE bEL0Ng TO U$.",
	  :battler       => :Opposing,
      :anim          => [:THUNDERWAVE, :Opposing],
      :playsound_1   => "Anim/PRSFX- Thunder Wave",
	  :battler_1     => :Self,
      :status_1 	 => :PARALYSIS,
      :text_1        => "1337 haXX0rz pog kekw!"
    },
    "defenderDamaged_foe_random" => {
	  :text      	=> "teRRibLe, terribLe D@maGe.",	  
	  :battler 		=> :Opposing,
	  :anim     	=> [:THUNDERBOLT, :Self],
	  :text_1      	=> "{1} was electrocuted!",
	  :playsound_1 	=> "Anim/PRSFX- Thunderbolt",
	  :hp      		=> -8
    },
  }

  #-----------------------------------------------------------------------------
  # Conclave Thaddeus
	# Team #0 - Doubles: Mechanical Theme
	# MBD - Electric terrain is set
	# Adept+: Electric terrain is set. Speed +1 for both enemy leads, paralyze both your leads. Enemies gain Charge at start and at the end of every third turn.

	# Team #1: Radioactive Theme
	# MBD - Poisonous Substance, Sticky web
	# Adept+: Toxic spikes, Sticky web. Poisons your lead. Your mon will lose 50% HP at the start of every turn if they stay out for more than 3 turns.

	# Team #2: Control, Disturbance, Propaganda
	# MBD - Confusion, +1 Atk/SpAtk for enemy
	# Adept+: Same as above, but you also get -1 Atk/SpAtk. Your mon will be forced to use the first move in their moveset every three turns.

	# Team #3 - Doubles: Mecha-Swarm
	# MBD - Both leads are Confused, Flapping wings lower Def of one lead and SpDef of the other
	# Adept+: Same as above. Enemies heal 1/4 after being attacked.
  #-----------------------------------------------------------------------------

  CONCLAVE_THADDEUS0_STD = {
    "turnCommand" => {
	  :speech      	 => [:Opposing, "Time to super-charge my machines!"],
	  :battler		 => :Opposing,
	  :terrain		 => :Electric,
	  :playsound	 => "Anim/PRSFX- Electric Terrain2",
	  :anim	     	 => [:ELECTRICTERRAIN],
    },
  }
  
  CONCLAVE_THADDEUS0 = {
    "turnCommand" => {
	  :speech      	 => [:Opposing, "My machines will destroy you!"],
	  :battler		 => :Opposing,
	  :anim     	 => "Common:StatUp",
	  :playsound 	 => "Anim/increase",
	  :stats     	 => [:SPEED, 1],
	  :battler_1	 => :OpposingAlly,
	  :anim_1    	 => "Common:StatUp",
	  :playsound_1 	 => "Anim/increase",
	  :stats_1     	 => [:SPEED, 1],
	  :battler_2	 => :Opposing,
	  :anim_2        => [:THUNDERWAVE, :Opposing],
	  :battler_3     => :Self,
      :status_3 	 => :PARALYSIS,
	  :battler_4     => :Ally,
      :status_4 	 => :PARALYSIS,
      :speech_5      => [:Opposing, "Time to super-charge my machines!"],
	  :text_5        => "Thaddeus's Pokémon will Charge up every three turns!",
	  :battler_5	 => :Self,
	  :terrain_5	 => :Electric,
	  :playsound_5 	 => "Anim/PRSFX- Electric Terrain2",
	  :anim_5  		 => [:ELECTRICTERRAIN],
	  :battler_6		 => :Opposing,
	  :playsound_6 	 => "Anim/PRSFX- Charge",
	  :anim_6     	 => [:CHARGE, :Self],
	  :effects_6     	 => [ [PBEffects::Charge, 5],],
	  :battler_7	 => :OpposingAlly,
	  :playsound_7 	 => "Anim/PRSFX- Charge",
	  :anim_7     		=> [:CHARGE, :Self],
	  :effects_7      	 => [ [PBEffects::Charge, 5],],
    },
	"turnEnd_every_3" => {
	  :battler		 => :Opposing,
	  :playsound 	 => "Anim/PRSFX- Charge",
	  :anim     	 => [:CHARGE, :Self],
	  :effects     	 => [ [PBEffects::Charge, 5],],
	  :battler_1	 => :OpposingAlly,
	  :playsound_1 	 => "Anim/PRSFX- Charge",
	  :anim_1     		=> [:CHARGE, :Self],
	  :effects_1      	 => [ [PBEffects::Charge, 5],],
    },
	  
  }

  CONCLAVE_THADDEUS1_STD = {
    "turnCommand" => {
	  :speech       => [:Opposing, "How dare you try to infiltrate MY Power Plant!"],
	  :battler 		=> :Opposing,
	  :anim 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team 		=> [
        [PBEffects::ToxicSpikes, 1, "Thaddeus dropped a poisonous substance on your side of the field!"],
      ],
	  :battler_2 	=> :Opposing,
	  :anim_1 		=> [:STICKYWEB, :Opposing],
	  :battler_3 	=> :Self,
	  :team_1 		=> [
        [PBEffects::StickyWeb, true, "Thaddeus dropped a sticky substance on your side of the field!"],
      ],
    },
  }

  CONCLAVE_THADDEUS1 = {
    "turnCommand" => {
	  :speech       => [:Opposing, "How dare you try to infiltrate MY Power Plant!"],
	  :battler 		=> :Opposing,
	  :anim 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team 		=> [
        [PBEffects::ToxicSpikes, 2, "Thaddeus dropped Toxic Spikes on your side of the field!"],
      ],
	  :battler_2 	=> :Opposing,
	  :anim_1 		=> [:STICKYWEB, :Opposing],
	  :battler_3 	=> :Self,
	  :team_1 		=> [
        [PBEffects::StickyWeb, true, "Thaddeus dropped a sticky substance on your side of the field!"],
      ],
      :speech_4		=> [:Opposing, "The radioactivity in this place will claim you!"],
	  :text_4      	=> "Your Pokémon will take massive damage every turn if they remain in the field for more than three turns!",
	  :battler_4    => :Opposing,
	  :anim_4     	=> [:VENOMDRENCH, :Opposing],
	  :battler_5   	=> :Self,
	  :text_5      	=> "{1} was drenched in a caustic substance!",
	  :playsound_5 	=> "Anim/PRSFX- Venom Drench",
      :status_5		=> :POISON
    },	
	"turnCommand_repeat" => {
	  :setvar => 1,
	},
	"variable_over_3_repeat" => {	 
	  :battler 		=> :Self,	  
	  :anim     	=> [:EMBER, :Self],
	  :hp      		=> -2
    },
	"switchSentOut_repeat" => {
	  :setvar => [:mult, 0],
    },
	
  }
  
  CONCLAVE_THADDEUS2_STD = {
    "turnCommand" => {
	  :speech      	 => [:Opposing, "Obey, petulant worm!"],
	  :battler		 => :Opposing,
	  :anim     	 => "Common:StatUp",
	  :playsound 	 => "Anim/increase",
	  :stats     	 => [:ATTACK, 1, :SPECIAL_ATTACK, 1],
	  :battler_2	 => :Opposing,
	  :anim_2        => [:SCHIZOPHRENIA, :Opposing],
	  :battler_3     => :Self,
      :status_3 	 => :CONFUSION
    },
  }

  CONCLAVE_THADDEUS2 = {
    "turnCommand" => {
	  :speech      	 => [:Opposing, "Obey, petulant worm!"],
	  :battler		 => :Opposing,
	  :anim     	 => "Common:StatUp",
	  :playsound 	 => "Anim/increase",
	  :stats     	 => [:ATTACK, 1, :SPECIAL_ATTACK, 1],
	  :battler_2	 => :Opposing,
	  :anim_2        => [:SCHIZOPHRENIA, :Opposing],
	  :battler_3     => :Self,
      :status_3 	 => :CONFUSION,
	  :anim_3        => "Common:StatDown",
	  :playsound_3   => "Anim/decrease",
	  :stats_3       => [:ATTACK, -1, :SPECIAL_ATTACK, -1]
    },
	 "turnCommand_3" => {
	  :speech      	 => [:Opposing, "You will dance in the palm of my hands!"],
	  :text      	 => "Your Pokémon will be forced to use the first move in their moveset every three turns!",
    },
	 "turnCommand_every_3" => {
	  :battler    	 => :Opposing,
	  :anim     	 => [:SUPERSONIC, :Opposing],
    },
	 "turnAttack_every_3" => {
      :usemove => 0,
    },
  }
  
  CONCLAVE_THADDEUS3_STD = {
    "turnCommand" => {
	  :speech      	 => [:Opposing, "The buzzing will drive you insane!"],
	  :battler		 => :Opposing,
	  :anim          => [:BUGBUZZ, :Opposing],
	  :battler_1     => :Self,
      :status_1 	 => :CONFUSION,
	  :anim_1        => "Common:StatDown",
	  :playsound_1   => "Anim/decrease",
	  :stats_1       => [:DEFENSE, -1],
	  :battler_2     => :Ally,
      :status_2 	 => :CONFUSION,
	  :anim_2        => "Common:StatDown",
	  :playsound_2   => "Anim/decrease",
	  :stats_2       => [:SPECIAL_DEFENSE, -1]
    },
  }

  CONCLAVE_THADDEUS3 = {
    "turnCommand" => {
	  :speech      	 => [:Opposing, "The buzzing will drive you insane!"],
	  :battler		 => :Opposing,
	  :anim          => [:BUGBUZZ, :Opposing],
	  :battler_1     => :Self,
      :status_1 	 => :CONFUSION,
	  :anim_1        => "Common:StatDown",
	  :playsound_1   => "Anim/decrease",
	  :stats_1       => [:DEFENSE, -1],
	  :battler_2     => :Ally,
      :status_2 	 => :CONFUSION,
	  :anim_2        => "Common:StatDown",
	  :playsound_2   => "Anim/decrease",
	  :stats_2       => [:SPECIAL_DEFENSE, -1]
    },
    "defenderDamaged_foe" => {
	  :speech      	 => [:Self, "Nothing my nanobots cannot fix for me!"],
	  :text      	 => "Enemies will greatly recover HP after being attacked!",
    },
	"defenderDamaged_foe_repeat" => {
	  :battler   	 => :Self,
	  :anim     	 => [:RECOVER, :Self],
	  :hp      		 => 4,
    },
  }
  
  #-----------------------------------------------------------------------------
  # Conclave Elara
	# Team #0: Overgrown Greenhouse
	# MBD - Grassy terrain + Poisonous Substance
	# Adept+ - Grassy terrain (resets at the end of every turn) + Toxic Spikes. Enemy gains Ingrain at start and on switch-in. 
	# Allies get Atk/SpAtk lowered at the end of every second turn.

	# Team #1: Fruit and sun team
	# MBD - Permanent Sun, enemy lead +1 Atk/SpAtk
	# Adept+: All of the above. Your lead loses 1/4 and is Burned. Your mon is inflicted with Powder every turn. Enemy deals 50% more damage and gets +1 Speed every third turn.

	# Team #2: Doubles -  Trance and Mysticism
	# MBD - Psychic terrain
	# Adept+: Psychic terrain (resets at the end of every turn). Both your leads get Taunted and Tormented at the beginning, and again at the start of every fourth turn.

	# Team #3: Doubles Motherly team
	# MBD - Misty terrain. +1 Def for one lead and +1 SpDef for other
	# Adept+: Misty Terrain + Tailwind. Both leads get + 1 Def/SpDef. Both enemies get Protected every three turns.
  #-----------------------------------------------------------------------------

  CONCLAVE_ELARA0_STD = { 
    "turnCommand" => {
	  :speech       => [:Opposing, "My plants will make you feel right at home!"],
	  :battler 		=> :Opposing,
	  :anim 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team 		=> [
        [PBEffects::ToxicSpikes, 1, "Elara dropped a poisonous substance on your side of the field!"],
      ],
      :speech_2      => [:Opposing, "My plants will nurture you!"],
	  :battler_2	 => :Self,
	  :terrain_2	 => :Grassy,
	  :playsound_2 	 => "Anim/PRSFX- Grassy Terrain",
	  :anim_2  		 => [:GRASSYTERRAIN]
    },	
  }
  
  CONCLAVE_ELARA0 = {
    "turnCommand" => {
	  :speech       	 => [:Opposing, "My plants will make you feel right at home!"],
	  :battler 			 => :Opposing,
	  :anim 			 => [:TOXICSPIKES, :Opposing],
	  :battler_1 		 => :Self,
	  :team 			 => [
        [PBEffects::ToxicSpikes, 2, "Elara dropped Toxic Spikes on your side of the field!"],
      ],
      :speech_2      	 => [:Opposing, "My plants will nurture you!"],
	  :text_2   	   	 => "The frenzied plants will constantly sap your offenses every two turns and Ingrain the enemies!",
	  :battler_2	 	 => :Self,
	  :terrain_2	 	 => :Grassy,
	  :playsound_2 	 	 => "Anim/PRSFX- Grassy Terrain",
	  :anim_2  			 => [:GRASSYTERRAIN],
      :battler_3       	 => :Opposing,
      :anim_3         	 => [:INGRAIN, :Self],
      :playsound_3     	 => "Anim/PRSFX- Ingrain1",
      :effects_3		 => [[PBEffects::Ingrain, true]]
    },	
	"turnEnd" => {	  
	  :speech		=> [:Opposing, "As long as I'm here my beauties will keep thriving!"],
	  :anim     	=> [:GRASSYTERRAIN],
    },
	"turnEnd_every_2" => {	  
	  :terrain 		 => :Grassy,	  
	  :battler 		 => :Opponent, 
	  :anim_1        => "Common:StatDown",
	  :playsound_1   => "Anim/decrease",
	  :stats_1       => [:ATTACK, -1, :SPECIAL_ATTACK, -1],
    },	
	"switchSentOut_foe_repeat" => {
      :battler       	 => :Self,
      :anim         	 => [:INGRAIN, :Self],
      :playsound     	 => "Anim/PRSFX- Ingrain1",
      :effects  		 => [[PBEffects::Ingrain, true]]
    },
  }
  
  CONCLAVE_ELARA1_STD = {
    "turnCommand" => {
	  :anim     	 => [:SUNNYDAY],
	  :speech      	 => [:Opposing, "Let the sun shine through!"],
	  :battler		 => :Opposing,
	  :anim_1     	 => "Common:StatUp",
	  :playsound 	 => "Anim/increase",
	  :stats     	 => [:ATTACK, 1, :SPECIAL_ATTACK, 1]
    },
  }

  CONCLAVE_ELARA1 = {
    "turnCommand" => {
	  :anim     	 => [:SUNNYDAY],
	  :speech      	 => [:Opposing, "Let the sun shine through!"],	
	  :battler		 => :Opposing,
	  :anim_1     	 => "Common:StatUp",
	  :playsound 	 => "Anim/increase",
	  :stats     	 => [:ATTACK, 1, :SPECIAL_ATTACK, 1],
	  :battler_2	 => :Opposing,
	  :anim_2        => [:MYSTICALFIRE, :Opposing],
	  :battler_3     => :Self,
      :status_3 	 => :BURN,
	  :hp      		 => -4,
	  :speech_2      => [:Opposing, "Have a taste of my special pollen!"],
	  :text_1	 	 => "Your team is covered in Powder for the rest of the battle, they will hurt themselves if they try to use Fire-type moves!",
	  :anim_3     	 => [:POWDER, :Self],
	  :playsound_3 	 => "Anim/PRSFX- Powder",
    },
	"turnCommand_repeat" => {
	  :battler			 => :Self,
	  :effects   		 => [ [PBEffects::Powder, true] ],
    },
	"turnCommand_3" => {
	  :speech      	 => [:Opposing, "My beauties are experts at harnessing the power of the Sun!"],	
	  :text	 		 => "Elara's Pokémon will become supercharged every three turns, dealing 50% more damage for that turn and raising their Speed!",
    },  
  	"turnCommand_every_3" => {
	  :battler     	 => :Opposing,
	  :anim     	 => [:SYNTHESIS, :Self],
	  :anim_1     	 => "Common:StatUp",
	  :playsound_1 	 => "Anim/increase",
	  :stats     	 => [:SPEED, 1],
	  :effects   	 => [ [PBEffects::HelpingHand, true] ],
    },
  }

  CONCLAVE_ELARA2_STD = {
    "turnCommand" => {
	  :speech       	 => [:Opposing, "Time to turn the temperature up a bit..."],
	  :battler		 	 => :Self,
	  :terrain		 	 => :Psychic,
	  :playsound	 	 => "Anim/PRSFX- Psychic Terrain3",
	  :anim	     		 => [:PSYCHICTERRAIN]
    },	
  }

  CONCLAVE_ELARA2 = {
    "turnCommand" => {
	  :speech       	 => [:Opposing, "Time to turn the temperature up a bit..."],
	  :battler		 	 => :Self,
	  :terrain		 	 => :Psychic,
	  :playsound	 	 => "Anim/PRSFX- Psychic Terrain3",
	  :anim	     		 => [:PSYCHICTERRAIN],
      :speech_1			 => [:Opposing, "Let me give you a taste of my unique blend!"],
	  :anim_1  			 => [:MIST],
	  :text		 		 => "Your side of the field fills with a strange gas, your Pokémon will be Taunted and Tormented every four turns!",
	  :battler_2 	 	 => :Self,	  
	  :anim_2  			 => [:TORMENT, :Self],
	  :playsound_2		 => "Anim/PRSFX- Torment",
	  :effects_2   		 => [ [PBEffects::Taunt, 5], [PBEffects::Torment, 5] ],
	  :battler_3 	 	 => :Ally,	  
	  :anim_3  			 => [:TORMENT, :Self],
	  :playsound_3		 => "Anim/PRSFX- Torment",
	  :effects_3   		 => [ [PBEffects::Taunt, 5], [PBEffects::Torment, 5] ],
    },			
	"turnEnd" => {	  
	  :speech		=> [:Opposing, "I won't let the Terrain drop under my watch!"],
	  :anim     	=> [:PSYCHICTERRAIN],
    },
	"turnEnd_repeat" => {	  
	  :terrain 		=> :Psychic,
    },	
	"turnCommand_every_4" => {	  
	  :battler 	 	 	 => :Self,	  
	  :anim  			 => [:TORMENT, :Self],
	  :playsound		 => "Anim/PRSFX- Torment",
	  :effects   		 => [ [PBEffects::Taunt, 5], [PBEffects::Torment, 5] ],
	  :battler_1	 	 => :Ally,	  
	  :anim_1  			 => [:TORMENT, :Self],
	  :playsound_1		 => "Anim/PRSFX- Torment",
	  :effects_1   		 => [ [PBEffects::Taunt, 5], [PBEffects::Torment, 5] ],
    },		
  }

  CONCLAVE_ELARA3_STD = {
    "turnCommand" => {
	  :speech       	=> [:Opposing, "You won't be able to find me in the mist!"],
	  :battler		 	=> :Self,
	  :terrain		 	=> :Misty,
	  :playsound	 	=> "Anim/PRSFX- Misty Terrain",
	  :anim	     		=> [:MISTYTERRAIN],
      :battler_2   		=> :Opposing,
	  :anim_2     		=> "Common:StatUp",
	  :playsound_2 		=> "Anim/increase",
	  :stats_2     		=> [:DEFENSE, 1],
      :battler_3   		=> :OpposingAlly,
	  :anim_3     		=> "Common:StatUp",
	  :playsound_3 		=> "Anim/increase",
	  :stats_3    		=> [:SPECIAL_DEFENSE, 1]
    },
  }

  CONCLAVE_ELARA3 = {
    "turnCommand" => {
	  :speech       	 => [:Opposing, "You won't be able to find me in the mist!"],
	  :battler		 	 => :Self,
	  :terrain		 	 => :Misty,
	  :playsound	 	 => "Anim/PRSFX- Misty Terrain",
	  :anim	     		 => [:MISTYTERRAIN],
	  :speech_1			 => [:Opposing, "I'll focus the mist to empower my team!"],
      :battler_1  		 => :Opposing,
      :anim_1         	 => [:TAILWIND, :Opposing],
	  :team_1			 => [ 
		[PBEffects::Tailwind, 4, "The wind is blowing in the enemy team's favour!"],
		],
      :battler_2   		=> :Opposing,
	  :anim_2     		=> "Common:StatUp",
	  :playsound_2 		=> "Anim/increase",
	  :stats_2     		=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1],
      :battler_3   		=> :OpposingAlly,
	  :anim_3     		=> "Common:StatUp",
	  :playsound_3 		=> "Anim/increase",
	  :stats_3    		=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1]
    },
	"turnCommand_3" => {
	  :speech       => [:Opposing, "Try and hit me in this mist!"],
	  :text       	=> "Elara's Pokémon will be Protected every three turns!",
    },
    "turnCommand_every_3" => {
      :battler   		=> :Opposing,
	  :anim  			=> [:DETECT, :Self],
	  :playsound		=> "Anim/PRSFX- Detect",
      :effects 			=> [ [PBEffects::Protect, true] ],
      :battler_1   		=> :OpposingAlly,
	  :anim_1  			=> [:DETECT, :Self],
	  :playsound_1		=> "Anim/PRSFX- Detect",
	  :stats_1    		=> [ [PBEffects::Protect, true] ]
    },
  }

  #-----------------------------------------------------------------------------
  # Aether-Infused Lanturn in Libram Trench
  # Level 90 Lanturn with Cursed Body Ability, knows Dark Pulse, Modest nature, 31 IVs
  #-----------------------------------------------------------------------------

=begin
# The original setup of the Pokemon.
	WildBattle.dx_start([:LANTURN, 89], {:outcome => 73 }, {
	  :ability => 1, # Marvel Scale
	  :nature  => :MODEST,
	  :gender  => 1,
	  :ivs     => 31,
	}, 
	:AETHER_INFUSION)
=end

# The midbattle config for the Pokemon
  AETHER_INFUSION = {
    "turnCommand" => {
      :playsound     => "Cries/LANTURN",
	  :text          => "The aether-infused Pokemon howls in pain and enrages.",
	  :battler       => :Opposing,
      :anim          => [:RAGE, :Self],
      :playsound_1   => "Anim/PRSFX- Rage1",
	  :battler_1     => :Opposing,
	  :anim_1        => "Common:StatUp",
	  :playsound_2   => "Anim/increase",
	  :stats_1       => [:SPECIAL_ATTACK, 2],
      :text_1        => "The aether-infused Pokemon cries out in agony!"
    },
    "defenderDamaged_foe_random" => {
	  :text      	=> "The aether-infused Pokemon flails in rage.",	  
	  :battler 		=> :Opposing,
	  :anim     	=> [:GHASTLYFLOOD, :Self],
	  :text_1      	=> "{1} was slammed by a tidal wave!",
	  :playsound_1 	=> "Anim/PRSFX- Waterfall1",
	  :hp      		=> -4
    },
  }

  #-----------------------------------------------------------------------------
  # Captain Dresk - Ashes of the Innocent Quest
	# MBD - Lowers your attacking stats and -12.5% when the defender is damaged
	# MBD Standard - Same as Adept, but no -12.5% when defender is damaged
  #-----------------------------------------------------------------------------

  ASHES_INNOCENT_DRESK = {
    "turnCommand" => {
      :speech      	=> [:Opposing, "You defile this place, interloper!"],
	  :battler       => :Opposing,
      :anim          => [:CURSE, :Opposing],
      :playsound     => "Anim/Curse",
	  :battler_1     => :Self,
	  :anim_1        => "Common:StatDown",
	  :playsound_1   => "Anim/decrease",
	  :stats_1       => [:ATTACK, -1, :SPECIAL_ATTACK, -1],
      :text_1        => "The curse lowered your attacking stats!"
    },
    "defenderDamaged_foe_random" => {
	  :speech      	=> [:Self, "I will bury you in the sand!"],  
	  :battler 		=> :Opposing,
	  :anim     	=> [:MUDSURGE, :Self],
	  :text_1      	=> "{1} was swamped in sand!",
	  :hp      		=> -8
    },
  }

  ASHES_INNOCENT_DRESK_STD = {
    "turnCommand" => {
      :speech      	=> [:Opposing, "You defile this place, interloper!"],
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
  # Anomaly Gyarados
  # Standard: Increases Sp. Attack by 1 stage, drops 25% of your life
  # Adept+: Same as standard but also heals by 25% when on low life, and confuses you on crit.
  #-----------------------------------------------------------------------------

  ANOMALY_NESTING_GROUNDS_STD = {
    "turnCommand" => {
	  :text        	=> "Drown under my might!",
	  :battler 		=> :Opposing,
	  :anim          => [:RAGE, :Self],
      :playsound_1   => "Anim/PRSFX- Rage1",
	  :battler_1     => :Opposing,
	  :anim_1        => "Common:StatUp",
	  :playsound_2   => "Anim/increase",
	  :stats_1       => [:SPECIAL_ATTACK, 1],
	  :anim_1     	 => [:TIDALWAVE, :Opposing],
	  :battler_2   	 => :Self,
	  :text_1      	 => "{2} was stunned by a tidal wave!",
	  :playsound_3 	 => "Anim/PRSFX- Surf",
      :hp      		 => -4
    },
  }

  ANOMALY_NESTING_GROUNDS = {
    "turnCommand" => {
	  :text        	 => "Drown under my might!",
	  :battler 		 => :Opposing,
	  :anim          => [:RAGE, :Self],
      :playsound_1   => "Anim/PRSFX- Rage1",
	  :battler_1     => :Opposing,
	  :anim_1        => "Common:StatUp",
	  :playsound_2   => "Anim/increase",
	  :stats_1       => [:SPECIAL_ATTACK, 1],
	  :anim_1     	 => [:TIDALWAVE, :Opposing],
	  :battler_2   	 => :Self,
	  :text_1      	 => "{2} was stunned by a tidal wave!",
	  :playsound_3 	 => "Anim/PRSFX- Surf",
      :hp      		 => -4
    },
    "defenderHPLow_foe" => {
	  :text      	=> "We endure!",
	  :playsound 	=> "zbryes02",
	  :battler 		=> :Self,
	  :anim     	=> [:STOCKPILE, :Self],
	  :playsound_1 	=> "Anim/PRSFX- Recover",
	  :hp      		=> 4
    },
    "attackerCrit_foe_random" => {
	  :text      	 => "This entire nest will collapse around you!",
	  :playsound 	 => "ZergUltraliskWhat02SC1",
	  :battler 		 => :Opposing,
	  :anim          => [:ROCKSLIDE, :Opposing],
	  :battler_1     => :Opposing,
      :status	 	 => :CONFUSION
    },	
  }

  #-----------------------------------------------------------------------------
  # Anomaly Cerebrates (Tiamat and Jormungand) in the Hatchery
  # Standard: Rock Slide that takes off 1/8 life and confuses your lead
  # Adept+: Same as standard but also heals them by 1/4 life on low life once.
  # Note that Anomaly battle has separate shield break effects in place not reflected in this script
  #-----------------------------------------------------------------------------

  ANOMALYGROUP_HATCHERY_STD = {
    "turnCommand" => {
	  :text	    		=> "You have burned our spawn!",
	  :battler   		=> :Self,
	  :anim	        	=> [:ROCKSLIDE, :Self],
	  :hp      			=> -8,
	  :anim_1        	=> "Common:StatDown",
	  :playsound_1   	=> "Anim/decrease",
	  :stats_1       	=> [:DEFENSE, -1],
	  :text_1    		=> "The Anomaly's rampage causes a rock slide, lowering your defenses!",
    },
    "switchSentOutLast_foe" => {
	  :text      		=> "My brother is weak. I shall finish you off myself!",
	  :playsound 		=> "zbrrdy00",
	  :anim	        	=> [:COUPDEGRACE, :Opposing],
	  :battler 			=> :Opposing,
	  :anim_1     		=> "Common:StatDown",
	  :playsound_1 		=> "Anim/decrease",
	  :stats     		=> [:ATTACK, -1]
    },
  }

  ANOMALYGROUP_HATCHERY = {
    "turnCommand" => {
	  :text	    		=> "You have burned our spawn!",
	  :battler   		=> :Self,
	  :anim	        	=> [:ROCKSLIDE, :Self],
	  :hp      			=> -8,
	  :anim_1        	=> "Common:StatDown",
	  :playsound_1   	=> "Anim/decrease",
	  :stats_1       	=> [:DEFENSE, -1, :SPECIAL_DEFENSE, -1],
	  :text_1    		=> "The Anomaly's rampage causes a rock slide, lowering your defenses!",
    },
    "switchSentOutLast_foe" => {
	  :text      		=> "My brother is weak. I shall finish you off myself!",
	  :playsound 		=> "zbrrdy00",
	  :anim	        	=> [:COUPDEGRACE, :Opposing],
	  :battler 			=> :Opposing,
	  :anim_1     		=> "Common:StatDown",
	  :playsound_1 		=> "Anim/decrease",
	  :stats     		=> [:ATTACK, -1, :SPECIAL_ATTACK, -1]
    },
    "defenderHPLow_foe" => {
	  :text      		=> "Vengeance for our broods!",
	  :playsound 		=> "zbryes02",
	  :battler 			=> :Self,
	  :anim     		=> [:STOCKPILE, :Self],
	  :playsound_1 		=> "Anim/PRSFX- Recover",
	  :hp      			=> 4
    },
  }

  #-----------------------------------------------------------------------------
  # Anomaly Muk in Flooded Base (Side Quest)
  # Standard: +SpAtk, Poisonous Substance
  # Adept+: +SpAtk, Toxic Spikes, Heals 25% when at low life.
  #-----------------------------------------------------------------------------

  ANOMALYMUK_FLOODED_STD = {
    "turnCommand" => {
	  :text      	=> "SO, HUNGRY... A MEAL MOST DELECTABLE, YOU ARE!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1],
	  :text_1      	=> "FATHER, WHY DID YOU ABANDON ME?.",
	  :anim_1 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team_1 		=> [
        [PBEffects::ToxicSpikes, 1, "The Anomaly covered your side of the field in a poisonous substance!"],
      ],
    },
  }

  ANOMALYMUK_FLOODED = {
    "turnCommand" => {
	  :text      	=> "SO, HUNGRY... A MEAL MOST DELECTABLE, YOU ARE!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1],
	  :text_1      	=> "FATHER, WHY DID YOU ABANDON ME?.",
	  :anim_1 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team_1 		=> [
        [PBEffects::ToxicSpikes, 2, "The Anomaly covered your side of the field in Toxic Spikes!"],
      ],
    },
    "defenderHPLow_foe" => {
	  :text         		=> "I already feel energized!",
	  :battler 				=> :Self,
	  :anim     			=> [:INGRAIN, :Self],
	  :playsound 			=> "Anim/PRSFX- Strength Sap1",
	  :hp      				=> 4,
	}
  }

  #-----------------------------------------------------------------------------
  # Ethereal Guild Anomaly Claude in Epoch Corporation HQ Wreckage (Team #0)
  # Standard: Reflect/Light Screen (3 turns)
  # Adept+: Reflect/Light Screen (5 turns)
  # Throws a concoction at you on crit hits that burns you and takes off 1/4 life at random once.
  # Heal himself on being damaged by 1/8 when being hit at random once
  #-----------------------------------------------------------------------------

  ECHQ_WRECKAGE_CLAUDE0_STD = {
    "turnCommand" => {
	  :speech  => [:Opposing, "My artificial Sigils empower me!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 3, "The mad scientist used the Sigils to set up Reflect on his side of the field!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Opposing],
	  :team_1 => [
		[PBEffects::LightScreen, 3, "The mad scientist used the Sigils to set up Light Screen on his side of the field!"],
	  ]
    },
  }

  ECHQ_WRECKAGE_CLAUDE0 = {
    "turnCommand" => {
	  :speech  => [:Opposing, "My artificial Sigils empower me!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 5, "The mad scientist used the Sigils to set up Reflect on his side of the field!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Opposing],
	  :team_1 => [
		[PBEffects::LightScreen, 5, "The mad scientist used the Sigils to set up Light Screen on his side of the field!"],
	  ]
    },
    "attackerCrit_foe_random" => {
	  :text      	=> "I'll incinerate you with my chemicals!",
	  :battler 		=> :Self,
	  :anim     	=> [:CONCOCTION, :Opposing],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Acid",
	  :hp      		=> -8,
      :status  		=> :BURN
    },
    "defenderDamaged_foe_random" => {
	  :speech         		=> [:Self, "My experiments have been successful!"],
	  :battler 				=> :Self,
	  :anim     			=> [:GROWTH, :Self],
	  :playsound 			=> "Anim/PRSFX- Strength Sap1",
	  :hp      				=> 8,
    },
  }

  #-----------------------------------------------------------------------------
  # Ethereal Guild Anomaly Claude in Epoch Corporation HQ Wreckage (Team #1)
  # Standard: Reflect/Light Screen (3 turns)
  # Adept+: # Reflect/Light Screen (5 turns)
  # Lowers defense on attack at random once, and +1 Def/SpDef if he misses at random once.
  #-----------------------------------------------------------------------------
  
  ECHQ_WRECKAGE_CLAUDE1_STD = {
    "turnCommand" => {
	  :speech  => [:Opposing, "My artificial Sigils empower me!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 3, "The mad scientist used the Sigils to set up Reflect on his side of the field!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Opposing],
	  :team_1 => [
		[PBEffects::LightScreen, 3, "The mad scientist used the Sigils to set up Light Screen on his side of the field!"],
	  ]
    },
  }

  ECHQ_WRECKAGE_CLAUDE1 = {
    "turnCommand" => {
	  :speech  => [:Opposing, "My artificial Sigils empower me!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 5, "The mad scientist used the Sigils to set up Reflect on his side of the field!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Opposing],
	  :team_1 => [
		[PBEffects::LightScreen, 5, "The mad scientist used the Sigils to set up Light Screen on his side of the field!"],
	  ]
    },
    "attackerDamaged_foe_random" => {
	  :text      	=> "You shall yield to the power of my artificial Sigils!",
      :battler 		=> :Opposing,
	  :anim    		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:DEFENSE, -1]
    },
    "attackerDodged_foe_random" => {
	  :text      	=> "You can run but you cannot hide!",
	  :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1]
    },
  }

  #-----------------------------------------------------------------------------
  # Ethereal Guild Anomaly Claude in Epoch Corporation HQ Wreckage (Team #2)
  # Standard: Reflect/Light Screen (3 turns)
  # Adept+: # Reflect/Light Screen (5 turns)
  # Lowers atk/spatk on low life, +1 attack when dealing damage at random once.
  #-----------------------------------------------------------------------------

  ECHQ_WRECKAGE_CLAUDE2_STD = {
    "turnCommand" => {
	  :speech  => [:Opposing, "My artificial Sigils empower me!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 3, "The mad scientist used the Sigils to set up Reflect on his side of the field!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Opposing],
	  :team_1 => [
		[PBEffects::LightScreen, 3, "The mad scientist used the Sigils to set up Light Screen on his side of the field!"],
	  ]
    },
  }

  ECHQ_WRECKAGE_CLAUDE2 = {
    "turnCommand" => {
	  :speech  => [:Opposing, "My artificial Sigils empower me!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 5, "The mad scientist used the Sigils to set up Reflect on his side of the field!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Opposing],
	  :team_1 => [
		[PBEffects::LightScreen, 5, "The mad scientist used the Sigils to set up Light Screen on his side of the field!"],
	  ]
    },
    "defenderHPHalf_foe_random" => {
	  :text      	=> "You don't stand a chance!",
	  :battler 		=> :Self,
	  :anim     	=> [:GOOSEBUMP, :Opposing],
	  :battler_1   	=> :Opposing,
	  :anim_1  		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:ATTACK, -1, :SPECIAL_ATTACK, -1]
    },
    "attackerDamaged_foe_random" => {
	  :text      	=> "I don't fight fair!",
	  :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1]
    },
  }

  #-----------------------------------------------------------------------------
  # Ethereal Guild Anomaly Claude in Epoch Corporation HQ Wreckage (Team #3)
  # Standard: Reflect/Light Screen (3 turns)
  # Adept+: # Reflect/Light Screen (5 turns)
  # Lowers your spdef when damaged at random once, caustic substance (1/8 health and poison) when dealing damage at random once
  #-----------------------------------------------------------------------------

  ECHQ_WRECKAGE_CLAUDE3_STD = {
    "turnCommand" => {
	  :speech  => [:Opposing, "My artificial Sigils empower me!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 3, "The mad scientist used the Sigils to set up Reflect on his side of the field!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Opposing],
	  :team_1 => [
		[PBEffects::LightScreen, 3, "The mad scientist used the Sigils to set up Light Screen on his side of the field!"],
	  ]
    },
  }

  ECHQ_WRECKAGE_CLAUDE3 = {
    "turnCommand" => {
	  :speech  => [:Opposing, "My artificial Sigils empower me!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 5, "The mad scientist used the Sigils to set up Reflect on his side of the field!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Opposing],
	  :team_1 => [
		[PBEffects::LightScreen, 5, "The mad scientist used the Sigils to set up Light Screen on his side of the field!"],
	  ]
    },
    "defenderDamaged_foe_random" => {
	  :text      	=> "Bow to the power of my artificial Sigils!",
      :battler 		=> :Opposing,
	  :anim    		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:SPECIAL_DEFENSE, -1]
    },
    "attackerDamaged_foe_random" => {
	  :text      	=> "Here, enjoy this chemical bomb!",
	  :battler 		=> :Opposing,
	  :anim     	=> [:VENOMDRENCH, :Self],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Venom Drench",
	  :hp      		=> -8,
      :status  		=> :POISON
    },
  }

  #-----------------------------------------------------------------------------
  # Light In The Mist Side Quest on Route 19
  # Level 97 Jellicent, Trevenant and Golduck
  # Jellicent - Sleeps you and Lower Speed
  # Trevenant - Grassy Terrain and lowers Defense/Sp.Def
  # Golduck - Psychic Terrain and lowers Atk/Sp. Atk
  #-----------------------------------------------------------------------------

=begin
# The original setup of the Pokemon.
WildBattle.dx_start([:JELLICENT, 97], {:outcome => 73 }, {
  :ability => 0, # Effect Spore
}, 
:LIGHT_IN_THE_MIST)

WildBattle.dx_start([:GOLDUCK, 97], {:outcome => 73 }, {
  :ability => 1, # Dishearten
}, 
:LIGHT_IN_THE_MIST)

WildBattle.dx_start([:TREVENANT, 97], {:outcome => 73 }, {
  :ability => 0, # Drought
}, 
:LIGHT_IN_THE_MIST)
=end

# The midbattle config for the Jellicent
  LIGHT_IN_THE_MIST1 = {
    "turnCommand" => {
	  :text          => "The wild Pokemon flares its spores at you!",  
	  :battler 		=> :Opposing,
	  :anim     	=> [:SPORE, :Opposing],
	  :playsound 	=> "Anim/PRSFX- Spore",
	  :battler_1   	=> :Self,
      :status  		=> :SLEEP,
	  :anim_1  		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:SPEED, -1]	  
    },
  }

# The midbattle config for the Trevenant
  LIGHT_IN_THE_MIST2 = {
    "turnCommand" => {
	  :text          => "The wild Pokemon scowls in anger at you!",
	  :battler       => :Opposing,
      :anim          => [:GLARE, :Opposing],
      :playsound_1   => "Anim/PRSFX- Glare",
	  :battler_1     => :Self,
	  :anim_1        => "Common:StatDown",
	  :playsound_2   => "Anim/decrease",
	  :stats_1       => [:DEFENSE, -1, :SPECIAL_DEFENSE, -1],
	  :terrain_3	 => :Grassy,
	  :playsound_3 	 => "Anim/PRSFX- Grassy Terrain3",
	  :anim_3    	 => [:GRASSYTERRAIN]
    },
  }
  
# The midbattle config for the Golduck
  LIGHT_IN_THE_MIST3 = {
    "turnCommand" => {
	  :text          => "The wild Pokemon's aura flares to life!",
	  :battler       => :Opposing,
      :anim          => [:GEOMANCY, :Opposing],
      :playsound_1   => "Anim/PRSFX- Geomancy",
	  :battler_1     => :Self,
	  :anim_1        => "Common:StatDown",
	  :playsound_2   => "Anim/decrease",
	  :stats_2       => [:ATTACK, -1, :SPECIAL_ATTACK, -1],
	  :terrain_3	 => :Psychic,
	  :playsound_3 	 => "Anim/PRSFX- Psychic Terrain3",
	  :anim_3  		 => [:PSYCHICTERRAIN]
    },
  }

  #-----------------------------------------------------------------------------
  # Anomaly Grapploct - Abandoned Shipwreck
  # Standard: Poisonous Substance.
  # Adept+: Toxic Spikes, 1/8 life lost on a super effective.
  #-----------------------------------------------------------------------------

  ANOMALYGRAPPLOCT_SHIPWRECK_STD = {
    "turnCommand" => {
	  :text      	=> "We shall drag you down to the sea and enslave your soul for eternity!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team_1 		=> [
        [PBEffects::ToxicSpikes, 1, "The Anomaly spread a poisonous substance on your side of the field!"],
      ],
    },
  }

  ANOMALYGRAPPLOCT_SHIPWRECK = {
    "turnCommand" => {
	  :text      	=> "We shall drag you down to the sea and enslave your soul for eternity!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team_1 		=> [
        [PBEffects::ToxicSpikes, 2, "The Anomaly spread Toxic Spikes on your side of the field!"],
      ],
    },
    "attackerSEdmg_foe" => {
	  :text      	=> "The Anomaly uses its tentacles to squeeze the life from you!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> [:WRAP, :Self],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was squeezed by the Anomaly's tentacles!",
	  :playsound_1 	=> "Anim/PRSFX- Wrap",
	  :hp      		=> -8
    },
  }

  #-----------------------------------------------------------------------------
  # Mafioso Randy in Tucana Bayou (Team #0)
  # Standard: +1 stage of Defense/Sp.Def
  # Adept+: # Standard + shoots you (burn, 1/8 health), heals the enemy 1/4 when low life.
  #-----------------------------------------------------------------------------

  MAFIOSO_RANDY_TUCANA0_STD = {
    "turnCommand" => {
	  :speech  		=> [:Opposing, "Tight, tight, tight, Blue, Yellow, Pink, whatever man!"],
      :battler   	=> :Opposing,
	  :anim      	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1]
    },
  }
  
  MAFIOSO_RANDY_TUCANA0 = {
    "turnCommand" => {
	  :speech  		=> [:Opposing, "Tight, tight, tight, Blue, Yellow, Pink, whatever man!"],
      :battler   	=> :Opposing,
	  :anim      	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1]
    },
    "defenderHPLow_foe" => {
	  :speech       => [:Self, "A-yo, daddy chill!"],
	  :battler 		=> :Self,
	  :anim     	=> [:STOCKPILE, :Self],
	  :playsound 	=> "Anim/PRSFX- Strength Sap1",
	  :hp      		=> 4
    },
    "attackerSEdmg_foe_random" => {
	  :speech    	=> [:Opposing, "Consider this a warning shot, ese!"],
	  :battler 		=> :Opposing,
	  :anim     	=> [:HELLBULLET, :Opposing],
	  :battler_1   	=> :Self,
	  :text      	=> "{1} was grazed in the arm by a stray bullet!",
	  :playsound 	=> "Anim/PRSFX- Spite2",
      :status  		=> :BURN,
	  :hp      		=> -8
    },
  }

  #-----------------------------------------------------------------------------
  # Mafioso Randy in Tucana Bayou (Team #1)
  # Standard: Poisons and slows you
  # Adept+: # Standard + shoots you (1/4 health), heals the enemy 1/4 when low life.
  #-----------------------------------------------------------------------------

  MAFIOSO_RANDY_TUCANA1_STD = {
    "turnCommand" => {
      :speech  		=> [:Opposing, "Tight, tight, tight, Blue, Yellow, Pink, whatever man!"],
	  :battler      => :Opposing,
	  :anim     	=> [:VENOMDRENCH, :Opposing],
	  :battler_1   	=> :Self,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Venom Drench",
      :status  		=> :POISON,
	  :stats     	=> [:SPEED, -1]
    },
  }

  MAFIOSO_RANDY_TUCANA1 = {
    "turnCommand" => {
      :speech  		=> [:Opposing, "Tight, tight, tight, Blue, Yellow, Pink, whatever man!"],
	  :battler      => :Opposing,
	  :anim     	=> [:VENOMDRENCH, :Opposing],
	  :battler_1   	=> :Self,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Venom Drench",
      :status  		=> :POISON,
	  :stats     	=> [:SPEED, -1]
    },
    "defenderHPLow_foe" => {
	  :speech       => [:Self, "A-yo, daddy chill!"],
	  :battler 		=> :Self,
	  :anim     	=> [:STOCKPILE, :Self],
	  :playsound 	=> "Anim/PRSFX- Strength Sap1",
	  :hp      		=> 4
    },
    "attackerSEdmg_foe_random" => {
	  :speech    	=> [:Opposing, "Consider this a warning shot, ese!"],
	  :battler 		=> :Opposing,
	  :anim     	=> [:HELLBULLET, :Opposing],
	  :battler_1   	=> :Self,
	  :text      	=> "{1} was grazed in the arm by a stray bullet!",
	  :playsound 	=> "Anim/PRSFX- Spite2",
	  :hp      		=> -4
    },
  }

  #-----------------------------------------------------------------------------
  # Mafioso Randy in Tucana Bayou (Team #2)
  # Standard: Electric Terrain
  # Adept+: # Standard + shoots you (burn, 1/8 health), heals the enemy 1/4 when low life.
  #-----------------------------------------------------------------------------

  MAFIOSO_RANDY_TUCANA2_STD = {
    "turnCommand" => {
      :speech  		=> [:Opposing, "Thunder and lightning time!"],
	  :battler 		=> :Self,
	  :terrain 		=> :Electric,
	  :playsound 	=> "Anim/PRSFX- Electric Terrain2",
	  :anim    		=> [:ELECTRICTERRAIN]
    },
  }

  MAFIOSO_RANDY_TUCANA2 = {
    "turnCommand" => {
      :speech  		=> [:Opposing, "Thunder and lightning time!"],
	  :battler 		=> :Self,
	  :terrain 		=> :Electric,
	  :playsound 	=> "Anim/PRSFX- Electric Terrain2",
	  :anim    		=> [:ELECTRICTERRAIN]
    },
    "defenderHPLow_foe" => {
	  :speech       => [:Self, "A-yo, daddy chill!"],
	  :battler 		=> :Self,
	  :anim     	=> [:STOCKPILE, :Self],
	  :playsound 	=> "Anim/PRSFX- Strength Sap1",
	  :hp      		=> 4
    },
    "attackerSEdmg_foe_random" => {
	  :speech    	=> [:Opposing, "Consider this a warning shot, ese!"],
	  :battler 		=> :Opposing,
	  :anim     	=> [:HELLBULLET, :Opposing],
	  :battler_1   	=> :Self,
	  :text      	=> "{1} was grazed in the arm by a stray bullet!",
	  :playsound 	=> "Anim/PRSFX- Spite2",
      :status  		=> :BURN,
	  :hp      		=> -8
    },
  }

  #-----------------------------------------------------------------------------
  # Mafioso Randy in Tucana Bayou (Team #3)
  # Standard: Electric Terrain
  # Adept+: # Standard + shoots you (1/4 health), heals the enemy 1/4 when low life.
  #-----------------------------------------------------------------------------

  MAFIOSO_RANDY_TUCANA3_STD = {
    "turnCommand" => {
      :speech  		=> [:Opposing, "Thunder and lightning time!"],
	  :battler 		=> :Self,
	  :terrain 		=> :Electric,
	  :playsound 	=> "Anim/PRSFX- Electric Terrain2",
	  :anim    		=> [:ELECTRICTERRAIN]
    },
  }

  MAFIOSO_RANDY_TUCANA3 = {
    "turnCommand" => {
      :speech  		=> [:Opposing, "Thunder and lightning time!"],
	  :battler 		=> :Self,
	  :terrain 		=> :Electric,
	  :playsound 	=> "Anim/PRSFX- Electric Terrain2",
	  :anim    		=> [:ELECTRICTERRAIN]
    },
    "defenderHPLow_foe" => {
	  :speech       => [:Self, "A-yo, daddy chill!"],
	  :battler 		=> :Self,
	  :anim     	=> [:STOCKPILE, :Self],
	  :playsound 	=> "Anim/PRSFX- Strength Sap1",
	  :hp      		=> 4
    },
    "attackerSEdmg_foe_random" => {
	  :speech    	=> [:Opposing, "Consider this a warning shot, ese!"],
	  :battler 		=> :Opposing,
	  :anim     	=> [:HELLBULLET, :Opposing],
	  :battler_1   	=> :Self,
	  :text      	=> "{1} was grazed in the arm by a stray bullet!",
	  :playsound 	=> "Anim/PRSFX- Spite2",
	  :hp      		=> -4
    },
  }

  #-----------------------------------------------------------------------------
  # Ethereal Guild Rogue Anomalies Claude and Christina in Tucana Bayou Destroyed Lab (Team #0)
  # Standard: Attacks at the outset, taking off 1/4 life. Reflect/Light Screen (3 turns). 
  # Adept+: Attacks at the outset and whenever an enemy faints, taking off 1/4 life. Reflect/Light Screen (5 turns)
  # Throws a concoction at you on turn three that burns you and takes off 1/4 life.
  # Randomly heals himself on being damaged by 1/8 when being hit once
  #-----------------------------------------------------------------------------

  DESTROYEDLAB_ROGUES0_STD = {
    "turnCommand" => {
	  :speech 		=> [:Speaker, :EGANOMALY_Claude, "Attack, dog!"],
	  :speech_1		=> [:Speaker, :EGANOMALY_Christina, "Release me, coward!"],
	  :battler   	=> :Self,
	  :text      	=> "Anomaly Christina is forced to lacerate your lead Pokemon with her claws.",
	  :playsound 	=> "PRSFX- Brutal Swing2",
	  :hp      		=> -4,
      :battler_1	=> :Opposing,
	  :anim			=> [:REFLECT, :Opposing],
	  :team 		=> [
        [PBEffects::Reflect, 3, "Infested Claude uses the Sigils to set up Reflect on his side of the field!"]
	  ],
	  :anim_1 		=> [:LIGHTSCREEN, :Opposing],
	  :team_1 		=> [
		[PBEffects::LightScreen, 3, "Infested Claude uses the Sigils to set up Light Screen on his side of the field!"],
	  ]
    },
  }

  DESTROYEDLAB_ROGUES0 = {
    "turnCommand" => {
	  :speech 		=> [:Speaker, :EGANOMALY_Claude, "Attack, dog!"],
	  :speech_1		=> [:Speaker, :EGANOMALY_Christina, "Release me, coward!"],
	  :battler   	=> :Self,
	  :text      	=> "Anomaly Christina will lacerate you with her claws whenever an enemy faints!",
	  :anim		   	=> [:SHADOWCLAW, :Self],
	  :playsound 	=> "PRSFX- Brutal Swing2",
	  :hp      		=> -4,
      :battler_1	=> :Opposing,
	  :anim_1 		=> [:REFLECT, :Opposing],
	  :team 		=> [
        [PBEffects::Reflect, 5, "Infested Claude uses the Sigils to set up Reflect on his side of the field!"]
	  ],
	  :anim_2 		=> [:LIGHTSCREEN, :Opposing],
	  :team_1 		=> [
		[PBEffects::LightScreen, 5, "Infested Claude uses the Sigils to set up Light Screen on his side of the field!"],
	  ]
    },
	"fainted_foe_repeat" => {
	  :battler   	=> :Opposing,
	  :anim		   	=> [:SHADOWCLAW, :Self],
	  :playsound 	=> "PRSFX- Brutal Swing2",
	  :hp      		=> -4,
    },
    "turnCommand_3" => {
	  :speech 		=> [:Speaker, :EGANOMALY_Claude, "I still have my chemicals!"],
	  :battler 		=> :Opposing,
	  :anim     	=> [:CONCOCTION, :Opposing],
	  :battler_1   	=> :Self,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Acid",
	  :hp      		=> -8,
      :status  		=> :BURN
    },
    "defenderDamaged_foe_random" => {
	  :speech         		=> [:Speaker, :EGANOMALY_Claude, "My experiments have been successful!"],
	  :battler 				=> :Self,
	  :anim     			=> [:GROWTH, :Self],
	  :playsound 			=> "Anim/PRSFX- Strength Sap1",
	  :hp      				=> 8,
    },
  }

  #-----------------------------------------------------------------------------
  # Ethereal Guild Rogue Anomalies Claude and Christina in Tucana Bayou Destroyed Lab (Team #1)
  # Standard: Attacks at the outset, taking off 1/4 life. Reflect/Light Screen (3 turns). 
  # Adept+: Attacks at the outset and whenever an enemy faints, taking off 1/4 life. Reflect/Light Screen (5 turns)
  # +1 Atk/SpAtk the first time you switch. -1 Def/SpDef/Spe on last mon.
  #-----------------------------------------------------------------------------
  
  DESTROYEDLAB_ROGUES1_STD = {
    "turnCommand" => {
	  :speech 		=> [:Speaker, :EGANOMALY_Claude, "Attack, dog!"],
	  :speech_1		=> [:Speaker, :EGANOMALY_Christina, "Release me, coward!"],
	  :battler   	=> :Self,
	  :text      	=> "Anomaly Christina is forced to lacerate your lead Pokemon with her claws.",
	  :playsound 	=> "PRSFX- Brutal Swing2",
	  :hp      		=> -4,
      :battler_1	=> :Opposing,
	  :anim 		=> [:REFLECT, :Opposing],
	  :team 		=> [
        [PBEffects::Reflect, 3, "Infested Claude uses the Sigils to set up Reflect on his side of the field!"]
	  ],
	  :anim_1 		=> [:LIGHTSCREEN, :Opposing],
	  :team_1 		=> [
		[PBEffects::LightScreen, 3, "Infested Claude uses the Sigils to set up Light Screen on his side of the field!"],
	  ]
    },
  }

  DESTROYEDLAB_ROGUES1 = {
    "turnCommand" => {
	  :speech 		=> [:Speaker, :EGANOMALY_Claude, "Attack, dog!"],
	  :speech_1		=> [:Speaker, :EGANOMALY_Christina, "Release me, coward!"],
	  :battler   	=> :Self,
	  :text      	=> "Anomaly Christina will lacerate you with her claws whenever an enemy faints!",
	  :anim		   	=> [:SHADOWCLAW, :Self],
	  :playsound 	=> "PRSFX- Brutal Swing2",
	  :hp      		=> -4,
      :battler_1	=> :Opposing,
	  :anim_1 		=> [:REFLECT, :Opposing],
	  :team 		=> [
        [PBEffects::Reflect, 5, "Infested Claude uses the Sigils to set up Reflect on his side of the field!"]
	  ],
	  :anim_2 		=> [:LIGHTSCREEN, :Opposing],
	  :team_1 		=> [
		[PBEffects::LightScreen, 5, "Infested Claude uses the Sigils to set up Light Screen on his side of the field!"],
	  ]
    },
	"fainted_foe_repeat" => {
	  :battler   	=> :Opposing,
	  :anim		   	=> [:SHADOWCLAW, :Self],
	  :playsound 	=> "PRSFX- Brutal Swing2",
	  :hp      		=> -4,
    },
    "switchSentOut" => {
	  :speech 		=> [:Speaker, :EGANOMALY_Claude, "You can run but you cannot hide!"],
	  :battler   	=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1, :SPECIAL_ATTACK, 1]
    },
    "switchSentOutLast_foe" => {
	  :speech 		=> [:Speaker, :EGANOMALY_Claude, "You shall yield to the power of my artificial Sigils!"],
      :battler 		=> :Opposing,
	  :anim    		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:DEFENSE, -1, :SPECIAL_DEFENSE, -1, :SPEED, -1]
    },
  }

  #-----------------------------------------------------------------------------
  # Ethereal Guild Rogue Anomalies Claude and Christina in Tucana Bayou Destroyed Lab (Team #2)
  # Standard: Attacks at the outset, taking off 1/4 life. Reflect/Light Screen (3 turns). 
  # Adept+: Attacks at the outset and whenever an enemy faints, taking off 1/4 life. Reflect/Light Screen (5 turns)
  # Forces you to switch to a random mon after you KO 3 mons. Last mon gets +1 Atk/SpAtk/Spe
  #-----------------------------------------------------------------------------

  DESTROYEDLAB_ROGUES2_STD = {
    "turnCommand" => {
	  :speech 		=> [:Speaker, :EGANOMALY_Claude, "Attack, dog!"],
	  :speech_1		=> [:Speaker, :EGANOMALY_Christina, "Release me, coward!"],
	  :battler   	=> :Self,
	  :text      	=> "Anomaly Christina is forced to lacerate your lead Pokemon with her claws.",
	  :playsound 	=> "PRSFX- Brutal Swing2",
	  :hp      		=> -4,
      :battler_1	=> :Opposing,
	  :anim 		=> [:REFLECT, :Opposing],
	  :team 		=> [
        [PBEffects::Reflect, 3, "Infested Claude uses the Sigils to set up Reflect on his side of the field!"]
	  ],
	  :anim_1 		=> [:LIGHTSCREEN, :Opposing],
	  :team_1 		=> [
		[PBEffects::LightScreen, 3, "Infested Claude uses the Sigils to set up Light Screen on his side of the field!"],
	  ]
    },
  }

  DESTROYEDLAB_ROGUES2 = {
    "turnCommand" => {
	  :speech 		=> [:Speaker, :EGANOMALY_Claude, "Attack, dog!"],
	  :speech_1		=> [:Speaker, :EGANOMALY_Christina, "Release me, coward!"],
	  :battler   	=> :Self,
	  :text      	=> "Anomaly Christina will lacerate you with her claws whenever an enemy faints!",
	  :anim		   	=> [:SHADOWCLAW, :Self],
	  :playsound 	=> "PRSFX- Brutal Swing2",
	  :hp      		=> -4,
      :battler_1	=> :Opposing,
	  :anim_1 		=> [:REFLECT, :Opposing],
	  :team 		=> [
        [PBEffects::Reflect, 5, "Infested Claude uses the Sigils to set up Reflect on his side of the field!"]
	  ],
	  :anim_2 		=> [:LIGHTSCREEN, :Opposing],
	  :team_1 		=> [
		[PBEffects::LightScreen, 5, "Infested Claude uses the Sigils to set up Light Screen on his side of the field!"],
	  ]
    },
	"fainted_foe_repeat" => {
	  :battler   	=> :Opposing,
	  :anim		   	=> [:SHADOWCLAW, :Self],
	  :playsound 	=> "PRSFX- Brutal Swing2",
	  :hp      		=> -4,
	  :setvar  		=> 1,
    },
    "variable_3" => {
	  :speech 		=> [:Speaker, :EGANOMALY_Claude, "I don't fight fair!"],
	  :battler 		=> :Opposing,
	  :anim     	=> [:WHIRLWIND, :Self],
	  :switch		=> :Forced,
    },
    "switchSentOutLast_foe" => {
	  :speech 		=> [:Speaker, :EGANOMALY_Claude, "You don't stand a chance!"],
	  :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1, :SPECIAL_ATTACK, 1, :SPEED, 1]
    },
  }

  #-----------------------------------------------------------------------------
  # Ethereal Guild Rogue Anomalies Claude and Christina in Tucana Bayou Destroyed Lab (Team #3)
  # Standard: Attacks at the outset, taking off 1/4 life. Reflect/Light Screen (3 turns). 
  # Adept+: Attacks at the outset and whenever an enemy faints, taking off 1/4 life. Reflect/Light Screen (5 turns)
  # Turn five throws a caustic substance (1/8 health and poison). The first time an enemy drops below 25%, they get fully healed and get +1 Def/SpDef.
  #-----------------------------------------------------------------------------

  DESTROYEDLAB_ROGUES3_STD = {
    "turnCommand" => {
	  :speech 		=> [:Speaker, :EGANOMALY_Claude, "Attack, dog!"],
	  :speech_1		=> [:Speaker, :EGANOMALY_Christina, "Release me, coward!"],
	  :battler   	=> :Self,
	  :text      	=> "Anomaly Christina is forced to lacerate your lead Pokemon with her claws.",
	  :playsound 	=> "PRSFX- Brutal Swing2",
	  :hp      		=> -4,
      :battler_1	=> :Opposing,
	  :anim 		=> [:REFLECT, :Opposing],
	  :team 		=> [
        [PBEffects::Reflect, 3, "Infested Claude uses the Sigils to set up Reflect on his side of the field!"]
	  ],
	  :anim_1 		=> [:LIGHTSCREEN, :Opposing],
	  :team_1 		=> [
		[PBEffects::LightScreen, 3, "Infested Claude uses the Sigils to set up Light Screen on his side of the field!"],
	  ]
    },
  }

  DESTROYEDLAB_ROGUES3 = {
    "turnCommand" => {
	  :speech 		=> [:Speaker, :EGANOMALY_Claude, "Attack, dog!"],
	  :speech_1		=> [:Speaker, :EGANOMALY_Christina, "Release me, coward!"],
	  :battler   	=> :Self,
	  :text      	=> "Anomaly Christina will lacerate you with her claws whenever an enemy faints!",
	  :anim		   	=> [:SHADOWCLAW, :Self],
	  :playsound 	=> "PRSFX- Brutal Swing2",
	  :hp      		=> -4,
      :battler_1	=> :Opposing,
	  :anim_1 		=> [:REFLECT, :Opposing],
	  :team 		=> [
        [PBEffects::Reflect, 5, "Infested Claude uses the Sigils to set up Reflect on his side of the field!"]
	  ],
	  :anim_2 		=> [:LIGHTSCREEN, :Opposing],
	  :team_1 		=> [
		[PBEffects::LightScreen, 5, "Infested Claude uses the Sigils to set up Light Screen on his side of the field!"],
	  ]
    },
	"fainted_foe_repeat" => {
	  :battler   	=> :Opposing,
	  :anim		   	=> [:SHADOWCLAW, :Self],
	  :playsound 	=> "PRSFX- Brutal Swing2",
	  :hp      		=> -4,
    },
    "defenderHPLow_foe" => {
	  :speech 		=> [:Speaker, :EGANOMALY_Claude, "Bow to the power of my artificial Sigils!"],
      :battler 		=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats   		=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1],
	  :hp 			=> 1,
    },
    "turnCommand_5" => {
	  :speech 		=> [:Speaker, :EGANOMALY_Claude, "Here, enjoy this chemical bomb!"],
	  :battler 		=> :Self,
	  :anim     	=> [:VENOMDRENCH, :Self],
	  :battler_1   	=> :Self,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Venom Drench",
	  :hp      		=> -8,
      :status  		=> :POISON
    },
  }

  #-----------------------------------------------------------------------------
  # Anomaly Vileplume in No Man's Land (The Rot Beneath Our Feet Side Quest)
  # Standard: +SpAtk, Poisonous Substance
  # Adept+: +SpAtk, Toxic Spikes, Lowers Def/SpDef by 1 stage on crit
  #-----------------------------------------------------------------------------

  ANOMALYVILEPLUME_NOMANSLAND_STD = {
    "turnCommand" => {
	  :text      	=> "I SHALL FEED ON MY CHILDREN'S REMAINS!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1],
	  :text_1      	=> "WASTE NOT, WANT NOT!",
	  :anim_1 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team_1 		=> [
        [PBEffects::ToxicSpikes, 1, "The Anomaly covered your side of the field in a poisonous substance!"],
      ],
    },
  }

  ANOMALYVILEPLUME_NOMANSLAND = {
    "turnCommand" => {
	  :text      	=> "I SHALL FEED ON MY CHILDREN'S REMAINS!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1],
	  :text_1      	=> "WASTE NOT, WANT NOT!",
	  :anim_1 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team_1 		=> [
        [PBEffects::ToxicSpikes, 2, "The Anomaly covered your side of the field in Toxic Spikes!"],
      ],
    },
    "attackerCrit_foe_random" => {
	  :text      	=> "We shall consume you!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim    		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:DEFENSE, -1, :SPECIAL_DEFENSE, -1]
    },
  }

  #-----------------------------------------------------------------------------
  # Depraved Trinity Damocles in The Trenches (All teams)
  # Standard: Reflect/Light Screen for 3 turns
  # Adept+: Reflect/Light Screen for 5 turns. For the first eight turns, damages you for 1/4 at the end of every turn.
  # Damages you for 1/4 on turn five. Heals for 1/4 and resets negative stat changes the first time you switch.
  #-----------------------------------------------------------------------------

  DTRINITY_DAMOCLES_STD = {
    "turnCommand" => {
	  :speech  => [:Opposing, "I am impervious!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 3, "The Anomaly lieutenant uses its powers to set up Reflect on its side of the field!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Opposing],
	  :team_1 => [
		[PBEffects::LightScreen, 3, "The Anomaly lieutenant uses its powers to set up Light Screen on its side of the field!"],
	  ]
    },
    "turnCommand_1" => {
	  :speech 		=> [:Speaker, :TIMEWARDEN_Cara, "\\PN, I'm channelling the energy of the Soulstone to shield us!"],
      :battler 		=> :Self,
	  :anim => 		[:REFLECT, :Self],
	  :team => 		[
        [PBEffects::Reflect, 5, "Cara's Soulstone set up a Reflect barrier on your side of the field!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Self],
	  :team_1 => [
		[PBEffects::LightScreen, 5, "Cara's Soulstone set up a Light Screen barrier on your side of the field!"],
	  ],
    },
  }

  DTRINITY_DAMOCLES = {
    "turnCommand" => {
	  :speech  => [:Opposing, "I am impervious!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 5, "The Anomaly lieutenant uses its powers to set up Reflect on its side of the field!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Opposing],
	  :team_1 => [
		[PBEffects::LightScreen, 5, "The Anomaly lieutenant uses its powers to set up Light Screen on its side of the field!"]
	  ],
	  :speech_2      => [:Self, "Be torn to shreds by my Slaughter Formation!"],
	  :anim_2        => [:SWORDSDANCE, :Self],
	  :text_2        => "Bloody swords float above the battlefield for eight turns! They will attack you every turn for major damage!"
    },
    "turnCommand_1" => {
	  :speech 		=> [:Speaker, :TIMEWARDEN_Cara, "\\PN, I'm channelling the energy of the Soulstone to shield us!"],
      :battler 		=> :Self,
	  :anim => 		[:REFLECT, :Self],
	  :team => 		[
        [PBEffects::Reflect, 5, "Cara's Soulstone set up a Reflect barrier on your side of the field!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Self],
	  :team_1 => [
		[PBEffects::LightScreen, 5, "Cara's Soulstone set up a Light Screen barrier on your side of the field!"],
	  ],
    },
    "turnEnd_repeat" => {
	  :ignore     	=> "turnCommand_9",
      :battler 		=> :Opposing,
	  :anim     	=> [:SACREDSWORD, :Opposing],
      :battler_1 	=> :Self,
	  :hp     	    => -4,
    },     
	"turnCommand_9" => {
	  :text      	=> "The floating swords break down into dust!",  
    },      
	"turnCommand_5" => {
	  :speech  		=> [:Opposing, "I shall smite you!"],
	  :anim     	=> [:NIGHTSLASH, :Self],
	  :playsound 	=> "Anim/PRSFX- Night Slash",
      :battler 		=> :Self,
	  :hp     	    => -4,
    },
    "switchSentOut" => {
	  :speech       => [:Opposing, "Your essence is mine!"],
	  :battler 		=> :Opposing,
	  :anim     	=> [:STRENGTHSAP, :Opposing],
	  :playsound 	=> "Anim/PRSFX- Strength Sap1",
	  :stats     	=> :Reset_Lowered,
	  :hp     	    => 4,
    },
  }

  #-----------------------------------------------------------------------------
  # Depraved Trinity Arachne in The Battlefront (All teams)
  # Standard: Poisonous Substance. Both your mons take 1/8 chip
  # Adept+: Toxic Spikes. Both your mons take 1/8 chip and get confused. For the first eight turns, raises enemy Spe and lowers yours at the end of every turn.
  # Damages both your mons for 1/8 on turn five. Damages both your mons for 1/8 and heals both enemies by 1/8 the first time an enemy drops below half.
  #-----------------------------------------------------------------------------

  DTRINITY_ARACHNE_STD = {
    "turnCommand" => {
	  :speech       => [:Opposing, "Beware your surroundings..."],
	  :battler 		=> :Opposing,
	  :anim 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team 		=> [
        [PBEffects::ToxicSpikes, 1, "The Anomaly lieutenant dropped a poisonous substance on your side of the field!"],
      ],
	  :battler_2	 => :Opposing,
	  :anim_2        => [:GLARE, :Opposing],
	  :battler_3     => :Self,
      :hp_4 		 => -8,
	  :battler_4     => :Ally,
      :hp_5 		 => -8
    },
    "turnCommand_1" => {
	  :speech 		=> [:Speaker, :TIMEWARDEN_Cara, "\\PN, stand back, I'm calling upon the power of the Soulstone again!"],
      :battler 		=> :Self,
	  :anim => 		[:REFLECT, :Self],
	  :team => 		[
        [PBEffects::Reflect, 5, "Cara's Soulstone set up a Reflect barrier on your side of the field!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Self],
	  :team_1 => [
		[PBEffects::LightScreen, 5, "Cara's Soulstone set up a Light Screen barrier on your side of the field!"],
	  ],
    },
  }

  DTRINITY_ARACHNE = {
    "turnCommand" => {
	  :speech       => [:Opposing, "Beware your surroundings..."],
	  :battler 		=> :Opposing,
	  :anim 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team 		=> [
        [PBEffects::ToxicSpikes, 2, "The Anomaly lieutenant dropped some Toxic Spikes on your side of the field!"],
      ],
	  :battler_2	 => :Opposing,
	  :anim_2        => [:GLARE, :Opposing],
	  :battler_3     => :Self,
      :status_3 	 => :CONFUSION,
      :hp_3 		 => -8,
	  :battler_4     => :Ally,
      :status_4 	 => :CONFUSION,
      :hp_4  		 => -8,
	  :speech_5      => [:Opposing, "Let's see you escape my Heavenly Net!"],
	  :battler_5 	 => :Opposing,
	  :anim_5 		 => [:STICKYWEB, :Opposing],
	  :text_5        => "Ethereal threads spread around the battlefield for eight turns! It will slow down allies and speed up enemies every turn!",
    },
    "turnCommand_1" => {
	  :speech 		=> [:Speaker, :TIMEWARDEN_Cara, "\\PN, stand back, I'm calling upon the power of the Soulstone again!"],
      :battler 		=> :Self,
	  :anim => 		[:REFLECT, :Self],
	  :team => 		[
        [PBEffects::Reflect, 5, "Cara's Soulstone set up a Reflect barrier on your side of the field!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Self],
	  :team_1 => [
		[PBEffects::LightScreen, 5, "Cara's Soulstone set up a Light Screen barrier on your side of the field!"],
	  ],
    },
    "turnEnd_repeat" => {
	  :ignore     	=> "turnCommand_9",
      :battler 		=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:SPEED, 1],
      :battler_1 	=> :OpposingAlly,
	  :anim_1     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats_1     	=> [:SPEED, 1],
	  :battler_3 	=> :Self,
	  :anim_3    	=> "Common:StatDown",
	  :playsound_3 	=> "Anim/decrease",
	  :stats_3   	=> [:SPEED, -1],
	  :battler_4 	=> :Ally,
	  :anim_4    	=> "Common:StatDown",
	  :playsound_4 	=> "Anim/decrease",
	  :stats_4   	=> [:SPEED, -1],
    },     
	"turnCommand_9" => {
	  :text      	=> "The ethereal threads dissolve into light!",  
    },      
	"turnCommand_5" => {
	  :speech  		=> [:Opposing, "I shall smite you!"],
      :battler 		=> :Self,
	  :anim     	=> [:ATTACKORDER, :Self],
	  :playsound 	=> "Anim/PRSFX- Attack Order",
	  :hp     	    => -8,      
	  :battler_1 	=> :Ally,
	  :hp_1         => -8,
    },
    "defenderHPHalf_foe" => {
	  :speech       => [:Self, "Your essence is mine!"],
	  :battler 		=> :Self,
	  :anim     	=> [:STRENGTHSAP, :Opposing],
	  :playsound 	=> "Anim/PRSFX- Strength Sap1",
	  :hp     	    => 8,
	  :battler_1 	=> :Opposing,
	  :hp_1     	=> -8,	  
	  :battler_2 	=> :Ally,
	  :anim_2     	=> [:STRENGTHSAP, :OpposingAlly],
	  :playsound_2 	=> "Anim/PRSFX- Strength Sap1",
	  :hp_2     	=> 8,
	  :battler_3 	=> :OpposingAlly,
	  :hp_3     	=> -8,
    },
  }

  #-----------------------------------------------------------------------------
  # Depraved Trinity Prometheus in No Man's Land (All Teams)
  # Standard: Takes off 1/4 life and burns you
  # Adept+: Takes off 1/4 life and burns you. For the first eight turns, raises enemy Atk/SpAtk and lowers your Def/SpDef at the end of every turn.
  # Damages you for 1/4 on turn five. Damages you for 1/4 and resets your positive stat changes the first time an enemy switches in.
  #-----------------------------------------------------------------------------

  DTRINITY_PROMETHEUS_STD = {
    "turnCommand" => {
	  :anim     	=> [:SUNNYDAY],
	  :speech  		=> [:Opposing, "I shall burn you with aether fire!"],
	  :battler 		=> :Opposing,
	  :anim_1     	=> [:MYSTICALFIRE, :Opposing],
	  :battler_1   	=> :Self,
	  :text_1      	=> "{1} was burned by aether flames!",
	  :playsound 	=> "Anim/PRSFX- Spite2",
	  :hp      		=> -8,
      :status  		=> :BURN
    },
    "turnCommand_1" => {
	  :speech 		=> [:Speaker, :TIMEWARDEN_Cara, "\\PN, I need to raise the Soulstone barrier again!"],
      :battler 		=> :Self,
	  :anim => 		[:REFLECT, :Self],
	  :team => 		[
        [PBEffects::Reflect, 5, "Cara's Soulstone set up a Reflect barrier on your side of the field!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Self],
	  :team_1 => [
		[PBEffects::LightScreen, 5, "Cara's Soulstone set up a Light Screen barrier on your side of the field!"],
	  ],
    },
  }

  DTRINITY_PROMETHEUS = {
    "turnCommand" => {
	  :speech  		=> [:Opposing, "I shall burn you with aether fire!"],
	  :battler 		=> :Opposing,
	  :anim_1     	=> [:MYSTICALFIRE, :Opposing],
	  :battler_1   	=> :Self,
	  :text_1      	=> "{1} was burned by aether flames!",
	  :playsound 	=> "Anim/PRSFX- Spite2",
	  :hp      		=> -8,
      :status  		=> :BURN,
	  :speech_2     => [:Opposing, "Be consumed under the gaze of the Dark Sun!"],
	  :anim_2     	=> [:SUNNYDAY],
	  :text_2       => "A sinister star shines upon the battlefield for eight turns! Its light will constantly empower foes while weakening allies!",
    },
    "turnCommand_1" => {
	  :speech 		=> [:Speaker, :TIMEWARDEN_Cara, "\\PN, I need to raise the Soulstone barrier again!"],
      :battler 		=> :Self,
	  :anim => 		[:REFLECT, :Self],
	  :team => 		[
        [PBEffects::Reflect, 5, "Cara's Soulstone set up a Reflect barrier on your side of the field!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Self],
	  :team_1 => [
		[PBEffects::LightScreen, 5, "Cara's Soulstone set up a Light Screen barrier on your side of the field!"],
	  ],
    },
    "turnEnd_repeat" => {
	  :ignore     	=> "turnCommand_9",
	  :anim     	=> [:SUNNYDAY],
      :battler 		=> :Opposing,
	  :anim_1     	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1, :SPECIAL_ATTACK, 1],
	  :battler_1 	=> :Self,
	  :anim_2    	=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats_1   	=> [:DEFENSE, -1, :SPECIAL_DEFENSE, -1]
    },     
	"turnCommand_9" => {
	  :text      	=> "The Dark Sun flickers out!",  
    },     
	"turnCommand_5" => {
	  :speech  		=> [:Opposing, "I shall smite you!"],
	  :anim     	=> [:SACREDFIRE, :Self],
	  :playsound 	=> "Anim/PRSFX- Sacred Fire",
      :battler 		=> :Self,
	  :hp     	    => -4,
    },
    "switchSentOut_foe" => {
	  :speech       => [:Self, "Your essence is mine!"],
	  :battler 		=> :Self,
	  :anim     	=> [:STRENGTHSAP, :Opposing],
	  :playsound 	=> "Anim/PRSFX- Strength Sap1",
	  :battler 		=> :Opposing,
	  :stats     	=> :Reset_Raised,
	  :hp     	    => -4,
    },
  }

  #-----------------------------------------------------------------------------
  # Corrupted Victor in the Grand Pylon (All Teams)
  # Standard: Tailwind (4 turns)
  # Adept+: # Tailwind (4 turns) + Reflect/Light Screens (5 turns)
  #-----------------------------------------------------------------------------

  EGANOMALY_VICTOR_GRANDPYLON_STD = {
    "turnCommand" => {
	  :speech      		=> [:Opposing, "Your lack of vision has damned all of humanity!"],
      :battler 			=> :Opposing,
      :anim_2	      	=> [:TAILWIND, :Opposing],
	  :team_2 			=> [ 
		[PBEffects::Tailwind, 4, "The corrupted Anomaly Victor's energy surges, giving his team a speed advantage!"],
		]
    },
    "turnCommand_1" => {
	  :speech 		=> [:Speaker, :TIMEWARDEN_Cara, "\\PN, I need to raise the Soulstone barrier again!"],
      :battler 		=> :Self,
	  :anim => 		[:REFLECT, :Self],
	  :team => 		[
        [PBEffects::Reflect, 5, "Cara's Soulstone set up a Reflect barrier on your side of the field!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Self],
	  :team_1 => [
		[PBEffects::LightScreen, 5, "Cara's Soulstone set up a Light Screen barrier on your side of the field!"],
	  ],
    },
  }
  
  EGANOMALY_VICTOR_GRANDPYLON = {
    "turnCommand" => {
	  :speech      		=> [:Opposing, "Your lack of vision has damned all of humanity!"],
      :battler 			=> :Opposing,
	  :anim 			=> [:REFLECT, :Opposing],
	  :team 			=> [
        [PBEffects::Reflect, 5, "The corrupted Anomaly Victor uses its powers to set up Reflect on its side of the field!"]
	  ],
	  :anim_1 			=> [:LIGHTSCREEN, :Opposing],
	  :team_1 			=> [
		[PBEffects::LightScreen, 5, "The corrupted Anomaly Victor uses its powers to set up Light Screen on its side of the field!"],
	  ],
      :anim_2	      	=> [:TAILWIND, :Opposing],
	  :team_2 			=> [ 
		[PBEffects::Tailwind, 4, "The corrupted Anomaly Victor's energy surges, giving his team a speed advantage!"],
		]
    },
    "turnCommand_1" => {
	  :speech 		=> [:Speaker, :TIMEWARDEN_Cara, "\\PN, I need to raise the Soulstone barrier again!"],
      :battler 		=> :Self,
	  :anim => 		[:REFLECT, :Self],
	  :team => 		[
        [PBEffects::Reflect, 5, "Cara's Soulstone set up a Reflect barrier on your side of the field!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Self],
	  :team_1 => [
		[PBEffects::LightScreen, 5, "Cara's Soulstone set up a Light Screen barrier on your side of the field!"],
	  ],
    },
  }

  #-----------------------------------------------------------------------------
  # Artie in Commander's Tent of Beta Omicron
  # Standard: Raises Def/SpDef by 1
  # Adept+: Artie sets up 5 turns of Reflect and Light Screen
  #-----------------------------------------------------------------------------

  ARTIE_BETAOMICRON_STD = {
    "turnCommand" => {
	  :speech    	=> [:Opposing, "I'm ready for you!"],
      :battler   	=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1]
    },
  }


  ARTIE_BETAOMICRON = {
    "turnCommand" => {
	  :speech  => [:Opposing, "I'm putting up some protection for my team!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 5, "Artie used Reflect!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Opposing],
	  :team_1 => [
		[PBEffects::LightScreen, 5, "Artie used Light Screen!"],
	  ]
    },
  }

  #-----------------------------------------------------------------------------
  # My Preciousss Side Quest stage in the Overgrowth
  # Level 109 Hypno
  # Hypno - Buffs its attack and defense
  # On entry, it is already poisoned
  #-----------------------------------------------------------------------------

=begin
WildBattle.dx_start([:HYPNO, 109], {:outcome => 73 }, {
  :ability => 2, # Moxie
  :status => :POISON,
}, 
:MY_PRECIOUSSS_HYPNO)
=end

# The midbattle config for the Hypno
  MY_PRECIOUSSS_HYPNO = {
    "turnCommand" => {
	  :text         => "The wild ogre Pokemon wails in pain... it is poisoned?!",
	  :battler 		=> :Opposing,	  
      :anim    		=> [:NOBLEROAR, :Opposing],
      :playcry 		=> true,
      :stats   		=> [:ATTACK, 1, :DEFENSE, 1]
    },
  }

  #-----------------------------------------------------------------------------
  # Anomaly Galvantula Shelob in Deadwind Pass (Side Quest)
  # Standard: +Def/+SpDef 1 stage each
  # Adept+: +Def/+SpDef 1 stage each, Ingrain effect
  #-----------------------------------------------------------------------------

  SHELOB_DEADWINDPASS_STD = {
    "turnCommand" => {
	  :text      	=> "I SHALL AVENGE THE DEATH OF MY CHILDREN!",
	  :playsound 	=> "zbrrdy00",
      :battler   	=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1],
    }
  }

  SHELOB_DEADWINDPASS = {
    "turnCommand" => {
	  :text      	=> "I SHALL AVENGE THE DEATH OF MY CHILDREN!",
	  :playsound 	=> "zbrrdy00",
      :battler   	=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1],
      :anim_1       => [:INGRAIN, :Self],
      :playsound_1  => "Anim/PRSFX- Ingrain1",
      :effects_1	=> [[PBEffects::Ingrain, true]],
	  :text_1      	=> "The large Anomaly harnesses energy from the surrounding spider webs!",
    }
  }

  #-----------------------------------------------------------------------------
  # Side Quest: Sacrificial Lamb - Dark Priest Khronus
  # Standard: Reflect and Light Screen (3 turns)
  # Adept+: Reflect and Light Screen (5 turns), Ghost damage randomly on SE attack, Atk/SpAtk boost and heal self by 50% on low life final team member.
  #-----------------------------------------------------------------------------
  
  DARKPRIEST_KHRONUS_STD = {
    "turnCommand" => {
	  :speech  => [:Opposing, "Lord Leviathan shields his devoted!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 3, "A sinister force set up Reflect on the Dark Priest's side of the field!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Opposing],
	  :team_1 => [
		[PBEffects::LightScreen, 3, "A sinister force set up Light Screen on the Dark Priest's side of the field!"],
	  ]
    },
  }

  DARKPRIEST_KHRONUS = {
    "turnCommand" => {
	  :speech  => [:Opposing, "Lord Leviathan shields his devoted!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 5, "A sinister force set up Reflect on the Dark Priest's side of the field!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Opposing],
	  :team_1 => [
		[PBEffects::LightScreen, 5, "A sinister force set up Light Screen on the Dark Priest's side of the field!"],
	  ]
    },
    "attackerSEdmg_foe_random" => {
	  :text      	=> "Master Leviathan, aid me!",
	  :battler 		=> :Self,
	  :anim     	=> [:GOOSEBUMP, :Opposing],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was cursed!",
	  :playsound_1 	=> "Anim/goosebump",
	  :hp      		=> -8,
    },
    "defenderHPLowLast_foe" => {
	  :speech      	=> [:Self, "Master Leviathan, your humble servant calls to you!"],
	  :battler   	=> :Self,
	  :anim     	=> [:ELEGY, :Self],
	  :hp      		=> 2,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1, :SPECIAL_ATTACK, 1]
    },
  }

  #-----------------------------------------------------------------------------
  # Elite Four Area: Leviathan's Fortress - Hostage Artie
  # Standard: Haze is applied every turn
  # Adept+: Haze is applied every turn along with weather and terrain removal
  # Cara sets up a Soulstone barrier immediately (5 turns of reflect/light screen) and Artie yaps every 7 turns
  # Artie heals you for 1/2 life every 10 turns
  #-----------------------------------------------------------------------------

  # Anime's Funni Haze thing
  # Only one Midbattle ID since the code handles Adept+
  # Singles
  E4_STATCLEAR_MBD = { 
    "turnCommand" => {
      :speech  => [:Speaker, :TIMEWARDEN_Cara, "\\PN, I'm channelling the energy of the Soulstone to help you!"],
      :battler => :Self,
      :anim    => [:REFLECT, :Self],
      :team    => [
        [PBEffects::Reflect, 5, "Cara's Soulstone set up a Reflect barrier on your side of the field!"]
      ],
      :anim_1 => [:LIGHTSCREEN, :Self],
      :team_1 => [
        [PBEffects::LightScreen, 5, "Cara's Soulstone set up a Light Screen barrier on your side of the field!"],
      ],
	  :anim_2           => [:ACIDRAIN],
      :speech_2  		=> [:Speaker, :HOSTAGE_Artie, "This entire field will be drenched in my corruption!"],
    },
    "turnCommand_repeat" => {
      :battler        => :Self,
      :statclearShift => 0,
    },
    "turnEnd_every_7" => {
      :speech    => [:Speaker, :HOSTAGE_Artie, "\\PN, hang in there for just a little longer!"]
    },
    "turnAttack_every_10" => {
      :speech    => [:Speaker, :HOSTAGE_Artie, "\\PN, you're breaking through Leviathan's control!"],
      :battler   => :Self,
      :anim      => [:STOCKPILE, :Self],
      :playsound => "Anim/PRSFX- Recover",
      :hp        => 2,
      :text      => "Artie's willpower healed your team by a small amount."
    },
  }

  #-----------------------------------------------------------------------------
  # Elite Four Area: Leviathan's Fortress - Hostage Aki
  # Standard: Trick room is triggered every 5 turns (effectively permanent unless you remove it)
  # Adept+: Magic Room is applied in addition (effectively permanent unless you remove it).
  # Cara sets up a Soulstone barrier immediately (5 turns of reflect/light screen) and Aki yaps every 7 turns
  # Aki heals you for 1/2 life every 10 turns
  #-----------------------------------------------------------------------------

  # Anime's Funni Trickroom/MagicRoom thing
  # Only one Midbattle ID since the code handles Adept+
  # Doubles
  E4_TRICKROOM_MBD = { 
    "turnCommand" => {
	  :speech 		=> [:Speaker, :TIMEWARDEN_Cara, "\\PN, I'm channelling the energy of the Soulstone to help you!"],
      :battler 		=> :Self,
	  :anim => 		[:REFLECT, :Self],
	  :team => 		[
        [PBEffects::Reflect, 5, "Cara's Soulstone set up a Reflect barrier on your side of the field!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Self],
	  :team_1 => [
		[PBEffects::LightScreen, 5, "Cara's Soulstone set up a Light Screen barrier on your side of the field!"],
	  ],
      :speech_2  		=> [:Speaker, :HOSTAGE_Aki, "My influence permeates this place... your perceptions betray you!"],
    },
    "turnCommand_repeat" => {
    :battler => :Self,
	  :trickroomShift => 0,
    },
    "turnEnd_every_7" => {
    :speech 		=> [:Speaker, :HOSTAGE_Aki, "\\PN, you can do this!"],
    },
    "turnAttack_repeat_every_10" => {
    :speech 		=> [:Speaker, :HOSTAGE_Aki, "\\PN, I'm fighting back as hard as I can!"],
	:battler 		=> :Self,
	:anim     		=> [:STOCKPILE, :Self],
	:playsound	 	=> "Anim/PRSFX- Recover",
	:hp      		=> 2,
	:text      		=> "Aki's willpower healed your team by a small amount."
    },
  }

  #-----------------------------------------------------------------------------
  # Elite Four Area: Leviathan's Fortress - Hostage Caitlin
  # Standard: A random stat is increased by one stage each turn
  # Adept+: Same as Standard
  # Cara sets up a Soulstone barrier immediately (5 turns of reflect/light screen) and Caitlin yaps every 7 turns
  # Caitlin heals you for 1/2 life every 10 turns
  #-----------------------------------------------------------------------------

  # Anime's Funni Ultra Moody thing
  # Only one Midbattle ID since the code handles Adept+
  # Singles
  E4_STATRAISE_MBD = { 
    "turnCommand" => {
	  :text      	=> "Leviathan's influence boosts the power of both sides of the battlefield unpredictably!",
	  :speech 		=> [:Speaker, :TIMEWARDEN_Cara, "\\PN, I'm channelling the energy of the Soulstone to help you!"],
      :battler 		=> :Self,
	  :anim => 		[:REFLECT, :Self],
	  :team => 		[
        [PBEffects::Reflect, 5, "Cara's Soulstone set up a Reflect barrier on your side of the field!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Self],
	  :team_1 => [
		[PBEffects::LightScreen, 5, "Cara's Soulstone set up a Light Screen barrier on your side of the field!"],
	  ],
    },
    "turnCommand_repeat" => {
    :battler => :Self,
	  :statraiseShift => 0,
    },
    "turnEnd_repeat_every_7" => {
    :speech 		=> [:Speaker, :HOSTAGE_Caitlin, "\\PN, this perv is touching me, get me away from him!"],
    },
    "turnAttack_repeat_every_10" => {
    :speech 		=> [:Speaker, :HOSTAGE_Caitlin, "\\PN, I'm getting a mad case of ick. Will you hurry up and win?!"],
	:battler 		=> :Self,
	:anim     		=> [:STOCKPILE, :Self],
	:playsound	 	=> "Anim/PRSFX- Recover",
	:hp      		=> 2,
	:text      		=> "Caitlin's... uh... willpower(?) healed your team by a small amount."
    },
  }

  #-----------------------------------------------------------------------------
  # Elite Four Area: Leviathan's Fortress - Hostage Sienna
  # Standard: Inverse mode
  # Adept+: Same as Standard
  # Cara sets up a Soulstone barrier immediately (5 turns of reflect/light screen) and Sienna yaps every 7 turns
  # Sienna heals you for 1/2 life every 10 turns
  #-----------------------------------------------------------------------------

  # Anime's Inverse Mode is already built into the code elsewhere
  # Doubles
  E4_INVERSEMODE_MBD = { 
    "turnCommand" => {
	  :text      	=> "Leviathan's influence inverts natural type effectiveness!",
	  :speech 		=> [:Speaker, :TIMEWARDEN_Cara, "\\PN, I'm channelling the energy of the Soulstone to help you!"],
      :battler 		=> :Self,
	  :anim => 		[:REFLECT, :Self],
	  :team => 		[
        [PBEffects::Reflect, 5, "Cara's Soulstone set up a Reflect barrier on your side of the field!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Self],
	  :team_1 => [
		[PBEffects::LightScreen, 5, "Cara's Soulstone set up a Light Screen barrier on your side of the field!"],
	  ],
    },
    "turnEnd_repeat_every_7" => {
    :speech 		=> [:Speaker, :HOSTAGE_Sienna, "\\PN, I'm fighting back as hard as I can!"],
    },
    "turnAttack_repeat_every_10" => {
    :speech 		=> [:Speaker, :HOSTAGE_Sienna, "\\PN, you're breaking through... I can feel it!"],
	:battler 		=> :Self,
	:anim     		=> [:STOCKPILE, :Self],
	:playsound	 	=> "Anim/PRSFX- Recover",
	:hp      		=> 2,
	:text      		=> "Sienna's willpower healed your team by a small amount."
    },
  }
  
  #-----------------------------------------------------------------------------
  # Elite Four Champion: Throne of Chaos - Hostage Ezreal
  # Standard: Permanent Sandstorm
  # Adept+: Same as Standard
  # Cara sets up a Soulstone barrier immediately (5 turns of reflect/light screen) and Sienna yaps every 7 turns
  # Sienna heals you for 1/2 life every 10 turns
  #-----------------------------------------------------------------------------

  # Battle call has weather set to Sandstorm
  # Doubles
  E4_CHAMPION_MBD = { 
    "turnCommand" => {
	  :text      	=> "Leviathan has kicked up a chaotic sandstorm to empower his hostage!",
	  :speech 		=> [:Speaker, :TIMEWARDEN_Cara, "\\PN, I'm channelling the energy of the Soulstone to help you!"],
      :battler 		=> :Self,
	  :anim => 		[:REFLECT, :Self],
	  :team => 		[
        [PBEffects::Reflect, 5, "Cara's Soulstone set up a Reflect barrier on your side of the field!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Self],
	  :team_1 => [
		[PBEffects::LightScreen, 5, "Cara's Soulstone set up a Light Screen barrier on your side of the field!"],
	  ],
    },
    "turnEnd_repeat_every_7" => {
    :speech 		=> [:Speaker, :HOSTAGE_Ezreal, "\\PN, you need to persevere!"],
    },
    "turnAttack_repeat_every_10" => {
    :speech 		=> [:Speaker, :HOSTAGE_Ezreal, "\\PN, you've almost done it, I believe in you!"],
	:battler 		=> :Self,
	:anim     		=> [:STOCKPILE, :Self],
	:playsound	 	=> "Anim/PRSFX- Recover",
	:hp      		=> 2,
	:text      		=> "Ezreal's willpower healed your team by a small amount."
    },
  }

  #-----------------------------------------------------------------------------
  # Puppet Christina in the Throne of Chaos
  # Cara sets up a Soulstone barrier immediately for 5 turns
  # Standard: Poisonous Substance and raises Def/SpDef by 1 when they miss you.
  # Adept+: Toxic Spikes and Sticky Web on entry, lowers defense on NVE damage, and +1 Def/SpDef if it misses.
  #-----------------------------------------------------------------------------
  
  CHRISTINA_MINION_STD = {
    "turnCommand" => {
	  :speech 		=> [:Speaker, :ANOMALY_LEVIATHAN, "You are mine, slave!"],
	  :speech_1		=> [:Speaker, :EGANOMALY_Christina, "Bastard, I'll kill you when I break free of your control!"],
	  :battler 		=> :Opposing,
	  :anim 		=> [:ACIDSPRAY, :Opposing],
	  :battler_1 	=> :Self,
	  :team 		=> [
        [PBEffects::ToxicSpikes, 1, "Leviathan forced Christina to vomit a poisonous substance on your side of the field!"],
      ],
	  :speech_2		=> [:Speaker, :TIMEWARDEN_Cara, "\\PN, I'm channelling the energy of the Soulstone to help you!"],
      :battler_2	=> :Self,
	  :anim_1		=> [:REFLECT, :Self],
	  :team_2 =>	[
        [PBEffects::Reflect, 5, "Cara's Soulstone set up a Reflect barrier on your side of the field!"]
	  ],
	  :anim_2 => [:LIGHTSCREEN, :Self],
	  :team_3 => [
		[PBEffects::LightScreen, 5, "Cara's Soulstone set up a Light Screen barrier on your side of the field!"],
	  ],
    },
    "attackerDodged_foe_random" => {
	  :text      	=> "You can run but you cannot hide!",
	  :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1]
    },
  }

  CHRISTINA_MINION = {
    "turnCommand" => {
	  :speech 		=> [:Speaker, :ANOMALY_LEVIATHAN, "You are mine, slave!"],
	  :speech_1		=> [:Speaker, :EGANOMALY_Christina, "Bastard, I'll kill you when I break free of your control!"],
	  :battler 		=> :Opposing,
	  :anim 		=> [:ACIDSPRAY, :Opposing],
	  :battler_1 	=> :Self,
	  :team 		=> [
        [PBEffects::ToxicSpikes, 2, "Leviathan forced Christina to vomit a poisonous substance on your side of the field!"],
      ],
	  :battler_2 	=> :Opposing,
	  :anim_1 		=> [:STICKYWEB, :Opposing],
	  :battler_3 	=> :Self,
	  :team_1 		=> [
        [PBEffects::StickyWeb, true, "Christina vomits up a sticky substance on your side of the field!"],
      ],
	  :speech_2		=> [:Speaker, :TIMEWARDEN_Cara, "\\PN, I'm channelling the energy of the Soulstone to help you!"],
      :battler_4	=> :Self,
	  :anim_2		=> [:REFLECT, :Self],
	  :team_2 =>	[
        [PBEffects::Reflect, 5, "Cara's Soulstone set up a Reflect barrier on your side of the field!"]
	  ],
	  :anim_3 => [:LIGHTSCREEN, :Self],
	  :team_3 => [
		[PBEffects::LightScreen, 5, "Cara's Soulstone set up a Light Screen barrier on your side of the field!"],
	  ],
    },
    "attackerNVEdmg_foe_random" => {
	  :speech 		=> [:Speaker, :ANOMALY_LEVIATHAN, "She will make you yield, human! We are your evolutionary superiors!"],
      :battler 		=> :Opposing,
	  :anim    		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:DEFENSE, -1]
    },
    "attackerDodged_foe_random" => {
	  :text      	=> "You can run but you cannot hide!",
	  :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1]
    },
  }

  #-----------------------------------------------------------------------------
  # Leviathan in the Throne of Chaos
  # Standard: Sets Psychic Terrain
  # Adept+: Same as Standard
  # Cara sets up a Soulstone barrier immediately (10 turns of reflect/light screen)
  #-----------------------------------------------------------------------------

  LEVIATHAN_THRONE_STD = {
    "turnCommand" => {
      :text  		=> "You're in my throne room now!",
	  :battler 		=> :Self,
	  :terrain 		=> :Psychic,
	  :playsound 	=> "Anim/PRSFX- Psychic Terrain3",
	  :anim    		=> [:PSYCHICTERRAIN],
	  :speech_1		=> [:Speaker, :TIMEWARDEN_Cara, "\\PN, the Soulstone is emanating with power. I need to tap into it to shield us!"],
      :battler_1	=> :Self,
	  :anim_1 		=> [:REFLECT, :Self],
	  :team_1 		=> [
        [PBEffects::Reflect, 10, "Cara's Soulstone set up a Reflect barrier on your side of the field!"]
	  ],
	  :anim_2 		=> [:LIGHTSCREEN, :Self],
	  :team_2 		=> [
		[PBEffects::LightScreen, 10, "Cara's Soulstone set up a Light Screen barrier on your side of the field!"],
	  ],
    },
  }

  LEVIATHAN_THRONE = {
    "turnCommand" => {
      :text  		=> "You're in my throne room now!",
	  :battler 		=> :Self,
	  :terrain 		=> :Psychic,
	  :playsound 	=> "Anim/PRSFX- Psychic Terrain3",
	  :anim    		=> [:PSYCHICTERRAIN],
	  :speech_1		=> [:Speaker, :TIMEWARDEN_Cara, "\\PN, the Soulstone is emanating with power. I need to tap into it to shield us!"],
      :battler_1	=> :Self,
	  :anim_1 		=> [:REFLECT, :Self],
	  :team_1 		=> [
        [PBEffects::Reflect, 10, "Cara's Soulstone set up a Reflect barrier on your side of the field!"]
	  ],
	  :anim_2 		=> [:LIGHTSCREEN, :Self],
	  :team_2 		=> [
		[PBEffects::LightScreen, 10, "Cara's Soulstone set up a Light Screen barrier on your side of the field!"],
	  ],
    },
  }

#-----------------------------------------------------------------------------
  # Anomaly Battles in the Soulstone Prison areas (Cara's Fear, Cara's Hesitation, Cara's Despair)
  # Various
  #-----------------------------------------------------------------------------

  SOULSTONEPRISON_ANOMALY0 = {
    "attackerDamaged_foe_random" => {
	  :text      	=> "Regenerate vitality!",
	  :playsound 	=> "zbrrdy00",
	  :text_1      	=> "The Anomaly gathered its energy!",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1]
    },
    "attackerCrit_foe_random" => {
	  :text      	=> "Chaos reigns!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1]
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
  
  SOULSTONEPRISON_ANOMALY1 = {
    "attackerSEdmg_foe_random" => {
	  :text      	=> "The master shall be victorious!",
	  :playsound 	=> "zbrrdy00",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1]
    },
    "switchSentOut_foe_random" => {
	  :text      	=> "We shall not yield!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Self,
	  :anim     	=> [:VENOMDRENCH, :Opposing],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Venom Drench",
	  :hp      		=> -8,
      :status  		=> :POISON
    },
    "defenderDamaged_foe_random" => {
	  :text      	=> "We shall conquer!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_DEFENSE, 1]
    },
  }
  
  SOULSTONEPRISON_ANOMALY2 = {
    "attackerNVEdmg_foe_random" => {
	  :text      	=> "We shall prevail!",
	  :playsound 	=> "zbrrdy00",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPECIAL_ATTACK, 1]
    },
    "defenderDamaged_foe_random" => {
	  :text      	=> "We cannot be stopped!",
	  :playsound 	=> "zbrrdy00",
      :battler 		=> :Opposing,
	  :anim    		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:SPECIAL_DEFENSE, -1]
    },
    "attackerDodged_foe_random" => {
	  :text      	=> "We shall consume your essence!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ACCURACY, 1]
    },
  }
  
  SOULSTONEPRISON_ANOMALY3 = {
    "attackerDamaged_foe_random" => {
	  :text      	=> "Mmm... Fresh meat!",
	  :playsound 	=> "zbryes02",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1]
    },
    "defenderDamaged_foe_random" => {
	  :text      	=> "I shall feed today!",
	  :playsound 	=> "zbryes02",
      :battler 		=> :Opposing,
	  :anim    		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:SPECIAL_DEFENSE, -1]
    },
    "attackerSEdmg_foe_random" => {
	  :text      	=> "We hunger, we feed!",
	  :playsound 	=> "zbrrdy00",
	  :battler 		=> :Opposing,
	  :anim     	=> [:VENOMDRENCH, :Self],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was drenched in a caustic substance!",
	  :playsound_1 	=> "Anim/PRSFX- Venom Drench",
	  :hp      		=> -8,
      :status  		=> :POISON
    },
  }

#-----------------------------------------------------------------------------
  # Leviathan in the Durance of the Prime with his minions
  # Standard: Rock slide that removes 1/8 of your team's life and lowers Atk/SpAtk by 1
  # Adept+: Same as above but also sets stealth rocks
  #-----------------------------------------------------------------------------

  LEVIATHAN_MINION_STD = {
    "turnCommand" => {
	  :speech      	 => [:Opposing, "You humans will not stop in the way of my evolution anymore. I shall bring this place down on your heads!"],
	  :battler 		 => :Opposing,
	  :anim          => [:ROCKSLIDE, :Opposing],
	  :battler_1     => :Self,
      :hp_1 		 => -8,
	  :anim_1     	 => "Common:StatDown",
	  :playsound_1 	 => "Anim/decrease",
	  :stats_1     	 => [:ATTACK, -1, :SPECIAL_ATTACK, -1],
	  :battler_2     => :Ally,
      :hp_2 		 => -8,
	  :anim_2     	 => "Common:StatDown",
	  :playsound_2 	 => "Anim/decrease",
	  :stats_2     	 => [:ATTACK, -1, :SPECIAL_ATTACK, -1]
    },
  }

  LEVIATHAN_MINION = {
    "turnCommand" => {
	  :speech      	 => [:Opposing, "You humans will not stop in the way of my evolution anymore. I shall bring this place down on your heads!"],
	  :battler 		 => :Opposing,
	  :anim          => [:ROCKSLIDE, :Opposing],
	  :battler_1     => :Self,
      :hp_1 		 => -8,
	  :anim_1     	 => "Common:StatDown",
	  :playsound_1 	 => "Anim/decrease",
	  :stats_1     	 => [:ATTACK, -1, :SPECIAL_ATTACK, -1],
	  :battler_2     => :Ally,
      :hp_2 		 => -8,
	  :anim_2     	 => "Common:StatDown",
	  :playsound_2 	 => "Anim/decrease",
	  :stats_2     	 => [:ATTACK, -1, :SPECIAL_ATTACK, -1],
	  :speech_1		 => [:Opposing, "This place is teeming with my corruption!"],
      :battler_3	 => :Opposing,
	  :anim_3		 => [:STEALTHROCK, :Opposing],
	  :battler_4 	 => :Self,
	  :team 		 => [
        [PBEffects::StealthRock, true, "Pointed stones float in the air around {1}!"],
      ],
    },
  }

#-----------------------------------------------------------------------------
  # Leviathan in the Durance of the Prime while possessing Cara
  # Standard: Sets Misty terrain and increases Def/SpDef by +1
  # Adept+: Sets Misty terrain, tailwind and increases Def/SpDef by +1
  #-----------------------------------------------------------------------------

  LEVIATHAN_CARA_STD = {
    "turnCommand" => {
	  :text       	 	=> "I shall access the power the Time Warden has been hiding from me!",
	  :battler		 	=> :Self,
	  :terrain		 	=> :Misty,
	  :playsound	 	=> "Anim/PRSFX- Misty Terrain",
	  :anim	     		=> [:MISTYTERRAIN],
      :battler_2   		=> :Opposing,
	  :anim_2     		=> "Common:StatUp",
	  :playsound_2 		=> "Anim/increase",
	  :stats_2     		=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1]
    },
  }

  LEVIATHAN_CARA = {
    "turnCommand" => {
	  :text       	 	=> "I shall access the power the Time Warden has been hiding from me!",
	  :battler		 	 => :Self,
	  :terrain		 	 => :Misty,
	  :playsound	 	 => "Anim/PRSFX- Misty Terrain",
	  :anim	     		 => [:MISTYTERRAIN],
	  :text_1			 => "You shall not deny my evolution!",
      :battler_1  		 => :Opposing,
      :anim_1         	 => [:TAILWIND, :Opposing],
	  :team_1			 => [ 
		[PBEffects::Tailwind, 4, "Leviathan's energy stirs a sinister wind to blow in his favour!"],
		],
      :battler_2   		=> :Opposing,
	  :anim_2     		=> "Common:StatUp",
	  :playsound_2 		=> "Anim/increase",
	  :stats_2     		=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1]
    },
  }

#-----------------------------------------------------------------------------
  # Leviathan in the Durance of the Prime while merged with the fragment of the Mindlink Prime
  # Standard: Sets Electric terrain and 1 layer of spikes
  # Adept+: Sets Electric terrain, 3 layer of spikes, and ingrain
  #-----------------------------------------------------------------------------

  LEVIATHAN_PRIME_STD = {
    "turnCommand" => {
      :text  		=> "POWER. OVERWHELMING!",
	  :battler 		=> :Self,
	  :terrain 		=> :Electric,
	  :playsound 	=> "Anim/PRSFX- Electric Terrain2",
	  :anim    		=> [:ELECTRICTERRAIN],
      :battler_1   	=> :Opposing,
      :text_1      	=> "YOU WILL BOW TO YOUR GOD.",
      :anim_2      	=> [:SPIKES, :Opposing],
      :battler_2   	=> :Self,
      :team_2      	=> [
        [PBEffects::Spikes, 1, "Leviathan merged with the fragment of the Mindlink Prime and covered your side of the field in Spikes!"],
      ],
    },
  }

  LEVIATHAN_PRIME = {
    "turnCommand" => {
      :text  		=> "POWER. OVERWHELMING!",
	  :battler 		=> :Self,
	  :terrain 		=> :Electric,
	  :playsound 	=> "Anim/PRSFX- Electric Terrain2",
	  :anim    		=> [:ELECTRICTERRAIN],
      :battler_1   	=> :Opposing,
      :anim_1     	=> [:INGRAIN, :Self],
      :playsound_1 	=> "Anim/PRSFX- Ingrain1",
      :effects_1	=> [[PBEffects::Ingrain, true]],
      :text_1      	=> "YOU WILL BOW TO YOUR GOD.",
      :anim_2      	=> [:SPIKES, :Opposing],
      :battler_2   	=> :Self,
      :team_2      	=> [
        [PBEffects::Spikes, 3, "Leviathan merged with the fragment of the Mindlink Prime and covered your side of the field in Spikes!"],
      ],
    },
  }

  #-----------------------------------------------------------------------------
  #-----------------------------------------------------------------------------
  #-----------------------------------------------------------------------------
  #-----------------------------------------------------------------------------
  #-----------------------------------------------------------------------------
  #-----------------------------------------------------------------------------
  #-----------------------------------------------------------------------------
  # Notoriety Trainers
  #-----------------------------------------------------------------------------
  #-----------------------------------------------------------------------------
  #-----------------------------------------------------------------------------
  #-----------------------------------------------------------------------------
  #-----------------------------------------------------------------------------
  #-----------------------------------------------------------------------------
  #-----------------------------------------------------------------------------

  NOTORIETY0 = {
    "switchSentOutLast_foe" => {
	  :speech      	=> [:Self, "It's time I put you in the ground once and for all!"],
	  :battler 		=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1]
    },
    "defenderHPLow_foe" => {
      :speech  => "My {1} will never give up!",
      :anim    => [:BULKUP, :Self],
      :playcry => true,
      :hp      => [4, "{1} is standing its ground!"],
      :stats   => [:DEFENSE, 1, :SPECIAL_DEFENSE, 1]
    },
  }

  NOTORIETY1 = {
    "switchSentOutLast_foe" => {
	  :speech      	=> [:Self, "I won't lose to you!"],
	  :battler 		=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1, :SPECIAL_ATTACK, 1]
    },
    "turnCommand_1" => {
	  :speech       => [:Opposing, "I'm invested now!"],
	  :battler 		=> :Opposing,
	  :anim     	=> [:INGRAIN, :Self],
	  :playsound 	=> "Anim/PRSFX- Strength Sap1",
	  :hp      		=> 2,
    },
  }
  
  NOTORIETY2 = {
    "switchSentOutLast_foe" => {
	  :speech      	=> [:Self, "I'm resorting to my special technique!"],
	  :battler 		=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1, :SPECIAL_ATTACK, 1, :SPECIAL_DEFENSE, 1]
    },
    "turnCommand_1" => {
      :speech       => [:Opposing, "I don't fight fair!"],
	  :battler      => :Opposing,
      :anim         => [:BACKSTABBING, :Opposing],
      :battler_1    => :Self,
	  :anim_1       => "Common:StatDown",
	  :playsound_1  => "Anim/decrease",
	  :stats_1      => [:ATTACK, -1, :SPECIAL_ATTACK, -1],
      :text_1       => "The cheap shot lowered your attacking stats!"
    },
  }
  
  NOTORIETY3 = {
    "switchSentOutLast_foe" => {
	  :speech      	=> [:Self, "You got into a fight with the wrong person!"],
	  :battler 		=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1]
    },
    "defenderHPLow_foe" => {
      :speech  => "I'll take you out once and for all!",
      :anim    => [:SWORDSDANCE, :Self],
      :playcry => true,
      :hp      => [4, "{1} is preparing its attack!"],
      :stats   => [:ATTACK, 1, :SPECIAL_ATTACK, 1, :SPEED, 1]
    },
  }

  #-----------------------------------------------------------------------------
  # DEV CASTLE
  #-----------------------------------------------------------------------------
  
  #-----------------------------------------------------------------------------
  # HexxVixtar in Dev Castle
  # Set 0: Light Screen and Reflect
  #-----------------------------------------------------------------------------

  DEVCASTLE_HexxVixtar = {
    "turnCommand" => {
	  :speech  => [:Opposing, "I'm putting up some protection for my team!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 5, "HexxVixtar set up a Reflect barrier!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Opposing],
	  :team_1 => [
		[PBEffects::LightScreen, 5, "HexxVixtar set up a Light Screen barrier!"],
	  ]
    },
  }
  
  #-----------------------------------------------------------------------------
  # FabulaFares in Dev Castle
  # Set 0: Misty Terrain and Embargo+Heal Block on both mons on entry. Misty Terrain resets and Embargo/Heal Block is applied again at the end of every 3rd turn.
  # Set 1: Psychic Terrain+Swamp on entry. Psychic Terrain resets at the end of every 3rd turn.
  # Set 2: Grassy Terrain+Sea of Fire and both mons get trapped on entry. Grassy Terrain resets and Trapping is applied again at the end of every 3rd turn.
  # Set 3: Electric Terrain and Taunt+Torment on both mons on entry. Electric Terrain resets and Taunt/Torment is applied again at the end of every 3rd turn.
  #-----------------------------------------------------------------------------

  DEVCASTLE_FABULAFARES0 = {
    "turnCommand" => {
      :speech  		=> [:Opposing, "Let's set the board, shall we?"],
	  :text  		=> "Misty Terrain is reset and your Pokémon are Embargo and Heal Blocked every three turns!",
	  :battler 		=> :Self,
	  :terrain 		=> :Misty,
	  :playsound 	=> "Anim/PRSFX- Misty Terrain3",
	  :anim    		=> [:MISTYTERRAIN],
	  :battler_1     => :Self,
	  :playsound_1  	=> "Anim/PRSFX- Embargo",
	  :anim_1     		=> [:EMBARGO, :Self],
	  :effects_1    	=> [ [PBEffects::Embargo, 5] , [PBEffects::HealBlock, 5],],
	  :battler_2     => :Ally,
	  :playsound_2 	=> "Anim/PRSFX- Embargo",
	  :anim_2    		=> [:EMBARGO, :Self],
	  :effects_2     	=> [ [PBEffects::Embargo, 5] , [PBEffects::HealBlock, 5],]
    },
    "turnEnd_every_3" => {
	  :battler 		=> :Self,
	  :terrain 		=> :Misty,
	  :playsound 	=> "Anim/PRSFX- Misty Terrain3",
	  :anim    		=> [:MISTYTERRAIN],
	  :battler_1     => :Self,
	  :playsound_1  	=> "Anim/PRSFX- Embargo",
	  :anim_1     		=> [:EMBARGO, :Self],
	  :effects_1    	=> [ [PBEffects::Embargo, 5] , [PBEffects::HealBlock, 5],],
	  :battler_2     => :Ally,
	  :playsound_2 	=> "Anim/PRSFX- Embargo",
	  :anim_2    		=> [:EMBARGO, :Self],
	  :effects_2     	=> [ [PBEffects::Embargo, 5] , [PBEffects::HealBlock, 5],]
    },
  }
  
=begin
# Comment Commented out Magic Coat that used to be in effect
  DEVCASTLE_FABULAFARES_UNUSED = {
    "turnCommand" => {
      :speech  => [:Opposing, "You don't get to put any status effects on me, haha!"],
	  :battler => :Opposing,
      :effects => [
        [PBEffects::MagicCoat, true, "You aren't able to apply any status effects on the enemy."],
      ],
	  :playsound => "Anim/PRSFX- Magic Coat",
	  :anim    => [:MAGICCOAT, :Self]
    },
  }
  
  DEVCASTLE_FABULAFARES_UNUSED2 = {
    "turnCommand" => {
      :speech  		=> [:Opposing, "You don't get to put any status effects on me, haha!"],
	  :battler 		=> :Self,
	  :effects     	=> [ [PBEffects::Taunt, 3, "You are forced to use an attacking move."] ],
	  :playsound 	=> "Anim/PRSFX- Taunt",
	  :anim    		=> [:TAUNT, :Self]
    },
  }
=end

  DEVCASTLE_FABULAFARES1 = {
    "turnCommand" => {
      :speech  		=> [:Opposing, "Let's set the board, shall we?"],
	  :text  		=> "Psychic Terrain is reset every three turns!",
	  :battler 		=> :Self,
	  :terrain 		=> :Psychic,
	  :playsound 	=> "Anim/PRSFX- Psychic Terrain3",
	  :anim    		=> [:PSYCHICTERRAIN],
	  :battler_1 => :Self,
	  :anim_1         => [:MUDDYWATER, :Self],
	  :playsound_1 	=> "Anim/PRSFX- Swamp Field",
	  :team => [ 
		[PBEffects::Swamp, 99, "A swamp appeared on your side!"],
		]
    },
    "turnEnd_every_3" => {
	  :battler 		=> :Self,
	  :terrain 		=> :Psychic,
	  :playsound 	=> "Anim/PRSFX- Psychic Terrain3",
	  :anim    		=> [:PSYCHICTERRAIN],
    },
  }
  
  DEVCASTLE_FABULAFARES2 = {
    "turnCommand" => {
      :speech  		=> [:Opposing, "Let's set the board, shall we?"],
	  :text  		=> "Grassy Terrain is reset and your Pokémon are Trapped every three turns!",
	  :battler 		=> :Self,
	  :terrain 		=> :Grassy,
	  :playsound 	=> "Anim/PRSFX- Grassy Terrain3",
	  :anim    		=> [:GRASSYTERRAIN],
	  :battler_1 => :Self,
	  :anim_1         => [:INCINERATE, :Self],
	  :playsound_1 	=> "Anim/PRSFX- Sea of Fire Field",
	  :team => [ 
		[PBEffects::SeaOfFire, 99, "A sea of fire appeared on your side!"],
		],
	  :battler_2     => :Self,
	  :playsound_2  	=> "Anim/PRSFX- Fire Spin",
	  :anim_2     		=> [:FIRESPIN, :Self],
	  :effects_2    	=> [ [PBEffects::NoRetreat, true],],
	  :battler_3     => :Ally,
	  :playsound_3 	=> "Anim/PRSFX- Fire Spin",
	  :anim_3    		=> [:FIRESPIN, :Self],
	  :effects_3     	=> [ [PBEffects::NoRetreat, true , "You got trapped!"],]
    },
    "turnEnd_every_3" => {
	  :battler 		=> :Self,
	  :terrain 		=> :Grassy,
	  :playsound 	=> "Anim/PRSFX- Grassy Terrain3",
	  :anim    		=> [:GRASSYTERRAIN],
	  :battler_1     => :Self,
	  :playsound_1  	=> "Anim/PRSFX- Fire Spin",
	  :anim_1     		=> [:FIRESPIN, :Self],
	  :effects_1    	=> [ [PBEffects::NoRetreat, true],],
	  :battler_2     => :Ally,
	  :playsound_2 	=> "Anim/PRSFX- Fire Spin",
	  :anim_2    		=> [:FIRESPIN, :Self],
	  :effects_2    	=> [ [PBEffects::NoRetreat, true , "You got trapped!"],]
    },
  }
  
  DEVCASTLE_FABULAFARES3 = {
    "turnCommand" => {
      :speech  		=> [:Opposing, "Let's set the board, shall we?"],
	  :text  		=> "Electric Terrain is reset and your Pokémon are Taunted and Tormented every three turns!",
	  :battler 		=> :Self,
	  :terrain 		=> :Electric,
	  :playsound 	=> "Anim/PRSFX- Electric Terrain3",
	  :anim    		=> [:ELECTRICTERRAIN],
	  :battler_1     => :Self,
	  :playsound_1  	=> "Anim/PRSFX- Taunt",
	  :anim_1     		=> [:TAUNT, :Self],
	  :effects_1    	=> [ [PBEffects::Taunt, 4] , [PBEffects::Torment, true],],
	  :battler_2     => :Ally,
	  :playsound_2 	=> "Anim/PRSFX- Taunt",
	  :anim_2    		=> [:TAUNT, :Self],
	  :effects_2     	=> [ [PBEffects::Taunt, 4] , [PBEffects::Torment, true],]
    },
    "turnEnd_every_3" => {
	  :battler 		=> :Self,
	  :terrain 		=> :Electric,
	  :playsound 	=> "Anim/PRSFX- Electric Terrain3",
	  :anim    		=> [:ELECTRICTERRAIN],
	  :battler_1     => :Self,
	  :playsound_1  	=> "Anim/PRSFX- Taunt",
	  :anim_1     		=> [:TAUNT, :Self],
	  :effects_1    	=> [ [PBEffects::Taunt, 4] , [PBEffects::Torment, true],],
	  :battler_2     => :Ally,
	  :playsound_2 	=> "Anim/PRSFX- Taunt",
	  :anim_2    		=> [:TAUNT, :Self],
	  :effects_2     	=> [ [PBEffects::Taunt, 4] , [PBEffects::Torment, true],]
    },
  }

  #-----------------------------------------------------------------------------
  # Badman in Dev Castle
  # Set 0: Strong Winds weather + Tailwind (5 turns)
  # Set 1: Trick Room/Wonder Room (5 turns each)
  # Set 2: Hail
  # Set 3: Standard screens (5 turns each)
  #-----------------------------------------------------------------------------

# Stron Winds is set in the event code
# setBattleRule("weather", :StrongWinds)
  DEVCASTLE_BADMAN0 = {
    "turnCommand" => {
	  :speech 			=> [:Opposing, "No one is outspeeding me in this wind!"],
      :battler   		=> :Opposing,
	  :anim_1         	=> [:TAILWIND, :Opposing],
	  :team => [ 
		[PBEffects::Tailwind, 5, "The wind is blowing in the enemy team's favour!"],
		]
    },
  }

  DEVCASTLE_BADMAN1 = {
    "turnCommand" => {
	  :speech    	=> [:Opposing, "You're playing on my terms now!"],
	  :anim          => [:TRICKROOM],
	  :playsound 	=> "Anim/PRSFX- Trick Room",
	  :field => [ 
		[PBEffects::TrickRoom, 5, "The dimensions were twisted!"],
		[PBEffects::WonderRoom, 5, "Defensive stats were swapped around!"],
		],
    },
  }

  DEVCASTLE_BADMAN2 = {
    "turnCommand" => {
	  :speech    	=> [:Opposing, "I am at home in the snow!"],
	  :weather		=> :Hail,
	  :anim          => [:RAINBOWBEAM, :Opposing],
	  :playsound 	=> "Anim/PRSFX- Rainbow Field",
	  :team => [ 
		[PBEffects::Rainbow, 99, "A rainbow appeared in the sky on the opponent's side!"],
		]
    },
  }
  
  DEVCASTLE_BADMAN3 = {
    "turnCommand" => {
	  :speech  => [:Opposing, "I'm putting up some protection for my team!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 5, "Endless set up a Reflect barrier!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Opposing],
	  :team_1 => [
		[PBEffects::LightScreen, 5, "Endless set up a Light Screen barrier!"],
	  ]
    },
  }

  #-----------------------------------------------------------------------------
  # PDM20 in Dev Castle
  # All Sets: Lowers both defensive stats by 1 stage on entry
  #-----------------------------------------------------------------------------

  DEVCASTLE_PDM20 = {
    "turnCommand" => {
	  :speech    	 	=> [:Opposing, "Gimme those stats you bingus!"],
	  :battler       	=> :Self,
	  :anim          	=> "Common:StatDown",
	  :playsound     	=> "Anim/decrease",
	  :stats         	=> [:DEFENSE, -1, :SPECIAL_DEFENSE, -1],
	  :battler_1       	=> :Ally,
	  :anim_1          	=> "Common:StatDown",
	  :playsound_1     	=> "Anim/decrease",
	  :stats_1         	=> [:DEFENSE, -1, :SPECIAL_DEFENSE, -1],
	  :battler_2       	=> :Opposing,
	  :anim_2          	=> "Common:StatUp",
	  :playsound_2     	=> "Anim/increase",
	  :stats_2         	=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1],
	  :battler_3       	=> :OpposingAlly,
	  :anim_3          	=> "Common:StatUp",
	  :playsound_3     	=> "Anim/increase",
	  :stats_3         	=> [:DEFENSE, 1, :SPECIAL_DEFENSE, 1]
    },
  }

  #-----------------------------------------------------------------------------
  # Endless in Dev Castle
  # All sets: Sets up reflect and light screen
  #-----------------------------------------------------------------------------

  DEVCASTLE_Endless = {
    "turnCommand" => {
	  :speech  => [:Opposing, "I'm putting up some protection for my team!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 5, "Endless set up a Reflect barrier!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Opposing],
	  :team_1 => [
		[PBEffects::LightScreen, 5, "Endless set up a Light Screen barrier!"],
	  ]
    },
  }

  #-----------------------------------------------------------------------------
  # Riptide in Dev Castle
  # Set 0: Enemies reset their negative stat changes at the end of every turn.
  # Set 1: Gravity is set for 99 turns.
  # Set 2: Enemies get Foresight at the start and on every switch. Whenever an enemy faints, you take 1/2 chip.
  # Set 3: Whenever an enemy faints, you get -2 Atk/SpAtk.
  #-----------------------------------------------------------------------------

  DEVCASTLE_Riptidecord0 = {
    "turnCommand" => {
	  :speech    	=> [:Opposing, "You're not special!"],
	  :text    		=> "Enemies will reset their negative stat changes every turn!",
    },
	"turnEnd_repeat" => {
	  :battler     	=> :Opposing,
	  :stats     	=> :Reset_Lowered,
    },
  }

  DEVCASTLE_Riptidecord1 = {
    "turnCommand" => {
	  :speech       => [:Opposing, "Why is everything so heavy?"],	  
	  :anim    		=> [:GRAVITY],
	  :field 		=> [ 
		[PBEffects::Gravity, 99, "Gravity intensified!"]
	  ]
    },
  }

  DEVCASTLE_Riptidecord2 = {
    "turnCommand" => {
	  :speech       => [:Opposing, " I'm here to blow up and act like I don't know nobody!"],
	  :text    		=> "You will take major damage whenever an enemy faints! Enemies also ignore Ghost-type immunities!",
      :battler 		=> :Opposing,
	  :anim    		=> [:FORESIGHT, :Self],
	  :playsound 	=> "Anim/PRSFX- Foresight",
	  :effects 		=> [
        [PBEffects::Foresight, true],
      ],
    },
	"switchSentOut_foe" => {
      :battler 		=> :Self,
	  :anim    		=> [:FORESIGHT, :Self],
	  :playsound 	=> "Anim/PRSFX- Foresight",
	  :effects 		=> [
        [PBEffects::Foresight, true],
      ],
    },
	"fainted_foe_repeat" => {
      :battler 		=> :Opposing,
	  :anim	   		=> [:LAVAPLUME, :Self],
	  :hp 	   		=> -2,
    },
  }

  DEVCASTLE_Riptidecord3 = {
    "turnCommand" => {
	  :speech       => [:Opposing, "Sinking down in your deep black..."],
	  :text    		=> "Your offenses will be sharply lowered whenever an enemy faints!",
    },
	"fainted_foe_repeat" => {
	  :battler       	=> :Opposing,
	  :anim    			=> [:DARKVOID, :Self],
	  :anim_1          	=> "Common:StatDown",
	  :playsound     	=> "Anim/decrease",
	  :stats         	=> [:ATTACK, -2, :SPECIAL_ATTACK, -2],
    },
  }

  #-----------------------------------------------------------------------------
  # Dem in Dev Castle
  # All sets: Custom MBD that Dem wrote
  #-----------------------------------------------------------------------------

  DEMICE_SPACE_0 = {
    "turnCommand_repeat" => {
    :battler => :Self,
	  :demiceShift      	=> 0,
    },
  }

  DEMICE_SPACE_1 = {
    "turnCommand_repeat" => {
    :battler => :Self,
	  :demiceShift      	=> 1,
    },
  }

  DEMICE_SPACE_2 = {
    "turnCommand_repeat" => {
    :battler => :Self,
	  :demiceShift      	=> 2,
    },
  }

  DEMICE_SPACE_3 = {
    "turnCommand_repeat" => {
    :battler => :Self,
	  :demiceShift      	=> 3,
    },
  }

  #-----------------------------------------------------------------------------
  # Jos in Dev Castle
  # All sets: Standard boss B.S.
  #-----------------------------------------------------------------------------

  DEVCASTLE_Breloom9000 = {
    "turnCommand" => {
	  :speech       => [:Opposing, "I'm gonna throw down all the B.S. you've come to expect from bosses, kek!"],
	  :battler 		=> :Opposing,
	  :anim 		=> [:TOXICSPIKES, :Opposing],
	  :battler_1 	=> :Self,
	  :team 		=> [
        [PBEffects::ToxicSpikes, 2, "Breloom dropped some Toxic Spikes on your side of the field!"],
      ],
	  :battler_2 	=> :Opposing,
	  :anim_1 		=> [:STEALTHROCK, :Opposing],
	  :battler_3 	=> :Self,
	  :team_1 		=> [
        [PBEffects::StealthRock, true, "Pointed stones float in the air around {1}!"],
      ],
    },
  }


  #-----------------------------------------------------------------------------
  # UNUSED
  #-----------------------------------------------------------------------------

=begin
  TWINS_TEMPLE0 = {
    "turnCommand" => {
	  :speech  => ["Palkia will light the way for us!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 5, "A force of light set up Reflect on the Twin Priests' side of the field!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Opposing],
	  :team_1 => [
		[PBEffects::LightScreen, 5, "A force of light set up Light Screen on the Twin Priests' side of the field!"],
	  ]
    },
    "defenderDamaged_foe_random" => {
	  :text  		=> "By fire be purged!",
	  :battler 		=> :Self,
	  :anim     	=> [:MYSTICALFIRE, :Opposing],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was singed by holy fire!",
	  :playsound 	=> "Anim/PRSFX- Spite2",
	  :hp      		=> -8,
    },
    "attackerCrit_foe_random" => {
	  :text      	=> "Palkia blesses us!",
      :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPEED, 1]
    },
  }

=begin
  TWINS_TEMPLE1 = {
    "turnCommand" => {
	  :speech  => ["We fight for Lord Palkia! You shall not defile this temple, invader!"],
      :battler => :Opposing,
	  :anim => [:REFLECT, :Opposing],
	  :team => [
        [PBEffects::Reflect, 5, "A force of light set up Reflect on the Twin Priests' side of the field!"]
	  ],
	  :anim_1 => [:LIGHTSCREEN, :Opposing],
	  :team_1 => [
		[PBEffects::LightScreen, 5, "A force of light set up Light Screen on the Twin Priests' side of the field!"],
	  ]
    },
    "attackerSEdmg_foe_random" => {
	  :text      	=> "Palkia fights on our side!",
	  :battler 		=> :Self,
	  :anim     	=> [:PURGE, :Opposing],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was smited!",
	  :playsound_1 	=> "Anim/handofgod",
	  :hp      		=> -8,
    },
    "defenderHPLowLast_foe" => {
	  :speech      	=> [:Self, "Palkia! Save us!"],
	  :battler   	=> :Self,
	  :anim     	=> [:HALLOWEDGROUND, :Self],
	  :hp      		=> 2,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:ATTACK, 1, :SPECIAL_ATTACK, 1]
    },
  }
  
  TWINS_TEMPLE2 = {
    "turnCommand_random" => {
	  :speech      	=> ["Palkia! Protect us from evil!"],
	  :battler   	=> :Opposing,
	  :anim     	=> "Common:StatUp",
	  :playsound 	=> "Anim/increase",
	  :stats     	=> [:DEFENSE, 1, :SPECIAL_DEFENSE,1]
    },
    "defenderHPHalf_foe_random" => {
	  :text      	=> "Palkia rebukes you!",
	  :battler 		=> :Self,
	  :anim     	=> [:PURGE, :Opposing],
	  :battler_1   	=> :Opposing,
	  :anim_1  		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:ATTACK, -1, :SPECIAL_ATTACK, -1]
    },
    "attackerDodged_foe_random" => {
	  :text      	=> "Palkia will guide us!",
	  :battler   	=> :Self,
	  :anim     	=> "Common:StatUp",
	  :playsound_1 	=> "Anim/increase",
	  :stats     	=> [:SPEED, 1, :ACCURACY, 1]
    },
  }
  
  TWINS_TEMPLE3 = {
    "attackerSEdmg_foe_random" => {
	  :text      	=> "Palkia fights on our side!",
	  :battler 		=> :Self,
	  :anim     	=> [:PURGE, :Opposing],
	  :battler_1   	=> :Opposing,
	  :text_1      	=> "{1} was smited!",
	  :playsound_1 	=> "Anim/handofgod",
	  :hp      		=> -8,
    },
    "defenderDamaged_foe_random" => {
	  :text      	=> "Your lack of faith shall be your undoing!",
	  :battler   	=> :Self,
	  :anim     	=> [:HALLOWEDGROUND, :Self],
	  :hp      		=> 8,
    },
    "attackerNVEdmg_foe_random" => {
	  :text      	=> "Palkia renders you vulnerable!",
      :battler 		=> :Opposing,
	  :anim    		=> "Common:StatDown",
	  :playsound_1 	=> "Anim/decrease",
	  :stats   		=> [:SPEED, -1]
    },
  }
=end

  TEST_BATTLE = {
=begin
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
=end
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
