# Boss 'PBS' Data
GameData::BossBattles.register({ #this is pretty much everything that a boss battle can have so test it out
  :id   => :GODSLAYER,
  :shieldCount => 1,# number of shields
  :immunities => { # any immunities to things
    :moves => [:PARTINGSHOT,:FEINT],#these are the moves that the boss is immune (takes no damage) to
    :fieldEffectDamage => [] # there arent any fields that in base essentials that do field effect damage and i dont want to make one
  },
  :entryText => "Heaven-shaking Godkiller appeared.",# dialogue upon enterring battle
  :pokemon => { # pokemon details (obvs)
    :species => :FLYGON,
    :name => "God-Slayer",# nick-name
    :level => 20,
    :form => 0,
    :item => :LEFTOVERS,
    :moves => [:DARKPULSE,:PSYSHOCK,:MOONLIGHT,:MOONBLAST],
    :ability => :RKSSYSTEM,
    :gender => "F",
    :nature => :MODEST,
    :happiness => 255,
    :ev => [252,0,4,0,252,0],
    :iv => [31,0,31,31,31,31],
    :baseStats => [95,95,95,95,95,95],
    :shiny => true
  },
  :onEntryEffects => { # effects applied on entry,use same attributes/syntax as onbreakeffects
    :fieldChange => :Misty,
    :fieldChangeMessage => "God-Slayer laughs at how dumb your face looks. So mean!",
    :delayedaction => {
                :delay => 1,
                :playerSideStatChanges => {
                    :SPEED => -1,
                },
                :message => "The aromatic mist is relaxing...",
                :repeat => true,
                :animation => :FAIRYWIND,
            }
  },
  :onBreakEffects => {  # in order of shield count,with the highest value being the first shield broken and the lowest the last
    1 => {
      :threshold => 0,# if desired,shield can be broken at higher hp% than 0
      :message => "God-Slayer is angered!",# message that plays when shield is broken
      :bossEffect => [:MagicCoat,:WRAP],# effect that applies on the boss when breaking shield. Can use arrays for multiple effects or just one without brackets
      :bossEffectDuration => [true,-1],# duration of effect,negative number means it lasts forever
      :bossEffectMessage => "{1} shrouded itself with Magic Coat!",# message that plays for the effect
      :bossEffectAnimation => :MAGICCOAT,# effect animation
      :speciesUpdate => :GARCHOMP,# change the pokemon
      :formChange => 1,# formchanges
      :abilityChange => :DOWNLOAD,# ability to change to upon shieldbreaker
      :fieldChange => :Grassy,# field changes
      :weatherChange => :Rain,# weather to apply
      :weatherCount => 5,# weather duration
      :weatherChangeMessage => "Rain began to fall!",# weather message
      :weatherChangeAnimation => "Rain",# weather animation
      :typeChange => [:FIRE,:ROCK],# any given type changes
      :movesetUpdate => [:EARTHQUAKE,:OUTRAGE,:ROCKSLIDE,:FIREBLAST],# moveset changes
      :statusCure => true,# cure status
      :effectClear => true,# clear effects
      :bossSideStatusChanges => :POISON,# status change on boss's side
      :playerSideStatusChanges => :BURN,# status change on player's side
      :statDropCure => true,# cure stat drops
      :playerEffect => [:Curse,:FIRESPIN],# effects that apply on player's side
      :playerEffectDuration => [true,-1],#negative number means it lasts forever
      :playerEffectAnimation => [:CURSE,:FIRESPIN],# effect animations
      :playerEffectMessage => "A curse was inflicted on the opposing side!",# effect message
      :stateChanges => :TrickRoom,# state change
      :stateChangeAnimation => :TRICKROOM,# state change animation
      :stateChangeCount => 5,# state change duration
      :stateChangeMessage => "The dimensions were changed!",# state change message
      :playerSideChanges => :ToxicSpikes,# player side change
      :playerSideChangeAnimation => :TOXICSPIKES,# side change animation
      :playerSideChangeCount => 1,# side change duration
      :playerSideChangeMessage => "Toxic Spikes was set up on the opposing side!",# side change message
      :bossSideChanges => :ToxicSpikes,# boss side change
      :bossSideChangeAnimation => :TOXICSPIKES,# side change animation
      :bossSideChangeCount => 1,# side change duration
      :bossSideChangeMessage => "Toxic Spikes was set up on the God-Slayer's side!",# side change message
      :itemChange => :LIFEORB,# item change
      :bossStatChanges => { # boss stat changes
        :ATTACK => 1
      },
      :playerSideStatChanges => { # player stat changes
        :ATTACK => -1
      },
      :delayedaction => {
        :delay => 1,# this just means how many turn it will take for the delayed action to happen
        :repeat => true,# repeat forever
        :message => "God-Slayer's type shifted!",
        :typeSequence => { # here the delayed action(changing type) will happen every turn
                    1 => {
                            :typeChange => [:FLYING,:FLYING],
                         },
                    2 => {
                            :typeChange => [:ELECTRIC,:FLYING],
                         },
                    3 => {
                            :typeChange => [:GROUND,:FLYING],
                         },
                    4 => {
                            :typeChange => [:FAIRY,:FLYING],
                         },
                },
      }
    }
  }
})
GameData::BossBattles.register({ 
  :id   => :GODSLAYER_STD,
  :shieldCount => 2,# number of shields
  :immunities => { # any immunities to things
    :moves => [:PARTINGSHOT,:FEINT],#these are the moves that the boss is immune (takes no damage) to
    :fieldEffectDamage => [] # there arent any fields that in base essentials that do field effect damage and i dont want to make one
  },
  :entryText => "Heaven-shaking Godkiller appeared.",# dialogue upon enterring battle
  :pokemon => { # pokemon details (obvs)
    :species => :FLYGON,
    :name => "God-Slayer",# nick-name
    :level => 20,
    :form => 0,
    :item => :LEFTOVERS,
    :moves => [:DARKPULSE,:PSYSHOCK,:MOONLIGHT,:MOONBLAST],
    :ability => :RKSSYSTEM,
    :gender => "F",
    :nature => :MODEST,
    :happiness => 255,
    :ev => [252,0,4,0,252,0],
    :iv => [31,0,31,31,31,31],
    :baseStats => [95,95,95,95,95,95],
    :shiny => true
  },
})

GameData::BossBattles.register({ #Everything in this boss is the bare MINIMUM to make a boss function
  :id => :THE_ORS,
  :shieldCount => 1,
  :immunities => {},
  :pokemon => {
    :species => :BIDOOF,
    :level => 20
  },
  :onBreakEffects => {}
})
GameData::BossBattles.register({ # A clone of the base boss called alwys on Standard mode
  :id => :THE_ORS_STD,# having '_STD' at the end will make this bass appear when calling for Boss Id ':THE_ORS'
  :shieldCount => 2,
  :immunities => {},
  :pokemon => {
    :species => :BIDOOF,
    :level => 20
  },
  :onBreakEffects => {}
})
GameData::BossBattles.register({ # A clone of the base boss called alwys on Adept mode
  :id => :THE_ORS_ADT,# having '_ADT' at the end will make this bass appear when calling for Boss Id ':THE_ORS'
  :shieldCount => 3,
  :immunities => {},
  :pokemon => {
    :species => :BIDOOF,
    :level => 20
  },
  :onBreakEffects => {}
})
GameData::BossBattles.register({ # A clone of the base boss called alwys on Unfair mode
  :id => :THE_ORS_UNF,# having '_UNF' at the end will make this bass appear when calling for Boss Id ':THE_ORS'
  :shieldCount => 4,
  :immunities => {},
  :pokemon => {
    :species => :BIDOOF,
    :level => 20
  },
  :onBreakEffects => {}
})

# Main Game Anomaly Bosses
GameData::BossBattles.register({ # Swalot (Orion City)
  :id => :ANOM_SWALOT,
  :shieldCount => 1,
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :entryText => "The Anomaly Swalot attacks!.",
  :pokemon => {
    :species => :SWALOT,
    :form => 2,
    :moves => [:MUDSHACKLES,:ROCKSLIDE,:ACIDSPRAY,:COSMICPOWER],
    :ability => :DRYSKIN,
    :item => :LEFTOVERS,
    :nature => :SASSY,
    :gender => "M",
    :ev => [0,252,252,0,0,0],
    :iv => [31,31,31,31,31,31],
    :level => 27
  },
  :onBreakEffects => {}
})
GameData::BossBattles.register({ # Swalot (Orion City)
  :id => :ANOM_SWALOT_ADT,
  :shieldCount => 1,
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :entryText => "The Anomaly Swalot attacks!.",
  :pokemon => {
    :species => :SWALOT,
    :form => 2,
    :moves => [:MUDSHACKLES,:ROCKSLIDE,:ACIDSPRAY,:COSMICPOWER],
    :ability => :DRYSKIN,
    :item => :LEFTOVERS,
    :nature => :SASSY,
    :gender => "M",
    :ev => [0,252,252,0,0,0],
    :iv => [31,31,31,31,31,31],
    :level => 27
  },
  :onBreakEffects => {
    1 => {
      :message => "The Anomaly Swalot is enraged!",
      :statDropCure => true,
      :statusCure => true,
      :abilityChange => :CLAYFORM,# ability to change to upon shieldbreaker
      :movesetUpdate => [:VENOSHOCK,:POISONGAS,:PROTECT,:SANDTOMB],# moveset changes
      :itemChange => :LEFTOVERS,# item change
      :weatherChange => :Sandstorm,# weather to apply
      :weatherCount => 10,# weather duration
      :weatherChangeMessage => "The Swalot kicked up a Sandstorm!",# weather message
      :weatherChangeAnimation => "Sandstorm",# weather animation
      :bossStatChanges => { # boss stat changes
        :ATTACK => 1,
        :SPECIAL_ATTACK => 1
       }
    }
  }
})
GameData::BossBattles.register({ # Swalot (Orion City)
  :id => :ANOM_SWALOT_UNF,
  :shieldCount => 1,
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :entryText => "The Anomaly Swalot attacks!.",
  :pokemon => {
    :species => :SWALOT,
    :form => 2,
    :moves => [:MUDSHACKLES,:ROCKSLIDE,:ACIDSPRAY,:COSMICPOWER],
    :ability => :DRYSKIN,
    :item => :LEFTOVERS,
    :nature => :SASSY,
    :gender => "M",
    :ev => [0,252,252,0,0,0],
    :iv => [31,31,31,31,31,31],
    :level => 27
  },
  :onBreakEffects => {
    1 => {
      :message => "The Anomaly Swalot is enraged!",
      :statDropCure => true,
      :statusCure => true,
      :abilityChange => :CLAYFORM,# ability to change to upon shieldbreaker
      :movesetUpdate => [:VENOSHOCK,:POISONGAS,:PROTECT,:SANDTOMB],# moveset changes
      :itemChange => :LEFTOVERS,# item change
      :weatherChange => :Sandstorm,# weather to apply
      :weatherCount => 10,# weather duration
      :weatherChangeMessage => "The Swalot kicked up a Sandstorm!",# weather message
      :weatherChangeAnimation => "Sandstorm",# weather animation
      :bossStatChanges => { # boss stat changes
        :ATTACK => 1,
        :SPECIAL_ATTACK => 1
       }
    }
  }
})
GameData::BossBattles.register({ # Galvantul (Caverns of Rhea)
  :id => :ANOM_GALVANTULA,
  :shieldCount => 1,
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :pokemon => {
    :species => :GALVANTULA,
    :form => 2,
    :moves => [:CROSSPOISON,:NIGHTSLASH,:FELLSTINGER,:AGILITY],
    :ability => :SNIPER,
    :item => :DARKGEM,
    :nature => :ADAMANT,
    :gender => "M",
    :ev => [0,252,0,252,0,0],
    :iv => [31,31,31,31,31,31],
    :level => 45
  },
  :onBreakEffects => {}
})
GameData::BossBattles.register({ # Arbok (Temple of Space)
  :id => :ANOM_ARBOK,
  :shieldCount => 1,
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :pokemon => {
    :species => :ARBOK,
    :form => 2,
    :moves => [:EARTHPOWER,:SLUDGEWAVE,:CLANGINGSCALES,:DARKPULSE],
    :ability => :MAESTRO,
    :item => :DARKGEM,
    :nature => :MODEST,
    :gender => "M",
    :ev => [0,0,0,252,252,0],
    :iv => [31,31,31,31,31,31],
    :level => 52
  },
  :onBreakEffects => {}
})
GameData::BossBattles.register({ # Starmie (The In-Between)
  :id => :ANOM_STARMIE,
  :shieldCount => 1,
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :pokemon => {
    :species => :STARMIE,
    :form => 2,
    :moves => [:HYPERSPACEHOLE,:SUPERNOVA,:BEJEWELED,:ETHEREALBURST],
    :ability => :SERENEGRACE,
    :item => :COSMICGEM,
    :nature => :MODEST,
    :gender => "M",
    :ev => [0,252,252,0,0,0],
    :iv => [31,31,31,31,31,31],
    :level => 53
  },
  :onBreakEffects => {}
})
GameData::BossBattles.register({ # Swoobat (The In-Between)
  :id => :ANOM_SWOOBAT,
  :shieldCount => 1,
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :pokemon => {
    :species => :SWOOBAT,
    :form => 2,
    :moves => [:CRUNCH,:VENOMDRAIN,:PSYCHICFANGS,:HYPERFANG],
    :ability => :STRONGJAW,
    :item => :DARKGEM,
    :nature => :ADAMANT,
    :gender => "M",
    :ev => [0,252,0,252,0,0],
    :iv => [31,31,31,31,31,31],
    :level => 54
  },
  :onBreakEffects => {}
})
GameData::BossBattles.register({ # Weezing (The In-Between)
  :id => :ANOM_WEEZING,
  :shieldCount => 1,
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :pokemon => {
    :species => :WEEZING,
    :form => 2,
    :moves => [:ERUPTION,:ACIDRAIN,:DARKPULSE,:EXTRASENSORY],
    :ability => :STEAMENGINE,
    :item => :DARKGEM,
    :nature => :MODEST,
    :gender => "M",
    :ev => [0,0,0,252,252,0],
    :iv => [31,31,31,31,31,31],
    :level => 54
  },
  :onBreakEffects => {}
})
GameData::BossBattles.register({ # Noivern (The In-Between)
  :id => :ANOM_NOIVERN,
  :shieldCount => 1,
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :pokemon => {
    :species => :NOIVERN,
    :form => 2,
    :moves => [:CLANGINGSCALES,:DRAGONPULSE,:OBLIVIONWING,:CHAOSBLAST],
    :ability => :PUNKROCK,
    :item => :DARKGEM,
    :nature => :MODEST,
    :gender => "M",
    :ev => [0,0,0,252,252,0],
    :iv => [31,31,31,31,31,31],
    :level => 54
  },
  :onBreakEffects => {}
})
GameData::BossBattles.register({ # Gyarados(Underwater Temple)
  :id => :ANOM_GYARADOS,
  :shieldCount => 1,
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :pokemon => {
    :species => :GYARADOS,
    :form => 2,
    :moves => [:THUNDERBOLT,:EXTRASENSORY,:DARKPULSE,:TIDALWAVE],
    :ability => :TELEPATHY,
    :item => :PSYCHICGEM,
    :nature => :ADAMANT,
    :gender => "M",
    :ev => [0,0,0,252,252,0],
    :iv => [31,31,31,31,31,31],
    :level => 57
  },
  :onBreakEffects => {}
})
GameData::BossBattles.register({ # Grapploct (Underwater Temple)
  :id => :ANOM_GRAPPLOCT,
  :shieldCount => 1,
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :pokemon => {
    :species => :GRAPPLOCT,
    :form => 2,
    :moves => [:WATERPRESSURE,:SUBMISSION,:CELESTIALFURY,:FRENZY],
    :ability => :ARENATRAP,
    :item => :BODYARMOR,
    :nature => :ADAMANT,
    :gender => "M",
    :ev => [0,252,0,252,0,0],
    :iv => [31,31,31,31,31,31],
    :level => 57
  },
  :onBreakEffects => {}
})
GameData::BossBattles.register({ # Hoopa (Route 13B)
  :id => :ANOM_HOOPA,
  :shieldCount => 1,
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :pokemon => {
    :species => :HOOPA,
    :form => 2,
    :moves => [:VALKYRIECHARIOT,:SUPERPOWER,:EARTHQUAKE,:FRENZY],
    :ability => :CONTRARY,
    :item => :GROUNDGEM,
    :nature => :ADAMANT,
    :gender => "M",
    :ev => [0,252,0,252,0,0],
    :iv => [31,31,31,31,31,31],
    :level => 63
  },
  :onBreakEffects => {}
})
GameData::BossBattles.register({ # Meganium (Deimos Caves L0)
  :id => :ANOM_MEGANIUM,
  :shieldCount => 1,
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :pokemon => {
    :species => :MEGANIUM,
    :form => 2,
    :moves => [:GIGADRAIN,:POLLENPUFF,:DRAININGKISS,:FAESBLESSING],
    :ability => :TRIAGE,
    :item => :LEFTOVERS,
    :nature => :MODEST,
    :gender => "M",
    :ev => [0,0,0,252,252,0],
    :iv => [31,31,31,31,31,31],
    :level => 69
  },
  :onBreakEffects => {}
})

# -------------------------------------------------------------
# -------------------------------------------------------------
# -------------------------------------------------------------
# -------------------------------------------------------------
# Post Game Anomaly Bosses
# -------------------------------------------------------------
# -------------------------------------------------------------
# -------------------------------------------------------------
# -------------------------------------------------------------

# -------------------------------------------------------------
# Anomaly Wishiwashi (Seaking, Lanturn and Wishiwashi)
# Location: Eridanus Trench
# -------------------------------------------------------------

# Standard Difficulty
GameData::BossBattles.register({
  :id   => :FENRIS_CEREBRATE_STD,
  :shieldCount => 2,# Number of shields
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :entryText => "MAY DARKNESS CONSUME YOU.",# Dialogue upon entering battle
  :pokemon => { # pokemon details (obvs)
    :species => :WISHIWASHI,
    :name => "Fenris",
    :form => 2,
  },
  :onBreakEffects => {
    2 => {
      :animation => :OMINOUSWIND, # effect animations
      :statDropCure => true,# cure enemy's stat drops
      :statusCure => true,
      :message => "There is no escaping our wrath!",  
      :movesetUpdate => [:TIDALWAVE,:TOXIC,:PROTECT,:BREAKINGSWIPE],# moveset changes
      :typeChange => [:WATER],# any given type changes
      :itemChange => :LEFTOVERS,# item change
      :abilityChange => :DISHEARTEN,# ability to change to upon shieldbreaker
    },
    1 => {}
  }
})

# Adept+ Difficulty
GameData::BossBattles.register({
  :id   => :FENRIS_CEREBRATE,
  :shieldCount => 2,# Number of shields
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :entryText => "MAY DARKNESS CONSUME YOU.",# Dialogue upon entering battle
  :pokemon => { # pokemon details (obvs)
    :species => :WISHIWASHI,
    :name => "Fenris",
    :form => 2,
  },
  :onBreakEffects => {
    2 => {
      :animation => :POISONGAS, # effect animations
      :statDropCure => true,# cure enemy's stat drops
      :playerSideStatusChanges => :POISON, # status change on player's side
      :statusCure => true,
      :message => "There is no escaping our wrath!",  
      :movesetUpdate => [:MUDDYWATER,:ACIDRAIN,:CHAINLIGHTNING,:TOPSYTURVY],# moveset changes
      :typeChange => [:POISON],# any given type changes
      :itemChange => :SHIELDGROUND,# item change
      :bossStatChanges => { # boss stat changes
        :SPECIAL_DEFENSE => 1,
        :DEFENSE => 1  
      },
      :abilityChange => :MERCILESS,# ability to change to upon shieldbreaker
    },
    1 => {
      :message => "We endure!",
      :animation => :PSYCHICTERRAIN, # effect animations
      :statDropCure => true,# cure enemy's stat drops
      :statusCure => true,
      :typeChange => [:PSYCHIC],# any given type changes
      :movesetUpdate => [:EXPANDINGFORCE,:PHOTONGEYSER,:EARTHPOWER,:BUGBUZZ],# moveset changes
      :itemChange => :MINDPLATE,# item change
      :abilityChange => :TERRORIZE,# ability to change to upon shieldbreaker
      :bossStatChanges => { # boss stat changes
        :SPECIAL_ATTACK => 1,
        :SPEED => 1,
      },
    }
  }
})

# -------------------------------------------------------------
# Anomaly Gyarados
# Location: Nesting Grounds
# -------------------------------------------------------------

# Standard Difficulty
GameData::BossBattles.register({
  :id   => :GYARADOS_OVERLORD_STD,
  :shieldCount => 2,# Number of shields
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :entryText => "MUST FEED ON AETHER!",# Dialogue upon entering battle
  :pokemon => { # pokemon details (obvs)
    :species => :GYARADOS,
    :form => 2,
  },
  :onBreakEffects => {
    2 => {
      :animation => :DRAGONDANCE, # effect animations
      :message => "I shall consume your essence to evolve!",  
      :movesetUpdate => [:SPACIALREND,:SNIPESHOT,:GAMMARAY,:KINETICBLAST],# moveset changes
      :typeChange => [:DRAGON,:WATER],# any given type changes
      :itemChange => :SCOPELENS,# item change
      :abilityChange => :SNIPER,# ability to change to upon shieldbreaker
    },
    1 => {}
  }
})

# Adept+ Difficulty
GameData::BossBattles.register({
  :id   => :GYARADOS_OVERLORD,
  :shieldCount => 2,# Number of shields
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :entryText => "MUST FEED ON AETHER!",# Dialogue upon entering battle
  :pokemon => { # pokemon details (obvs)
    :species => :GYARADOS,
    :form => 2,
  },
  :onBreakEffects => {
    2 => {
      :animation => :DRAGONDANCE, # effect animations
      :message => "I shall consume your essence to evolve!",  
      :movesetUpdate => [:SPACIALREND,:SNIPESHOT,:GAMMARAY,:KINETICBLAST],# moveset changes
      :typeChange => [:DRAGON,:WATER],# any given type changes
      :itemChange => :SCOPELENS,# item change
      :statDropCure => true,# cure enemy's stat drops
      :statusCure => true,
      :abilityChange => :SNIPER,# ability to change to upon shieldbreaker
    },
    1 => {
      :message => "We are infinite! Concede or be consumed!",
      :animation => :STRENGTHSAP, # effect animations
      :statDropCure => true,# cure enemy's stat drops
      :statusCure => true,
      :typeChange => [:BUG,:GROUND],# any given type changes
      :movesetUpdate => [:SANDFLURRY,:HIVEMIND,:AUTUMNBLAST,:BEJEWELED],# moveset changes
      :itemChange => :LIFEORB,# item change
      :abilityChange => :OWNTEMPO,# ability to change to upon shieldbreaker
    }
  }
})

# -------------------------------------------------------------
# Tiamat the Cerebrate
# Location: The Hatchery
# -------------------------------------------------------------

# Standard Difficulty
GameData::BossBattles.register({ # Tiamat the Cerebrate in The Hatchery
  :id   => :TIAMAT_CEREBRATE_STD,
  :shieldCount => 2, # number of shields
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :pokemon => { # pokemon details (obvs)
    :species => :CENTISKORCH,
    :form => 2,
  },
  :onBreakEffects => {
    2 => {
      :threshold => 0,
      :message => "The Anomaly Cerebrate sprays caustic acid and poisons your side of the field!",# effect message
      :playerSideStatusChanges => :POISON, # status change on player's side
      :playerSideChanges => :ToxicSpikes, # player side change
      :playerSideChangeAnimation => :TOXICSPIKES, # side change animation
      :playerSideChangeCount => 1, # side change duration
      :playerSideChangeMessage => "A poisonous substance was dropped on your side of the field!",# side change message
    },
    1 => {}
  }
})

# Adept+ Difficulty
GameData::BossBattles.register({ # Tiamat the Cerebrate in The Hatchery
  :id   => :TIAMAT_CEREBRATE,
  :shieldCount => 2, # number of shields
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :pokemon => { # pokemon details (obvs)
    :species => :CENTISKORCH,
    :form => 2,
  },
  :onBreakEffects => {
    2 => {
      :threshold => 0,
      :message => "The Anomaly Cerebrate sprays caustic acid and poisons your side of the field!",# effect message
      :playerSideStatusChanges => :POISON, # status change on player's side
      :playerSideChanges => :ToxicSpikes, # player side change
      :playerSideChangeAnimation => :TOXICSPIKES, # side change animation
      :playerSideChangeCount => 2, # side change duration
      :playerSideChangeMessage => "Toxic Spikes was set up on your side of the field!",# side change message
    },
    1 => {
      :threshold => 0,
      :message => "I shall absorb the essence of my fallen children!",
      :animation => :STRENGTHSAP, # effect animations
      :abilityChange => :SHEERFORCE, # ability to change to upon shieldbreaker
      :typeChange => [:FIRE,:GROUND], # any given type changes
      :movesetUpdate => [:FLAREBLITZ,:ROCKSLIDE,:EARTHQUAKE,:PLAGUE],# moveset changes
      :itemChange => :BODYARMOR,# item change
      :bossStatChanges => { # boss stat changes
        :ATTACK => 1,
        :SPEED => 1,
      },
    }
  }
})

# -------------------------------------------------------------
# Jormungand the Cerebrate
# Location: The Hatchery
# -------------------------------------------------------------

# Standard Difficulty
GameData::BossBattles.register({ # Jormungand the Cerebrate in The Hatchery
  :id   => :JORMUNGAND_CEREBRATE_STD,
  :shieldCount => 2, # number of shields
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :pokemon => { # pokemon details (obvs)
    :species => :EXCADRILL,
    :form => 2,
  },
  :onBreakEffects => {
    2 => {
      :threshold => 0,
      :message => "The Anomaly Cerebrate hardens its exoskeleton!",# effect message
      :animation => :IRONDEFENSE, # effect animations
      :bossStatChanges => { # boss stat changes
        :SPECIAL_DEFENSE => 1,
      },
    },
    1 => {}
  }
})

# Adept+ Difficulty
GameData::BossBattles.register({ # Jormungand the Cerebrate in The Hatchery
  :id   => :JORMUNGAND_CEREBRATE,
  :shieldCount => 2, # number of shields
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :pokemon => { # pokemon details (obvs)
    :species => :EXCADRILL,
    :form => 2,
  },
  :onBreakEffects => {
    2 => {
      :threshold => 0,
      :message => "The Anomaly Cerebrate hardens its exoskeleton!",# effect message
      :animation => :IRONDEFENSE, # effect animations
      :bossStatChanges => { # boss stat changes
        :DEFENSE => 1,
        :SPECIAL_DEFENSE => 1,
      },
    },
    1 => {
      :threshold => 0,
      :message => "I will adapt so you pay for your insolence!",
      :animation => :STRENGTHSAP, # effect animations
      :abilityChange => :STURDY, # ability to change to upon shieldbreaker
      :typeChange => [:FIGHTING,:STEEL], # any given type changes
      :movesetUpdate => [:GOLDENBULLET,:SUPERPOWER,:WILDCHARGE,:FRENZY],# moveset changes
      :itemChange => :BODYARMOR,# item change
      :bossStatChanges => { # boss stat changes
        :ATTACK => 1,
        :SPEED => 1,
      },
    }
  }
})

# -------------------------------------------------------------
# Anomaly Muk (Soil Samples Side Quest)
# Location: Flooded Base
# -------------------------------------------------------------

# Standard Difficulty
GameData::BossBattles.register({ # Anomaly Muk in Flooded Base
  :id   => :ANOMALYMUK_FLOODED_STD,
  :shieldCount => 2, # number of shields
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :pokemon => { # pokemon details (obvs)
    :species => :MUK,
    :form => 2,
  },
  :onBreakEffects => {
    2 => {
      :threshold => 0,
      :message => "So long I have waited for such a feast!",# effect message
      :abilityChange => :FORTIFICATION, # ability to change to upon shieldbreaker
      :animation => :IRONDEFENSE, # effect animations
      :bossStatChanges => { # boss stat changes
        :DEFENSE => 1,
        :SPECIAL_DEFENSE => 1,
      },
    },
    1 => {}
  }
})

# Adept+ Difficulty
GameData::BossBattles.register({ # Anomaly Muk in Flooded Base
  :id   => :ANOMALYMUK_FLOODED,
  :shieldCount => 2, # number of shields
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :pokemon => { # pokemon details (obvs)
    :species => :MUK,
    :form => 2,
  },
  :onBreakEffects => {
    2 => {
      :threshold => 0,
      :message => "So long I have waited for such a feast!",# effect message
      :abilityChange => :FORTIFICATION, # ability to change to upon shieldbreaker
      :animation => :IRONDEFENSE, # effect animations
      :statDropCure => true,# cure enemy's stat drops
      :statusCure => true,
      :bossStatChanges => { # boss stat changes
        :DEFENSE => 1,
        :SPECIAL_DEFENSE => 1,
      },
    },
    1 => {
      :threshold => 0,
      :message => "I am renewed!",
      :animation => :RECYCLE, # effect animations
      :typeChange => [:STEEL,:POISON], # any given type changes
      :statDropCure => true,# cure enemy's stat drops
      :statusCure => true,
      :movesetUpdate => [:GEOMANCY,:GIGADRAIN,:SLUDGEBOMB,:PLASMAFORGE],# moveset changes
      :itemChange => :SHIELDGROUND,# item change
    }
  }
})

# -------------------------------------------------------------
# Anomaly Grapploct (Call of the Drowned Side Quest)
# Location: Abandoned Shipwreck
# -------------------------------------------------------------

# Standard Difficulty
GameData::BossBattles.register({ # Anomaly Grapploct in the Abandoned Shipwreck
  :id   => :ANOMALYGRAPPLOCT_SHIPWRECK_STD,
  :shieldCount => 2, # number of shields
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :pokemon => { # pokemon details (obvs)
    :species => :GRAPPLOCT,
    :form => 2,
  },
  :onBreakEffects => {
    2 => {
      :threshold => 0,
      :message => "My strength grows!",# effect message
      :abilityChange => :FORTIFICATION, # ability to change to upon shieldbreaker
      :animation => :IRONDEFENSE, # effect animations
      :bossStatChanges => { # boss stat changes
        :DEFENSE => 1,
        :SPECIAL_DEFENSE => 1,
      },
    },
    1 => {}
  }
})

# Adept+ Difficulty
GameData::BossBattles.register({ # Anomaly Grapploct in the Abandoned Shipwreck
  :id   => :ANOMALYGRAPPLOCT_SHIPWRECK,
  :shieldCount => 2, # number of shields
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :pokemon => { # pokemon details (obvs)
    :species => :GRAPPLOCT,
    :form => 2,
  },
  :onBreakEffects => {
    2 => {
      :threshold => 0,
      :message => "My strength grows!",# effect message
      :abilityChange => :FORTIFICATION, # ability to change to upon shieldbreaker
      :animation => :IRONDEFENSE, # effect animations
      :statDropCure => true,# cure enemy's stat drops
      :statusCure => true,
      :bossStatChanges => { # boss stat changes
        :DEFENSE => 1,
        :SPECIAL_DEFENSE => 1,
      },
    },
    1 => {
      :threshold => 0,
      :message => "I emerge from the Void!",
      :animation => :BLACKHOLE, # effect animations
      :typeChange => [:COSMIC,:POISON], # any given type changes
      :statDropCure => true,# cure enemy's stat drops
      :statusCure => true,
      :movesetUpdate => [:COSMICAVATAR,:GUNKSHOT,:NORETREAT,:SURGINGSTRIKES],# moveset changes
      :itemChange => :SHIELDROCK,# item change
    }
  }
})

# -------------------------------------------------------------
# Anomaly Vileplume (The Rot Beneath Our Feet Side Quest)
# Location: No Man's Land
# -------------------------------------------------------------

# Standard Difficulty
GameData::BossBattles.register({ # Anomaly Vileplume in No Man's Land
  :id   => :ANOMALYVILEPLUME_NOMANSLAND,
  :shieldCount => 2, # number of shields
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :pokemon => { # pokemon details (obvs)
    :species => :VILEPLUME,
    :form => 2,
  },
  :onBreakEffects => {
    2 => {
      :threshold => 0,
      :message => "My children will not have died in vain!",# effect message
      :abilityChange => :ANGERSHELL, # ability to change to upon shieldbreaker
      :animation => :OUTRAGE, # effect animations
      :bossStatChanges => { # boss stat changes
        :DEFENSE => 1,
        :SPECIAL_DEFENSE => 1,
      },
    },
    1 => {}
  }
})

# Adept+ Difficulty
GameData::BossBattles.register({ # Anomaly Vileplume in No Man's Land
  :id   => :ANOMALYVILEPLUME_NOMANSLAND,
  :shieldCount => 2, # number of shields
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :pokemon => { # pokemon details (obvs)
    :species => :VILEPLUME,
    :form => 2,
  },
  :onBreakEffects => {
    2 => {
      :threshold => 0,
      :message => "My children will not have died in vain!",# effect message
      :abilityChange => :ANGERSHELL, # ability to change to upon shieldbreaker
      :animation => :OUTRAGE, # effect animations
      :statDropCure => true,# cure enemy's stat drops
      :statusCure => true,
      :bossStatChanges => { # boss stat changes
        :DEFENSE => 1,
        :SPECIAL_DEFENSE => 1,
      },
    },
    1 => {
      :threshold => 0,
      :message => "I shall expunge you from our land, human filth!",
      :animation => :POLLENPUFF, # effect animations
      :typeChange => [:BUG,:DARK], # any given type changes
      :statDropCure => true,# cure enemy's stat drops
      :statusCure => true,
      :movesetUpdate => [:PHEROMONESTREAM,:UMBRALWAVE,:ECTOPLASM,:SLUDGEBOMB],# moveset changes
      :itemChange => :SHIELDFIRE,# item change
    }
  }
})

# -------------------------------------------------------------
# Anomaly Galvantula (My Preciousss Side Quest)
# Location: Deadwind Pass
# -------------------------------------------------------------

# Standard Difficulty
GameData::BossBattles.register({ # Anomaly Galvantula in Deadwind Pass
  :id   => :SHELOB_DEADWINDPASS,
  :shieldCount => 2, # number of shields
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :pokemon => { # pokemon details (obvs)
    :species => :GALVANTULA,
    :form => 2,
  },
  :onBreakEffects => {
    2 => {
      :threshold => 0,
      :message => "I cannot pass up such a delectable meal!",# effect message
      :animation => :STRENGTHSAP, # effect animations
      :abilityChange => :TRIAGE, # ability to change to upon shieldbreaker
      :typeChange => [:POISON,:PSYCHIC], # any given type changes
      :movesetUpdate => [:VENOMDRAIN,:LEECHLIFE,:MINDDRAIN,:TOXICTHREAD],# moveset changes
      :itemChange => :BIGROOT,# item change
      :bossStatChanges => { # boss stat changes
        :DEFENSE => 1,
        :SPECIAL_DEFENSE => 1,
      },
    },
    1 => {}
  }
})

# Adept+ Difficulty
GameData::BossBattles.register({ # Anomaly Galvantula in Deadwind Pass
  :id   => :SHELOB_DEADWINDPASS,
  :shieldCount => 2, # number of shields
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :pokemon => { # pokemon details (obvs)
    :species => :GALVANTULA,
    :form => 2,
  },
  :onBreakEffects => {
    2 => {
      :threshold => 0,
      :message => "I cannot pass up such a delectable meal!",# effect message
      :animation => :STRENGTHSAP, # effect animations
      :abilityChange => :TRIAGE, # ability to change to upon shieldbreaker
      :typeChange => [:POISON,:PSYCHIC], # any given type changes
      :movesetUpdate => [:VENOMDRAIN,:LEECHLIFE,:MINDDRAIN,:TOXICTHREAD],# moveset changes
      :itemChange => :BIGROOT,# item change
      :bossStatChanges => { # boss stat changes
        :DEFENSE => 1,
        :SPECIAL_DEFENSE => 1,
      },
    },
    1 => {
      :threshold => 0,
      :message => "I shall feast upon your corpse!",
      :animation => :POLLENPUFF, # effect animations
      :typeChange => [:BUG,:POISON], # any given type changes
      :movesetUpdate => [:PLAGUE,:CHITINOUSSTRIKE,:FRENZY,:FELLSTINGER],# moveset changes
      :itemChange => :SHIELDFLYING,# item change
    }
  }
})

# -------------------------------------------------------------
# Christina's Minions
# Location: Throne of Chaos
# Standard and Adept - One shield
# -------------------------------------------------------------

# All Difficulties
GameData::BossBattles.register({ # Leviathan in the Throne of Chaos
  :id   => :CHRISTINA_MINION1,
  :shieldCount => 0, # number of shields
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :pokemon => { # pokemon details (obvs)
    :species => :REUNICLUS2,
    :form => 2
  },
  :onBreakEffects => {}
})

GameData::BossBattles.register({ # Leviathan in the Throne of Chaos
  :id   => :CHRISTINA_MINION2,
  :shieldCount => 0, # number of shields
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :pokemon => { # pokemon details (obvs)
    :species => :JUMPLUFF2,
    :form => 2
  },
  :onBreakEffects => {}
})

GameData::BossBattles.register({ # Leviathan in the Throne of Chaos
  :id   => :CHRISTINA_MINION3,
  :shieldCount => 0, # number of shields
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :pokemon => { # pokemon details (obvs)
    :species => :ARCANINE,
    :form => 2
  },
  :onBreakEffects => {}
})

GameData::BossBattles.register({ # Leviathan in the Throne of Chaos
  :id   => :CHRISTINA_MINION4,
  :shieldCount => 0, # number of shields
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :pokemon => { # pokemon details (obvs)
    :species => :CENTISKORCH,
    :form => 2
  },
  :onBreakEffects => {}
})

GameData::BossBattles.register({ # Leviathan in the Throne of Chaos
  :id   => :CHRISTINA_MINION5,
  :shieldCount => 0, # number of shields
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :pokemon => { # pokemon details (obvs)
    :species => :STARMIE,
    :form => 2
  },
  :onBreakEffects => {}
})

GameData::BossBattles.register({ # Leviathan in the Throne of Chaos
  :id   => :CHRISTINA_MINION6,
  :shieldCount => 0, # number of shields
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :pokemon => { # pokemon details (obvs)
    :species => :HOOPA,
    :form => 2
  },
  :onBreakEffects => {}
})

# -------------------------------------------------------------
# Leviathan
# Location: Throne of Chaos
# -------------------------------------------------------------

# Standard Difficulty
GameData::BossBattles.register({ # Leviathan in the Throne of Chaos
  :id   => :LEVIATHAN_THRONE_STD,
  :shieldCount => 2, # number of shields
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :pokemon => { # pokemon details (obvs)
    :species => :ARCEUS,
    :form => 97,
  },
  :onBreakEffects => {
    2 => {
      :threshold => 0,
      :message => "Insolent whelp, you dare fight back?!",# effect message
      :animation => :IRONDEFENSE, # effect animations
      :bossStatChanges => { # boss stat changes
        :DEFENSE => 1,
        :SPECIAL_DEFENSE => 1,
      },
    },
    1 => {
      :threshold => 0,
      :message => "My power is infinite! Bow before a God!",
      :animation => :STRENGTHSAP, # effect animations
      :abilityChange => :CONTRARY, # ability to change to upon shieldbreaker
      :typeChange => [:FLYING,:FAIRY], # any given type changes
      :movesetUpdate => [:TEMPESTFLARE,:FLEURCANNON,:AUTUMNBLAST,:BOOMBURST], # moveset changes
      :itemChange => :WIDELENS, # item change
    },
  }
})

# Adept+ Difficulty
GameData::BossBattles.register({ # Leviathan in the Throne of Chaos
  :id   => :LEVIATHAN_THRONE,
  :shieldCount => 3, # number of shields
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :pokemon => { # pokemon details (obvs)
    :species => :ARCEUS,
    :form => 97,
  },
  :onBreakEffects => {
    3 => {
      :threshold => 0,
      :message => "Insolent whelp, you dare fight back?!",# effect message
      :animation => :IRONDEFENSE, # effect animations
      :bossStatChanges => { # boss stat changes
        :DEFENSE => 1,
        :SPECIAL_DEFENSE => 1,
      },
    },
    2 => {
      :threshold => 0,
      :message => "My power is infinite! Bow before a God!",
      :animation => :STRENGTHSAP, # effect animations
      :abilityChange => :CONTRARY, # ability to change to upon shieldbreaker
      :typeChange => [:FLYING,:FAIRY], # any given type changes
      :movesetUpdate => [:TEMPESTFLARE,:FLEURCANNON,:AUTUMNBLAST,:BOOMBURST], # moveset changes
      :itemChange => :WIDELENS, # item change
      :statusCure => true,# cure status
    },
    1 => {
      :threshold => 0,
      :message => "I am chaos incarnate! I shall scourge the In-Between of you human infestation!",
      :animation => :BLACKHOLE, # effect animations
      :abilityChange => :SHARPSHOOTER, # ability to change to upon shieldbreaker
      :typeChange => [:ELECTRIC,:GHOST], # any given type changes
      :movesetUpdate => [:SPECTRALTHIEF,:THUNDERBOLT,:BIGBANG,:BLASTFREEZE],# moveset changes
      :itemChange => :SHIELDGHOST, # item change
      :statusCure => true,# cure status
    },
  }
})

# -------------------------------------------------------------
# Leviathan's Minions
# Location: Durance of the Prime
# Standard - Immune to certain moves
# Adept+ - HP is multiplied by 2
# -------------------------------------------------------------

# -------------------------------------------------------------
# Christina's Minions
# Location: Throne of Chaos
# Standard and Adept - One shield
# -------------------------------------------------------------

# All Difficulties
GameData::BossBattles.register({ # Leviathan in the Throne of Chaos
  :id   => :LEVIATHAN_MINION1,
  :shieldCount => 0, # number of shields
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :pokemon => { # pokemon details (obvs)
    :species => :BARBARACLE,
    :form => 2
  },
  :onBreakEffects => {}
})

GameData::BossBattles.register({ # Leviathan in the Throne of Chaos
  :id   => :LEVIATHAN_MINION2,
  :shieldCount => 0, # number of shields
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :pokemon => { # pokemon details (obvs)
    :species => :WISHIWASHI,
    :form => 2
  },
  :onBreakEffects => {}
})

GameData::BossBattles.register({ # Leviathan in the Throne of Chaos
  :id   => :LEVIATHAN_MINION3,
  :shieldCount => 0, # number of shields
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :pokemon => { # pokemon details (obvs)
    :species => :HYDRAPPLE,
    :form => 2
  },
  :onBreakEffects => {}
})

GameData::BossBattles.register({ # Leviathan in the Throne of Chaos
  :id   => :LEVIATHAN_MINION4,
  :shieldCount => 0, # number of shields
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :pokemon => { # pokemon details (obvs)
    :species => :CROBAT,
    :form => 2
  },
  :onBreakEffects => {}
})

GameData::BossBattles.register({ # Leviathan in the Throne of Chaos
  :id   => :LEVIATHAN_MINION5,
  :shieldCount => 0, # number of shields
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :pokemon => { # pokemon details (obvs)
    :species => :BRELOOM,
    :form => 2
  },
  :onBreakEffects => {}
})

GameData::BossBattles.register({ # Leviathan in the Throne of Chaos
  :id   => :LEVIATHAN_MINION6,
  :shieldCount => 0, # number of shields
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :pokemon => { # pokemon details (obvs)
    :species => :BELLOSSOM,
    :form => 2
  },
  :onBreakEffects => {}
})

# -------------------------------------------------------------
# Leviathan - Possessed Cara
# Location: Durance of the Prime
# -------------------------------------------------------------

# Standard Difficulty
GameData::BossBattles.register({ # Leviathan in the Throne of Chaos
  :id   => :LEVIATHAN_CARA_STD,
  :shieldCount => 2, # number of shields
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :pokemon => { # pokemon details (obvs)
    :species => :ARCEUS,
    :form => 98,
  },
  :onBreakEffects => {
    2 => {
      :threshold => 0,
      :message => "You are trapped in here with me!",# effect message
      :animation => :IRONDEFENSE, # effect animations
      :bossStatChanges => { # boss stat changes
        :DEFENSE => 1,
        :SPECIAL_DEFENSE => 1,
      },
    },
    1 => {
      :threshold => 0,
      :message => "Chaos reigns supreme!",
      :animation => :NORETREAT, # effect animations
      :abilityChange => :REGROWTH, # ability to change to upon shieldbreaker
      :typeChange => [:GRASS,:FIGHTING], # any given type changes
      :movesetUpdate => [:ATHENASWISDOM,:PRIMORDIALBEAM,:SIGNALOVERLOAD,:MOONSTONERAY], # moveset changes
      :itemChange => :WHITEHERB, # item change
    },
  }
})

# Adept+ Difficulty
GameData::BossBattles.register({ # Leviathan in the Throne of Chaos
  :id   => :LEVIATHAN_CARA,
  :shieldCount => 3, # number of shields
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :pokemon => { # pokemon details (obvs)
    :species => :ARCEUS,
    :form => 98,
  },
  :onBreakEffects => {
    3 => {
      :threshold => 0,
      :message => "You are trapped in here with me!",# effect message
      :animation => :IRONDEFENSE, # effect animations
      :bossStatChanges => { # boss stat changes
        :DEFENSE => 1,
        :SPECIAL_DEFENSE => 1,
      },
      :statusCure => true,# cure status
    },
    2 => {
      :threshold => 0,
      :message => "Chaos reigns supreme!",
      :animation => :NORETREAT, # effect animations
      :abilityChange => :REGROWTH, # ability to change to upon shieldbreaker
      :typeChange => [:GRASS,:FIGHTING], # any given type changes
      :movesetUpdate => [:ATHENASWISDOM,:PRIMORDIALBEAM,:SIGNALOVERLOAD,:MOONSTONERAY], # moveset changes
      :itemChange => :WHITEHERB, # item change
      :statusCure => true,# cure status
    },
    1 => {
      :threshold => 0,
      :message => "You kill me, and the Time Warden dies as well!",
      :animation => :CURSE, # effect animations
      :abilityChange => :PRISMARMOR, # ability to change to upon shieldbreaker
      :typeChange => [:WATER,:GROUND], # any given type changes
      :movesetUpdate => [:WATERSPOUT,:SANDSNARE,:MANABLAST,:CHROMERAY],# moveset changes
      :itemChange => :SHIELDGRASS, # item change
      :statusCure => true,# cure status
    },
  }
})

# -------------------------------------------------------------
# Leviathan - Fused with Mindlink Prime
# Location: Durance of the Prime
# -------------------------------------------------------------

# Standard Difficulty
GameData::BossBattles.register({ # Leviathan in the Throne of Chaos
  :id   => :LEVIATHAN_PRIME_STD,
  :shieldCount => 2, # number of shields
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :pokemon => { # pokemon details (obvs)
    :species => :ARCEUS,
    :form => 99,
  },
  :onBreakEffects => {
    2 => {
      :threshold => 0,
      :message => "Such power... even in such a small fragment...",# effect message
      :animation => :IRONDEFENSE, # effect animations
      :bossStatChanges => { # boss stat changes
        :DEFENSE => 1,
        :SPECIAL_DEFENSE => 1,
      },
    },
    1 => {
      :threshold => 0,
      :message => "My mind is merged with something much greater now!",
      :animation => :LOCKON, # effect animations
      :abilityChange => :REGROWTH, # ability to change to upon shieldbreaker
      :typeChange => [:POISON,:ROCK], # any given type changes
      :movesetUpdate => [:PLAGUE,:BOULDERCRUSH,:ELECTRONCRUSH,:OBERONSWRATH], # moveset changes
      :itemChange => :ASSAULTVEST, # item change
    },
  }
})

# Adept+ Difficulty
GameData::BossBattles.register({ # Leviathan in the Throne of Chaos
  :id   => :LEVIATHAN_PRIME,
  :shieldCount => 3, # number of shields
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :pokemon => { # pokemon details (obvs)
    :species => :ARCEUS,
    :form => 99,
  },
  :onBreakEffects => {
    3 => {
      :threshold => 0,
      :message => "Such power... even in such a small fragment...",# effect message
      :animation => :IRONDEFENSE, # effect animations
      :bossStatChanges => { # boss stat changes
        :DEFENSE => 1,
        :SPECIAL_DEFENSE => 1,
      },
      :statusCure => true,# cure status
    },
    2 => {
      :threshold => 0,
      :message => "My mind is merged with something much greater now!",
      :animation => :LOCKON, # effect animations
      :abilityChange => :REGROWTH, # ability to change to upon shieldbreaker
      :typeChange => [:POISON,:ROCK], # any given type changes
      :movesetUpdate => [:PLAGUE,:BOULDERCRUSH,:ELECTRONCRUSH,:OBERONSWRATH], # moveset changes
      :itemChange => :ASSAULTVEST, # item change
      :statusCure => true,# cure status
    },
    1 => {
      :threshold => 0,
      :message => "TERMINATE. AND. CONSUME!",
      :animation => :METALSOUND, # effect animations
      :abilityChange => :ADAPTABILITY, # ability to change to upon shieldbreaker
      :typeChange => [:DRAGON,:SOUND], # any given type changes
      :movesetUpdate => [:OUTRAGE,:SONICNOVA,:FREEZESHOCK,:POSSESSION],# moveset changes
      :itemChange => :BODYARMOR, # item change
      :statusCure => true,# cure status
    },
  }
})

# -------------------------------------------------------------
# -------------------------------------------------------------
# -------------------------------------------------------------
# -------------------------------------------------------------
# -------------------------------------------------------------
# -------------------------------------------------------------
# -------------------------------------------------------------
# -------------------------------------------------------------
# -------------------------------------------------------------
# -------------------------------------------------------------
# -------------------------------------------------------------

# Battle Tower Bosses
GameData::BossBattles.register({
  :id => :BTBOSS_IGNOTUS_WIGGLYTUFF2,
  :shieldCount => 1,
  :immunities => {},
  :pokemon => {
    :species => :WIGGLYTUFF2,
    :level => 60,
    :gender => "F",
  },
  :onBreakEffects => {}
})


GameData::BossBattles.register({
  :id => :BTBOSS_PDM20_SWAMPERT,
  :shieldCount => 1,
  :immunities => {},
  :pokemon => {
    :species => :SWAMPERT,
    :level => 60,
    :gender => "M",
  },
  :onBreakEffects => {}
})


=begin
# Adept+ Difficulty
GameData::BossBattles.register({
  :id   => :TEST_BATTLE,
  :shieldCount => 2,# Number of shields
  :immunities => { # Any immunities to things
    :moves => [:DESTINYBOND,:PERISHSONG,:ENDEAVOR],#these are the moves that the boss is immune (takes no damage) to
  },
  :entryText => "MUST FEED ON AETHER!",# Dialogue upon entering battle
  :pokemon => { # pokemon details (obvs)
    :species => :GYARADOS,
    :form => 2,
  },
  :onBreakEffects => {
    2 => {
      :animation => :DRAGONDANCE, # effect animations
      :message => "I shall consume your essence to evolve!",  
      :movesetUpdate => [:SURGINGSTRIKES,:POISONJAB,:XSCISSOR,:NIGHTSLASH],# moveset changes
      :bossChangeBST => [150,400,10,10,50,10],
      :bossChangeEVs => [0,252,0,252,0,0],
      :typeChange => [:POISON,:WATER],# any given type changes
      :itemChange => :SCOPELENS,# item change
      :abilityChange => :SNIPER,# ability to change to upon shieldbreaker
    },
    1 => {
      :message => "We are infinite! Concede or be consumed!",
      :animation => :STRENGTHSAP, # effect animations
      :statDropCure => true,# cure enemy's stat drops
      :typeChange => [:BUG,:GROUND],# any given type changes
      :movesetUpdate => [:SANDFLURRY,:HIVEMIND,:AUTUMNBLAST,:BEJEWELED],# moveset changes
      :itemChange => :LIFEORB,# item change
      :abilityChange => :OWNTEMPO,# ability to change to upon shieldbreaker
    }
  }
})
=end