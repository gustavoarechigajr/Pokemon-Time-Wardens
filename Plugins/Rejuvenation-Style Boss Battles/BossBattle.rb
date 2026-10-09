# Boss Battles by Pokemon Rejuvenation, Updated by the Repudation Team for Essentials v21.1.
module GameData
  class BossBattles
    attr_accessor :id
    attr_accessor :name
    attr_accessor :entryText
    attr_accessor :immunities
    attr_accessor :shieldCount
    attr_accessor :canrun
    attr_accessor :onBreakEffects
    attr_accessor :onEntryEffects
    attr_accessor :pokemon
    attr_accessor :chargeAttack
    attr_accessor :randomSetChanges

    DATA = {}

    def initialize(data)
      data.each do |key, value|
        case key
          when :name              then @name              = value
          when :entryText         then @entryText         = value
          when :shieldCount       then @shieldCount       = value
          when :immunities        then @immunities        = value
          when :canrun            then @canrun            = value
          when :pokemon           then @pokemon           = value
          when :onBreakEffects    then @onBreakEffects    = value
          when :onEntryEffects    then @onEntryEffects    = value
          when :chargeAttack      then @chargeAttack      = value
          when :randomSetChanges  then @randomSetChanges  = value
        end
      end
      @id_boss   = data[:id]
    end

    extend ClassMethodsSymbols
    include InstanceMethods

    def self.load; end
    def self.save; end
    def get_boss_id; return @id_boss; end
  end
end

#===============================================================================
class Pokemon
  attr_accessor :isbossmon # is a boss pokemon
  attr_accessor :shieldCount # number of shields
  attr_accessor :bossId # id of the boss idk
  attr_accessor :shieldActive
  @isbossmon=false
  def enablebossmon
    @isbossmon=true
  end

  def baseStats
    this_base_stats = species_data.base_stats
    ret = {}
    GameData::Stat.each_main { |s| ret[s.id] = this_base_stats[s.id] }
    if @isbossmon && GameData::BossBattles.try_get(self.bossId).pokemon[:baseStats]
      new_base_stats = GameData::BossBattles.try_get(self.bossId).pokemon[:baseStats]
      statsArr = [:HP, :ATTACK, :DEFENSE, :SPEED, :SPECIAL_ATTACK, :SPECIAL_DEFENSE]
      statsArr.zip(new_base_stats).each { |stat, value| ret[stat] = value } #changes the base stats by assiging the new stats in the pbs format
    end
    return ret
  end

  def boss_baseStats(bst)
    ret = {}
    new_base_stats = bst
    statsArr = [:HP, :ATTACK, :DEFENSE, :SPEED, :SPECIAL_ATTACK, :SPECIAL_DEFENSE]
    statsArr.zip(new_base_stats).each { |stat, value| ret[stat] = value } #changes the base stats by assiging the new stats in the pbs format
    return ret
  end

  def calc_boss_stats(bst, ev = @ev)
    base_stats = boss_baseStats(bst)
    this_level = self.level
    this_IV    = self.calcIV
    # Format stat multipliers due to nature
    nature_mod = {}
    GameData::Stat.each_main { |s| nature_mod[s.id] = 100 }
    this_nature = self.nature_for_stats
    if this_nature
      this_nature.stat_changes.each { |change| nature_mod[change[0]] += change[1] }
    end
    mon_ev = (ev==[]) ? @ev : boss_baseStats(ev)
    # Calculate stats
    stats = {}
    GameData::Stat.each_main do |s|
      if s.id == :HP
        stats[s.id] = calcHP(base_stats[s.id], this_level, this_IV[s.id], mon_ev[s.id])
      else
        stats[s.id] = calcStat(base_stats[s.id], this_level, this_IV[s.id], mon_ev[s.id], nature_mod[s.id])
      end
    end
    hp_difference = stats[:HP] - @totalhp
    @totalhp = stats[:HP]
    self.hp = [@hp + hp_difference, 1].max if @hp > 0 || hp_difference > 0
    @attack  = stats[:ATTACK]
    @defense = stats[:DEFENSE]
    @spatk   = stats[:SPECIAL_ATTACK]
    @spdef   = stats[:SPECIAL_DEFENSE]
    @speed   = stats[:SPEED]
  end
end

class BossBattles
  def self.start(battleId, bypass = true)
    pokemon = pbLoadWildBoss(battleId,bypass)
    outcome = WildBattle.start(pokemon)
    # Return false if the player lost or drew the battle, and true if any other result
    return outcome != 2 && outcome != 5
  end

  def self.dual_start(battleId1, battleId2, bypass = true)
    team = pbLoadDualBoss(battleId1, battleId2, bypass)
    outcome = WildBattle.start(team[0],team[1])
    # Return false if the player lost or drew the battle, and true if any other result
    return outcome != 2 && outcome != 5
  end

  def self.dx_start(battleId, rules = {}, midbattle = {}, bypass = true)
    pokemon = pbLoadWildBoss(battleId,bypass)
    $game_temp.dx_rules     = rules
    $game_temp.dx_midbattle = midbattle
    rules[:rank] = nil
    rules[:outcome] = 1 if !rules[:outcome]
    if $game_temp.dx_midbattle.is_a?(Symbol) && hasConst?(EssentialsDeluxe, $game_temp.dx_midbattle)
      hash = getConst(EssentialsDeluxe, $game_temp.dx_midbattle).clone
      $game_temp.dx_midbattle = hash
    end
    outcome = WildBattle.start(pokemon, can_override: false)
    if rules[:player]
      $player.name = oldTrainer[0]
      $player.outfit = oldTrainer[1]
    end
    if rules[:party]
      $player.party = oldTrainer[2]
    end
    # Return false if the player lost or drew the battle, and true if any other result
    $game_temp.dx_clear
    return outcome != 2 && outcome != 5
  end

  def self.dual_dx_start(battleId1, battleId2, rules = {}, midbattle = {}, bypass = true)
    team = pbLoadDualBoss(battleId1, battleId2, bypass)
    $game_temp.dx_rules     = rules
    $game_temp.dx_midbattle = midbattle
    rules[:rank] = nil
    rules[:outcome] = 1 if !rules[:outcome]
    if $game_temp.dx_midbattle.is_a?(Symbol) && hasConst?(EssentialsDeluxe, $game_temp.dx_midbattle)
      hash = getConst(EssentialsDeluxe, $game_temp.dx_midbattle).clone
      $game_temp.dx_midbattle = hash
    end
    outcome = WildBattle.start(team[0], team[1], can_override: false)
    if rules[:player]
      $player.name = oldTrainer[0]
      $player.outfit = oldTrainer[1]
    end
    if rules[:party]
      $player.party = oldTrainer[2]
    end
    # Return false if the player lost or drew the battle, and true if any other result
    $game_temp.dx_clear
    return outcome != 2 && outcome != 5
  end

  def self.pbLoadWildBoss(poke, bypass) # create a pokemon object that has the boss's pokemon data
    boss = GameData::BossBattles.try_get(poke)
    bossid = poke
    poke = boss.pokemon
    species = poke[:species]
    level = poke[:level]
    form = poke[:form] || 0
    pokemon = Pokemon.new(species, level)
    bossFunction(boss,bossid,pokemon,bypass)
    pokemon.item = poke[:item]
    if poke[:moves] && poke[:moves].length > 0
      poke[:moves].each { |move| pokemon.learn_move(move) }
    else
      pokemon.reset_moves
    end
    pokemon.hp_level = poke[:hp_level]
    statsArr = [:HP, :ATTACK, :DEFENSE, :SPEED, :SPECIAL_ATTACK, :SPECIAL_DEFENSE]
    if poke[:iv]
      statsArr.zip(poke[:iv].cycle).each { |stat, value| pokemon.iv[stat] = value } # does the same thing as base stats code
    else
      GameData::Stat.each_main { |s| pokemon.iv[s.id] = 31} # fill in empty iv values
    end
    if poke[:ev]
      statsArr.zip(poke[:ev].cycle).each { |stat, value| pokemon.ev[stat] = value } # does the same thing as base stats code
    else
      GameData::Stat.each_main { |s| pokemon.ev[s.id] = 85} # fill in empty ev values
    end
    pokemon.ability = poke[:ability]
    pokemon.shiny = poke[:shiny] ? poke[:shiny] : false
    pokemon.nature = poke[:nature] ? poke[:nature] : (:HARDY) # Hardy is default nature
    if poke[:form]
      pokemon.forced_form = poke[:form] if MultipleForms.hasFunction?(species, "getForm")
      pokemon.form_simple = poke[:form]
    end
    if !nil_or_empty?(poke[:name])
      pokemon.name = poke[:name]
    end
    pokemon.happiness = poke.fetch(:happiness,70)
    pokemon.poke_ball = poke[:poke_ball] if poke[:poke_ball]
    pokemon.gender = poke[:gender]
    pokemon.calc_stats
    setBattleRule("cannotrun")
    setBattleRule("disablepokeballs")
    return pokemon
  end

  def self.pbLoadDualBoss(poke1,poke2,bypass)
    pokemon1 = pbLoadWildBoss(poke1,bypass)
    pokemon2 = pbLoadWildBoss(poke2,bypass)
    return [pokemon1,pokemon2]
  end
end

def bossFunction(boss, bossid, pokemon, bypass) # adds relevant boss stuff to the pokemon
  pokemon.enablebossmon
  pokemon.shieldCount = boss.shieldCount

  diff_mode = ""
  case $Trainer.difficulty_mode
    when 0; then diff_mode = "_STD"
    when 1; then diff_mode = "_ADT"
    when 2; then diff_mode = "_UNF"
  end
  dif_boss_id = ("#{bossid}#{diff_mode}").to_sym
  bossid = dif_boss_id if GameData::BossBattles.try_get(dif_boss_id) != nil && bypass

  pokemon.bossId = bossid
end

class Battle::AI
  def setUpMovesQuick(idxBattler)
    set_up(idxBattler)
    choices = pbGetMoveScores
    pbChooseMove(choices)
  end
end

def load_mbd_ids; mdb_ids = []; EssentialsDeluxe.constants.each { |data| mdb_ids.push(data.to_sym) }; return mdb_ids; end

MenuHandlers.add(:debug_menu, :test_deluxe_trainer_battle, {
  "name"        => _INTL("Test Deluxe Trainer Battle"),
  "parent"      => :battle_menu,
  "description" => _INTL("Start a single battle against a trainer with mid battle dialouge."),
  "effect"      => proc {
    mbdata, mbcmd, mbd = load_mbd_ids, 0, []
    for i in 0...mbdata.length; mbd.push(_INTL(":#{mbdata[i]}")); end
    mbd = pbShowCommands(nil, mbd, -1, mbcmd)
    trainerdata = pbListScreen(_INTL("SINGLE TRAINER"), TrainerBattleLister.new(0, false))
    if trainerdata
      setBattleRule("canLose")
      TrainerBattle.dx_start([trainerdata[0], trainerdata[1], trainerdata[2]], {}, mbdata[mbd])
    end
    next false
  }
})

MenuHandlers.add(:debug_menu, :test_deluxe_trainer_battle_advanced, {
  "name"        => _INTL("Test Deluxe Trainer Battle Advanced"),
  "parent"      => :battle_menu,
  "description" => _INTL("Start a battle against 1 or more trainers with mid battle dialouge."),
  "effect"      => proc {
    mbdata, mbcmd, mbd = load_mbd_ids, 0, []
    for i in 0...mbdata.length; mbd.push(_INTL(":#{mbdata[i]}")); end
    mbd = pbShowCommands(nil, mbd, -1, mbcmd)

    trainers = []
    size0 = 1
    size1 = 1
    trainerCmd = 0
    loop do
      trainerCmds = []
      trainers.each { |t| trainerCmds.push(sprintf("%s x%d", t[1].full_name, t[1].party_count)) }
      trainerCmds.push(_INTL("[Add trainer]"))
      trainerCmds.push(_INTL("[Set player side size]"))
      trainerCmds.push(_INTL("[Set opponent side size]"))
      trainerCmds.push(_INTL("[Start {1}v{2} battle]", size0, size1))
      trainerCmd = pbShowCommands(nil, trainerCmds, -1, trainerCmd)
      break if trainerCmd < 0
      if trainerCmd == trainerCmds.length - 1      # Start battle
        if trainers.length == 0
          pbMessage(_INTL("No trainers were chosen, cannot start battle."))
          next
        elsif size1 < trainers.length
          pbMessage(_INTL("Opposing side size is invalid. It should be at least {1}.", trainers.length))
          next
        elsif size1 > trainers.length && trainers[0][1].party_count == 1
          pbMessage(
            _INTL("Opposing side size cannot be {1}, as that requires the first trainer to have 2 or more Pokémon, which they don't.",
                  size1)
          )
          next
        end
        setBattleRule(sprintf("%dv%d", size0, size1))
        setBattleRule("canLose")
        battleArgs = []
        trainers.each { |t| battleArgs.push(t[1]) }
        TrainerBattle.dx_start([*battleArgs], {}, mbdata[mbd])
        break
      elsif trainerCmd == trainerCmds.length - 2   # Set opponent side size
        if trainers.length == 0 || (trainers.length == 1 && trainers[0][1].party_count == 1)
          pbMessage(_INTL("No trainers were chosen or trainer only has one Pokémon."))
          next
        end
        maxVal = 2
        maxVal = 3 if trainers.length >= 3 ||
                      (trainers.length == 2 && trainers[0][1].party_count >= 2) ||
                      trainers[0][1].party_count >= 3
        params = ChooseNumberParams.new
        params.setRange(1, maxVal)
        params.setInitialValue(size1)
        params.setCancelValue(0)
        newSize = pbMessageChooseNumber(
          _INTL("Choose the number of battlers on the opponent's side (max. {1}).", maxVal), params
        )
        size1 = newSize if newSize > 0
      elsif trainerCmd == trainerCmds.length - 3   # Set player side size
        if !pbCanDoubleBattle?
          pbMessage(_INTL("You only have one Pokémon."))
          next
        end
        maxVal = (pbCanTripleBattle?) ? 3 : 2
        params = ChooseNumberParams.new
        params.setRange(1, maxVal)
        params.setInitialValue(size0)
        params.setCancelValue(0)
        newSize = pbMessageChooseNumber(
          _INTL("Choose the number of battlers on the player's side (max. {1}).", maxVal), params
        )
        size0 = newSize if newSize > 0
      elsif trainerCmd == trainerCmds.length - 4   # Add trainer
        trainerdata = pbListScreen(_INTL("CHOOSE A TRAINER"), TrainerBattleLister.new(0, false))
        if trainerdata
          tr = pbLoadTrainer(trainerdata[0], trainerdata[1], trainerdata[2])
          trainers.push([0, tr])
        end
      else                                         # Edit a trainer
        if pbConfirmMessage(_INTL("Change this trainer?"))
          trainerdata = pbListScreen(_INTL("CHOOSE A TRAINER"),
                                     TrainerBattleLister.new(trainers[trainerCmd][0], false))
          if trainerdata
            tr = pbLoadTrainer(trainerdata[0], trainerdata[1], trainerdata[2])
            trainers[trainerCmd] = [0, tr]
          end
        elsif pbConfirmMessage(_INTL("Delete this trainer?"))
          trainers.delete_at(trainerCmd)
        end
      end
    end
    next false
  }
})

MenuHandlers.add(:debug_menu, :test_boss_battle, {
  "name"        => _INTL("Test Boss Battle"),
  "parent"      => :battle_menu,
  "description" => _INTL("Start a single battle against a Boss Pokémon."),
  "condition"   => proc { next $DEBUG && $BOSSDEV },
  "effect"      => proc {
    $INTERNAL = true
    setBattleRule("canLose")
    boss_data = []
    GameData::BossBattles.each { |data| boss_data.push(data.get_boss_id) }
    command = 0
    cmd = []
    for i in 0...boss_data.length; cmd.push(_INTL(":#{boss_data[i]}")); end
    cmd = pbShowCommands(nil, cmd, -1, command)
    case cmd
      when -1; next false
      when cmd; BossBattles.start(boss_data[cmd]); next false
    end
  }
})

MenuHandlers.add(:debug_menu, :test_dual_boss_battle, {
  "name"        => _INTL("Test Dual Boss Battle"),
  "parent"      => :battle_menu,
  "description" => _INTL("Start a double battle against a Boss Pokémon."),
  "condition"   => proc { next $DEBUG && $BOSSDEV },
  "effect"      => proc {
    $INTERNAL = true
    setBattleRule("canLose")
    boss_data = []
    GameData::BossBattles.each { |data| boss_data.push(data.get_boss_id) }
    command = 0
    cmd1 = []
    cmd2 = []
    for i in 0...boss_data.length; cmd1.push(_INTL(":#{boss_data[i]}")); end
    for i in 0...boss_data.length; cmd2.push(_INTL(":#{boss_data[i]}")); end
    cmd1 = pbShowCommands(nil, cmd1, -1, command)
    cmd2 = pbShowCommands(nil, cmd2, -1, command)
    next false if cmd1 == -1 || cmd2 == -1
    case cmd2
      when -1; next false
      when cmd2; BossBattles.dual_start(boss_data[cmd1], boss_data[cmd2], true); next false
    end
  }
})

MenuHandlers.add(:debug_menu, :test_specfic_boss_battle, {
  "name"        => _INTL("Test Specific Boss Battle"),
  "parent"      => :battle_menu,
  "description" => _INTL("Start a single battle against a Boss Pokémon."),
  "condition"   => proc { next $DEBUG && $BOSSDEV },
  "effect"      => proc {
    $INTERNAL = true
    setBattleRule("canLose")
    boss_data = []
    GameData::BossBattles.each { |data| boss_data.push(data.get_boss_id) }
    command = 0
    cmd = []
    for i in 0...boss_data.length; cmd.push(_INTL(":#{boss_data[i]}")); end
    cmd = pbShowCommands(nil, cmd, -1, command)
    case cmd
      when -1; next false
      when cmd; BossBattles.start(boss_data[cmd],false); next false
    end
  }
})

MenuHandlers.add(:debug_menu, :test_specfic_dual_boss_battle, {
  "name"        => _INTL("Test Specific Dual Boss Battle"),
  "parent"      => :battle_menu,
  "description" => _INTL("Start a double battle against 2 Boss Pokémon."),
  "condition"   => proc { next $DEBUG && $BOSSDEV },
  "effect"      => proc {
    $INTERNAL = true
    setBattleRule("canLose")
    boss_data = []
    GameData::BossBattles.each { |data| boss_data.push(data.get_boss_id) }
    command = 0
    cmd1 = []
    cmd2 = []
    for i in 0...boss_data.length; cmd1.push(_INTL(":#{boss_data[i]}")); end
    for i in 0...boss_data.length; cmd2.push(_INTL(":#{boss_data[i]}")); end
    cmd1 = pbShowCommands(nil, cmd1, -1, command)
    cmd2 = pbShowCommands(nil, cmd2, -1, command)
    next false if cmd1 == -1 || cmd2 == -1
    case cmd2
      when -1; next false
      when cmd2; BossBattles.dual_start(boss_data[cmd1], boss_data[cmd2], false); next false
    end
  }
})

MenuHandlers.add(:debug_menu, :test_deluxe_boss_battle, {
  "name"        => _INTL("Test Deluxe Boss Battle"),
  "parent"      => :battle_menu,
  "description" => _INTL("Start a single battle against a Boss Pokémon with mid battle dialouge."),
  "condition"   => proc { next $DEBUG && $BOSSDEV },
  "effect"      => proc {
    $INTERNAL = true
    setBattleRule("canLose")
    boss_data = []
    GameData::BossBattles.each { |data| boss_data.push(data.get_boss_id) }
    mbdata  = load_mbd_ids
    command = 0
    mbcmd   = 0
    cmd = []
    mbd = []
    for i in 0...boss_data.length; cmd.push(_INTL(":#{boss_data[i]}")); end
    for i in 0...mbdata.length; mbd.push(_INTL(":#{mbdata[i]}")); end
    cmd = pbShowCommands(nil, cmd, -1, command)
    mbd = pbShowCommands(nil, mbd, -1, mbcmd)
    case cmd
      when -1; next false
      when cmd; BossBattles.dx_start(boss_data[cmd], {:outcome => 73 }, mbdata[mbd], false); next false
    end
  }
})

MenuHandlers.add(:debug_menu, :test_deluxe_dual_boss_battle, {
  "name"        => _INTL("Test Deluxe Dual Boss Battle"),
  "parent"      => :battle_menu,
  "description" => _INTL("Start a double battle against 2 Boss Pokémon with mid battle dialouge."),
  "condition"   => proc { next $DEBUG && $BOSSDEV },
  "effect"      => proc {
    $INTERNAL = true
    setBattleRule("canLose")
    boss_data = []
    GameData::BossBattles.each { |data| boss_data.push(data.get_boss_id) }
    command = 0
    mbcmd   = 0
    mbdata  = load_mbd_ids
    cmd1 = []
    cmd2 = []
    for i in 0...boss_data.length; cmd1.push(_INTL(":#{boss_data[i]}")); end
    for i in 0...boss_data.length; cmd2.push(_INTL(":#{boss_data[i]}")); end
    for i in 0...mbdata.length; mbd.push(_INTL(":#{mbdata[i]}")); end
    cmd1 = pbShowCommands(nil, cmd1, -1, command)
    cmd2 = pbShowCommands(nil, cmd2, -1, command)
    mbd = pbShowCommands(nil, mbd, -1, mbcmd)
    next false if cmd1 == -1 || cmd2 == -1
    case cmd2
      when -1; next false
      when cmd2; BossBattles.dual_dx_start(boss_data[cmd1], boss_data[cmd2], {:outcome => 73 }, mbdata[mbd], false); next false
    end
  }
})
