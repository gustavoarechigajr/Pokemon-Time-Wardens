class Battle::Battler
  attr_accessor :shieldCount
  attr_accessor :entryText
  attr_accessor :randomSetChanges
  attr_accessor :shieldsBroken
  attr_accessor :shieldsBrokenThisTurn
  attr_accessor :shieldActive
  attr_accessor :bossdelayedeffect
  attr_accessor :bossdelaycounter
  attr_accessor :isbossmon
  attr_accessor :onBreakEffects
  attr_accessor :onEntryEffects
  attr_accessor :chargeAttack
  attr_accessor :immunities

  #simple true/false vars
  SwitchEff = [PBEffects::AquaRing, PBEffects::TrappingUser, PBEffects::BeakBlast, PBEffects::BurnUp, PBEffects::Curse,
    PBEffects::DefenseCurl, PBEffects::DestinyBond, PBEffects::Electrify, PBEffects::Endure,
    PBEffects::FlashFire, PBEffects::Flinch, PBEffects::FollowMe, PBEffects::Foresight, PBEffects::GastroAcid, PBEffects::Grudge, PBEffects::HelpingHand,
    PBEffects::Imprison, PBEffects::Ingrain, PBEffects::MagicCoat, PBEffects::MeFirst, PBEffects::Minimize,
    PBEffects::MiracleEye, PBEffects::Nightmare, PBEffects::NoRetreat, PBEffects::ParentalBond, PBEffects::Powder,
    PBEffects::PowerTrick, PBEffects::Quash, PBEffects::RagePowder, PBEffects::Rage, PBEffects::Roost,
    PBEffects::Round, PBEffects::ShellTrap, PBEffects::SkyDrop, PBEffects::SmackDown, PBEffects::Snatch, PBEffects::TarShot, PBEffects::Torment, PBEffects::Transform, PBEffects::Truant]
  #turn count vars
  TurnEff = [PBEffects::Bide, PBEffects::Charge, PBEffects::Confusion, PBEffects::Disable, PBEffects::Embargo, PBEffects::Encore,
    PBEffects::FuryCutter, PBEffects::HealBlock, PBEffects::HyperBeam, PBEffects::LaserFocus, PBEffects::LockOn, PBEffects::MagnetRise,
    PBEffects::Metronome, PBEffects::TrappingUser, PBEffects::Outrage, PBEffects::PerishSongUser, PBEffects::Substitute, PBEffects::Taunt,
    PBEffects::Telekinesis, PBEffects::ThroatChop, PBEffects::Toxic, PBEffects::Uproar, PBEffects::Yawn, PBEffects::TwoTurnAttack]

  #position vars
  PosEff = [PBEffects::Attract, PBEffects::BideTarget, PBEffects::Counter, PBEffects::MirrorCoat, PBEffects::LeechSeed, PBEffects::LockOnPos, :MeanLook,
    PBEffects::MirrorCoatTarget, PBEffects::CounterTarget, PBEffects::Octolock]

  #other counter vars
  CountEff = [PBEffects::BideDamage, PBEffects::FocusEnergy, PBEffects::ProtectRate, PBEffects::Rollout, PBEffects::Stockpile, PBEffects::StockpileDef, PBEffects::StockpileSpDef]

  #weirdo shit (usually move objects)
  OtherEff = [PBEffects::ChoiceBand, PBEffects::DisableMove, PBEffects::EncoreMove, PBEffects::MagicBounce, PBEffects::Protect] #:TwoTurnAttack

  def isbossmon; return @pokemon ? @pokemon.isbossmon : false; end
  def countShield; return @shieldCount; end

  def pbInitialize(pkmn, idxParty, batonPass = false)
    pbInitPokemon(pkmn, idxParty)
    pbInitEffects(batonPass)
    pbInitBoss(pkmn) if self.isbossmon # initialize the boss
    @damageState.reset
  end

  def pbInitBoss(pkmn)
    bossid = pkmn.bossId
    boss = GameData::BossBattles.try_get(bossid)
    if boss.immunities
      @immunities = {
        :moves => boss.immunities[:moves] || [],
        :fieldEffectDamage => boss.immunities[:fieldEffectDamage] || []
      }
    end
    @onBreakEffects = boss.onBreakEffects
    @onEntryEffects = boss.onEntryEffects
    @entryText = boss.entryText || nil

    @chargeAttack = boss.chargeAttack ? boss.chargeAttack.clone : nil
    @randomSetChanges = boss.randomSetChanges ? boss.randomSetChanges.clone : nil

    @shieldCount = boss.shieldCount
    @name = boss.name unless boss.name.nil?
    @shieldsBroken = Array.new(pkmn.shieldCount, false)
    @shieldsBrokenThisTurn = 0
    @battle.typesequence = 0
    @bossdelaycounter = nil
    @bossdelayedeffect = nil
  end

  def pbReduceHP(amt, anim = true, registerDamage = true, anyAnim = true)
    amt = amt.round
    amt = @hp if amt > @hp
    amt = 1 if amt < 1 && !fainted?
    boss_cond = (self.isbossmon && ((@hp - amt) == 0) && self.shieldCount > 0 && self.index.odd?) ? true : false
    return @battle.pbShieldDamage(self,amt) if boss_cond
    oldHP = @hp
    self.hp -= amt
    PBDebug.log("[HP change] #{pbThis} lost #{amt} HP (#{oldHP}=>#{@hp})") if amt > 0
    raise _INTL("HP less than 0") if @hp < 0
    raise _INTL("HP greater than total HP") if @hp > @totalhp
    @battle.scene.pbHPChanged(self, oldHP, anim) if anyAnim && amt > 0
    if amt > 0 && registerDamage
      @droppedBelowHalfHP = true if @hp < @totalhp / 2 && @hp + amt >= @totalhp / 2
      @tookDamageThisRound = true
    end
    return amt
  end

  def bossMoveCheck(basemove,target) # this checks if a move if in the boss move immunity list
    immunitylist = target.immunities[:moves]
    for move in immunitylist
      if move == basemove
        return false
      end
    end
    return true
  end

  alias boss_pbSuccessCheckAgainstTarget pbSuccessCheckAgainstTarget
  def pbSuccessCheckAgainstTarget(move, user, target, targets)
    if target.isbossmon
      ret = bossMoveCheck(move.id, target)
      if ret == false
        @battle.pbDisplay(_INTL("The boss is immune to this move!"))
        return false
      end
    end
    ret = boss_pbSuccessCheckAgainstTarget(move, user, target, targets)
    return ret
  end

  def calc_boss_stats(bst, evs = [])
    return if !@pokemon
    @pokemon.calc_boss_stats(bst, evs)
    @attack       = @pokemon.attack
    @defense      = @pokemon.defense
    @spatk        = @pokemon.spatk
    @spdef        = @pokemon.spdef
    @speed        = @pokemon.speed
  end
end
