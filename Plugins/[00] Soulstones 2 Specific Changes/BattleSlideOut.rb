#-------------------------------------------------------------------------------
# New sendout animation for Anomalies to slide in when sent out for
# the first time in battle. Adapted from Following Pokemon EX By:
#  Golisopod User, Help-14, zingzags, Rayd12smitty, Venom12, mej71, PurpleZaffre, 
#  Akizakura16, Thundaga, Armin (Fairies Resource Pack), Maruno
#-------------------------------------------------------------------------------
class Battle::Scene::Animation::PokeballTrainerSendOut < Battle::Scene::Animation
  def initialize(sprites, viewport, idxTrainer, battler, startBattle, idxOrder=0)
    @idxTrainer     = idxTrainer
    @battler        = battler
    @showingTrainer = startBattle
    @idxOrder       = idxOrder
    @trainer        = @battler.battle.pbGetOwnerFromBattlerIndex(@battler.index)
    @shadowVisible  = sprites["shadow_#{battler.index}"].visible
    @sprites        = sprites
    @viewport       = viewport
    @pictureEx      = []   # For all the PictureEx
    @pictureSprites = []   # For all the sprites
    @tempSprites    = []   # For sprites that exist only for this animation
    @animDone       = false
	tr_type, tr_name, tr_team = @trainer.trainer_type, @trainer.name, @trainer.party
	tr_id = @battler.battle.trainer_Ver(tr_type, tr_name, tr_team)
    slide_check = trainer_slide_check(tr_type, tr_name, tr_id)
    if slide_check
      createFollowerProcesses
    else
      createProcesses
    end
  end

  def createFollowerProcesses
    delay = 0
    delay = 5 if @showingTrainer
    batSprite = @sprites["pokemon_#{@battler.index}"]
    shaSprite = @sprites["shadow_#{@battler.index}"]
    battlerY = batSprite.y
    battler = addSprite(batSprite, PictureOrigin::BOTTOM)
    battler.setVisible(delay, true)
    battler.setZoomXY(delay, 100, 100)
    battler.setColor(delay, Color.new(0, 0, 0, 0))
    battler.setDelta(0, 240, 0)
    battler.moveDelta(delay, 12, -240, 0)
    battler.setCallback(delay + 12, [batSprite,:pbPlayIntroAnimation])
    if @shadowVisible
      shadow = addSprite(shaSprite, PictureOrigin::CENTER)
      shadow.setVisible(delay, @shadowVisible)
      shadow.setDelta(0, Graphics.width*2, 0)
      shadow.setDelta(delay, 12, Graphics.width/2, 0)
    end
  end
end

class Battle::Scene::Animation::BattlerRecall < Battle::Scene::Animation
  def createProcesses
    trainer = @battler.battle.pbGetOwnerFromBattlerIndex(@idxBattler)
	tr_type, tr_name, tr_team = trainer.trainer_type,  trainer.name, trainer.party
	tr_id = @battler.battle.trainer_Ver(tr_type, tr_name, tr_team)
    slide_check = trainer_slide_check(tr_type, tr_name, tr_id)
    batSprite = @sprites["pokemon_#{@idxBattler}"]
    shaSprite = @sprites["shadow_#{@idxBattler}"]
    if @idxBattler.odd? && slide_check
      delay = 0
      battlerY = batSprite.y
      battler = addSprite(batSprite, PictureOrigin::BOTTOM)
      battler.setVisible(delay, true)
      battler.setZoomXY(delay, 100, 100)
      battler.moveDelta(delay, 12, 240, 0)
      battler.setCallback(delay + 12, [batSprite,:pbPlayIntroAnimation])
      if shaSprite.visible
        shadow = addSprite(shaSprite, PictureOrigin::CENTER)
        shadow.setVisible(delay, @shadowVisible)
        shadow.setDelta(0, Graphics.width*2, 0)
        shadow.setDelta(delay, 12, Graphics.width/2, 0)
      end
	else
      # Calculate the Poké Ball graphic to use
      poke_ball = (batSprite.pkmn) ? batSprite.pkmn.poke_ball : nil
      # Calculate the color to turn the battler sprite
      col = getBattlerColorFromPokeBall(poke_ball)
      col.alpha = 0
      # Calculate end coordinates for battler sprite movement
      ballPos = Battle::Scene.pbBattlerPosition(@idxBattler, batSprite.sideSize)
      battlerEndX = ballPos[0]
      battlerEndY = ballPos[1]
      # Set up battler sprite
      battler = addSprite(batSprite, PictureOrigin::BOTTOM)
      battler.setVisible(0, true)
      battler.setColor(0, col)
      # Set up Poké Ball sprite
      ball = addBallSprite(battlerEndX, battlerEndY, poke_ball)
      ball.setZ(0, batSprite.z + 1)
      # Poké Ball animation
      ballOpenUp(ball, 0, poke_ball)
      delay = ball.totalDuration
      ballBurstRecall(delay, ball, battlerEndX, battlerEndY, poke_ball)
      ball.moveOpacity(10, 2, 0)
      # Battler animation
      battlerAbsorb(battler, delay, battlerEndX, battlerEndY, col)
      if shaSprite.visible
        # Set up shadow sprite
        shadow = addSprite(shaSprite, PictureOrigin::CENTER)
        # Shadow animation
        shadow.moveOpacity(0, 10, 0)
        shadow.setVisible(delay, false)
      end
    end
  end
end

def trainer_slide_check(tr_type, tr_name, tr_ver)
  case [tr_type, tr_name, tr_ver]
  # when [:TRAINED_ID, "Trainer Name", tr_ver]; slide_check = true
    when [:ANOMALY_SWALOT, "???", 0], [:CHAMBER_GUARDIAN, "Avatar", 0], [:ANOMALY_GALVANTULA, "???", 0], [:ANOMALY_ARBOK, "???", 0], [:ANOMALY_STARMIE, "???", 0], [:ANOMALY_SWOOBAT, "???", 0], [:ANOMALY_GROUP0, "???", 0], [:ANOMALY_GROUP1, "???", 0], [:ORIGIN_GIRATINA, "Giratina", 0], [:ANOMALY_GROUP2, "???", 0], [:ANOMALY_HOOPA, "???", 0], [:ANOMALY_MEGANIUM, "???", 0], [:ANOMALY_GALVANTULA, "???", 1], [:ANOMALY_GALVANTULA, "???", 2], [:ANOMALY_GALVANTULA, "???", 3], [:ANOMALY_GALVANTULA, "???", 4], [:ANOMALY_GROUP3, "???", 0], [:DESTROYER_WUGTRIO, "PROTOTYPE 037", 0], [:ANOMALY_GROUP5, "???", 0], [:ANOMALY_SWALOT2, "???", 1], [:ANOMALY_GYARADOS, "???", 0], [:ANOMALY_GROUP6, "???", 0], [:ANOMALY_MUK, "???", 0], [:ANOMALY_GRAPPLOCT, "???", 0], [:ANOMALY_VILEPLUME, "???", 0], [:ANOMALY_GALVANTULA2, "Shelob", 0], [:ABOMINATION_LEVIATHAN, "Leviathan", 0], [:ABOMINATION_LEVIATHAN, "Leviathan", 1], [:POSSESSED_TIMEWARDEN, "Cara", 0], [:MINDLINK_Prime, "Prime", 0], [:POKEGANG_FISH, "Pokemon", 0], [:POKEGANG_FISH1, "Pokemon", 0], [:POKEGANG_FISH2, "Pokemon", 0], [:POKEGANG_FISH3, "Pokemon", 0], [:POKEGANG_FISH, "Pokemon", 1], [:POKEGANG_FISH1, "Pokemon", 1], [:POKEGANG_FISH2, "Pokemon", 1], [:POKEGANG_FISH3, "Pokemon", 1], [:POKEGANG_FISH, "Pokemon", 2], [:POKEGANG_FISH1, "Pokemon", 2], [:POKEGANG_FISH2, "Pokemon", 2], [:POKEGANG_FISH3, "Pokemon", 2], [:POKEGANG_FISH, "Pokemon", 3], [:POKEGANG_FISH1, "Pokemon", 3], [:POKEGANG_FISH2, "Pokemon", 3], [:POKEGANG_FISH3, "Pokemon", 3], [:POKEGANG_URBAN, "Pokemon", 0], [:ANOMALY_MINOR0, "of Anomalies", 0], [:ANOMALY_MINOR0, "of Anomalies", 1], [:ANOMALY_MINOR0, "of Anomalies", 2], [:ANOMALY_MINOR0, "of Anomalies", 3], [:POKEGANG_FISH, "Pokemon", 4], [:POKEGANG_FISH1, "Pokemon", 4], [:POKEGANG_FISH2, "Pokemon", 4], [:POKEGANG_FISH3, "Pokemon", 4], [:POKEGANG_FISH, "Pokemon", 5], [:POKEGANG_FISH1, "Pokemon", 5], [:POKEGANG_FISH2, "Pokemon", 5], [:POKEGANG_FISH3, "Pokemon", 5], [:POKEGANG_FISH, "Pokemon", 6], [:POKEGANG_FISH1, "Pokemon", 6], [:POKEGANG_FISH2, "Pokemon", 6], [:POKEGANG_FISH3, "Pokemon", 6], [:POKEGANG_FISH, "Pokemon", 7], [:POKEGANG_FISH1, "Pokemon", 7], [:POKEGANG_FISH2, "Pokemon", 7], [:POKEGANG_FISH3, "Pokemon", 7], [:ANOMALY_MINOR1, "of Anomalies", 0], [:ANOMALY_MINOR1, "of Anomalies", 1], [:ANOMALY_MINOR1, "of Anomalies", 2], [:ANOMALY_MINOR1, "of Anomalies", 3], [:ANOMALY_MINOR2, "of Anomalies", 0], [:ANOMALY_MINOR2, "of Anomalies", 1], [:ANOMALY_MINOR2, "of Anomalies", 2], [:ANOMALY_MINOR2, "of Anomalies", 3], [:ANOMALY_MINOR2, "of Anomalies", 4], [:ANOMALY_MINOR2, "of Anomalies", 5], [:ANOMALY_MINOR2, "of Anomalies", 6], [:ANOMALY_MINOR2, "of Anomalies", 7], [:POKEGANG_FISH, "Pokemon", 8], [:POKEGANG_FISH1, "Pokemon", 8], [:POKEGANG_FISH2, "Pokemon", 8], [:POKEGANG_FISH3, "Pokemon", 8], [:POKEGANG_FISH, "Pokemon", 9], [:POKEGANG_FISH1, "Pokemon", 9], [:POKEGANG_FISH2, "Pokemon", 9], [:POKEGANG_FISH3, "Pokemon", 9], [:POKEGANG_FISH, "Pokemon", 10], [:POKEGANG_FISH1, "Pokemon", 10], [:POKEGANG_FISH2, "Pokemon", 10], [:POKEGANG_FISH3, "Pokemon", 10], [:POKEGANG_FISH, "Pokemon", 11], [:POKEGANG_FISH1, "Pokemon", 11], [:POKEGANG_FISH2, "Pokemon", 11], [:POKEGANG_FISH3, "Pokemon", 11], [:ANOMALY_MINOR3, "of Anomalies", 0], [:ANOMALY_MINOR3, "of Anomalies", 1], [:ANOMALY_MINOR3, "of Anomalies", 2], [:ANOMALY_MINOR3, "of Anomalies", 3], [:ANOMALY_MINOR3, "of Anomalies", 4], [:ANOMALY_MINOR3, "of Anomalies", 5], [:ANOMALY_MINOR3, "of Anomalies", 6], [:ANOMALY_MINOR3, "of Anomalies", 7], [:POKEGANG_FISH, "Pokemon", 12], [:POKEGANG_FISH1, "Pokemon", 12], [:POKEGANG_FISH2, "Pokemon", 12], [:POKEGANG_FISH3, "Pokemon", 12], [:POKEGANG_FISH, "Pokemon", 13], [:POKEGANG_FISH1, "Pokemon", 13], [:POKEGANG_FISH2, "Pokemon", 13], [:POKEGANG_FISH3, "Pokemon", 13], [:SENTRY1, "Sentry", 0], [:SENTRY1, "Sentry", 1], [:SENTRY1, "Sentry", 2], [:SENTRY2, "Guardian", 0], [:SENTRY2, "Guardian", 1], [:SENTRY2, "Guardian", 2], [:SENTRY1, "Sentry", 3], [:SENTRY2, "Guardian", 3], [:SENTRY1, "Sentry", 4], [:SENTRY2, "Guardian", 4], [:SENTRY1, "Sentry", 5], [:SENTRY2, "Guardian", 5], [:SENTRY1, "Sentry", 6], [:SENTRY2, "Guardian", 6], [:SENTRY1, "Sentry", 7], [:SENTRY2, "Guardian", 7], [:ANOMALY_MINOR4, "of Anomalies", 0], [:ANOMALY_MINOR4, "of Anomalies", 1], [:ANOMALY_MINOR4, "of Anomalies", 2], [:ANOMALY_MINOR4, "of Anomalies", 3], [:ANOMALY_MINOR4, "of Anomalies", 4], [:ANOMALY_MINOR4, "of Anomalies", 5], [:ANOMALY_MINOR4, "of Anomalies", 6], [:ANOMALY_MINOR4, "of Anomalies", 7], [:POKEGANG_FISH, "Pokemon", 14], [:POKEGANG_FISH1, "Pokemon", 14], [:POKEGANG_FISH2, "Pokemon", 14], [:POKEGANG_FISH3, "Pokemon", 14], [:POKEGANG_FISH, "Pokemon", 15], [:POKEGANG_FISH1, "Pokemon", 15], [:POKEGANG_FISH2, "Pokemon", 15], [:POKEGANG_FISH3, "Pokemon", 15], [:ANOMALY_MINOR5, "of Anomalies", 0], [:ANOMALY_MINOR5, "of Anomalies", 1], [:ANOMALY_MINOR5, "of Anomalies", 2], [:ANOMALY_MINOR5, "of Anomalies", 3], [:POKEGANG_FISH, "Pokemon", 16], [:POKEGANG_FISH1, "Pokemon", 16], [:POKEGANG_FISH2, "Pokemon", 16], [:POKEGANG_FISH3, "Pokemon", 16], [:POKEGANG_FISH, "Pokemon", 17], [:POKEGANG_FISH1, "Pokemon", 17], [:POKEGANG_FISH2, "Pokemon", 17], [:POKEGANG_FISH3, "Pokemon", 17], [:POKEGANG_CAVE, "Pokemon", 0], [:POKEGANG_CAVE, "Pokemon", 1], [:POKEGANG_SCAVENGER, "Pokemon", 0], [:POKEGANG_SCAVENGER1, "Pokemon", 0], [:POKEGANG_SCAVENGER2, "Pokemon", 0], [:POKEGANG_SCAVENGER3, "Pokemon", 0], [:POKEGANG_SWARM, "Pokemon", 0], [:POKEGANG_SWARM1, "Pokemon", 0], [:POKEGANG_SWARM2, "Pokemon", 0], [:POKEGANG_SWARM, "Pokemon", 1], [:POKEGANG_CAVE, "Pokemon", 2], [:POKEGANG_SWARM1, "Pokemon", 1], [:POKEGANG_SWARM2, "Pokemon", 1], [:POKEGANG_SWARM, "Pokemon", 2], [:POKEGANG_SWARM1, "Pokemon", 2], [:POKEGANG_SWARM2, "Pokemon", 2], [:POKEGANG_CAVE, "Pokemon", 3], [:POKEGANG_CAVE, "Pokemon", 4], [:POKEGANG_SWARM, "Pokemon", 3], [:POKEGANG_SWARM1, "Pokemon", 3], [:POKEGANG_SWARM2, "Pokemon", 3], [:POKEGANG_CAVE, "Pokemon", 5], [:POKEGANG_SWARM, "Pokemon", 4], [:POKEGANG_SWARM1, "Pokemon", 4], [:POKEGANG_SWARM2, "Pokemon", 4], [:POKEGANG_CAVE, "Pokemon", 6], [:POKEGANG_CAVE, "Pokemon", 7], [:POKEGANG_SWARM, "Pokemon", 5], [:POKEGANG_SWARM1, "Pokemon", 5], [:POKEGANG_SWARM2, "Pokemon", 5], [:POKEGANG_CAVE, "Pokemon", 8], [:POKEGANG_CAVE, "Pokemon", 9], [:POKEGANG_FISH, "Pokemon", 18], [:POKEGANG_FISH1, "Pokemon", 18], [:POKEGANG_FISH2, "Pokemon", 18], [:POKEGANG_FISH3, "Pokemon", 18], [:POKEGANG_FISH, "Pokemon", 19], [:POKEGANG_FISH1, "Pokemon", 19], [:POKEGANG_FISH2, "Pokemon", 19], [:POKEGANG_FISH3, "Pokemon", 19], [:POKEGANG_ROBOT, "Pokemon", 0], [:POKEGANG_ROBOT1, "Pokemon", 0], [:POKEGANG_ROBOT2, "Pokemon", 0], [:POKEGANG_ROBOT3, "Pokemon", 0], [:POKEGANG_ROBOT, "Pokemon", 1], [:POKEGANG_ROBOT1, "Pokemon", 1], [:POKEGANG_ROBOT2, "Pokemon", 1], [:POKEGANG_ROBOT3, "Pokemon", 1], [:POKEGANG_WATER, "Pokemon", 0], [:POKEGANG_WATER1, "Pokemon", 0], [:POKEGANG_WATER2, "Pokemon", 0], [:POKEGANG_FISH, "Pokemon", 20], [:POKEGANG_FISH1, "Pokemon", 20], [:POKEGANG_FISH2, "Pokemon", 20], [:POKEGANG_FISH3, "Pokemon", 20], [:POKEGANG_WATER, "Pokemon", 1], [:POKEGANG_WATER1, "Pokemon", 1], [:POKEGANG_WATER2, "Pokemon", 1], [:POKEGANG_FISH, "Pokemon", 21], [:POKEGANG_FISH1, "Pokemon", 21], [:POKEGANG_FISH2, "Pokemon", 21], [:POKEGANG_FISH3, "Pokemon", 21], [:POKEGANG_FISH, "Pokemon", 22], [:POKEGANG_FISH1, "Pokemon", 22], [:POKEGANG_FISH2, "Pokemon", 22], [:POKEGANG_FISH3, "Pokemon", 22], [:ANOMALY_MINOR6, "of Anomalies", 0], [:ANOMALY_MINOR6, "of Anomalies", 1], [:ANOMALY_MINOR6, "of Anomalies", 2], [:ANOMALY_MINOR6, "of Anomalies", 3], [:ANOMALY_MINOR0, "of Tumour Anomalies", 0], [:ANOMALY_MINOR1, "of Tumour Anomalies", 0], [:ANOMALY_MINOR2, "of Tumour Anomalies", 0], [:ANOMALY_MINOR3, "of Tumour Anomalies", 0], [:ANOMALY_MINOR4, "of Tumour Anomalies", 0], [:ANOMALY_MINOR5, "of Tumour Anomalies", 0], [:ANOMALY_MINOR6, "of Tumour Anomalies", 0], [:BETATESTER_MissNyakura, "MissNyakura", 0], [:BETATESTER_WitchyAlex, "WitchyAlex", 0], [:COMMUNITYARTIST_Attea, "Attea", 0], [:COMMUNITYARTIST_Raffs07, "Raffs07", 0], [:B9K_FINALFORM, "Breloom 9000", 0], [:B9K_FINALFORM, "Breloom 9000", 1], [:B9K_FINALFORM, "Breloom 9000", 2], [:B9K_FINALFORM, "Breloom 9000", 3]
          slide_check = true
    else; slide_check = false
  end
  return slide_check
end
