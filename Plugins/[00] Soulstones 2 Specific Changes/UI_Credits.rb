#==============================================================================
# * Scene_Credits
#------------------------------------------------------------------------------
# Scrolls the credits you make below. Original Author unknown.
#
## Edited by MiDas Mike so it doesn't play over the Title, but runs by calling
# the following:
#    $scene = Scene_Credits.new
#
## New Edit 3/6/2007 11:14 PM by AvatarMonkeyKirby.
# Ok, what I've done is changed the part of the script that was supposed to make
# the credits automatically end so that way they actually end! Yes, they will
# actually end when the credits are finished! So, that will make the people you
# should give credit to now is: Unknown, MiDas Mike, and AvatarMonkeyKirby.
#                                             -sincerly yours,
#                                               Your Beloved
# Oh yea, and I also added a line of code that fades out the BGM so it fades
# sooner and smoother.
#
## New Edit 24/1/2012 by Maruno.
# Added the ability to split a line into two halves with <s>, with each half
# aligned towards the centre. Please also credit me if used.
#
## New Edit 22/2/2012 by Maruno.
# Credits now scroll properly when played with a zoom factor of 0.5. Music can
# now be defined. Credits can't be skipped during their first play.
#
## New Edit 25/3/2020 by Maruno.
# Scroll speed is now independent of frame rate. Now supports non-integer values
# for SCROLL_SPEED.
#
## New Edit 21/8/2020 by Marin.
# Now automatically inserts the credits from the plugins that have been
# registered through the PluginManager module.
#==============================================================================
class Scene_Credits
  # Backgrounds to show in credits. Found in Graphics/Titles/ folder
  BACKGROUNDS_LIST       = ["credits1", "credits2", "credits3", "credits4", "credits5"]
  BGM                    = "Ysera Returns to Elune"
  SCROLL_SPEED           = 80   # Pixels per second # Changed by Jos 2023-08-14 to make it go faster
  SECONDS_PER_BACKGROUND = 11
  TEXT_OUTLINE_COLOR     = Color.new(0, 0, 128, 255)
  TEXT_BASE_COLOR        = Color.new(255, 255, 255, 255)
  TEXT_SHADOW_COLOR      = Color.new(0, 0, 0, 100)

  # This next piece of code is the credits.
  # Start Editing
  CREDIT = <<_END_

Thank you for playing Pokemon Time Wardens!

Lead Developer:
Jos_Louis

Artists:
Badman
Endless
Hexx_Vixtar
Riptidecord

Scripting:
DemICE
PDM20

Former Developers: 
Angel
Cygnus
Nuems

#-----------------------------------
THIRD PARTY SCRIPTS
#-----------------------------------

v20.1 Generation 8 Pack for Essentials v20.1 v1.0.3
https://eeveeexpo.com/resources/952/

Battler Sprites:
Gen 1-5 Pokemon Sprites - veekun
Gen 6 Pokemon Sprites - All Contributors To Smogon X/Y Sprite Project
Gen 7 Pokemon Sprites - All Contributors To Smogon Sun/Moon Sprite Project
Gen 8 Pokemon Sprites - All Contributors To Smogon Sword/Shield Sprite Project
Overworld Sprites
Gen 6+ Berry Tree Overworlds - Anarlaurendil
Gen 6 Pokemon Overworlds - princess-pheonix, LunarDusk, Wolfang62, TintjeMadelintje101, piphybuilder88
Gen 7 Pokemon Overworlds - Larry Turbo, princess-pheonix
Gen 8 Pokemon Overworlds - SageDeoxys, Wolfang62, LarryTurbo, tammyclaydon
Gen 1-5 Pokemon Overworlds - MissingLukey, help-14, Kymoyonian, cSc-A7X, 2and2makes5, Pokegirl4ever, Fernandojl, 
Silver-Skies, TyranitarDark, Getsuei-H, Kid1513, Milomilotic11, Kyt666, kdiamo11, Chocosrawlooid, Syledude, Gallanty, 
Gizamimi-Pichu, 2and2makes5, Zyon17,LarryTurbo, spritesstealer, LarryTurbo
Icon Sprites
Gen 1-6 Pokemon Icon Sprites - Alaguesia
Gen 7 Pokemon Icon Sprites - Marin, MapleBranchWing, Contributors to the DS Styled Gen 7+ Repository
Gen 8 Icon Sprites - Larry Turbo, Leparagon
Cry Credits:
Gen 1-6 Pokemon Cries - Rhyden
Gen 7 Pokemon Cries - Marin, Rhyden
Gen 8 Pokemon Cries - Zeak6464
Script Credits:
Golisopod User, Luka S.J.
Compilation of Resources:
Golisopod User, UberDunsparce


{INSERTS_PLUGIN_CREDITS_DO_NOT_REMOVE}


Tech's Oddities 2023-05-17
https://eeveeexpo.com/resources/1281/
TechSkylander1518


Generation 9 Resource Pack
https://eeveeexpo.com/resources/1101/

Script Gen 9 and Adapting PLA for v20:
-Caruban

PBS for Gen 9:
-Caruban
-PorousMist (Updated the abilities, items, and moves description)
-DJChaos (TM Items)

Pokemon Gen 9 Battler Sprites:
The-King-Of-Roads-X, Mak, leParagon, Caruban, Azria, Mashirosakura, Katten, jinxed, OldSoulja, 
Abnayami, Skyflyer, Divaruta 666, Sopita_Yorita, Clara, JordanosArt, AshnixsLaw

Battler Sprites QC:
leParagon

Pokemon Gen 9 icons:
ezerart

Pokemon Gen 9 Followers:
Azria, DarkusShadow 

Pokemon PLA and Gen 9 Footprints :
Caruban

Pokemon Gen 9 Cries:
Edited from Lightblade Absol Gen 9 Cries compilation video
https://www.youtube.com/watch?v=KV6k3G62oT0
Edited from HeroLinik Pokemon Scarlet and Violet - Walking Wake and Iron Leaves Cries video
https://www.youtube.com/watch?v=weH2W3mQ35Y

Gen 9 item icons:
-lichenprincess (Tera Orb, Bamboos, Tera Shards, Mirror Herb, Loaded Dice, Leader Crest, and Kubfu Scrolls, Booster Energy, 
Gimmighoul coin, TM Material, Kofu's Wallet, Sandwich, Herba Mysticas)
-Caruban (Punching Glove, Auspicious Armor, Malicious Armor, Ability Shield, Clear Amulet, Covert Cloak, Scarlet&Violet Book)

Original Pokémon: Legends Arceus Expansion Script :
-StCooler (Original script for Gen 8 Project in v18 and Status sprites)
-PorousMist and curryofthepast (Adapting the script for v19.1 use)

PLA item icons :
-AztecCroc, 3DJackArt, Caruban, lichenprincess

Pokemon cries ripped:
-Morningdew

Pokeballs battle animation and summary icon:
-Caruban
-WolfPP (Beast ball battle animation)

PLA Pokémon icons:
-LuigiTKO

Follower
-Boonzeet
-DarkusShadow
-princess-phoenix
-Ezeart
-WolfPP

PLA Sprites from Smogon Gen8 Sprite Project :
(https://www.smogon.com/forums/threads/smogon-sprite-project.3647722/)
-Blaquaza, KingOfThe-X-Roads, KattenK, Travis, G.E.Z., SpheX, Hematite, SelenaArmorclaw


Vanilla Style Version
Pokémon sprites:
KingOfThe-X-Roads, Mak, Red7246, Vent, Caruban, leParagon, Sopita_Yorita, Z-nogyroP, 
Alxndre~◇, Mashirosakura, NanaelJustice, KRLW890
Blaquaza, KattenK, Travis, G.E.Z., SpheX, Hematite

Gen 9 Icons:
Vent, Katten, leParagon, Cesare_CBass, Alxndre~◇

PLA Icons:
LuigiTKO, Pikafan2000, Cesare_CBass, Vent, Cesare_Cbass, MultiDiegoDani, leParagon, JWNutz
and thanks for 
Pokémon Icons Act 2.9 - Teracristalizando
(https://whackahack.com/foro/threads/pokemon-icons-act-2-9-teracristalizando-07-08-2022.63896/)

Full Sprites Credit List:
https://docs.google.com/spreadsheets/d/1T-KC-4XDOeFKq0Z6tfN6Sz4JIlpaK7B8A0lbmBg9fNY/edit?usp=sharing

#-----------------------------------
ART
#-----------------------------------

VARIOUS ART RESOURCES NOT LIMITED TO 
- BATTLE BACKGROUNDS 
- OVERWORLD SPRITES
- TRAINER SPRITES
- FAKEMON / REGIONAL VARIANTS
- TILES AND AUTOTILES

#-----------------------------------
Resource: Character Customization Resources (Gen 4) 1.0
https://eeveeexpo.com/resources/317/

Contributor: Coffee Cup/ Poltergeist

#-----------------------------------

ALL Official Gen 4 Overworld Sprites v1.5
https://eeveeexpo.com/resources/404/

Contributors:
Neo-Spriteman
VanillaSunshine
PurpleZaffre & Maicerochico
AtomicReactor

#-----------------------------------

ULTIMATE Gen 4 Overworlds Pack 2021-03-29
https://eeveeexpo.com/resources/609/

PurpleZaffre

#-----------------------------------

Type icons mod and types in battle UI
Trapstarr

#-----------------------------------

Gen 5 Characters in Gen 4 OW style 2.0
https://eeveeexpo.com/resources/370/
DiegoWT

#-----------------------------------

POKEMON SPRITES FAKEMON / REGIONAL VARIANTS:
- Fakemon Festival Pack
https://eeveeexpo.com/resources/654/

Altaira
Atsui
Dulcet
Lumio
Magiscarf
Odisea
PansyGum
PrincessPhoenix
Scotsman
Mechamudskipper
JWNutz
Mechanicalape464
AnonAlpaca
Leparagon & PurpleZaffre for administration
Nuclear Omega & PurpleZaffre for administration
AceTrainerAvery
Thundaga, Voltseon, TristantineTheGreat, Kristiano100

#----------------------------------------------------------------------------------------------------------------------

Ivy Colosseum tileset
Main contributors:
• Amras Anárion (myself) (CC BY-SA) Interior architecture, black tiles, ivy, arena's coat or arms, crystal lamps, 
wooden table, stone counter, almost all furniture, all parchments, dishes and food, statues of Celebi and Arkainu, 
carnyxes and arena area layout on the ground.

• Dracoyan (CC BY-SA) Exterior bulding, statues of dragon, texture of the floor pavement, starting 
point for the convex exteriors walls and exterior square pillars

Minor contributions:

• Chimcharsfireworkd (CC-BY) (Sparse paving for floor, floor flowers)
• Magiscarf (CC-BY-NC-SA) (barrel, floor grass texture, large paving stones for the floor)

• Thunungu (CC BY-SA) (the two green plant in pot, the two small plant in pot, dark wooden bucket, large candlestick)

• Redshrike (CC-BY) (Fine candlestick, wall flag and the two very colorful big plant in a pot)
• aveontrainer (CC-BY) (deer head)

https://www.deviantart.com/anarlaurendil/art/Ivy-Colosseum-tileset-Celebi-arena-1135970503


#----------------------------------------------------------------------------------------------------------------------

Medieval Tileset
• Amras Anárion (myself) (CC BY-SA) Since almost nothing existed in the 16x16 medieval-fantasy theme, I had to create most of the tiles.
• Thunungu (CC BY-SA) (pale brown table and chair and its stone version, pale brown barrel, soil texture to the floor, 
wood floor, large candlestick, rustic shelf, green plant, green and red carpet with yellow edges and champion cup)
• aveontrainer (CC-BY) (Gray stone fireplace, Front of stone fireplace, deer head, horizontal staircase barrier, 
chairs in dark red velvet, dark wood furniture)
• Inkaline (CC BY-NC) (wooden chairs, beds, chairs in light red velvet, some candles)
• Redshrike (CC-BY) (little candlestick, 3 carpets, closed books and the two very colorful plant in a pot.)
• Dracoyan (CC-BY) (sawmill rail and grinding wheel)
• Magiscarf (CC BY-NC-SA) (light wood logs)
https://www.deviantart.com/anarlaurendil/art/Medieval-Pokemon-tileset-Alienor-interiors-v1-901041147

#----------------------------------------------------------------------------------------------------------------------

Nocturn's MegaPack
https://eeveeexpo.com/resources/655/

Champions:
Backgrounds/Foregrounds: Mechamudskipper
Pokegear icon & Egg Hatcher Icon: NocTurn

Mite, Quartet, and NightingaleNoctowl battle sprites: Mechamudskipper
All other trainer sprite edits: NocTurn
UI based off of Aki's resource with edits from NocTurn

Charlene OW: PurpleZaffre
Clive Animation: Monika~
Hiker Base: Kyledove
All other OWs: NocTurn

Nexus:
Trainer designs:
Tatiana: Apollo
Snickerblizz: Bea
LogicalLoony: Cole
AnthiXD: Camelia, Karen, Lacey, Mona + Wade, Moonflower, Vedalia

Trainer Classes:
Oskidoodle: Breeder, Fisherman
AnthiXD: Bug Catcher M + F, Conservationist M + F, Lass, Lumberjack, Nomads, Nurse Carol, Scientists, Youngster
Bungod: Hiker

Code:
NoahConstrictor: All code

Music:
Key: Route 2
Jobless Music: Greenmire, Trainer_Victory, VS_Dangerous_Pokemon
HunteR: Intro

Sprites:
Spring: Fisherman & Cole OW
NocTurn: All other OWs
Spring: All item icons
MechaMudskipper: Breeder, BugCatcherF, Conservationist F + M, Fisherman, Nomad M, Lumberjack
JaneJewel: Cole, Lacey, Wade
AnthiXD: GreenThumb, ScientistF
Zaffre: Lenora based used for Lass OW

#-----------------------------------

# Gen 4 OW Collection
# Compiled & Created by Vanilla Sunshine
# With help from Neo-Spriteman,               
# Purple Zaffre, Maicerochico, and Atomic Reactor
# Intended for use with Mr. Gela's Trainer Sprites and PBS.
# https://eeveeexpo.com/resources/391

#-----------------------------------

TILESETS AND AUTOTILES:

Ready to use Tilesets:
https://eeveeexpo.com/resources/15/

- Akizakura16
- LotusKing
- Kaliser
- JesusCarrasco
- WilsonScarloxy
- SailorVicious
- Magiscarf
- Kyle Dove

#-----------------------------------
OTHER MISC TILES AND BATTLE BACKGROUNDS FROM DEVIANTART:

- ChaoticCherryCake
- Carchagui
- Aveontrainer
- Phyromatical

#-----------------------------------

MUSIC:

- GlitchxCity
- EchanTheMan
- Yeth_half
- Emdasche formerly known as ElectricMudkip
- Pokemon Reborn Team
- Pokemon Rejuvenation Team
- Tekken 8
- World of Warcraft, Diablo and Starcraft by Blizzard Entertainment
- Clair Obscur: Expedition 33; Lorien Testard and Alice Dupont-Percier
- Monster Hunter Wilds

#-----------------------------------

#----------------------------------------------------------------------------------------------------------------------

PokeRover Application
SexyRexy

#----------------------------------------------------------------------------------------------------------------------


VARIOUS SPRITE DESIGNS / CONCEPTS /
Jos_Louis
Badman
Endless
Hexx_Vixtar
Angel

Khrona
kfweagz
Mr. Fakemon
Plates of Arceus Reborn Mod
Hubercioch
Doowi
Anarlaurendil
Steelman2004
Geno
Maeracle
S4's "Spicy Man" Army#3133 aka currlor
Velkin
Boro
LuRocha
Scotsman33
LightningStrike7
KingPanloco
NocTurn
Nimolinari
IndianAnimator
Noel#5229, Colin#1356
Starry_Knight_Constellations
Eysselia, Cataclyptic, Anarlaurendil, Dracoyan, Amras Anarion
RedEmber513
RBRNNova
Eeveelution Reborn Mod
Arcadian Gekkouga#8920
Azria (a_zerudez)
PokelustCompany
Pokemon Reborn Team
Pokemon Rejuvenation Team
DiegoWT
Taka
ZeneonP0
Ochako
Agentbla
Raffs07
CrystalStar
YoshiGaminStuf
Stellari
CreativeVision
Dewdneym
TotallyNotCalledEvan
TrashGamer101
Escav
AtteaTheSilly
Ace
Raffs07
Badman
A11
Zeta
Hexx_Vixtar
Ignotus68
Brylark and TheAetherPlayer
Endless
PDM20
BiggusWeeabus
Riptidecord
Angel
Velink
Eeveelution Reborn
Pokemon Defiance
BlueTowel
Kixur
KingOfTheXRoad
Star Gaazer
Otter
Aboodie

#-----------------------------------
PLAY TESTING
#-----------------------------------
alba
IamDeanWinchster
Riptidecord
Potato
AwesomeE
Doowi
cdawg0616
Spenser
Otter
TrashGamer101
YoshiGaminStuf
Ignotus68
WitchyAlex
MissNyakura
CrystalStar
Zeta
SexyRexy

#-----------------------------------
Other Misc. Contributions
#-----------------------------------
All the members of the Pokemon Soulstones Discord Server 
for your support and encouragement over the years!

Please let the Dev team know if you believe you ought to be credited 
and your name is not presented on this list!

#----------------------------------
POKEMON ESSENTIALS CREDITS
#-----------------------------------

"Pokémon Essentials" was created by:
Flameguru
Poccil (Peter O.)
Maruno

With contributions from:
AvatarMonkeyKirby<s>Marin
Boushy<s>MiDas Mike
Brother1440<s>Near Fantastica
FL.<s>PinkMan
Genzai Kawakami<s>Popper
Golisopod User<s>Rataime
help-14<s>Savordez
IceGod64<s>SoundSpawn
Jacob O. Wobbrock<s>the__end
KitsuneKouta<s>Venom12
Lisa Anthony<s>Wachunga
Luka S.J.<s>
and everyone else who helped out

"mkxp-z" by:
Roza
Based on "mkxp" by Ancurio et al.

"RPG Maker XP" by:
Enterbrain

Pokémon is owned by:
The Pokémon Company
Nintendo
Affiliated with Game Freak

This is a non-profit fan-made game.
No copyright infringements intended.
Please support the official games!

_END_
# Stop Editing

  def main
    #-------------------------------
    # Animated Background Setup
    #-------------------------------
    @counter = 0.0   # Counts time elapsed since the background image changed
    @bg_index = 0
    @bitmap_height = Graphics.height   # For a single credits text bitmap
    @trim = Graphics.height / 10
    # Number of game frames per background frame
    @realOY = -(Graphics.height - @trim)
    #-------------------------------
    # Credits text Setup
    #-------------------------------
    plugin_credits = ""
    PluginManager.plugins.each do |plugin|
      pcred = PluginManager.credits(plugin)
      plugin_credits << "\"#{plugin}\" v.#{PluginManager.version(plugin)} by:\n"
      if pcred.size >= 5
        plugin_credits << (pcred[0] + "\n")
        i = 1
        until i >= pcred.size
          plugin_credits << (pcred[i] + "<s>" + (pcred[i + 1] || "") + "\n")
          i += 2
        end
      else
        pcred.each { |name| plugin_credits << (name + "\n") }
      end
      plugin_credits << "\n"
    end
    CREDIT.gsub!(/\{INSERTS_PLUGIN_CREDITS_DO_NOT_REMOVE\}/, plugin_credits)
    credit_lines = CREDIT.split(/\n/)
    #-------------------------------
    # Make background and text sprites
    #-------------------------------
    viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    viewport.z = 99999
    text_viewport = Viewport.new(0, @trim, Graphics.width, Graphics.height - (@trim * 2))
    text_viewport.z = 99999
    @background_sprite = IconSprite.new(0, 0)
    @background_sprite.setBitmap("Graphics/Titles/" + BACKGROUNDS_LIST[0])
    @credit_sprites = []
    @total_height = credit_lines.size * 32
    lines_per_bitmap = @bitmap_height / 32
    num_bitmaps = (credit_lines.size.to_f / lines_per_bitmap).ceil
    num_bitmaps.times do |i|
      credit_bitmap = Bitmap.new(Graphics.width, @bitmap_height + 16)
      pbSetSystemFont(credit_bitmap)
      lines_per_bitmap.times do |j|
        line = credit_lines[(i * lines_per_bitmap) + j]
        next if !line
        line = line.split("<s>")
        xpos = 0
        align = 1   # Centre align
        linewidth = Graphics.width
        line.length.times do |k|
          if line.length > 1
            xpos = (k == 0) ? 0 : 20 + (Graphics.width / 2)
            align = (k == 0) ? 2 : 0   # Right align : left align
            linewidth = (Graphics.width / 2) - 20
          end
          credit_bitmap.font.color = TEXT_SHADOW_COLOR
          credit_bitmap.draw_text(xpos, (j * 32) + 12, linewidth, 32, line[k], align)
          credit_bitmap.font.color = TEXT_OUTLINE_COLOR
          credit_bitmap.draw_text(xpos + 2, (j * 32) + 2, linewidth, 32, line[k], align)
          credit_bitmap.draw_text(xpos,     (j * 32) + 2, linewidth, 32, line[k], align)
          credit_bitmap.draw_text(xpos - 2, (j * 32) + 2, linewidth, 32, line[k], align)
          credit_bitmap.draw_text(xpos + 2, (j * 32) + 4, linewidth, 32, line[k], align)
          credit_bitmap.draw_text(xpos - 2, (j * 32) + 4, linewidth, 32, line[k], align)
          credit_bitmap.draw_text(xpos + 2, (j * 32) + 6, linewidth, 32, line[k], align)
          credit_bitmap.draw_text(xpos,     (j * 32) + 6, linewidth, 32, line[k], align)
          credit_bitmap.draw_text(xpos - 2, (j * 32) + 6, linewidth, 32, line[k], align)
          credit_bitmap.font.color = TEXT_BASE_COLOR
          credit_bitmap.draw_text(xpos, (j * 32) + 4, linewidth, 32, line[k], align)
        end
      end
      credit_sprite = Sprite.new(text_viewport)
      credit_sprite.bitmap = credit_bitmap
      credit_sprite.z      = 9998
      credit_sprite.oy     = @realOY - (@bitmap_height * i)
      @credit_sprites[i] = credit_sprite
    end
    #-------------------------------
    # Setup
    #-------------------------------
    # Stops all audio but background music
    previousBGM = $game_system.getPlayingBGM
    pbMEStop
    pbBGSStop
    pbSEStop
    pbBGMFade(2.0)
    pbBGMPlay(BGM)
    Graphics.transition
    loop do
      Graphics.update
      Input.update
      update
      break if $scene != self
    end
    pbBGMFade(2.0)
    $game_temp.background_bitmap = Graphics.snap_to_bitmap
    Graphics.freeze
    viewport.color = Color.new(0, 0, 0, 255)   # Ensure screen is black
    Graphics.transition(8, "fadetoblack")
    $game_temp.background_bitmap.dispose
    @background_sprite.dispose
    @credit_sprites.each { |s| s&.dispose }
    text_viewport.dispose
    viewport.dispose
    $PokemonGlobal.creditsPlayed = true
    pbBGMPlay(previousBGM)
  end

  # Check if the credits should be cancelled
  def cancel?
    if Input.trigger?(Input::USE) && $PokemonGlobal.creditsPlayed
      $scene = Scene_Map.new
      pbBGMFade(1.0)
      return true
    end
    return false
  end

  # Checks if credits bitmap has reached its ending point
  def last?
    if @realOY > @total_height + @trim
      $scene = ($game_map) ? Scene_Map.new : nil
      pbBGMFade(2.0)
      return true
    end
    return false
  end

  def update
    delta = Graphics.delta_s
    @counter += delta
    # Go to next slide
    if @counter >= SECONDS_PER_BACKGROUND
      @counter -= SECONDS_PER_BACKGROUND
      @bg_index += 1
      @bg_index = 0 if @bg_index >= BACKGROUNDS_LIST.length
      @background_sprite.setBitmap("Graphics/Titles/" + BACKGROUNDS_LIST[@bg_index])
    end
    return if cancel?
    return if last?
    @realOY += SCROLL_SPEED * delta
    @credit_sprites.each_with_index { |s, i| s.oy = @realOY - (@bitmap_height * i) }
  end
end
