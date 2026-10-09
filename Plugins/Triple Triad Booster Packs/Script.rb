#===============================================================================
# * Triple Triad Booster Pack - by FL (Credits will be appreciated)
#===============================================================================
#
# This script is for Pokémon Essentials. It's a booster pack item for 
# Triple Triad minigame.
#
#== INSTALLATION ===============================================================
#
# To this script works, put it above main OR convert into a plugin. Add into
# PBS\items.txt:
#
# In Essentials version 20 or above:
#
#  [BOOSTERPACK]
#  Name = Booster Pack
#  NamePlural = Booster Packs
#  Pocket = 1
#  Price = 1000
#  FieldUse = Direct
#  Flags = Fling_30
#  Description = A booster pack for Triple Triad game. Contains 5 cards.
#  [STARTERPACK]
#  Name = Starter Pack
#  NamePlural = Starter Packs
#  Pocket = 1
#  Price = 500
#  FieldUse = Direct
#  Flags = Fling_30
#  Description = A booster pack for Triple Triad game. Contains 3 starter cards.
#
# In v16-v19.1:
#
#  712,BOOSTERPACK,Booster Pack,Booster Packs,1,1000,"A booster pack for Triple Triad game. Contains 5 cards.",2,0,0,
#  713,STARTERPACK,Starter Pack,Starter Packs,1,500,"A booster pack for Triple Triad game. Contains 3 starter cards.",2,0,0,
#
# In v15.2 or below:
#
#  712,BOOSTERPACK,Booster Pack,1,1000,"A booster pack for Triple Triad game. Contains 5 cards.",2,0,0,
#  713,STARTERPACK,Starter Pack,1,500,"A booster pack for Triple Triad game. Contains 3 starter cards.",2,0,0,
#
#== HOW TO USE =================================================================
#
# You can set the booster pack list on LIST. So, you can create several types of 
# packs.
#
#== NOTES ======================================================================
#
# This script generates random cards, but pre-generates some cards forward at
# player save. So player can't reset the game trying to get other cards. I 
# suggest you to initialize this list after the professor lecture, for all
# packs. Just call 'BoosterPack.initialize_all_packs' at end of lecture event.
#
# The variable MIN_PACK_STOCK defines how many cards are pre-generated in save.
# If the number in this variable is 5, by example, and the values are
# initialized. Even if the player saves and keep opening the packs and
# resetting, he gets the same first 5 cards, since these cards are randomized
# ahead. To disable this feature, just make the variable value as 0.
#
# For helping in making booster pack lists, this script includes the method
# 'BoosterPack.print_species_array(type)' that prints all the IDs of a pokémon
# type. An example: if you call the code: 
# 'BoosterPack.print_species_array(:DRAGON)', the species ID array of all Dragon
# pokémon in pokemon.txt will be printed into a window (if you use Essentials
# version 19 or newer, it is also copied into your cilpboard/Ctrl+V). If you
# paste it into the list index 3 (remember that the first index is 0), all that
# you need to do in the item script is:
#
# ItemHandlers::UseFromBag.add(:DRAGONPACK,proc{|item|
#   BoosterPack.give(item,3,3)
#   next 1
# })
#
#===============================================================================

if defined?(PluginManager) && !PluginManager.installed?("Triple Triad Booster Pack")
  PluginManager.register({                                                 
    :name    => "Triple Triad Booster Pack",                                        
    :version => "1.1",                                                     
    :link    => "https://www.pokecommunity.com/showthread.php?t=356231",             
    :credits => "FL"
  })
end

module BoosterPack  
  LIST=[
    # The below line is the booster of index 0 or full random
    nil,
    # The below lines are the booster of index 1: Starter Pack
=begin
    [
      :BULBASAUR, :CHARMANDER, :SQUIRTLE, :CHIKORITA, :CYNDAQUIL, :TOTODILE,
      :TREECKO, :TORCHIC, :MUDKIP, :TURTWIG, :CHIMCHAR, :PIPLUP, 
      :SNIVY, :TEPIG, :OSHAWOTT
    ],
    # The below lines are the booster of index 2: Kanto Normal Pack
    [
      :PIDGEY, :PIDGEOTTO, :PIDGEOT, :RATTATA, :RATICATE, :SPEAROW, :FEAROW, 
      :JIGGLYPUFF, :WIGGLYTUFF, :MEOWTH, :PERSIAN, :FARFETCHD, :DODUO, :DODRIO,
      :LICKITUNG, :CHANSEY, :KANGASKHAN, :TAUROS, :DITTO, :EEVEE, :PORYGON,
      :SNORLAX
    ],
=end
    # The below lines are the booster of Tier 1 Cards (index 3)
    [
:ABRA,:AIPOM,:AMAURA,:ANORITH,:APPLIN,:ARON,:ARROKUDA,:AZURILL,:BAGON,:BALTOY,:BELDUM,:BERGMITE,:BIDOOF,:BINACLE,:BLITZLE,:BONSLY,:BOUNSWEET,:BOUNSWEET2,:BRONZOR,:BUDEW,:BUDEW2,:BUIZEL,:BULBASAUR,:BUNEARY,:CACNEA,:CARVANHA,:CASCOON,:CATERPIE,:CHARMANDER,:CHERUBI,:CHESPIN,:CHIKORITA,:CHIKORITA2,:CHIMCHAR,:CHINCHOU,:CHINGLING,:CLAMPERL,:CLEFAIRY,:CLEFFA,:CLOBBOPUS,:CORPHISH,:CORVISQUIRE,:CRANIDOS,:CROAGUNK,:CUBCHOO,:CUBONE,:CUFANT,:CUTIEFLY,:CYNDAQUIL,:CYNDAQUIL2,:DARUMAKA,:DEERLING,:DEINO,:DEWPIDER,:DEWPIDER2,:DIGLETT,:DIGLETT2,:DITTO,:DODUO,:DODUO2,:DRATINI,:DREEPY,:DRIFLOON,:DRILBUR,:DRILBUR2,:DROWZEE,:DUCKLETT,:DUOSION,:DUOSION2,:DUSKULL,:DWEBBLE,:EKANS,:ELECTRIKE,:ELEKID,:ELGYEM,:ESPURR,:EXEGGCUTE,:EXEGGCUTE2,:FEEBAS,:FEEBAS2,:FENNEKIN,:FERROSEED,:FINIZEN,:FINNEON,:FLAAFFY,:FLABEBE,:FLETCHINDER,:FLETCHLING,:FLOETTE,:FRILLISH,:FROAKIE,:FUECOCO,:GASTLY,:GEODUDE,:GEODUDE2,:GIBLE,:GIBLE2,:GIMMIGHOUL,:GLOOM,:GOLDEEN,:GOLETT,:GOOMY,:GOSSIFLEUR,:GOTHITA,:GOTHITA2,:GOTHORITA,:GOTHORITA2,:GRAVELER,:GRAVELER2,:GRIMER,:GRIMER2,:GROWLITHE,:GULPIN,:HAPPINY,:HATENNA,:HATTREM,:HELIOPTILE,:HIPPOPOTAS,:HONEDGE,:HOOTHOOT,:HOOTHOOT2,:HOPPIP,:HOPPIP2,:HORSEA,:HORSEA2,:HOUNDOUR,:IGGLYBUFF,:IMPIDIMP,:IMPIDIMP2,:JANGMOO,:JIGGLYPUFF,:JOLTIK,:KABUTO,:KABUTO2,:KAKUNA,:KIRLIA,:KLINK,:KOFFING,:KRABBY,:KRICKETOT,:KROKOROK,:LAMPENT,:LARVESTA,:LARVESTA2,:LARVITAR,:LEDYBA,:LILEEP,:LILLIPUP,:LITLEO,:LITTEN,:LITWICK,:LOMBRE,:LOTAD,:LOUDRED,:LUXIO,:MACHOP,:MACHOP2,:MAGBY,:MAGIKARP,:MAGNEMITE,:MAGNEMITE2,:MANKEY,:MANTYKE,:MAREANIE,:MAREEP,:MARILL,:MEDITITE,:MEOWTH,:METAPOD,:MILCERY,:MIMEJR,:MINCCINO,:MORELULL,:MUDBRAY,:MUDKIP,:MUDKIP2,:MUNCHLAX,:MUNNA,:NATU,:NINCADA,:NOIBAT,:NUMEL,:NUMEL2,:NUZLEAF,:ODDISH,:OMANYTE,:ONIX,:PALPITOAD,:PARAS,:PATRAT,:PAWMI,:PAWMO,:PHANPY,:PHANTUMP,:PICHU,:PIDGEOTTO,:PIDGEY,:PIDOVE,:PIKACHU,:PIKIPEK,:PINECO,:PIPLUP,:POLIWAG,:POLIWHIRL,:POOCHYENA,:POPPLIO,:PORYGON,:PSYDUCK,:PURRLOIN,:RALTS,:RATTATA,:REMORAID,:RIOLU,:ROGGENROLA,:ROGGENROLA2,:ROLYCOLY,:ROOKIDEE,:ROWLET,:RUFFLET,:SALANDIT,:SANDILE,:SANDYGAST,:SCRAGGY,:SEEDOT,:SEEL,:SENTRET,:SEWADDLE,:SHEDINJA,:SHELLOS,:SHIELDON,:SHINX,:SHROOMISH,:SHUPPET,:SILCOON,:SILICOBRA,:SINISTEA,:SIZZLIPEDE,:SKIDDO,:SKIPLOOM,:SKIPLOOM2,:SKITTY,:SKITTY2,:SKORUPI,:SKRELP,:SKWOVET,:SLAKOTH,:SLOWPOKE,:SLUGMA,:SLUGMA2,:SMEARGLE,:SMOOCHUM,:SNIVY,:SNOM,:SNORUNT,:SNOVER,:SOBBLE,:SOLOSIS,:SOLOSIS2,:SPEAROW,:SPHEAL,:SPINARAK,:SPRITZEE,:SPRITZEE2,:STARAVIA,:STARLY,:STARYU,:STEENEE,:STEENEE2,:STUFFUL,:STUNKY,:SUNKERN,:SURSKIT,:SURSKIT2,:SWABLU,:SWABLU2,:SWADLOON,:SWINUB,:SWINUB2,:SWIRLIX,:TAILLOW,:TEDDIURSA,:TENTACOOL,:TEPIG,:TIMBURR,:TIMBURR2,:TINKATINK,:TINKATUFF,:TIRTOUGA,:TOTODILE,:TOTODILE2,:TOXEL,:TRANQUILL,:TRAPINCH,:TREECKO,:TRUBBISH,:TRUMBEAK,:TURTWIG,:TYMPOLE,:TYNAMO,:TYROGUE,:TYRUNT,:VANILLISH,:VANILLISH2,:VANILLITE,:VANILLITE2,:VENIPEDE,:VENONAT,:VIBRAVA,:VOLTORB,:VOLTORB2,:VULLABY,:VULPIX,:WATTREL,:WEEDLE,:WHIRLIPEDE,:WHISMUR,:WIMPOD,:WINGULL,:WOOBAT,:WOOLOO,:WOOLOO2,:WOOPER,:WURMPLE,:WURMPLE2,:YAMASK,:YAMPER,:YANMA,:YANMA2,:ZIGZAGOON,:ZORUA,:ZUBAT,:BRONZOR2,:PUMPKABOO,:FOMANTIS,:COTTONEE,:TAROUNTULA,:COMBEE,:WISHIWASHI,:MAKUHITA,:MIMEJR2,:GOLETT2,:KARRABLAST,:PAWNIARD,:SMOLIV,:DOLLIV,:NICKIT,:SPHEAL2,:BARBOACH,:AXEW,:GREAVARD,:SANDSHREW,:CETODDLE,:TORCHIC,:NACLI,:NACLSTACK,:FRIGIBAX,:WYNAUT,:MIENFOO,:TOGEPI,:ZORUA2,:PANCHAM,:OSHAWOTT,:BERGMITE2,:TYRUNT2,:WIGLETT,:GROWLITHE2,:PANSAGE,:PANSEAR,:PANPOUR,:RHYHORN,:DUSKULL2,:GLAMEOW,:SHELLDER,:INKAY,:BUNNELBY,:ROCKRUFF,:ROWLET2,:LICKITUNG,:ZORUA2,:PANCHAM,:OSHAWOTT,:BERGMITE2,:TYRUNT2,:WIGLETT,:GROWLITHE2,:PANSAGE,:PANSEAR,:PANPOUR,:RHYHORN,:DUSKULL2,:GLAMEOW,:SHELLDER,:INKAY,:BUNNELBY,:ROCKRUFF,:ROWLET2,:LICKITUNG,:SQUIRTLE,:CACNEA2,:BELLSPROUT,:WEEPINBELL,:PETILIL,:PHANTUMP2,:IGGLYBUFF2,:JIGGLYPUFF2,:TANDEMAUS,:GRUBBIN,:TEDDIURSA2,:TANDEMAUS2,:CETODDLE2,:SHELMET,:SNUBBULL,:CHEWTLE,:SKIDDO2,:BURMY,:SPRIGATITO,:GLIMMET,:BRAMBLIN,:TOEDSCOOL,:CAPSAKID,:QUAXLY,:FOONGUS,:PARAS2,:PHANPY2,:UNOWN,:ROOKIDEE2,:CORVISQUIRE2,:LITLEO2,:TADBULB,:SCORBUNNY,:BLIPBUG,:DOTTLER,:MUDBRAY2,:FARFETCHD,:PICHU2,:PIKACHU2,:RALTS2,:KIRLIA2,:MASCHIFF,:NYMBLE,:TREECKO2,:BLITZLE2,:TURTWIG2,:POLTCHAGEIST,:NACLI2,:NACLSTACK2,:COTTONEE2,:GROOKEY,:CHARCADET,:SPOINK,:ONIX2,:CHARMANDER2,:POLTCHAGEIST2,:SHELLOS_1,:SHELLOS_2,:SHELLOS_3,:SHELLOS_4,:SHELLOS_5,:SHELLOS_6,:SHELLOS_7,:SHELLOS_8,:SHELLOS_9,:SHELLOS_10,:SHELLOS_11,:SHELLOS_12,:SHELLOS_13,:HONEDGE_1,:HONEDGE_2,:HONEDGE_3,:ESPURR_1,:BURMY_1,:BURMY_2,:SPOINK_1
    ],
    # The below lines are the booster of Tier 2 Cards (index 4)
    [
:ABSOL,:ABSOL2,:AMBIPOM,:ARAQUANID,:ARAQUANID2,:ARBOK,:ARCHEN,:ARIADOS,:AROMATISSE,:AROMATISSE2,:AZUMARILL,:BANETTE,:BASCULIN,:BAYLEEF,:BAYLEEF2,:BEAUTIFLY,:BEEDRILL,:BIBAREL,:BOLDORE,:BOLDORE2,:BRAIXEN,:BRIONNE,:BUTTERFREE,:CACTURNE,:CAMERUPT,:CAMERUPT2,:CARKOL,:CARNIVINE,:CHANSEY,:CHARMELEON,:CHERRIM,:CHIMECHO,:CLEFABLE,:COFAGRIGUS,:CORSOLA,:CRAMORANT,:CRAWDAUNT,:CROCALOR,:CROCONAW,:CROCONAW2,:DARMANITAN,:DARTRIX,:DEDENNE,:DELIBIRD,:DEWGONG,:DOUBLADE,:DRAGONAIR,:DRAKLOAK,:DRIZZILE,:DUNSPARCE,:DURANT,:DUSCLOPS,:DUSTOX,:EELEKTRIK,:EEVEE,:EEVEE2,:ELDEGOSS,:EMOLGA,:FALINKS,:FEAROW,:FORRETRESS,:FROGADIER,:FROSLASS,:FROSMOTH,:FURFROU,:FURRET,:GABITE,:GABITE2,:GALVANTULA,:GARBODOR,:GLALIE,:GLIGAR,:GOLBAT,:GRAPPLOCT,:GREEDENT,:GROTLE,:GROVYLE,:GURDURR,:GURDURR2,:HAKAMOO,:HAUNTER,:HELIOLISK,:HERDIER,:HITMONCHAN,:HITMONLEE,:HITMONTOP,:HYPNO,:INDEEDEE,:IVYSAUR,:JELLICENT,:JUMPLUFF,:JUMPLUFF2,:JYNX,:KADABRA,:KINGLER,:KLANG,:KLEFKI,:KRICKETUNE,:LAIRON,:LANTURN,:LEDIAN,:LIEPARD,:LINOONE,:LOPUNNY,:LUDICOLO,:LUMINEON,:LUVDISC,:MACHOKE,:MACHOKE2,:MAGCARGO,:MAGCARGO2,:MAGNETON,:MAGNETON2,:MANECTRIC,:MAROWAK,:MARSHTOMP,:MARSHTOMP2,:MASQUERAIN,:MASQUERAIN2,:MEDICHAM,:MEOWSTIC,:METANG,:MIGHTYENA,:MISDREAVUS,:MONFERNO,:MORGREM,:MORGREM2,:MRMIME,:MURKROW,:MURKROW2,:NINJASK,:NOCTOWL,:NOCTOWL2,:NOSEPASS,:NOSEPASS2,:OCTILLERY,:PARASECT,:PELIPPER,:PERSIAN,:PIDGEOT,:PIGNITE,:PILOSWINE,:PILOSWINE2,:PINCURCHIN,:PONYTA,:PRIMEAPE,:PRINPLUP,:PUPITAR,:QUAGSIRE,:QUILAVA,:QUILAVA2,:QUILLADIN,:RATICATE,:RIBOMBEE,:ROSELIA,:ROSELIA2,:SABLEYE,:SABLEYE2,:SALAZZLE,:SAWK,:SAWSBUCK,:SEADRA,:SEADRA2,:SEAKING,:SEALEO,:SERVINE,:SHARPEDO,:SHELGON,:SHIFTRY,:SHIINOTIC,:SKARMORY,:SKUNTANK,:SLIGGOO,:SLURPUFF,:SNEASEL,:STANTLER,:STANTLER2,:STONJOURNER,:SUNFLORA,:SWALOT,:SWELLOW,:TANGELA,:THROH,:TORKOAL,:TORRACAT,:TREVENANT,:UNFEZANT,:VENOMOTH,:VIGOROTH,:WAILMER,:WATCHOG,:WIGGLYTUFF,:ZWEILOUS,:LURANTIS,:WHIMSICOTT,:VESPIQUEN,:TROPIUS,:HARIYAMA,:MRMIME2,:PONYTA2,:SEALEO2,:WHISCASH,:ORICORIO,:FRAXURE,:PACHIRISU,:QWILFISH,:SANDSLASH,:COMBUSKEN,:ARCTIBAX,:WOBBUFFET,:SPINDA,:TOGETIC,:CLODSIRE,:DEWOTT,:PLUSLE,:MINUN,:DUSCLOPS2,:PURUGLY,:MALAMAR,:TATSUGIRI,:DIGGERSBY,:DARTRIX2,:WARTORTLE,:CACTURNE2,:LILLIGANT,:TREVENANT2,:WIGGLYTUFF2,:MAUSHOLD,:PERRSERKER,:CHARJABUG,:RUNERIGUS,:SNEASEL2,:HEATMOR,:MAUSHOLD2,:GRANBULL,:ORTHWORM,:WORMADAM,:MOTHIM,:FLORAGATO,:KLAWF,:MARACTUS,:BRAMBLEGHAST,:QUAXWELL,:AMOONGUSS,:PARASECT2,:TANGELA2,:RABOOT,:KOMALA,:AUDINO,:LOKIX,:SQUAWKABILLY,:GROVYLE2,:EISCUE,:KOMALA2,:GROTLE2,:WHIMSICOTT2,:SEVIPER,:TOGEDEMARU,:THWACKEY,:GRUMPIG,:BRUXISH,:VOLBEAT,:ILLUMISE,:CHARMELEON2,:BASCULIN_1,:FURFROU_1,:FURFROU_2,:FURFROU_3,:FURFROU_4,:FURFROU_5,:FURFROU_6,:DOUBLADE_1,:DOUBLADE_2,:DOUBLADE_3,:CHERRIM_1,:MEOWSTIC_1,:ORICORIO_1,:ORICORIO_2,:ORICORIO_3,:WORMADAM_1,:MOTHIM_1,:WORMADAM_2,:MOTHIM_2,:GRUMPIG_1
    ],
    # The below lines are the booster of Tier 3 (index 5)
    [
:ABOMASNOW,:AEGISLASH,:AERODACTYL,:AGGRON,:ALAKAZAM,:ALCREMIE,:ALTARIA,:ALTARIA2,:AMPHAROS,:ANNIHILAPE,:APPLETUN,:ARCANINE,:ARCHEOPS,:ARMALDO,:AURORUS,:AVALUGG,:BARBARACLE,:BARRASKEWDA,:BASCULEGION,:BASTIODON,:BEARTIC,:BEHEEYEM,:BELLOSSOM,:BEWEAR,:BLISSEY,:BOLTUND,:BRAVIARY,:BRELOOM,:BRONZONG,:CARBINK,:CARRACOSTA,:CENTISKORCH,:CHANDELURE,:CHARIZARD,:CHESNAUGHT,:CINCCINO,:CLAYDOL,:COALOSSAL,:COMFEY,:CONKELDURR,:CONKELDURR2,:COPPERAJAH,:CORVIKNIGHT,:CRADILY,:CROBAT,:CRUSTLE,:CURSOLA,:DECIDUEYE,:DELCATTY,:DELCATTY2,:DELPHOX,:DHELMISE,:DIPPLIN,:DODRIO,:DODRIO2,:DONPHAN,:DRAGALGE,:DRAPION,:DRIFBLIM,:DRUDDIGON,:DUBWOOL,:DUBWOOL2,:DUDUNSPARCE,:DUGTRIO,:DUGTRIO2,:DUSKNOIR,:EELEKTROSS,:ELECTABUZZ,:ELECTIVIRE,:ELECTRODE,:ELECTRODE2,:EMBOAR,:EMPOLEON,:ESPEON,:EXCADRILL,:EXCADRILL2,:EXEGGUTOR,:EXEGGUTOR2,:EXPLOUD,:FERALIGATR,:FERALIGATR2,:FERROTHORN,:FLAPPLE,:FLAREON,:FLOATZEL,:FLORGES,:FLYGON,:GALAXEON,:GALLADE,:GARDEVOIR,:GASTRODON,:GENGAR,:GHOLDENGO,:GIGALITH,:GIGALITH2,:GLACEON,:GLISCOR,:GOGOAT,:GOLDUCK,:GOLEM,:GOLEM2,:GOLISOPOD,:GOLURK,:GOREBYSS,:GOTHITELLE,:GOTHITELLE2,:GRENINJA,:GRIMMSNARL,:GRIMMSNARL2,:GYARADOS,:HATTERENE,:HERACROSS,:HIPPOWDON,:HONCHKROW,:HONCHKROW2,:HOUNDOOM,:HUNTAIL,:INCINEROAR,:INFERNAPE,:INTELEON,:JOLTEON,:KABUTOPS,:KABUTOPS2,:KILOWATTREL,:KINGDRA,:KINGDRA2,:KLINKLANG,:KROOKODILE,:LAPRAS,:LAPRAS2,:LEAFEON,:LEAVANNY,:LUCARIO,:LUNATONE,:LUXRAY,:MACHAMP,:MACHAMP2,:MAGMAR,:MAGMORTAR,:MAGNEZONE,:MAGNEZONE2,:MAMOSWINE,:MAMOSWINE2,:MANDIBUZZ,:MANTINE,:MEGANIUM,:MEGANIUM2,:MILOTIC,:MILOTIC2,:MILTANK,:MIMIKYU,:MISMAGIUS,:MRRIME,:MUDSDALE,:MUK,:MUK2,:MUSHARNA,:NINETALES,:NOIVERN,:OBSTAGOON,:OCTAVEON,:OMASTAR,:PALAFIN,:PALOSSAND,:PAWMOT,:PINSIR,:POLITOED,:POLIWRATH,:POLTEAGEIST,:PORYGON2,:PORYGONZ,:PRIMARINA,:PRISMEON,:PROBOPASS,:PROBOPASS2,:PYROAR,:RAICHU,:RAMPARDOS,:RAPIDASH,:REUNICLUS,:REUNICLUS2,:ROSERADE,:ROSERADE2,:SANDACONDA,:SCEPTILE,:SCIZOR,:SCOLIPEDE,:SCRAFTY,:SCYTHER,:SEISMITOAD,:SERPERIOR,:SKELEDIRGE,:SLOWBRO,:SLOWKING,:SNEASLER,:SNORLAX,:SOLROCK,:SPIRITOMB,:STARAPTOR,:STARMIE,:STEELIX,:STOUTLAND,:SUDOWOODO,:SWAMPERT,:SWAMPERT2,:SWANNA,:SWOOBAT,:SYLVEON,:TALONFLAME,:TANGROWTH,:TAUROS,:TENTACRUEL,:TINKATON,:TORTERRA,:TOUCANNON,:TOXAPEX,:TOXICROAK,:TOXTRICITY,:TSAREENA,:TSAREENA2,:TYPHLOSION,:TYPHLOSION2,:TYRANTRUM,:UMBREON,:URSALUNA,:URSARING,:VANILLUXE,:VANILLUXE2,:VAPOREON,:VENUSAUR,:VILEPLUME,:VOLCARONA,:VOLCARONA2,:WAILORD,:WALREIN,:WEAVILE,:WEEZING,:WYRDEER,:WYRDEER2,:XATU,:YANMEGA,:YANMEGA2,:ZEBSTRIKA,:ZOROARK,:BRONZONG2,:GOURGEIST,:SPIDOPS,:MRRIME2,:RAPIDASH2,:GOLURK2,:ESCAVALIER,:CRYOGONAL,:BISHARP,:KINGAMBIT,:ARBOLIVA,:THIEVUL,:WALREIN2,:HAXORUS,:OVERQWIL,:MINIOR,:HOUNDSTONE,:CETITAN,:BLAZIKEN,:GARGANACL,:BOUFFALANT,:MIENSHAO,:TOGEKISS,:ZOROARK2,:PANGORO,:SAMUROTT,:AVALUGG2,:TYRANTRUM2,:WUGTRIO,:ARCANINE2,:SIMISAGE,:SIMISEAR,:SIMIPOUR,:RHYDON,:RHYPERIOR,:DUSKNOIR2,:CLOYSTER,:DONDOZO,:LYCANROC,:DECIDUEYE2,:LICKILICKY,:BLASTOISE,:VICTREEBEL,:MINIOR2,:VIKAVOLT,:URSARING2,:URSALUNA2,:WEAVILE2,:SNEASLER2,:SHUCKLE,:ORANGURU,:PASSIMIAN,:CETITAN2,:SCYTHER2,:SCIZOR2,:ACCELGOR,:DREDNAW,:GOGOAT2,:SIGILYPH,:MEOWSCARADA,:GLIMMORA,:CYCLIZAR,:TOEDSCRUEL,:STUNFISK,:SCOVILLAIN,:QUAQUAVAL,:DONPHAN2,:CORVIKNIGHT2,:PYROAR2,:TANGROWTH2,:BELLIBOLT,:CINDERACE,:HYDRAPPLE,:ORBEETLE,:TURTONATOR,:MUDSDALE2,:HAWLUCHA,:FLAMIGO,:RELICANTH,:SIRFETCHD,:ROTOM,:DURALUDON,:RAICHU2,:GARDEVOIR2,:GALLADE2,:DRAMPA,:BOMBIRDIER,:MABOSSTIFF,:SCEPTILE2,:SPIRITOMB2,:ZEBSTRIKA2,:TORTERRA2,:SINISTCHA,:GARGANACL2,:MIMIKYU2,:RILLABOOM,:ARMAROUGE,:CERULEDGE,:STEELIX2,:CHARIZARD2,:SINISTCHA2,:GASTRODON_1,:GASTRODON_2,:GASTRODON_3,:GASTRODON_4,:GASTRODON_5,:GASTRODON_6,:GASTRODON_7,:GASTRODON_8,:GASTRODON_9,:GASTRODON_10,:GASTRODON_11,:GASTRODON_12,:GASTRODON_13,:AEGISLASH_1,:AEGISLASH_2,:AEGISLASH_3,:DARMANITAN_1,:BASCULEGION_1,:UNOWN_1,:TOGEDEMARU_1
    ]
]

  MIN_PACK_STOCK=30

  module_function

  def initialize_all_packs
    for i in 0...BoosterPack::LIST.size
      $PokemonGlobal.fill_booster_stock(i)
    end
  end

  def validate_list
    for pack_list in LIST
      next if !pack_list || pack_list.empty?
      raise ArgumentError.new(
        "#{get_invalid_species_sym(pack_list)} isn't a valid species!"
      ) if get_invalid_species_sym(pack_list)
    end
  end

  def get_invalid_species_sym(array)
    return array.find{|s| !Bridge.species_sym_is_valid(s) }
  end

  def random_card(booster_list)
    if !booster_list || booster_list.empty?
      return Bridge.random_species
    end
    return booster_list[rand(booster_list.size)]
  end

  def random_card_by_index(index)
    return random_card(LIST[index])
  end    
  
  def give(item,numberOfCards,booster_index=0)
    validate_list
    Bridge.message(_INTL(
      "{1} opened the {2}.", Bridge.player.name, Bridge.item_name(item)
    ))
    numberOfCards.times do
      if MIN_PACK_STOCK>0
        card_species = $PokemonGlobal.first_booster_at_stock(booster_index)
      else
        card_species = random_card_by_index(booster_index)
      end
      Bridge.give_triad_card(card_species,1)
      Bridge.message(_INTL(
        "{1} draws {2} card!",
        Bridge.player.name,
        Bridge.species_name(card_species))
      )
    end
  end
  
  def print_species_array(type)
    Bridge.print_value(create_species_array(type))
  end  
  
  def create_species_array(type)
    return Bridge.create_species_array(type)
  end  

  # Essentials multiversion layer
  module Bridge
    if defined?(Essentials)
      MAJOR_VERSION = Essentials::VERSION.split(".")[0].to_i
    else
      MAJOR_VERSION = 0
    end

    module_function

    def message(string)
      return MAJOR_VERSION >= 19 ? pbMessage(string) : Kernel.pbMessage(string)
    end

    def give_triad_card(sym, quantity)
      pbGiveTriadCard(
        (MAJOR_VERSION >= 19 ? sym : getID(PBSpecies, sym)), quantity
      )
    end 

    def player
      return MAJOR_VERSION >= 20 ? $player : $Trainer
    end 

    def species_name(species)
      return PBSpecies.getName(getID(PBSpecies, species)) if MAJOR_VERSION < 19
      return GameData::Species.get(species).name
    end

    def species_sym_is_valid(species_sym)
      return getConst(PBSpecies, species_sym) != nil if MAJOR_VERSION < 19
      return GameData::Species.try_get(species_sym) != nil 
    end

    def random_species
      if MAJOR_VERSION < 19
        return getConstantName(PBSpecies, rand(PBSpecies.maxValue)+1).to_sym
      end
      random_species_array = create_random_species_array_v19_plus
      return random_species_array[rand(random_species_array.size)]
    end    
    
    def create_random_species_array_v19_plus
      ret =[]
      GameData::Species.each_species{ |species| ret.push(species.id)}
      return ret
    end
    
    def print_value(value)
      Input.clipboard = value.to_s if MAJOR_VERSION >= 19
      print(value.inspect)
    end
    
    def create_species_array(type)
      ret = []
      if MAJOR_VERSION >= 19
        GameData::Species.each_species { |species|
          if MAJOR_VERSION == 19
            ret.push(species.id) if species.type1==type || species.type2==type
          else
            ret.push(species.id) if species.types.include?(type)
          end
        }
      else
        dexdata=pbOpenDexData
        for species in 1..PBSpecies.maxValue
          pbDexDataOffset(dexdata,species,8)
          type1=dexdata.fgetb
          type2=dexdata.fgetb
          if isConst?(type1,PBTypes,type) || isConst?(type2,PBTypes,type)
            ret.push(getConstantName(PBSpecies, species).to_sym) 
          end
        end
      end
      return ret
    end

    def item_name(item)
      return PBItems.getName(getID(PBItems, item)) if MAJOR_VERSION < 19
      return GameData::Item.get(item).name
    end
  end
end


if BoosterPack::MIN_PACK_STOCK>0
  class PokemonGlobalMetadata
    def fill_booster_stock(booster_index)
      @booster_stock=[]  if !@booster_stock
      if @booster_stock.size<=booster_index || !@booster_stock[booster_index]
        @booster_stock[booster_index]=[]
      end
      while @booster_stock[booster_index].size < BoosterPack::MIN_PACK_STOCK
        @booster_stock[booster_index].push(
          BoosterPack.random_card_by_index(booster_index)
        )
      end
    end
    
    # Gives the first available booster at stock.
    # Call fill_booster_stock before and after since the variable on first time
    # isn't initialized
    def first_booster_at_stock(booster_index)
      fill_booster_stock(booster_index)
      ret = @booster_stock[booster_index].shift
      fill_booster_stock(booster_index)
      return ret
    end
  end
end

ItemHandlers::UseFromBag.add(:BOOSTERPACK,proc{|item|
  BoosterPack.give(item, 5)
  next 1
})
ItemHandlers::UseFromBag.add(:STARTERPACK,proc{|item|
  BoosterPack.give(item, 3, 1)
  next 1
})
# 5 cards from index 3 (Tier 1 pack)
ItemHandlers::UseFromBag.add(:TIER1PACK,proc{|item|
  BoosterPack.give(item, 5, 1)
  next 1
})
# 5 cards from index 4 (Tier 2 pack)
ItemHandlers::UseFromBag.add(:TIER2PACK,proc{|item|
  BoosterPack.give(item, 5, 2)
  next 1
})
# 5 cards from index 5 (Tier 3 pack)
ItemHandlers::UseFromBag.add(:TIER3PACK,proc{|item|
  BoosterPack.give(item, 5, 3)
  next 1
})

def pbSellAllTriads
  total_price = 0
  triad_data = $PokemonGlobal.triads
  sell_triad_cards = []
  triad_data.length.times do |i|
    item = triad_data.get_item(i)
    Console.echo_warn(item)
    next if item.nil?
    price = TriadCard.new(item).price
    quantity = triad_data.quantity(item)
    next if price == 0
    price /= 4
    price *= quantity
    total_price += price
    sell_triad_cards.push(item)
  end
  if total_price > 0
    Console.echo_h1(total_price)
    if pbConfirmMessage(_INTL("For your entire collection, I can pay ${1}. Would that be OK?", total_price.to_s_formatted))
      for t in 0...sell_triad_cards.length
        triad_card = sell_triad_cards[t]
        triad_quantity = $PokemonGlobal.triads.quantity(triad_card)
        $PokemonGlobal.triads.remove(triad_card, triad_quantity)
      end
      $player.money += total_price
      pbMessage(_INTL("You turned over your entire collection and received ${1}.\\se[Mart buy item]", total_price.to_s_formatted))
    end
  else
    pbMessage(_INTL("You don't seem to have any cards I can buy off you."))
  end
end

