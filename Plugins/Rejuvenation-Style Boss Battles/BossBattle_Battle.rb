class Battle
  attr_accessor :onBreakEffects
  attr_accessor :onEntryEffects
  attr_accessor :chargeAttack
  attr_accessor :immunities
  attr_accessor :typesequence

  def pbOnBattlerEnteringBattle(battler_index, skip_event_reset = false)
    battler_index = [battler_index] if !battler_index.is_a?(Array)
    battler_index.flatten!
    
    # NOTE: This isn't done for switch commands, because they previously call
    #       pbRecallAndReplace, which could cause Neutralizing Gas to end, which
    #       in turn could cause Intimidate to trigger another Pokémon's Eject
    #       Pack. That Eject Pack should trigger at the end of this method, but
    #       this resetting would prevent that from happening, so it is skipped
    #       and instead done earlier in def pbAttackPhaseSwitch.
    if !skip_event_reset
      allBattlers.each do |b|
        b.droppedBelowHalfHP = false
        b.statsDropped = false
      end
    end
    # For each battler that entered battle, in speed order
    pbPriority(true).each do |b|
      next if !battler_index.include?(b.index) || b.fainted?
      pbRecordBattlerAsParticipated(b)
      pbMessagesOnBattlerEnteringBattle(b)
      # Position/field effects triggered by the battler appearing
      pbEffectsOnBattlerEnteringPosition(b)   # Healing Wish/Lunar Dance
      pbEntryHazards(b)
      # Battler faints if it is knocked out because of an entry hazard above
      if b.fainted?
        b.pbFaint
        pbGainExp
        pbJudge
        next
      end
      b.pbCheckForm
      # Primal Revert upon entering battle
      pbPrimalReversion(b.index)
      # Ending primordial weather, checking Trace
      b.pbContinualAbilityChecks(true)
      if b.isbossmon # trigger on entry effects
        pbShieldEffects(b,b.onEntryEffects) if b.onEntryEffects
      end
      # Abilities that trigger upon switching in
      if (!b.fainted? && b.unstoppableAbility?) || b.abilityActive?
        Battle::AbilityEffects.triggerOnSwitchIn(b.ability, b, self, true)
      end
      pbEndPrimordialWeather   # Checking this again just in case
      # Items that trigger upon switching in (Air Balloon message)
      if b.itemActive?
        Battle::ItemEffects.triggerOnSwitchIn(b.item, b, self)
      end
      # Berry check, status-curing ability check
      b.pbHeldItemTriggerCheck
      b.pbAbilityStatusCureCheck
    end
    # Check for triggering of Emergency Exit/Wimp Out/Eject Pack (only one will
    # be triggered)
    pbPriority(true).each do |b|
      break if b.pbItemOnStatDropped
      break if b.pbAbilitiesOnDamageTaken
    end
    allBattlers.each do |b|
      b.droppedBelowHalfHP = false
      b.statsDropped = false
    end
  end

  def pbStartBossWeather(user, newWeather, duration = -1, showAnim = true)
    return if @field.weather == newWeather
    @field.weather = newWeather
    # duration = (fixedDuration) ? 5 : -1
    if duration > 0 && user && user.itemActive?
      duration = Battle::ItemEffects.triggerWeatherExtender(user.item, @field.weather,
                                                            duration, user, self)
    end
    @field.weatherDuration = duration
    weather_data = GameData::BattleWeather.try_get(@field.weather)
    pbCommonAnimation(weather_data.animation) if showAnim && weather_data
    pbHideAbilitySplash(user) if user
    case @field.weather
    when :Sun         then pbDisplay(_INTL("The sunlight turned harsh!"))
    when :Rain        then pbDisplay(_INTL("It started to rain!"))
    when :Sandstorm   then pbDisplay(_INTL("A sandstorm brewed!"))
    when :Hail        then pbDisplay(_INTL("It started to hail!"))
    when :HarshSun    then pbDisplay(_INTL("The sunlight turned extremely harsh!"))
    when :HeavyRain   then pbDisplay(_INTL("A heavy rain began to fall!"))
    when :StrongWinds then pbDisplay(_INTL("Mysterious strong winds are protecting Flying-type Pokémon!"))
    when :ShadowSky   then pbDisplay(_INTL("A shadow sky appeared!"))
    end
    # Check for end of primordial weather, and weather-triggered form changes
    allBattlers.each { |b| b.pbCheckFormOnWeatherChange }
    pbEndPrimordialWeather
  end

  def pbShieldEffects(battler, onBreakdata, delay=false) # all the shield effects stuff happens here
    if battler.shieldsBroken[battler.shieldCount+1]==true && !onBreakdata[:delayedaction] &&
      return
    end
    PBDebug.log("**[Boss Mon shield Broken]**")
    if onBreakdata[:animation]
      pbAnimation(onBreakdata[:animation],battler,nil)
      PBDebug.log("onBreakdata Triggered :animation")
    end
    if onBreakdata[:message] && onBreakdata[:message] != "" #works
      PBDebug.log("onBreakdata Triggered :message")
      if onBreakdata[:message].start_with?("{1}")
        pbDisplay(_INTL(onBreakdata[:message],battler.pbThis))
      else
        pbDisplay(_INTL(onBreakdata[:message],battler.pbThis(true)))
      end
    end
    if onBreakdata[:fieldChange] && onBreakdata[:fieldChange] != @field.terrain #works
      PBDebug.log("onBreakdata Triggered :fieldChange")
      pbStartTerrain(battler, onBreakdata[:fieldChange], false)
      fieldmessage = (onBreakdata[:fieldChangeMessage] && onBreakdata[:fieldChangeMessage] != "") ? onBreakdata[:fieldChangeMessage] : "The field was changed!"
      pbDisplay(_INTL("{1}",fieldmessage))
    end
    multiturnsymbols = [:CLAMP,:FIRESPIN,:SANDTOMB,:WRAP,:MAGMASTORM,:INFESTATION,:BIND,:WHIRLPOOL]
    if onBreakdata[:bossAnim]
      pbAnimation(onBreakdata[:bossAnim][i].to_s,battler,@battlers[1])
    end
    if onBreakdata[:playerAnim]
      pbAnimation(onBreakdata[:playerAnim][i].to_s,battler,@battlers[0])
    end
    if onBreakdata[:bossEffect] # works
      PBDebug.log("onBreakdata Triggered :bossEffect")
      if onBreakdata[:bossEffect].is_a?(Array)
        for i in 0...onBreakdata[:bossEffect].length
          allSameSideBattlers(battler.index).each do |b|
            if multiturnsymbols.include?(onBreakdata[:bossEffect][i])
              b.effects[PBEffects::TrappingMove] = onBreakdata[:bossEffect][i]
              b.effects[PBEffects::Trapping] = onBreakdata[:bossEffectDuration][i] ? onBreakdata[:bossEffectDuration][i] : 5
              pbCommonAnimation(onBreakdata[:bossEffectAnimation][i].to_s,battler,nil) if onBreakdata[:bossEffectAnimation]
            else
              b.effects[PBEffects.const_get(onBreakdata[:bossEffect][i])] = onBreakdata[:bossEffectDuration] ? onBreakdata[:bossEffectDuration][i] : 5
              pbAnimation(onBreakdata[:bossEffectAnimation][i],battler,nil) if onBreakdata[:bossEffectAnimation]
            end
          end
        end
      else
        allSameSideBattlers(battler.index).each do |b|
          if multiturnsymbols.include?(onBreakdata[:bossEffect])
            b.effects[PBEffects::TrappingMove] = onBreakdata[:bossEffect]
            b.effects[PBEffects::Trapping] = onBreakdata[:bossEffectDuration] ? onBreakdata[:bossEffectDuration] : 5
            pbCommonAnimation(onBreakdata[:bossEffectAnimation].to_s,battler,nil) if onBreakdata[:bossEffectAnimation]
          else
            b.effects[PBEffects.const_get(onBreakdata[:bossEffect])] = onBreakdata[:bossEffectDuration]
            pbAnimation(onBreakdata[:bossEffectAnimation],battler,nil) if onBreakdata[:bossEffectAnimation]
          end
        end
      end
      if onBreakdata[:bossEffectMessage] # works
        if onBreakdata[:bossEffectMessage].is_a?(Array)
          if onBreakdata[:bossEffectMessage][i].start_with?("{1}")
            pbDisplay(_INTL(onBreakdata[:bossEffectMessage][i],battler.pbThis)) if onBreakdata[:bossEffectMessage][i] != ""
          else
            pbDisplay(_INTL(onBreakdata[:bossEffectMessage][i],battler.pbThis(true))) if onBreakdata[:bossEffectMessage][i] != ""
          end
        else
          if onBreakdata[:bossEffectMessage].start_with?("{1}")
            pbDisplay(_INTL(onBreakdata[:bossEffectMessage],battler.pbThis)) if onBreakdata[:bossEffectMessage] != ""
          else
            pbDisplay(_INTL(onBreakdata[:bossEffectMessage],battler.pbThis(true))) if onBreakdata[:bossEffectMessage] != ""
          end
        end
      end
    end
    if onBreakdata[:playerEffect] # works
      PBDebug.log("onBreakdata Triggered :playerEffects")
      if onBreakdata[:playerEffect].is_a?(Array)
        for i in 0...onBreakdata[:playerEffect].length
          allOtherSideBattlers(battler.index).each do |b|
            if multiturnsymbols.include?(onBreakdata[:playerEffect][i])
              b.effects[PBEffects::TrappingMove] = onBreakdata[:playerEffect][i]
              b.effects[PBEffects::Trapping] = onBreakdata[:playerEffectsduration][i] ? onBreakdata[:playerEffectsduration][i] : 5
              pbCommonAnimation(onBreakdata[:playerEffectAnimation][i].to_s,battler,nil) if onBreakdata[:playerEffectAnimation]
            else
              b.effects[PBEffects.const_get(onBreakdata[:playerEffect][i])] = onBreakdata[:playerEffectsduration][i] ? onBreakdata[:playerEffectsduration][i] : 5
              pbAnimation(onBreakdata[:playerEffectAnimation][i],battler,nil) if onBreakdata[:playerEffectAnimation]
            end
          end
        end
      else
        allOtherSideBattlers(battler.index).each do |b|
          if multiturnsymbols.include?(onBreakdata[:playerEffect])
            b.effects[PBEffects::TrappingMove] = onBreakdata[:playerEffect]
            b.effects[PBEffects::Trapping] = onBreakdata[:playerEffectsduration] ? onBreakdata[:playerEffectsduration] : 5
            pbCommonAnimation(onBreakdata[:playerEffectAnimation].to_s,battler,nil) if onBreakdata[:playerEffectAnimation]
          else
            b.effects[PBEffects.const_get(onBreakdata[:playerEffect])] = onBreakdata[:playerEffectsduration]
            pbAnimation(onBreakdata[:playerEffectAnimation],battler,nil) if onBreakdata[:playerEffectAnimation]
          end
        end
      end
      if onBreakdata[:playerEffectMessage]
        if onBreakdata[:playerEffectMessage].is_a?(Array)
          if onBreakdata[:playerEffectMessage][i].start_with?("{1}")
            pbDisplay(_INTL(onBreakdata[:playerEffectMessage][i],battler.pbThis)) if onBreakdata[:playerEffectMessage][i] != ""
          else
            pbDisplay(_INTL(onBreakdata[:playerEffectMessage][i],battler.pbThis(true))) if onBreakdata[:playerEffectMessage][i] != ""
          end
        else
          if onBreakdata[:playerEffectMessage].start_with?("{1}")
            pbDisplay(_INTL(onBreakdata[:playerEffectMessage],battler.pbThis)) if onBreakdata[:playerEffectMessage] != ""
          else
            pbDisplay(_INTL(onBreakdata[:playerEffectMessage],battler.pbThis(true))) if onBreakdata[:playerEffectMessage] != ""
          end
        end
      end
    end
    if onBreakdata[:speciesUpdate] # works
      PBDebug.log("onBreakdata Triggered :speciesUpdate")
      battler.pokemon.species = onBreakdata[:speciesUpdate]
      battler.species = onBreakdata[:speciesUpdate]
      pbAnimation(:TRANSFORM,battler,nil)
      battler.pbUpdate(true)
      @scene.pbChangePokemon(battler,battler.pokemon)
    end
    if onBreakdata[:formChange] # works
      PBDebug.log("onBreakdata Triggered :formchange")
      if MultipleForms.hasFunction?(battler.pokemon, "getForm")
        battler.pokemon.forced_form = f
      end
      battler.pokemon.form_simple = onBreakdata[:formChange]
      battler.form = onBreakdata[:formChange]
      battler.pbChangeForm(onBreakdata[:formChange], _INTL("{1}'s form changed!"))
      pbAnimation(:TRANSFORM,battler,nil)
      battler.pbUpdate(true)
      @scene.pbChangePokemon(battler,battler.pokemon)
    end
    if onBreakdata[:abilityChange] # works
      PBDebug.log("onBreakdata Triggered :abilitychange")
      battler.ability = onBreakdata[:abilityChange]
      Battle::AbilityEffects.triggerOnSwitchIn(battler.ability, battler, self, true)
    end
    if onBreakdata[:weatherChange] # works
      PBDebug.log("onBreakdata Triggered :weatherChange")
      weatherduration= onBreakdata[:weatherCount] ? onBreakdata[:weatherCount] : -1
      pbCommonAnimation(onBreakdata[:weatherChangeAnimation]) if onBreakdata[:weatherChangeAnimation]
      weathermessage = onBreakdata[:weatherChangeMessage] != "" ? onBreakdata[:weatherChangeMessage] : "The weather was changed!"
      pbDisplayBrief(_INTL("{1}",weathermessage))
      pbStartBossWeather(battler, onBreakdata[:weatherChange], weatherduration, false)
    end
    if onBreakdata[:statusCure] # works
      PBDebug.log("onBreakdata Triggered :statusCure")
      pbAnimation(:REFRESH,battler,nil)
      battler.pbCureStatus(false)
      pbDisplayBrief(_INTL("{1} recovered from its status!",battler.pbThis))
    end
    negativeEffects = [PBEffects::Curse,PBEffects::GastroAcid,PBEffects::Imprison,PBEffects::Nightmare,PBEffects::TarShot,PBEffects::SmackDown,PBEffects::Encore,PBEffects::HealBlock,PBEffects::TrappingMove,PBEffects::Trapping,PBEffects::LeechSeed,PBEffects::Attract]
    if onBreakdata[:effectClear] # works
      PBDebug.log("onBreakdata Triggered :effectClear")
      for i in negativeEffects
        if Battle::Battler::SwitchEff.include?(i)
          if battler.effects[i] != false
            battler.effects[i] = false
          end
        end
        if Battle::Battler::TurnEff.include?(i) || Battle::Battler::CountEff.include?(i)
          if battler.effects[i] != 0
            battler.effects[i] = 0
          end
        end
        if Battle::Battler::PosEff.include?(i)
          if battler.effects[i] != -1
            battler.effects[i] = -1
          end
        end
        if Battle::Battler::OtherEff.include?(i)
          if battler.effects[i] != nil
            battler.effects[i] = nil
          end
        end
      end
      pbAnimation(:HEALBELL,battler,nil)
      pbDisplay(_INTL("{1} cleared itself of negative effects!",battler.pbThis))
    end
    if onBreakdata[:statDropCure] # works
      PBDebug.log("onBreakdata Triggered :statDropCure")
      GameData::Stat.each_battle { |s| battler.stages[s.id] = 0 if battler.stages[s.id] != 0 } if battler.hasLoweredStatStages?
    end
    if onBreakdata[:resetStatStages] # works
      PBDebug.log("onBreakdata Triggered :resetStatStages")
      @battlers.each_with_index { |b| 
        GameData::Stat.each_battle { |s| b.stages[s.id] = 0 if b.stages[s.id] != 0 }
      }
      pbDisplayBrief(_INTL("{1}'s Aura eliminated all stat changes!",battler.pbThis))
    end
    if onBreakdata[:playerSideStatusChanges]# works
      PBDebug.log("onBreakdata Triggered :playerSideStatusChanges")
      canstatus = false
      allOtherSideBattlers(battler.index).each do |b|
        case onBreakdata[:playerSideStatusChanges]
          when :SLEEP
            canstatus = b.pbCanSleep?(battler,false)
          when :PARALYSIS
            canstatus = b.pbCanParalyze?(battler,false)
          when :POISON
            canstatus = b.pbCanPoison?(battler,false)
          when :TOXIC
            canstatus = b.pbCanPoison?(battler,false)
          when :FREEZE
            canstatus = b.pbCanFreeze?(battler,false)
          when :BURN
            canstatus = b.pbCanBurn?(battler,false)
          when :FROSTBITE #remove if you don't have gen9 pack installed
            canstatus = b.pbCanFrostbite?(battler,false)
          when :DROWSY #same thing as frostbite
            canstatus = b.pbCanDrowse?(battler,false)
        end
        if canstatus
          statusCount = 0
          statusCount = 1 if onBreakdata[:playerSideStatusChanges] == :TOXIC
          statusCount = 2 if onBreakdata[:playerSideStatusChanges] == :SLEEP
          status = onBreakdata[:playerSideStatusChanges] == :TOXIC ? :POISON : onBreakdata[:playerSideStatusChanges]
          b.pbInflictStatus(status, statusCount)
        end
      end
    end
    if onBreakdata[:bossSideStatusChanges]
      PBDebug.log("onBreakdata Triggered :bossSideStatusChanges")
      canstatus = false
      allSameSideBattlers(battler.index).each do |b|
        case onBreakdata[:bossSideStatusChanges]
        when :SLEEP
          canstatus = b.pbCanSleep?(battler,false)
        when :PARALYSIS
          canstatus = b.pbCanParalyze?(battler,false)
        when :POISON
          canstatus = b.pbCanPoison?(battler,false)
        when :TOXIC
          canstatus = b.pbCanPoison?(battler,false)
        when :FREEZE
          canstatus = b.pbCanFreeze?(battler,false)
        when :BURN
          canstatus = b.pbCanBurn?(battler,false)
        when :FROSTBITE #remove if you don't have gen9 pack installed
          canstatus = b.pbCanFrostbite?(battler,false)
        when :DROWSY #same thing as frostbite
          canstatus = b.pbCanDrowse?(battler,false)
      end
      if canstatus
        statusCount = 0
        statusCount = 1 if onBreakdata[:bossSideStatusChanges] == :TOXIC
        statusCount = 2 if onBreakdata[:bossSideStatusChanges] == :SLEEP
        status = onBreakdata[:bossSideStatusChanges] == :TOXIC ? :POISON : onBreakdata[:bossSideStatusChanges]
        b.pbInflictStatus(status, statusCount)
      end
      end
    end
    if onBreakdata[:playerSideChanges] # works
      PBDebug.log("onBreakdata Triggered :playerSideChanges")
      playerstatemessageplayed = false
      if onBreakdata[:playerSideChanges].is_a?(Array)
        for i in 0...onBreakdata[:playerSideChanges].length
          battler.pbOpposingSide.effects[PBEffects.const_get(onBreakdata[:playerSideChanges][i])] = onBreakdata[:playerSideChangeCount] ? onBreakdata[:playerSideChangeCount][i] : 5
          pbAnimation(onBreakdata[:playerSideChangeAnimation][i],battler,@battlers[0]) if onBreakdata[:playerSideChangeAnimation]
          if onBreakdata[:playerSideChangeMessage].is_a?(Array)
            statemessage = onBreakdata[:playerSideChangeMessage][i] != "" ? onBreakdata[:playerSideChangeMessage][i] : "The state of the battle was changed!"
          else
            statemessage = onBreakdata[:playerSideChangeMessage] != "" ? onBreakdata[:playerSideChangeMessage] : "An effect was put up on !"
            playerstatemessageplayed = true
          end
          pbDisplay(_INTL("{1}",statemessage)) if !playerstatemessageplayed
        end
      else
        battler.pbOpposingSide.effects[PBEffects.const_get(onBreakdata[:playerSideChanges])] = onBreakdata[:playerSideChangeCount] ? onBreakdata[:playerSideChangeCount] : 5
        pbAnimation(onBreakdata[:playerSideChangeAnimation],battler,@battlers[0]) if onBreakdata[:playerSideChangeAnimation]
        statemessage = onBreakdata[:playerSideChangeMessage] != "" ? onBreakdata[:playerSideChangeMessage] : "An effect was put up on !"
        pbDisplay(_INTL("{1}",statemessage))
      end
    end
    if onBreakdata[:bossSideChanges] # works
      PBDebug.log("onBreakdata Triggered :bossSideChanges")
      if onBreakdata[:bossSideChanges].is_a?(Array)
        statemessageplayed = false
        for i in 0...onBreakdata[:bossSideChanges].length
          battler.pbOwnSide.effects[PBEffects.const_get(onBreakdata[:bossSideChanges][i])] = onBreakdata[:bossSideChangeCount] ? onBreakdata[:bossSideChangeCount][i] : 5
          pbAnimation(onBreakdata[:bossSideChangeAnimation][i],battler,@battlers[1]) if onBreakdata[:bossSideChangeAnimation]
          if onBreakdata[:bossSideChangeMessage].is_a?(Array)
            statemessage = onBreakdata[:bossSideChangeMessage][i] != "" ? onBreakdata[:bossSideChangeMessage][i] : "The state of the battle was changed!"
          else
            statemessage = onBreakdata[:bossSideChangeMessage] != "" ? onBreakdata[:bossSideChangeMessage] : "An effect was put up on !"
            statemessageplayed = true
          end
          pbDisplay(_INTL("{1}",statemessage)) if !statemessageplayed
        end
      else
        battler.pbOwnSide.effects[PBEffects.const_get(onBreakdata[:bossSideChanges])] = onBreakdata[:bossSideChangeCount] ? onBreakdata[:bossSideChangeCount] : 5
        pbAnimation(onBreakdata[:bossSideChangeAnimation],battler,@battlers[1]) if onBreakdata[:bossSideChangeAnimation]
        statemessage = onBreakdata[:bossSideChangeMessage] != "" ? onBreakdata[:bossSideChangeMessage] : "An effect was put up on !"
        pbDisplay(_INTL("{1}",statemessage))
      end
    end
    if onBreakdata[:stateChanges]
      PBDebug.log("onBreakdata Triggered :stateChanges")
      if onBreakdata[:stateChanges].is_a?(Array)
        for i in 0...onBreakdata[:stateChanges].length
          if onBreakdata[:stateChanges][i] == PBEffects::TrickRoom
            @field.effects[PBEffects::TrickRoom] = onBreakdata[:stateChangeCount] ? onBreakdata[:stateChangeCount][i] : 5
          else
            @field.effects[PBEffects.const_get(onBreakdata[:stateChanges][i])]  = onBreakdata[:stateChangeCount] ? onBreakdata[:stateChangeCount][i] : 5
          end
          pbAnimation(onBreakdata[:stateChangeAnimation][i],battler,nil) if onBreakdata[:stateChangeAnimation]
          statemessage = onBreakdata[:stateChangeMessage][i] != "" ? onBreakdata[:stateChangeMessage][i] : "The state of the battle was changed!"
          pbDisplay(_INTL("{1}",statemessage))
        end
      else
        if onBreakdata[:stateChanges] == PBEffects::TrickRoom
          @field.effects[PBEffects::TrickRoom] = onBreakdata[:stateChangeCount] ? onBreakdata[:stateChangeCount] : 5
        else
          @field.effects[PBEffects.const_get(onBreakdata[:stateChanges])] = onBreakdata[:stateChangeCount] ? onBreakdata[:stateChangeCount] : 5
        end
        pbAnimation(onBreakdata[:stateChangeAnimation],battler,nil) if onBreakdata[:stateChangeAnimation]
        statemessage = onBreakdata[:stateChangeMessage] != "" ? onBreakdata[:stateChangeMessage] : "The state of the battle was changed!"
        pbDisplay(_INTL("{1}",statemessage))
      end
    end
    if battler.randomSetChanges #works
      items = battler.randomSetChanges.values
      setdetails=items[rand(items.length)]
      if setdetails[:typeChange] #works
        PBDebug.log("onBreakdata Triggered :typeChange")
        for type in 0...onBreakdata[:typeChange].length
          newType = GameData::Type.get(onBreakdata[:typeChange][type]).id
          battler.types[type] = newType
        end
      end
      if setdetails[:movesetUpdate] #works
        PBDebug.log("onBreakdata Triggered :movesetUpdate")
        setdetails[:movesetUpdate].each_with_index do |move, i|
          next unless move
          battler.pokemon.moves[i] = Pokemon::Move.new(move)
          if battler.level >=75
            battler.pokemon.moves[i].ppup=3
            battler.pokemon.moves[i].pp=battler.pokemon.moves[i].totalpp
          end
        end
        battler.moves = []
        for move in battler.pokemon.moves
          battler.moves.push(Battle::Move.from_pokemon_move(self, move)) if move
        end
        #@battleAI.setUpMovesQuick(battler.index)
    end
      if setdetails[:bossStatChanges]
        setdetails[:bossStatChanges].each_pair {|stat,statval| #works
          statval *= -1 if battler.ability == :CONTRARY
          if statval > 0 && !battler.pbCanRaiseStatStage?(stat)
            battler.pbRaiseStatStage(stat,statval,battler)
            pbDisplay(_INTL("{1}'s fracturing aura boosted its {2}!", battler.pbThis, GameData::Stat.get(stat).name))
          elsif statval < 0 && !battler.pbCanLowerStatStage?(stat)
            battler.pbLowerStatStage(stat,-statval,battler)
            pbDisplay(_INTL("{1}'s fracturing aura lowered its {2}!", battler.pbThis, GameData::Stat.get(stat).name))
          end
        }
      end
      battler.randomSetChanges.delete(battler.randomSetChanges.key(setdetails))
    else
      if onBreakdata[:typeChange] #works
        PBDebug.log("onBreakdata Triggered :movesetUpdate")
        for type in 0...onBreakdata[:typeChange].length
          newType = GameData::Type.get(onBreakdata[:typeChange][type]).id
          battler.types[type] = newType
        end
      end
      if onBreakdata[:movesetUpdate] #works
        PBDebug.log("onBreakdata Triggered :movesetUpdate")
        onBreakdata[:movesetUpdate].each_with_index do |move, i|
          next unless move
          battler.pokemon.moves[i] = Pokemon::Move.new(move)
          if battler.level >=75
            battler.pokemon.moves[i].ppup=3
            battler.pokemon.moves[i].pp=battler.pokemon.moves[i].totalpp
          end
        end
        battler.moves = []
        for move in battler.pokemon.moves
          battler.moves.push(Battle::Move.from_pokemon_move(self, move)) if move
        end
        #@battleAI.setUpMovesQuick(battler.index)
      end
    end
    if onBreakdata[:typeSequence] #works
      PBDebug.log("onBreakdata Triggered :typeSequence")
      if delay
        typeset =  onBreakdata[:typeSequence].values
        typeset[@typesequence][:typeChange].each_with_index do |type, i|
          newType = GameData::Type.get(type).id
          battler.types[i] = newType
        end
        @typesequence = (@typesequence + 1) % typeset.length
      end
    end
    if onBreakdata[:itemChange] #works
      PBDebug.log("onBreakdata Triggered :itemchange")
      battler.item = onBreakdata[:itemChange]
    end
    if onBreakdata[:bossStatChanges]
      onBreakdata[:bossStatChanges].each_pair {|stat,statval| #works
        PBDebug.log("onBreakdata Triggered :bossStatChanges")
        statval *= -1 if battler.ability == :CONTRARY
        if statval > 0 && !battler.pbCanRaiseStatStage?(stat,battler)
          battler.pbRaiseStatStageBasic(stat,statval)

          if onBreakdata[:bossStatChangeMessage]
            if onBreakdata[:bossStatChangeMessage].is_a?(Array)
              if onBreakdata[:bossStatChangeMessage][i].start_with?("{1}")
                pbDisplay(_INTL(onBreakdata[:bossStatChangeMessage][i],battler.pbThis)) if onBreakdata[:bossStatChangeMessage][i] != ""
              else
                pbDisplay(_INTL(onBreakdata[:bossStatChangeMessage][i],battler.pbThis(true))) if onBreakdata[:bossStatChangeMessage][i] != ""
              end
            else
              if onBreakdata[:bossStatChangeMessage].start_with?("{1}")
                pbDisplay(_INTL(onBreakdata[:bossStatChangeMessage],battler.pbThis)) if onBreakdata[:bossStatChangeMessage] != ""
              else
                pbDisplay(_INTL(onBreakdata[:bossStatChangeMessage],battler.pbThis(true))) if onBreakdata[:bossStatChangeMessage] != ""
              end
            end
          else
            pbDisplay(_INTL("{1}'s fracturing aura boosted its {2}!", battler.pbThis, GameData::Stat.get(stat).name))
          end
          PBDebug.log("Raising Stats")
        elsif statval < 0 && !battler.pbCanLowerStatStage?(stat)
          battler.pbLowerStatStageBasic(stat,-statval)
          if onBreakdata[:bossStatChangeMessage]
            if onBreakdata[:bossStatChangeMessage].is_a?(Array)
              if onBreakdata[:bossStatChangeMessage][i].start_with?("{1}")
                pbDisplay(_INTL(onBreakdata[:bossStatChangeMessage][i],battler.pbThis)) if onBreakdata[:bossStatChangeMessage][i] != ""
              else
                pbDisplay(_INTL(onBreakdata[:bossStatChangeMessage][i],battler.pbThis(true))) if onBreakdata[:bossStatChangeMessage][i] != ""
              end
            else
              if onBreakdata[:bossStatChangeMessage].start_with?("{1}")
                pbDisplay(_INTL(onBreakdata[:bossStatChangeMessage],battler.pbThis)) if onBreakdata[:bossStatChangeMessage] != ""
              else
                pbDisplay(_INTL(onBreakdata[:bossStatChangeMessage],battler.pbThis(true))) if onBreakdata[:bossStatChangeMessage] != ""
              end
            end
          else
            pbDisplay(_INTL("{1}'s fracturing aura lowered its {2}!", battler.pbThis, GameData::Stat.get(stat).name))
          end
          PBDebug.log("Lowering Stats")
        end
      }
    end
    if onBreakdata[:playerSideStatChanges]
      PBDebug.log("onBreakdata Triggered :playerSideStatChanges")
      onBreakdata[:playerSideStatChanges].each_pair {|stat,statval| #works
        allOtherSideBattlers(battler.index).each do |b|
          statval *= -1 if b.ability == :CONTRARY
          if statval > 0 && b.pbCanRaiseStatStage?(stat)
            b.pbRaiseStatStageBasic(stat,statval,battler)
            if onBreakdata[:playerStatChangeMessage]
              if onBreakdata[:playerStatChangeMessage].is_a?(Array)
                if onBreakdata[:playerStatChangeMessage][i].start_with?("{1}")
                  pbDisplay(_INTL(onBreakdata[:playerStatChangeMessage][i],battler.pbThis)) if onBreakdata[:playerStatChangeMessage][i] != ""
                else
                  pbDisplay(_INTL(onBreakdata[:playerStatChangeMessage][i],battler.pbThis(true))) if onBreakdata[:playerStatChangeMessage][i] != ""
                end
              else
                if onBreakdata[:playerStatChangeMessage].start_with?("{1}")
                  pbDisplay(_INTL(onBreakdata[:playerStatChangeMessage],battler.pbThis)) if onBreakdata[:playerStatChangeMessage] != ""
                else
                  pbDisplay(_INTL(onBreakdata[:playerStatChangeMessage],battler.pbThis(true))) if onBreakdata[:playerStatChangeMessage] != ""
                end
              end
            else
              pbDisplay(_INTL("{1}'s fracturing aura boosted its {2}'s [{3}]!", battler.pbThis, b.pbThis, GameData::Stat.get(stat).name))
            end
          elsif statval < 0 && b.pbCanLowerStatStage?(stat)
            b.pbLowerStatStageBasic(stat,-statval,battler)
            if onBreakdata[:playerStatChangeMessage]
              if onBreakdata[:playerStatChangeMessage].is_a?(Array)
                if onBreakdata[:playerStatChangeMessage][i].start_with?("{1}")
                  pbDisplay(_INTL(onBreakdata[:playerStatChangeMessage][i],battler.pbThis)) if onBreakdata[:playerStatChangeMessage][i] != ""
                else
                  pbDisplay(_INTL(onBreakdata[:playerStatChangeMessage][i],battler.pbThis(true))) if onBreakdata[:playerStatChangeMessage][i] != ""
                end
              else
                if onBreakdata[:playerStatChangeMessage].start_with?("{1}")
                  pbDisplay(_INTL(onBreakdata[:playerStatChangeMessage],battler.pbThis)) if onBreakdata[:playerStatChangeMessage] != ""
                else
                  pbDisplay(_INTL(onBreakdata[:playerStatChangeMessage],battler.pbThis(true))) if onBreakdata[:playerStatChangeMessage] != ""
                end
              end
            else
              pbDisplay(_INTL("{1}'s fracturing aura lowered its {2}'s [{3}]!", battler.pbThis, b.pbThis, GameData::Stat.get(stat).name))
            end
          end
        end
      } 
    end
    if onBreakdata[:bossChangeBST]
      if onBreakdata[:bossChangeEVs]
        battler.calc_boss_stats(onBreakdata[:bossChangeBST],onBreakdata[:bossChangeEVs])
        PBDebug.log("onBreakdata Triggered :bossChangeBST, :bossChangeEVs")
        pbDisplay(_INTL("The enemy's aura adjusted its BST and EVs!"))
      else
        battler.calc_boss_stats(onBreakdata[:bossChangeBST])
        PBDebug.log("onBreakdata Triggered :bossChangeBST")
        pbDisplay(_INTL("The enemy's aura adjusted its BST!"))
      end
    end
    if delay #works
      PBDebug.log("onBreakdata Triggered :repeat")
      if onBreakdata[:repeat]
        battler.bossdelaycounter = onBreakdata[:delay]
      else
        battler.bossdelaycounter = nil
        battler.bossdelayedeffect = nil
      end
    end
    if onBreakdata[:delayedaction] #works
      PBDebug.log("onBreakdata Triggered :delayedaction")
      battler.bossdelayedeffect = onBreakdata[:delayedaction]
      battler.bossdelaycounter = (onBreakdata[:delayedaction][:delay])
    end
  end

  def delayedaction # how the delayed action works
    pbPriority(true).each do |i|
      next if i.fainted?
      battler = i
      if battler.isbossmon
        next if !battler.bossdelayedeffect
        next if battler.bossdelaycounter.nil?
        battler.bossdelaycounter -=1
        if battler.bossdelaycounter == 0
          pbShieldEffects(battler,battler.bossdelayedeffect,true)
        end
      end
    end
  end

  def pbCommandPhase(delay = true)
    delayedaction if delay == true # call the delayed action effects here
    triggers = ["turnCommand", "turnCommand_" + (1 + @turnCount).to_s]
    @scene.pbDeluxeTriggers(nil, nil, triggers)
    @scene.pbBeginCommandPhase
    @battlers.each_with_index do |b, i|
      next if !b
      pbClearChoice(i) if pbCanShowCommands?(i)
    end
    2.times do |side|
      @megaEvolution[side].each_with_index do |megaEvo, i|
        @megaEvolution[side][i] = -1 if megaEvo >= 0
      end
      if PluginManager.installed?("ZUD Mechanics")
        @ultraBurst[side].each_with_index do |uBurst, i|
          @ultraBurst[side][i] = -1 if uBurst >= 0
        end
        @zMove[side].each_with_index do |zMove, i|
          @zMove[side][i] = -1 if zMove >= 0
        end
        @dynamax[side].each_with_index do |dmax, i|
          @dynamax[side][i] = -1 if dmax >= 0
        end
      end
      if PluginManager.installed?("PLA Battle Styles")
        @battleStyle[side].each_with_index do |style, i|
          @battleStyle[side][i] = -1 if style >= 0
        end
      end
      if PluginManager.installed?("Terastal Phenomenon")
        @terastallize[side].each_with_index do |tera, i|
          @terastallize[side][i] = -1 if tera >= 0
        end
      end
      if PluginManager.installed?("Pokémon Birthsigns")
        @zodiacPower[side].each_with_index do |zodiac, i|
          @zodiacPower[side][i] = -1 if zodiac >= 0
        end
      end
      if PluginManager.installed?("Focus Meter System")
        @focusMeter[side].each_with_index do |meter, i|
          @focusMeter[side][i] = -1 if meter >= 0
        end
      end
      @custom[side].each_with_index do |custom, i|
        @custom[side][i] = -1 if custom >= 0
      end
    end
    pbCommandPhaseLoop(true)
    return if @decision != 0
    pbCommandPhaseLoop(false)
  end

  def pbShieldDamage(battler, amt)
    sheilddam = false
    if battler.shieldCount > 0 && battler.onBreakEffects
      onBreakdata = battler.onBreakEffects[battler.shieldCount]
      hpthreshold = (onBreakdata && onBreakdata[:threshold]) ? onBreakdata[:threshold] : 0
      if (battler.hp - amt) <= (battler.totalhp*hpthreshold).round
        amt = (battler.hp - (battler.totalhp*hpthreshold).round)
        shielddam = true
      end
    end
    oldHP = battler.hp
    battler.hp -= amt
    PBDebug.log("[Boss HP Change] #{battler.pbThis} lost #{amt} HP (#{oldHP} -> #{battler.hp})") if amt > 0
    raise _INTL("HP less than 0") if battler.hp < 0
    raise _INTL("HP greater than total HP") if battler.hp > battler.totalhp
    if shielddam == true # trigger the on shield break effect
      if battler.statusCount > 0
        battler.effects[PBEffects::Toxic] = 1
      end
      @scene.pbHPChanged(battler, oldHP, true)
      # healamt = ((battler.totalhp*3)/4).floor - battler.hp
      # oldHP = battler.hp
      # battler.hp += healamt
      pbShieldEffects(battler,onBreakdata) if onBreakdata
      battler.shieldCount-=1 if battler.shieldCount>0
      battler.pbRecoverHP(battler.totalhp)
      @scene.pbUpdateShield(battler.shieldCount,battler.index)
    end
    return amt
  end

  def pbEORSwitch(favorDraws = false)
    return if @decision > 0 && !favorDraws
    return if @decision == 5 && favorDraws
    pbJudge
    return if @decision > 0
    # Check through each fainted battler to see if that spot can be filled.
    switched = []
    loop do
      switched.clear
      @battlers.each do |b|
        next if !b || !b.fainted?
        idxBattler = b.index
        next if !pbCanChooseNonActive?(idxBattler)
        if !pbOwnedByPlayer?(idxBattler)   # Opponent/ally is switching in
          next if b.wild?   # Wild Pokémon can't switch
          idxPartyNew = pbSwitchInBetween(idxBattler)
          opponent = pbGetOwnerFromBattlerIndex(idxBattler)
          # NOTE: The player is only offered the chance to switch their own
          #       Pokémon when an opponent replaces a fainted Pokémon in single
          #       battles. In double battles, etc. there is no such offer.
          if @internalBattle && @switchStyle && trainerBattle? && pbSideSize(0) == 1 &&
             opposes?(idxBattler) && !@battlers[0].fainted? && !switched.include?(0) &&
             pbCanChooseNonActive?(0) && @battlers[0].effects[PBEffects::Outrage] == 0
            idxPartyForName = idxPartyNew
            enemyParty = pbParty(idxBattler)
            if enemyParty[idxPartyNew].ability == :ILLUSION && !pbCheckGlobalAbility(:NEUTRALIZINGGAS)
              new_index = pbLastInTeam(idxBattler)
              idxPartyForName = new_index if new_index >= 0 && new_index != idxPartyNew
            end
            if pbDisplayConfirm(_INTL("{1} is about to send out {2}. Will you switch your Pokémon?",
                                      opponent.full_name, enemyParty[idxPartyForName].name))
              idxPlayerPartyNew = pbSwitchInBetween(0, false, true)
              if idxPlayerPartyNew >= 0
                pbMessageOnRecall(@battlers[0])
                pbRecallAndReplace(0, idxPlayerPartyNew)
                switched.push(0)
              end
            end
          end
          pbRecallAndReplace(idxBattler, idxPartyNew)
          switched.push(idxBattler)
        elsif trainerBattle? || (@sideSizes[0] != 1 && @sideSizes[1] != 1)  # Player switches in in a trainer battle
          idxPlayerPartyNew = pbGetReplacementPokemonIndex(idxBattler)   # Owner chooses
          pbRecallAndReplace(idxBattler, idxPlayerPartyNew)
          switched.push(idxBattler)
        else   # Player's Pokémon has fainted in a wild battle
          switch = false
          if pbDisplayConfirm(_INTL("Use next Pokémon?"))
            switch = true
          else
            switch = (pbRun(idxBattler, true) <= 0)
          end
          if switch
            idxPlayerPartyNew = pbGetReplacementPokemonIndex(idxBattler)   # Owner chooses
            pbRecallAndReplace(idxBattler, idxPlayerPartyNew)
            switched.push(idxBattler)
          end
        end
      end
      break if switched.length == 0
      pbOnBattlerEnteringBattle(switched)
    end
  end
end
