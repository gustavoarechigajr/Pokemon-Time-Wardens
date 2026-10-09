# Changed by DemICE 27-Sep-2023 Implementing the AP system.
module Settings
  MAIN_BOSSES = [:RIVAL_Artie, :ETHGUILD_Captain, :RETIRED_Wesley, :EGADMIN_Maximillion,
    :HEADMASTER_Maurizio, :TIMEWARDEN_Cara, :ANOMALY_SWALOT, :ETHGUILD_Christina, 
    :PRIESTESS_Sienna2, :INFESTEDCULTIST_F, :ANOMALY_GALVANTULA, :PRIESTS_Leo_Selene, 
    :ORIGIN_GIRATINA, :ANOMALY_HOOPA, :EGANOMALY_Christina, :EGADMIN_Claude, :AVATAR_Time,
    :AVATAR_Space, :SIMULACRUM_Ezreal, :EGANOMALY_Captain, :EGADMIN_Angelo, :PRIESTESS_Sienna,
    :TECHWIZARD_Caitlin, :ETHGUILD_Aki, :CHAD_Ronnie, :CONCLAVE_Aldric, :CONCLAVE_Grigori,
    :CONCLAVE_Thaddeus, :CONCLAVE_Elara, :ANOMALY_GROUP6, :EGANOMALY_Claude, :MAFIOSO, :EGANOMALY_Rogues, :DTRINITY_Damocles, :DTRINITY_Arachne, :DTRINITY_Prometheus, :EGANOMALY_Victor, :HOSTAGE_Artie, :HOSTAGE_Aki, :HOSTAGE_Caitlin, :HOSTAGE_Sienna, :HOSTAGE_Ezreal, :HOSTAGE_Christina, :ABOMINATION_LEVIATHAN, :POSSESSED_TIMEWARDEN, :MINDLINK_Prime
  ]
  MINI_BOSSES = [:ANOMALY_ARBOK, :ANOMALY_SWOOBAT, :ANOMALY_STARMIE, :ANOMALY_GROUP0, 
          :ANOMALY_GROUP1, :ANOMALY_GROUP2, :ANOMALY_MEGANIUM, :ANOMALY_GROUP3, :ANOMALY_GROUP4, :ANOMALY_GROUP5, :ANOMALY_GYARADOS, :ANOMALY_MUK, :ANOMALY_GRAPPLOCT, :ANOMALY_VILEPLUME, :ANOMALY_GALVANTULA2
  ]
  NOTO_BOSSES = [:NOTORIETY_Male, :NOTORIETY_Female]
end

class Trainer
  attr_accessor(:achievement_points)
  attr_accessor(:finish_points)

  alias achievement_points_initialize initialize
  def initialize(name, trainer_type)
    achievement_points_initialize(name, trainer_type) 
    resetAP
    resetScore
  end

  def aPoints(var=0)
    if @achievement_points.nil?
      resetAP
    end
    return @achievement_points[var]
  end

  def addAP(value=1)
    if @achievement_points.nil?
      resetAP
    end
    @achievement_points[0]+=value
    @achievement_points[1]+=value
  end

  def payAP(value=1); @achievement_points[0]-=value; end
  def resetAP; @achievement_points = [0,0]; end
  def resetScore; @finishing_score = [@achievement_points[1],@achievement_points[1]]; end

  def updateTotalScore(var) # 0 = Main Game  ,  1 = Post Game
    if @finishing_score.nil?
      resetScore
    end
    @finishing_score[var]=@achievement_points[1]
  end

  def totalScore(var) # 0 = Main Game  ,  1 = Post Game
    if @finishing_score.nil?
      resetScore
    end
    return @finishing_score[var]
  end
end

class Battle
  def trainer_Ver(tid, trn = "", tpd = [])
    mons = []
    for i in 0...tpd.length
      mons.push(tpd[i].species)
    end
    case mons
      when [:GALLADE, :GARBODOR, :GRAPPLOCT, :NOIVERN, :VENOMOTH, :ARCANINE];     val = 4 # Angelo Anomaly
      when [:DIALGA, :GIRATINA, :PALKIA, :ARCEUS];                                val = 5 # Angelo Gods
      when [:BARBARACLE, :WISHIWASHI, :HYDRAPPLE, :CROBAT, :BRELOOM, :BELLOSSOM]; val = 1 # Leviathan 2
      else;                                                                       val = 0
    end
    case [tid, trn]
      when [:EGADMIN_Angelo, "Angelo"], [:ABOMINATION_LEVIATHAN, "Leviathan"]; version = val # [:TRAINER_ID, "Trainer Name]
      when [:ANOMALY_SWALOT2, "???"];                                          version = 1
      else;                                                                    version = 0
    end
    return version
  end


  def pbEndOfBattle
    oldDecision = @decision
    @decision = 4 if @decision == 1 && wildBattle? && @caughtPokemon.length > 0
    case oldDecision
      ##### WIN #####
      when 1
        PBDebug.log("")
        PBDebug.log("***Player won***")
        points=0
        stylepoints=0
        partypoints=0
        pointshalved=false
        beltpoints=0
        diffpoints=0
        if trainerBattle?
          foe_version = trainer_Ver(@opponent[0].trainer_type, @opponent[0].name, @opponent[0].party)
          @scene.pbTrainerBattleSuccess
          case @opponent.length
            when 1; pbDisplayPaused(_INTL("You defeated {1}!", @opponent[0].full_name))
            when 2; pbDisplayPaused(_INTL("You defeated {1} and {2}!", @opponent[0].full_name,@opponent[1].full_name))
            when 3; pbDisplayPaused(_INTL("You defeated {1}, {2} and {3}!", @opponent[0].full_name,@opponent[1].full_name, @opponent[2].full_name))
          end
          @opponent.each_with_index do |trainer, i|
            @scene.pbShowOpponent(i)
            msg = trainer.lose_text
            msg = "..." if !msg || msg.empty?
            pbDisplayPaused(msg.gsub(/\\[Pp][Nn]/, pbPlayer.name))
          end
          # The policy here is any boss that gates progression awards AP. Side quest bosses do not reward AP UNLESS they are Anomalies (e.g. ANOMALY_ARBOK and ANOMALY_MEGANIUM).
          bosses = Settings::MAIN_BOSSES
          minibosses = Settings::MINI_BOSSES
          notobosses = Settings::NOTO_BOSSES
          # Dev Castle bosses are intentionally excluded
          isboss, isminiboss, isnotoboss = false, false, false
          case @opponent.length
            when 1
              isboss = bosses.include?(@opponent[0].trainer_type)
              isboss = false if ((@opponent[0].trainer_type == :RIVAL_Artie || @opponent[0].trainer_type == :EGADMIN_Claude) && @opponent[0].party_count < 5)
              isminiboss = (minibosses.include?(@opponent[0].trainer_type) || ((@opponent[0].trainer_type == :RIVAL_Artie || @opponent[0].trainer_type == :EGADMIN_Claude) && @opponent[0].party_count < 5))
              isnotoboss = notobosses.include?(@opponent[0].trainer_type)
            when 2
              isboss = (bosses.include?(@opponent[0].trainer_type) || bosses.include?(@opponent[1].trainer_type))
              isminiboss = (minibosses.include?(@opponent[0].trainer_type) || minibosses.include?(@opponent[1].trainer_type))
              isnotoboss = (notobosses.include?(@opponent[0].trainer_type) || notobosses.include?(@opponent[1].trainer_type))
            when 3
              isboss = (bosses.include?(@opponent[0].trainer_type) || bosses.include?(@opponent[1].trainer_type) || bosses.include?(@opponent[2].trainer_type))
              isminiboss = (minibosses.include?(@opponent[0].trainer_type) || minibosses.include?(@opponent[1].trainer_type) || minibosses.include?(@opponent[2].trainer_type))
              isnotoboss = (notobosses.include?(@opponent[0].trainer_type) || notobosses.include?(@opponent[1].trainer_type) || notobosses.include?(@opponent[2].trainer_type))
          end
          if (isboss || isminiboss) && !$game_switches[406]  # Changed 09-Oct-2023 by DemICE disable infinite AP farm
            Console.echo_h2("A boss was defeated!")
            stylepoints += 3 if isboss
            stylepoints -= 2 if $PokemonSystem.battlestyle == 0 && $Trainer.difficulty_mode==0 && @sideSizes[0]==1 && isboss
            Console.echo_h2("Battle style points: "+stylepoints.to_s) if isboss
            partypoints = ((isboss) ? 6 : (2 + @opponent[0].party_count))
            for i in $Trainer.party
              partypoints -= 1 if i.hp==0
            end
            partypoints = 0 if partypoints < 0
            Console.echo_h2("Party condition points: "+partypoints.to_s)
            if $PokemonSystem.battlestyle==0 && $Trainer.difficulty_mode==0 && @sideSizes[0]==1 && isboss
              partypoints /= 2 if partypoints > 1
              pointshalved=true
            end
            Console.echo_h2("Party condition points after factoring set/shift mode: "+partypoints.to_s) if isboss
            if ($PokemonSystem.battle_belt==0 || $Trainer.difficulty_mode>0) && !$game_switches[405]
              beltpoints += ((isboss) ? 3 : 1)
              currentbeltquantity=0
              [$Trainer.battlebelt[:med1], $Trainer.battlebelt[:med2], $Trainer.battlebelt[:combat]].each do | beltitem |
                currentbeltquantity+=1 if beltitem[1]>0
              end
              itemsused = $beltquantity - currentbeltquantity
              itemsused = 0 if itemsused < 0
              beltpoints -= itemsused
              beltpoints = 0 if beltpoints < 0
            end
            Console.echo_h2("Battle belt item usage points: "+beltpoints.to_s)
            boss_type = (isboss) ? 2 : 1
            diffpoints += boss_type*$Trainer.difficulty_mode
            Console.echo_h2("Difficulty mode points: "+diffpoints.to_s)
            points=stylepoints+partypoints+beltpoints+diffpoints
            points /= 2 if $extender_used
            if (foe_version < 4 && @opponent[0].trainer_type == :EGADMIN_Angelo) || @opponent[0].trainer_type == :HOSTAGE_Ezreal || (@opponent[0].trainer_type == :ABOMINATION_LEVIATHAN && foe_version == 1)
              $game_variables[415] = points
            elsif (foe_version == 4 && @opponent[0].trainer_type == :EGADMIN_Angelo) || [:POSSESSED_TIMEWARDEN, :HOSTAGE_Christina].include?(@opponent[0].trainer_type)
              $game_variables[415] += points
            else
              points += $game_variables[415] if $game_variables[415] > 0 && @opponent[0].trainer_type == :EGADMIN_Angelo && foe_version == 5
              points += $game_variables[415] if $game_variables[415] > 0 && @opponent[0].trainer_type == :ABOMINATION_LEVIATHAN && $game_variables[415] > 0 && foe_version == 0
              points += $game_variables[415] if $game_variables[415] > 0 && @opponent[0].trainer_type == :MINDLINK_Prime
              $Trainer.addAP(points)
            end
            Console.echo_h2("Total points earned: "+points.to_s)
          end
          if isnotoboss && !$game_switches[406] 
            $Trainer.addAP(2) 
            @scene.pbBottomRightWindow(_INTL("<b>Notorious Trainer defeated!</b>\nTotal AP earned:<r>2"))
          end
        end
        # Gain money from winning a trainer battle, and from Pay Day
        pbGainMoney if @decision != 4
        if points>0
          extendered = ""
          extendered = "\nHalved due to Room Extender use." if $extender_used
          $extender_used = false
          if stylepoints >0
            if (@opponent[0].trainer_type == :EGADMIN_Angelo && foe_version == 5) || (@opponent[0].trainer_type == :ABOMINATION_LEVIATHAN && foe_version == 0) || @opponent[0].trainer_type == :MINDLINK_Prime
              @scene.pbBottomRightWindow(_INTL("<b>A boss was defeated!</b>\nBattle style points:<r>+{1}\r\nParty condition points:<r>+{2}\r\nBattle belt item usage points:<r>+{3}\r\nDifficulty mode points:<r>+{4}\r\nPhase 1+2 points:<r>+{7}\r\n<b>Total AP earned:<r>{5}</b>{6}",stylepoints, partypoints, beltpoints,diffpoints,points,extendered,$game_variables[415]))
            elsif (@opponent[0].trainer_type == :EGADMIN_Angelo && foe_version <= 4) || [:HOSTAGE_Ezreal, :HOSTAGE_Christina].include?(@opponent[0].trainer_type) || (@opponent[0].trainer_type == :ABOMINATION_LEVIATHAN && foe_version == 1) || @opponent[0].trainer_type == :POSSESSED_TIMEWARDEN
              @scene.pbBottomRightWindow(_INTL("<b>A boss was defeated!</b>\nBattle style points:<r>+{1}\r\nParty condition points:<r>+{2}\r\nBattle belt item usage points:<r>+{3}\r\nDifficulty mode points:<r>+{4}\r\n<b>Total AP stored:<r>{5}</b>{6}",stylepoints, partypoints, beltpoints,diffpoints,points,extendered))
            else
              @scene.pbBottomRightWindow(_INTL("<b>A boss was defeated!</b>\nBattle style points:<r>+{1}\r\nParty condition points:<r>+{2}\r\nBattle belt item usage points:<r>+{3}\r\nDifficulty mode points:<r>+{4}\r\n<b>Total AP earned:<r>{5}</b>{6}",stylepoints, partypoints, beltpoints,diffpoints,points,extendered))
            end
          else
            @scene.pbBottomRightWindow(_INTL("<b>A miniboss was defeated!</b>\nParty condition points:<r>+{2}\r\nBattle belt item usage points:<r>+{3}\r\nDifficulty mode points:<r>+{4}\r\n<b>Total AP earned:<r>{5}</b>{6}",stylepoints, partypoints, beltpoints,diffpoints,points,extendered))
          end
        end
        # Hide remaining trainer
        @scene.pbShowOpponent(@opponent.length) if trainerBattle? && @caughtPokemon.length > 0
      ##### LOSE, DRAW #####
      when 2, 5
        PBDebug.log("")
        PBDebug.log("***Player lost***") if @decision == 2
        PBDebug.log("***Player drew with opponent***") if @decision == 5
        if @internalBattle
          pbDisplayPaused(_INTL("You have no more Pokémon that can fight!"))
          if trainerBattle?
            case @opponent.length
              when 1
                pbDisplayPaused(_INTL("You lost against {1}!", @opponent[0].full_name))
              when 2
                pbDisplayPaused(_INTL("You lost against {1} and {2}!",@opponent[0].full_name, @opponent[1].full_name))
              when 3
                pbDisplayPaused(_INTL("You lost against {1}, {2} and {3}!",@opponent[0].full_name, @opponent[1].full_name, @opponent[2].full_name))
            end
          end
          # Lose money from losing a battle
          pbLoseMoney
          pbDisplayPaused(_INTL("You blacked out!")) if !@canLose
        elsif @decision == 2   # Lost in a Battle Frontier battle
          if @opponent
            @opponent.each_with_index do |trainer, i|
              @scene.pbShowOpponent(i)
              msg = trainer.win_text
              msg = "..." if !msg || msg.empty?
              pbDisplayPaused(msg.gsub(/\\[Pp][Nn]/, pbPlayer.name))
            end
          end
        end
      ##### CAUGHT WILD POKÉMON #####
      when 4
        @scene.pbWildBattleSuccess if !Settings::GAIN_EXP_FOR_CAPTURE
    end
    pbRecordAndStoreCaughtPokemon # Register captured Pokémon in the Pokédex, and store them
    pbGainMoney if @decision == 4 # Collect Pay Day money in a wild battle that ended in a capture
    if @internalBattle # Pass on Pokérus within the party
      infected = []
      $player.party.each_with_index do |pkmn, i|
        infected.push(i) if pkmn.pokerusStage == 1
      end
      infected.each do |idxParty|
        strain = $player.party[idxParty].pokerusStrain
        if idxParty > 0 && $player.party[idxParty - 1].pokerusStage == 0 && rand(3) == 0   # 33%
          $player.party[idxParty - 1].givePokerus(strain)
        end
        if idxParty < $player.party.length - 1 && $player.party[idxParty + 1].pokerusStage == 0 && rand(3) == 0   # 33%
          $player.party[idxParty + 1].givePokerus(strain)
        end
      end
    end
    # Clean up battle stuff
    @scene.pbEndBattle(@decision)
    @battlers.each do |b|
      next if !b
      pbCancelChoice(b.index)   # Restore unused items to Bag
      Battle::AbilityEffects.triggerOnSwitchOut(b.ability, b, true) if b.abilityActive?
    end
    pbParty(0).each_with_index do |pkmn, i|
      next if !pkmn
      @peer.pbOnLeavingBattle(self, pkmn, @usedInBattle[0][i], true)   # Reset form
      pkmn.item = @initialItems[0][i]
    end
    $RevealedAbility = {1 => [{:pkmn=>nil, :abil=>nil}, {:pkmn=>nil, :abil=>nil}], 3 => [{:pkmn=>nil, :abil=>nil}, {:pkmn=>nil, :abil=>nil}], 5 => [{:pkmn=>nil, :abil=>nil}, {:pkmn=>nil, :abil=>nil}]}
    return @decision
  end

  alias ap_pbEORCountDownFieldEffect pbEORCountDownFieldEffect
  def pbEORCountDownFieldEffect(effect, msg)
    $extender_used = false if !$extender_used
    if effect == PBEffects::TrickRoom && @field.effects[effect] > 5 && !$extender_used
      $extender_used = true 
    end
    ap_pbEORCountDownFieldEffect(effect, msg)
  end
end

def pbBottomRightWindow(text, scene = nil)
  window = Window_AdvancedTextPokemon.new(text)
  window.width = 400
  window.x     = 0#Graphics.width - window.width
  window.y     = 0
  window.z     = 99999
  pbPlayDecisionSE
  loop do
    Graphics.update
    Input.update
    window.update
    scene&.pbUpdate
    break if Input.trigger?(Input::USE)
  end
  window.dispose
end
