module GameData
  class Trainer
    SCHEMA["BossID"] = [:boss,     "s"]

    # Creates a battle-ready version of a trainer's data.
    # @return [Array] all information about a trainer in a usable form
    alias bossbattle_to_trainer to_trainer
    def to_trainer
      trainer = bossbattle_to_trainer
      trainer.party.each_with_index do |pkmn, i|
        boss, boss_data = nil, nil
        pkmn_data = @pokemon[i]
        if pkmn_data[:boss] != nil
          boss_name = pkmn_data[:boss]
          # Difficulty check
          diff_mode = ""
          case $Trainer.difficulty_mode
            when 0; then diff_mode = "_STD"
            when 1; then diff_mode = "_ADT"
            when 2; then diff_mode = "_UNF"
          end
          dif_boss_id = "#{boss_name}#{diff_mode}"
          boss_name = dif_boss_id if GameData::BossBattles.try_get(dif_boss_id.to_sym) != nil
          boss_data, pkmn_data[:boss] = boss_name.to_sym, boss_name.to_sym
        end
        boss = boss_data ? GameData::BossBattles.try_get(boss_data) : nil # if pokemon has a bossid check if its a valid boss and set boss equal to it
        bossid = boss_data # keep the bossid
        pkmn_data = boss.pokemon if boss_data != nil # change the pokemon data to the boss data
        pkmn.enablebossmon if boss_data != nil
        pkmn.shieldCount = boss.shieldCount if boss_data != nil
        pkmn.bossId = bossid if boss_data != nil
        if boss_data != nil
          statsArr = [:HP, :ATTACK, :DEFENSE, :SPEED, :SPECIAL_ATTACK, :SPECIAL_DEFENSE]
          if pkmn_data[:iv]
            statsArr.zip(pkmn_data[:iv].cycle).each { |stat, value| pkmn.iv[stat] = value }
          else
            GameData::Stat.each_main { |s| pkmn.iv[s.id] = 31} # fill in empty iv values
          end
          if pkmn_data[:ev]
            statsArr.zip(pkmn_data[:ev].cycle).each { |stat, value| pkmn.ev[stat] = value }
          else
            GameData::Stat.each_main { |s| pkmn.ev[s.id] = 85} # fill in empty ev values
          end
          pkmn.name = pkmn_data[:name] if pkmn_data[:name] != nil
          pkmn.level = pkmn_data[:level] if pkmn_data[:level] != nil
          pkmn.hp_level = pkmn_data[:hp_level] if pkmn_data[:hp_level] != nil
          pkmn.form_simple = pkmn_data[:form] if pkmn_data[:form] != nil
          pkmn.item = pkmn_data[:item] if pkmn_data[:item] != nil
          if pkmn_data[:moves] != nil
            pkmn_data[:moves].each { |move| pkmn.learn_move(move) }
          end
          pkmn.ability = pkmn_data[:ability] if pkmn_data[:ability] != nil
          pkmn.nature = pkmn_data[:nature] if pkmn_data[:nature] != nil
          pkmn.happiness = pkmn_data[:happiness] if pkmn_data[:happiness] != nil
          pkmn.shiny = pkmn_data[:shiny] if pkmn_data[:shiny] != nil
        end
        pkmn.calc_stats if boss_data != nil
      end
      return trainer
    end
  end
end