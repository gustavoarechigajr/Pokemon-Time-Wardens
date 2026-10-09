module QuestModule
  
  # You don't actually need to add any information, but the respective fields in the UI will be blank or "???"
  # I included this here mostly as an example of what not to do, but also to show it's a thing that exists
  Quest0 = {
  
  }
  
  # Here's the simplest example of a single-stage quest with everything specified
  # Uses ID 900 onwards for main quests to distinguish them from other side quests
  CHAPTER1_MAIN_STORY = {
    :ID => "901",
    :Name => "CHAPTER 1: Prologue",
    :QuestGiver => "Main Story",
    :Stage1 => "Part 1",
    :Stage2 => "Part 2",
    :Stage3 => "Part 3",
    :Stage4 => "Part 4",
    :Stage5 => "Part 5",
	:Stage6 => "Part 6",
	:Stage7 => "Part 7",
	:Stage8 => "Part 8",
	:Stage9 => "Part 9",
	:Stage10 => "Part 10",
	:Stage11 => "Part 11",
	:Stage12 => "Part 12",
    :Location1 => "Cygnus Village",
    :Location2 => "Cygnus Village",
    :Location3 => "Europa Lake",
    :Location4 => "Europa Forest",
	:Location5 => "Europa Forest",
	:Location6 => "Europa Cave",
	:Location7 => "Agnes' Lab",
	:Location8 => "Auriga Bay",
	:Location9 => "Auriga Resort",
	:Location10 => "Auriga Resort",
	:Location11 => "Auriga Bay",
	:Location12 => "Lyra City",
    :QuestDescription1 => "Today is my birthday. I just talked to Mom and she reminded me that we were going to visit Europa Lake for a picnic to celebrate. The neighbours, the Campbell family, are going to be joining us, so I need to find Artie Campbell next door.",
    :QuestDescription2 => "I talked to Artie and he said that he's done packing everything up but his mom, Agnes, is probably delayed in her lab. I should pay her a visit to see how much longer she will be." ,
    :QuestDescription3 => "Agnes said that she is just about ready but just needed to get my birthday gift! This is exciting, I wonder what she's going to give me for my birthday! She told me to go onwards to Europa Lake and she would catch up with us.",
    :QuestDescription4 => "Artie has gone into Europa Forest to catch some Pokemon. I should follow him and catch as many Pokemon as I can. I'll show him up for sure!",
    :QuestDescription5 => "Artie is waiting for me at the entrance to Europa Cave. I should catch some Pokemon that will help me hit his Ghost-type Minccino.",
	:QuestDescription6 => "What was that noise that came from Europa Cave?! With my new Pokemon, I'm sure that I can investigate and figure out what's going on.",
	:QuestDescription7 => "I encountered a silver-haired woman and her Pokemon being ambushed by some suspicious looking people in Europa Cave. Shortly after beating them, the Pokemon collapsed. We returned to Artie's mom's lab to nurse them back to health.",
	:QuestDescription8 => "The Manaphy we found in Europa Cave is the companion Pokemon of the silver-haired woman we found fainted there. I need to take a boat from Auriga Bay to Lyra City to meet with Agnes' former colleague, Caitlin Linklater, as she may have a cure to the lady's 'Temporal Illness'.",
    :QuestDescription9 => "No dice. Apparently I need a boat pass to get to Lyra City so the ferry won't let me board. The ferry captain did say that apparently I could win a boat pass in a Triple Triad tournament hosted in Auriga Resort." ,
    :QuestDescription10 => "Artie has enrolled in the Triple Triad tournament. I'll need to see if I can win a boat pass from other guests in the hotel.",
    :QuestDescription11 => "I met with Caitlin Linklater and her uncle Wesley in Auriga Resort. She gave me a boat pass and invited me to her home in Lyra City to learn more about Temporal Illness.",
	:QuestDescription12 => "With the boat pass in hand, I was able to take a boat to Lyra City to meet with Caitlin Linklater in her home there.",
    :RewardString => "Continue Story."
  }
  
  CHAPTER2_MAIN_STORY = {
    :ID => "902",
    :Name => "CHAPTER 2: Temporal Illness",
    :QuestGiver => "Main Story",
    :Stage1 => "Part 1",
    :Stage2 => "Part 2",
    :Stage3 => "Part 3",
    :Stage4 => "Part 4",
    :Stage5 => "Part 5",
	:Stage6 => "Part 6",
	:Stage7 => "Part 7",
	:Stage8 => "Part 8",
	:Stage9 => "Part 9",
	:Stage10 => "Part 10",
    :Location1 => "Lyra City",
	:Location2 => "Route 2A Gatehouse",
	:Location3 => "Route 2A",
	:Location4 => "Route 2A",
	:Location5 => "Epoch Mine",
	:Location6 => "Epoch Mine",
	:Location7 => "Triton Cave",
	:Location8 => "Caitlin's Villa",
	:Location9 => "Agnes' Lab",
	:Location10 => "Telescopium Academy",
	:QuestDescription1 => "I should meet with Artie at Caitlin Linklater's house in Lyra City. I can get there using the boat pass she provided me and take a ferry to Lyra City from Auriga Bay.",
    :QuestDescription2 => "I met with Artie and he mentioned that Caitlin isn't home. She might be at the site of the leyline mine protests near Route 2A.",
	:QuestDescription3 => "I saw Caitlin at the gate to Route 2A. She was able to convince the guard to let me through. I should follow her since she told him that I was a junior field scientist with the Epoch Corporation.",
	:QuestDescription4 => "Caitlin has told me to keep an eye out for 6 manashrooms that grow along Route 2A.",
	:QuestDescription5 => "I collected 6 Manashrooms on Route 2A and gave them to Caitlin, but she still needs more help in the Epoch Mine. I should follow her there.",
	:QuestDescription6 => "Pierre has told me to recover the stolen natural resources from Ethereal Guild henchmen masquerading as protesters from the Epoch Mine.",
	:QuestDescription7 => "One of the protesters that was actually an Ethereal Guild henchman told me that their hideout is in Triton Cave, which is north of Route 2B. Artie might be in danger... Caitlin and Pierre have gone ahead already.",
	:QuestDescription8 => "After having rescued Artie from the Ethereal Guild, Caitlin now has enough manashrooms to brew the mixture needed to revive the silver-haired woman that you found in Europa Cave. I should return to Caitlin's Villa in Lyra City.",
	:QuestDescription9 => "Caitlin was able to distill a mixture for me to bring back to Agnes' Lab that will hopefully be able to revive the silver-haired woman we found in Europa Cave.",
	:QuestDescription10 => "Caitlin's mixture worked! The silver-haired woman's name is Cara. She is known as a 'Time Warden' and has a very colourful past. She believes the Ethereal Guild are up to no good and needs to learn more.",
    :RewardString => "Continue Story."
  }
  
  CHAPTER3_MAIN_STORY = {
    :ID => "903",
    :Name => "CHAPTER 3: Intelligence Gathering",
    :QuestGiver => "Main Story",
    :Stage1 => "Part 1",
    :Stage2 => "Part 2",
    :Stage3 => "Part 3",
    :Stage4 => "Part 4",
    :Stage5 => "Part 5",
    :Location1 => "Telescopium Academy",
	:Location2 => "Telescopium Academy",
	:Location3 => "Telescopium Academy",
	:Location4 => "Telescopium Academy",
	:Location5 => "Telescopium Academy",
	:QuestDescription1 => "Agnes has advised us to go to Telescopium Academy and learn what we can from the acolytes that inhabit this monastery to support Cara's intelligence-gathering. I should meet with Artie and Cara at Telescopium Academy as soon as I can.",
    :QuestDescription2 => "After besting Artie in a trainer battle, I should continue with meeting Cara as originally planned inside the Telescopium Academy",
	:QuestDescription3 => "Cara has suggested we interview the acolytes within the monastery and read as many books as we can. We can reconvene on the top floor if and when we've found anything useful. We need two passwords to get into the Headmaster's chambers.",
	:QuestDescription4 => "I found a fair bit of useful information and most importantly, the passwords needed to open the Headmaster's chambers. We should approach him to inquire what he may know about the Ethereal Guild.",
	:QuestDescription5 => "The Headmaster mentored a man named Angelo duPlessis in some forbidden secrets relating to Arceus and the Creation Trio. He might be the secret leader of the Ethereal Guild and has been interested in the Sigils and leylines.",
    :RewardString => "Continue Story."
  }
  
  CHAPTER4_MAIN_STORY = {
    :ID => "904",
    :Name => "CHAPTER 4: The Epoch Corporation",
    :QuestGiver => "Main Story",
    :Stage1 => "Part 1",
    :Stage2 => "Part 2",
    :Stage3 => "Part 3",
    :Stage4 => "Part 4",
    :Stage5 => "Part 5",
	:Stage6 => "Part 6",
	:Stage7 => "Part 7",
	:Stage8 => "Part 8",
	:Stage9 => "Part 9",
	:Stage10 => "Part 10",
	:Stage11 => "Part 11",
	:Stage12 => "Part 12",
	:Stage13 => "Part 13",
    :Location1 => "Route 5A",
	:Location2 => "Orion City (Central)",
	:Location3 => "Orion City (East)",
	:Location4 => "Caitlin's Penthouse",
	:Location5 => "Caitlin's Penthouse",
	:Location6 => "Orion Sewers",
	:Location7 => "Orion Sewers",
	:Location8 => "Orion Slums",
	:Location9 => "Orion Slums",
	:Location10 => "Orion Slums",
	:Location11 => "Orion Landfill",
	:Location12 => "Caitlin's Penthouse",
	:Location13 => "Route 6A",
	:QuestDescription1 => "Given Angelo's interest in the leylines, the first thought the group had to alert the Epoch Corporation about Angelo's nefarious schemes was Caitlin Linklater, who lives in Orion City. First, I should meet with Cara on Route 5A though.",
    :QuestDescription2 => "Cara gave me an evolution stone to evolve my Eevee for helping her so far! She's told me to travel through the Orion Underground and meet her and Artie in Orion City (Central).",
	:QuestDescription3 => "Caitlin is not in her penthouse, however, the lobby guard of her condo building said she might be at the site of some anti-leyline mining protests happening in the Orion City (East).",
	:QuestDescription4 => "We found Caitlin. She seems to be familiar with the name Angelo du Plessis. She's told us to meet with her in her Penthouse back in Orion City (Central)",
	:QuestDescription5 => "The lobby guard of Caitlin's penthouse appears to have been... 'mind-controlled' by possibly Cara and Manaphy? Whatever. They're letting us through. I should take the elevator to her penthouse.",
	:QuestDescription6 => "Caitlin has reason to believe that the CEO of the Epoch Corporation, Angelo, might actually be a double-agent leading the Ethereal Guild simultaneously. Apparently, he has a meeting in the Sewers. How suspicious...",
	:QuestDescription7 => "Artie is accompanying me through the Sewers so we don't get separated from one another. We're on the lookout for Angelo and hoping to find out what he's up to exactly...",
	:QuestDescription8 => "We caught Angelo conspiring with some Ethereal Guild officials. They are planning an attack on the city from within the Orion Landfill. They apparently have some creature caged that they plan on releasing on the citizens!",
	:QuestDescription9 => "The attack has started! I heard an explosion and there's now smoke billowing from the Orion Slums. I need to rush there to investigate.",
	:QuestDescription10 => "Artie was able to brief Caitlin and Cara and we were able to meet up in the Orion Slums but then Caitlin ran off like an idiot! We need to be careful when hunting for this creature the Ethereal Guild may have set loose within the Slums!",
	:QuestDescription11 => "Cara and Caitlin found something. There's a massive hole in the wall of one of the houses leading into the Orion Landfill!",
	:QuestDescription12 => "The Ethereal Guild had released a Temporal Anomaly on the city. I was able to weaken it but Angelo and one of the Epoch Corporation scientists showed up and saved us though? They were planning this! We need to return to Caitlin's penthouse to debrief!",
	:QuestDescription13 => "Angelo is on his way to obtain the other Sigils of Creation. I need to head to Fornax Town through Route 6A/B and through Mt. Oberon because apparently Angelo has found the location of a useful artifact.",
    :RewardString => "Continue Story."
  }
  
  CHAPTER5_MAIN_STORY = {
    :ID => "905",
    :Name => "CHAPTER 5: The Sigils of Creation",
    :QuestGiver => "Main Story",
    :Stage1 => "Part 1",
    :Stage2 => "Part 2",
    :Stage3 => "Part 3",
    :Stage4 => "Part 4",
    :Stage5 => "Part 5",
	:Stage6 => "Part 6",
    :Location1 => "Route 6A",
	:Location2 => "Route 6B",
	:Location3 => "Mt. Oberon",
	:Location4 => "Mt. Oberon",
	:Location5 => "Fornax Town Hall",
	:Location6 => "Indus Village",
	:QuestDescription1 => "I need to meet Artie on Route 6A next. Cara is going ahead to Mt. Oberon so we should look to meet with her there next. We're currently pursuing Angelo who believes he has found the location of an important artifact for his mission.",
    :QuestDescription2 => "I beat Artie in another battle after he challenged me. However, we need to hurry to the foot of Mt. Oberon so as to not keep Cara waiting any longer.",
	:QuestDescription3 => "The Epoch Corporation have not yet built out their mine within Mt. Oberon but with the Ethereal Guild having infiltrated the Epoch Corporation's leyline mines, we need to sneak through the volcano as we don't know who might be an innocent employee, vs. an Ethereal Guild henchman masquerading as one.",
	:QuestDescription4 => "Angelo was able to use one of his Sigils to cause the volcano to reactivate. Upon seeing this, the Mayor of Fornax Town surrendered the other Sigil. The Ethereal Guild have kidnapped him and are now holding him hostage within Fornax Town Hall. We need to rescue him!",
	:QuestDescription5 => "Cara and I have to work our way through Fornax Town Hall and defeat the Ethereal Guild henchmen that may be stationed here and keeping the Mayor of the town hostage.",
	:QuestDescription6 => "We managed to defeat the two lieutenants of the Ethereal Guild that were stationed in Fornax Town Hall to keep Mayor Olaf hostage. He didn't have any useful info on the Sigils, but he has given us a lead that the Cult of Time in the Indus Jungles might have some information that could help us.",
    :RewardString => "Continue Story."
  }
  
  CHAPTER6_MAIN_STORY = {
    :ID => "906",
    :Name => "CHAPTER 6: The Cult of Time",
    :QuestGiver => "Main Story",
    :Stage1 => "Part 1",
    :Stage2 => "Part 2",
    :Stage3 => "Part 3",
    :Stage4 => "Part 4",
    :Stage5 => "Part 5",
	:Stage6 => "Part 6",
	:Stage7 => "Part 7",
	:Stage8 => "Part 8",
    :Location1 => "Indus Village",
	:Location2 => "Indus Caverns",
	:Location3 => "Indus Caverns",
	:Location4 => "Temple of Time",
	:Location5 => "Temple of Time",
	:Location6 => "Heart of Time",
	:Location7 => "Indus Temple Grounds",
	:Location8 => "Cygnus Village",
	:QuestDescription1 => "I have a tool to cross the whirlpools that had formed around Route 8A/8B, so I now need to meet up with Artie and Cara in Indus Village to determine how we gather information on the Sigils next.",
    :QuestDescription2 => "Caitlin has said that Angelo has not been using the Sigils to cause natural disasters and has been instead using some leyline technology she developed. She wants us to observe an experiment in Indus Caverns to prove it.",
	:QuestDescription3 => "Caitlin has told us to bring Escape Ropes with us and meet her on the deepest level of the Indus Caverns.",
	:QuestDescription4 => "Caitlin has set up a 'trap' within the Indus Caverns that will trigger if Angelo attempts to trigger a quake using his leyline technology. This should result in a sinkhole trapping him but we need to get to the Cult of Time's priestess to help defend her against the Ethereal Guild.",
	:QuestDescription5 => "Cara was waiting for me outside the Temple of Time. I need to follow her inside to catch up to the rest of the group to discuss a plan on how we are going to rescue the Priestess of the Cult of Time.",
	:QuestDescription6 => "The Priestess of the Cult of Time is channelling the powers of Dialga's wrath. This has put all of her cultists within the Temple of Time in a trance. They must be defeated before the chamber doors to the Heart of Time are opened.",
	:QuestDescription7 => "Caitlin's trap failed and it ruptured a leyline node instead, causing a Temporal Anomaly to surge forth. Fortunately, Dialga followed and was able to save us, and 'stitch' the leyline back. I need to meet Cara outside the Temple now to discuss what this means.",
	:QuestDescription8 => "Cara and Sienna have gone onwards to Cassiopeia City while Caitlin and Artie are expecting me back in Cygnus Village to work on developing some technology that will counter the leyline pulse instruments that Angelo has been using.",
    :RewardString => "Continue Story."
  }
  
  CHAPTER7_MAIN_STORY = {
    :ID => "907",
    :Name => "CHAPTER 7: The Leyline Matrix",
    :QuestGiver => "Main Story",
    :Stage1 => "Part 1",
    :Stage2 => "Part 2",
    :Stage3 => "Part 3",
    :Stage4 => "Part 4",
    :Stage5 => "Part 5",
	:Stage6 => "Part 6",
	:Stage7 => "Part 7",
	:Stage8 => "Part 8",
	:Stage9 => "Part 9",
	:Stage10 => "Part 10",
	:Stage11 => "Part 11",
	:Stage12 => "Part 12",
	:Stage13 => "Part 13",
    :Location1 => "Cygnus Village",
	:Location2 => "Pisces Village",
	:Location3 => "Route 8A",
	:Location4 => "Route 8B",
	:Location5 => "Route 5B",
	:Location6 => "Mensa Village",
	:Location7 => "Caverns of Rhea",
	:Location8 => "Caverns of Rhea",
	:Location9 => "Caverns of Rhea",
	:Location10 => "Caverns of Rhea",
	:Location11 => "Caverns of Rhea",
	:Location12 => "Cygnus Village",
	:Location13 => "Cassiopeia City",
	:QuestDescription1 => "Caitlin's expecting me in Cygnus Village. As she has effectively been locked out of Epoch Corporation technical resources, she needs a lab to develop the technology needed to counter the instruments that Angelo has been using to trigger leyline quakes.",
    :QuestDescription2 => "Caitlin has detected something bizarre in the leyline matrix as one of the leylines near the Indus Jungles appears to have 'disappeared'. She has requested I meet her and Artie in Pisces Village to conduct a site visit.",
	:QuestDescription3 => "Caitlin has requested you go diving in the underwater trenches of Route 8A and drop her 'Macguffins' in the bubbling vents and then return to her in Pisces Village when you're done so she can conduct a signal test.",
	:QuestDescription4 => "Caitlin's hypothesis was correct as the leyline appears to have moved... to Route 8B. She's once again asked me to go diving in the underwater trenches of that route and conduct similar tests and find air vents to drop her 'Macguffins' so she can run tests at each vent.",
	:QuestDescription5 => "Caitlin has given me a Teleport Pass that I can use at the Teleporter in Hyperion Lake. I then need to travel through Route 5B to meet Caitlin in Mensa Village.",
	:QuestDescription6 => "Artie challenged me to a quick battle but now I need to trek through the floating islands of Route 5B to meet Caitlin and Artie in Mensa Village.",
	:QuestDescription7 => "Foreman Pierre of the Epoch Corporation met us in Mensa Village. He appears to have found the location of a leyline that moved from the leyline mine around Hyperlion Lake, up to the floating islands around Mensa Village. We need to meet with him near the Caverns of Rhea next.",
	:QuestDescription8 => "The movement of the leylines has caused a large number of protruding crystals to emerge within the Caverns of Rhea. A number of civilians might be within the cave and they need to be directed to leave as soon as possible given that their exposure to these crystals might not be safe.",
	:QuestDescription9 => "I have cleared one level of the Caverns of Rhea but my work is not done as there's another level to go. I need to hurry through this place because it's not clear whether such direct exposure to these crystals could be dangerous.",
	:QuestDescription10 => "The second level is clear, I need to follow Caitlin and Artie down now to the last level of the Caverns of Rhea to make sure all civilians are accounted for and safely escorted out.",
	:QuestDescription11 => "The third level of the Caverns of Rhea had Anomalies crawling about! However, Caitlin had stolen the same tech that Angelo used to incapacitate the Orion Landfill Anomaly, and has tasked Artie and myself with clearing the rest of the Caverns of these Anomalies.",
	:QuestDescription12 => "A large Anomaly was waiting in the heart of the deepest level of the Caverns of Rhea, but after defeating it, I was able to use the leyline pulse emitter to eradicate it. Caitlin has now requested we meet back up with her in Agnes' Lab in Cygnus Village.",
	:QuestDescription13 => "Caitlin has gathered the info she needs to develop the technology to counter Angelo's leyline quake pulse emitter technology. She's told us to go onwards to Cassiopeia City and meet back up with Cara and Sienna there.",
    :RewardString => "Continue Story."
  }
  
  CHAPTER8_MAIN_STORY = {
    :ID => "908",
    :Name => "CHAPTER 8: The Cult of Space",
    :QuestGiver => "Main Story",
    :Stage1 => "Part 1",
    :Stage2 => "Part 2",
    :Stage3 => "Part 3",
    :Stage4 => "Part 4",
    :Stage5 => "Part 5",
	:Stage6 => "Part 6",
	:Stage7 => "Part 7",
	:Stage8 => "Part 8",
    :Location1 => "Cygnus Village",
	:Location2 => "Cassiopeia City",
	:Location3 => "Cassiopeia Oasis",
	:Location4 => "Forgotten Tombs",
	:Location5 => "Forgotten Tombs",
	:Location6 => "Temple of Space",
	:Location7 => "Heart of Space",
	:Location8 => "The In-Between",
	:QuestDescription1 => "After learning what you could about the leyline matrix and the Anomalies, Caitlin has instructed you to catch up to Cara and Sienna in Cassiopeia City while she finishes working on the technology that will counter Angelo's leyline quake pulse emitters. Go east through Indus Village.",
    :QuestDescription2 => "Sienna suspects that Angelo will likely try to find the Sigil of Space by desecrating the various tombs across the Cassiopeia Oasis that conceal the burial place of the Priests of Space's father, Mordecai. She has asked for me to meet her there next.",
	:QuestDescription3 => "The Ethereal Guild have already arrived in Cassiopeia Oasis and are in the midst of ransacking each of the 9 tombs in the area. I need to dispose of them and find the energy signature emanating from the Sigil of Space.",
	:QuestDescription4 => "Sienna wants to show me what to look for. I need to follow her into a nearby tomb.",
	:QuestDescription5 => "Sienna has instructed me to look at the tablets within the tombs and read the inscriptions on them. They might have some useful information about the Cult of Space and the Sigil of Space. When I'm done, I can meet with Cara outside the Temple of Space.",
	:QuestDescription6 => "Caitlin arrived and warned us of Angelo's impending arrival. She has given us some dampener tech that will allegedly counter Angelo's attempts to trigger another leyline quake. In the meantime, Sienna has been able to open the door to the Temple of Space so we can protect the twin Priests of Space from Angelo.",
	:QuestDescription7 => "To defend against the Ethereal Guild's incursions, the Priests of Space struck some dark bargains to fortify the Temple of Space with some enchantments. The cultists within the Temple will not be welcoming but only by defeating them will the way to the Heart of Space be opened.",
	:QuestDescription8 => "After cleansing the twin Priests of Space of their corruption, swarms of Anomalies started pouring through a portal they had opened to the In-Between. One particularly large one knocked us into the portal... where are we now?",
    :RewardString => "Continue Story."
  }
  
  CHAPTER9_MAIN_STORY = {
    :ID => "909",
    :Name => "CHAPTER 9: The In-Between",
    :QuestGiver => "Main Story",
    :Stage1 => "Part 1",
    :Stage2 => "Part 2",
    :Stage3 => "Part 3",
    :Stage4 => "Part 4",
    :Stage5 => "Part 5",
	:Stage6 => "Part 6",
	:Stage7 => "Part 7",
	:Stage8 => "Part 8",
	:Stage9 => "Part 9",
	:Stage10 => "Part 10",
	:Stage11 => "Part 11",
	:Stage12 => "Part 12",
	:Stage13 => "Part 13",
	:Stage14 => "Part 14",
	:Stage15 => "Part 15",
	:Stage16 => "Part 16",
	:Stage17 => "Part 17",
    :Location1 => "The In-Between",
	:Location2 => "The In-Between",
	:Location3 => "The In-Between",
	:Location4 => "The In-Between",
	:Location5 => "Antimatter Temple",
	:Location6 => "Ezreal's Prison",
	:Location7 => "Antimatter Temple",
	:Location8 => "Eridanus Settlement",
	:Location9 => "Ezreal's Tent",
	:Location10 => "Eridanus Settlement",
	:Location11 => "Mt. Titania",
	:Location12 => "Underwater Temple",
	:Location13 => "Underwater Temple",
	:Location14 => "Underwater Temple",
	:Location15 => "Lyra Glacier",
	:Location16 => "Lyra Glacier",
	:Location17 => "Caitlin's Villa",
	:QuestDescription1 => "Cara, Maximillion and I seem to have fallen into a portal into some astral dimension, after a particularly vicious Anomaly knocked us in here... I'll need to do some scouting...",
    :QuestDescription2 => "Cara rifled through the unconscious Maximillion and found the Sigil of Antimatter. It can be used to shield me as I travel through the In-Between to find a way to get back to the Orion Region.",
	:QuestDescription3 => "I managed to use the leyline pulse emitter tech to eradicate some Anomalies while scouting. I found some humans here but they were quickly possessed by the Anomaly. ",
	:QuestDescription4 => "Maximillion is awake. We have all returned to this ominous abandoned building I found. It seems to have similar markings to the other Temples we have visited, so it may have clues on how to escape this realm.",
	:QuestDescription5 => "Cara has stuck me with babysitting Maximillion. I need to travel through this Temple with him by my side. He may also have some useful information to share while we travel...",
	:QuestDescription6 => "We came across a prisoner named Ezreal. He was being attacked by Anomalies but we defeated them. However, Maximillion escaped and stole the Sigil of Antimatter and plans to continue climbing the Temple to use it to enslave Giratina.",
	:QuestDescription7 => "Maximillion tried to control Giratina but failed and Giratina killed him. Ezreal was able to cure Giratina of his trance. Ezreal's people were banished here and has offered to explain all from his settlement in the In-Between.",
	:QuestDescription8 => "Ezreal has told us to speak to the other cultists within the settlement to gain our bearings, understand their origins and learn who they are and what they are doing in the In-Between.",
	:QuestDescription9 => "Some Origin Cult members settled in the In-Between. We learned their history but Ezreal will likely have more to tell us now from his tent in the Eridanus Settlement.",
	:QuestDescription10 => "Giratina can help us return to the Orion Region using the Antimatter Sigil. There is a relic in an Underwater Temple that we need to find that would help us repair the leyline matrix: The Orb of Creation",
	:QuestDescription11 => "Giratina opened a portal back to the Orion Region. Cara and I need to find this relic that would help us restabilize the Origin, reconstruct the great cosmic web and anchor the universe bubbles back in place.",
	:QuestDescription12 => "I need to go diving near the shores of Mt. Titania to find this underwater temple where the Orb of Creation was lost during the Creation War.",
	:QuestDescription13 => "Giratina has cast a spell on us that will allow us to communicate with one another telepathically. We've found the Temple of Antimatter but we need to look for the Orb of Creation here.",
	:QuestDescription14 => "Ezreal has told us to look for certain altars within the Underwater Temple. Allegedly, they hold special memories that were recorded, almost like a time capsule. They may contain some useful information.",
	:QuestDescription15 => "We came across a large Anomaly that had consumed the Orb of Creation in the Underwater Temple that was from the time of the Creation War. We managed to eradicate it and recover the Orb. We need to return to the surface next.",
	:QuestDescription16 => "Cara and I debriefed what happened and the treachery we observed. Cara believes in Ezreal and claims that despite some of his people's actions, his goals are benign and we should continue to trust him.",
	:QuestDescription17 => "Ezreal seemed to be showing signs of illness ever since he returned to the Orion Region. He has now fallen into a deep trance and we are taking care of him in Caitlin's Villa in Lyra City before we decide what to do next.",
    :RewardString => "Continue Story."
  }
  
  CHAPTER10_MAIN_STORY = {
    :ID => "910",
    :Name => "CHAPTER 10: Interplanar Storms",
    :QuestGiver => "Main Story",
    :Stage1 => "Part 1",
    :Stage2 => "Part 2",
    :Stage3 => "Part 3",
    :Stage4 => "Part 4",
    :Location1 => "Ursa Village",
	:Location2 => "Route 13A",
	:Location3 => "Route 13B",
	:Location4 => "Route 14A",
	:QuestDescription1 => "Artie, Caitlin and Sienna are in Ursa Village scouting out a sudden increased presence of Ethereal Guild personnel in the area. They've told Cara and I to meet them there as soon as we can.",
    :QuestDescription2 => "There was a leyline node explosion that has triggered an Interplanar storm, causing an Anomaly invasion. We need to clear the Route of Anomalies and use the Orb of Creation to mend the leyline rupture.",
	:QuestDescription3 => "Cara has instructed us to close the Anomaly portals, and disarm any Ethereal Guild henchmen of the anomalies they have enslaved across both Route 13A and Route 13B. Meet up with her near Route 13B when done.",
	:QuestDescription4 => "A large Anomaly was defeated. Cara then used the Orb of Creation to successfully close the last portal, however, it seems that our work is not yet done. We need to meet her in Route 14A next.",
    :RewardString => "Continue Story."
  }
  
  CHAPTER11_MAIN_STORY = {
    :ID => "911",
    :Name => "CHAPTER 11: Anomaly Invasion",
    :QuestGiver => "Main Story",
    :Stage1 => "Part 1",
    :Stage2 => "Part 2",
    :Stage3 => "Part 3",
    :Stage4 => "Part 4",
    :Stage5 => "Part 5",
	:Stage6 => "Part 6",
	:Stage7 => "Part 7",
	:Stage8 => "Part 8",
	:Stage9 => "Part 9",
	:Stage10 => "Part 10",
	:Stage11 => "Part 11",
	:Stage12 => "Part 12",
	:Stage13 => "Part 13",
	:Stage14 => "Part 14",
	:Stage15 => "Part 15",
	:Stage16 => "Part 16",
	:Stage17 => "Part 17",
	:Stage18 => "Part 18",
	:Stage19 => "Part 19",
    :Location1 => "Route 14A",
	:Location2 => "Callisto Lake",
	:Location3 => "Callisto Lake",
	:Location4 => "Callisto Lake",
	:Location5 => "Underwater Base",
	:Location6 => "Crew Quarters",
	:Location7 => "Control Bridge",
	:Location8 => "Control Bridge",
	:Location9 => "Engine Room",
	:Location10 => "Facility Lab",
	:Location11 => "Facility Lab",
	:Location12 => "Facility Lab",
	:Location13 => "Epoch Corporation HQ",
	:Location14 => "Epoch Corporation HQ",
	:Location15 => "Callisto Lake",
	:Location16 => "Draco City",
	:Location17 => "Draco City",
	:Location18 => "Draco City",
	:Location19 => "Draco City",
	:QuestDescription1 => "I need to take the Cable Car down to Route 14A to meet Cara and Caitlin there. Angelo is on his way to Draco City with the Ethereal Guild, the enslaved Palkia and an army of Anomalies in their service.",
    :QuestDescription2 => "One of the Ethereal Guild lieutenants, Aki, came to us pleading for help. His colleague, Christina, was responsible for destroying the leyline node that caused the Interplanar Storm. She is now stuck in the Ethereal Guild base, fending them off and needs a rescue.",
	:QuestDescription3 => "While the surface of Callisto Lake is deserted, Caitlin's leyline energy detectors seem to suggest that the underwater caverns of Callisto Lake are crawling with Anomalies. I need to go diving and close these portals and get rid of any Anomalies I find crawling about.",
	:QuestDescription4 => "After closing down a bunch of the Anomaly portals that were open at the bottom of Callisto Lake, Cara says she's found the entrance to the Ethereal Guild Underwater Base. I need to hurry through the passage she was standing by and surface to catch up to the others.",
	:QuestDescription5 => "The Ethereal Guild underwater base appears to have been compromised... there might be some Anomalies on the loose. Cara has told us to exercise caution as we proceed through the base and look for Foreman Pierre and Lieutenant Christina of the Ethereal Guild.",
	:QuestDescription6 => "A dying guard told us that if we are able to access the Control Bridge of the Underwater Base, we could review the security footage to see if we can find Pierre and Christina. One of the dead guards' bodies may have a key card for us to be able to access the Control Bridge.",
	:QuestDescription7 => "I found a keycard on the body of one of the dead guards within the Crew Quarters. We were able to use it to open the way to the Control Bridge.",
	:QuestDescription8 => "Caitlin has gone looking for the surveillance system so we can track down Pierre and Christina. We need to inch our way through the base until we find that security system.",
	:QuestDescription9 => "Caitlin found the security system and has found Pierre in the Engine Room. Additionally, she found out that Christina has barricaded herself in the Facility Lab, and there is a teleporter from that room that takes you to the Epoch Corporation HQ in Orion City.",
	:QuestDescription10 => "I found Pierre safe and sound. However, something appears to have broken a hole in the door to the Facility Lab and it can't be friendly. Christina doesn't have much time so I need to hurry there to try to save her.",
	:QuestDescription11 => "Caitlin and the others have somehow gotten themselves stuck within a Facility Lab booby-trap. To free them, I need to set the switches of the nearby Pokemon enclosures to a certain order and speak to Caitlin when I think I've got the right combination so she can disable the electrical barrier.",
	:QuestDescription12 => "I was able to find the right switch combination to release Caitlin and the others from the booby-trap. Now I need to progress further to try to find and save Christina before it's too late.",
	:QuestDescription13 => "Christina was infested by the Anomalies and killed Pierre. Dialga came through the rupture and saved us from her just in time. Caitlin and Aki have gone onwards to Draco City to defend it from Angelo, but I need to take the Facility Lab teleporter to the Epoch Corporation HQ.",
	:QuestDescription14 => "Cara, Manaphy and I are on the hunt for the Priests of Space, Leo and Selene, who are apparently being kept hostage within the Epoch Corporation HQ. They have already gone ahead while I need to cover their trails.",
	:QuestDescription15 => "Our attempt to rescue the Twin Priests of Space failed. Claude enslaved Dialga and used him to kill the Priests after they channelled their power to help me win the battle against him. The base was subsequently destroyed with the force of Dialga's attack.",
	:QuestDescription16 => "I need to get to Draco City as soon as I can. While Claude is dead and Angelo has moved onwards to the Alpha Point, Draco City will be left in ruins. I need to find Caitlin and Aki, and try to save whoever is left from the Ethereal Guild attack.",
	:QuestDescription17 => "I need to find all the Ethereal Guild henchmen within Draco City and chase them out to stop the attack. Once that is done, I can try to track down Caitlin and Aki.",
	:QuestDescription18 => "I managed to rescue Caitlin and Aki from the clutches of two Ethereal Guild captains that had ambushed them. I need to now meet back up with Cara and the others near the safehouse in the northwest end of Draco City.",
	:QuestDescription19 => "I need to meet with Cara, Artie and Dialga in Ara City to plan out how we're going to ask Arceus for his help.",
    :RewardString => "Continue Story."
  }

  CHAPTER12_MAIN_STORY = {
    :ID => "912",
    :Name => "CHAPTER 12: Favour from the Gods",
    :QuestGiver => "Main Story",
    :Stage1 => "Part 1",
    :Stage2 => "Part 2",
    :Stage3 => "Part 3",
    :Stage4 => "Part 4",
	:Stage5 => "Part 5",
	:Stage6 => "Part 6",
	:Stage7 => "Part 7",
	:Stage8 => "Part 8",
	:Stage9 => "Part 9",
	:Stage10 => "Part 10",
	:Stage11 => "Part 11",
	:Stage12 => "Part 12",
    :Location1 => "Ara City",
	:Location2 => "Ara City",
	:Location3 => "Route 17B",
	:Location4 => "Temple of Creation",
	:Location5 => "Temple of Creation",
	:Location6 => "Altar of Time",
	:Location7 => "Temple of Creation",
	:Location8 => "Altar of Space",
	:Location9 => "Temple of Creation",
	:Location10 => "Altar of Creation",
	:Location11 => "Arceus's Realm",
	:Location12 => "Temple of Creation",
	:QuestDescription1 => "My next objective is to make my way to Ara City. We're hoping to petition Arceus for his help to stop Angelo's mad quest for multiversal domination.",
    :QuestDescription2 => "Artie challenged me to a quick battle outside Ara City, but I put him in his place. Now I need to meet with Cara and him in the park on the east end of Ara City.",
	:QuestDescription3 => "Cara, Artie and Dialga will be waiting for me near the Temple of Creation, which is north of Ara City past Route 17B.",
	:QuestDescription4 => "Dialga will guide us through a ritual that is required to open a pathway to Arceus' Realm within the Temple of Creation.",
	:QuestDescription5 => "A simulacrum of Ezreal appeared within the Temple and wants to speak with us near the Altar of Time. For whatever reason, he didn't want Lord Dialga to overhear our discussions...",
	:QuestDescription6 => "The simulacrum of Ezreal was created before the events of the Creation War and doesn't know what elapsed after its creation. He is willing to help us for now though and awaits us in the Altar of Time.",
	:QuestDescription7 => "I had to face the memory of one of Dialga's temporal champions. One part of the ritual is complete. I need to go to the right wing to the Altar of Space next.",
	:QuestDescription8 => "The simulacrum of Ezreal opened the door to the Altar of Space for us. He still seems trustworthy so we continue to accept his aid. He awaits us in the Altar of Space now.",
	:QuestDescription9 => "Similar to the Altar of Time, I had to face off against a memory of Palkia's temporal champion. The final part of the ritual awaits us in front of the entrance of the Altar of Creation.",
	:QuestDescription10 => "The simulacrum of Ezreal opened the way to the Altar of Creation. We have almost opened the way to Arceus.",
	:QuestDescription11 => "After defeating the simulacrum of Ezreal as the final guardian, he reluctantly opened the way to Arceus' Realm. Dialga and the others have already taken the portal.",
	:QuestDescription11 => "After defeating the simulacrum of Ezreal as the final guardian, he reluctantly opened the way to Arceus' Realm. Dialga and the others have already taken the portal.",
	:QuestDescription12 => "Arceus ended up being just as useless as Ezreal's simulacrum warned. It seems that if we are to stop Angelo, humankind will be left to their own devices to stop him.",
    :RewardString => "Continue Story."
  }
  
  CHAPTER13_MAIN_STORY = {
    :ID => "913",
    :Name => "CHAPTER 13: The Time Matrix",
    :QuestGiver => "Main Story",
    :Stage1 => "Part 1",
    :Stage2 => "Part 2",
    :Stage3 => "Part 3",
    :Stage4 => "Part 4",
	:Stage5 => "Part 5",
	:Stage6 => "Part 6",
	:Stage7 => "Part 7",
	:Stage8 => "Part 8",
	:Stage9 => "Part 9",
	:Stage10 => "Part 10",
	:Stage11 => "Part 11",
	:Stage12 => "Part 12",
	:Stage13 => "Part 13",
	:Stage14 => "Part 14",
	:Stage15 => "Part 15",
	:Stage16 => "Part 16",
	:Stage17 => "Part 17",
	:Stage18 => "Part 18",
	:Stage19 => "Part 19",
    :Location1 => "Temple of Creation",
	:Location2 => "Draco City",
	:Location3 => "Draco City",
	:Location4 => "Draco City Museum",
	:Location5 => "Draco City Museum",
	:Location6 => "The Time Matrix",
	:Location7 => "The Time Matrix",
	:Location8 => "Spire of Antimatter",
	:Location9 => "Spire of Antimatter",
	:Location10 => "Spire of Time",
	:Location11 => "Spire of Time",
	:Location12 => "Spire of Time",
	:Location13 => "Draco City Museum",
	:Location14 => "Spire of Space",
	:Location15 => "Spire of Space",
	:Location16 => "Spire of Space",
	:Location17 => "Remnants of the Origin",
	:Location18 => "Remnants of the Origin",
	:Location19 => "Draco City Museum",
	:QuestDescription1 => "We need to go back to the Temple of Creation and come up with a new plan to stop Angelo from reaching the Origin.",
    :QuestDescription2 => "Caitlin might have a way to stop Angelo by turning the Anomalies against him. We need to go back to Draco City to seek her assistance. She's humanity's best hope now. Cara can teleport us to Draco City to meet with them.",
	:QuestDescription3 => "Cara teleported us back to Draco City... it seems that in the 'weeks' that elapsed while we were visiting Arceus' Realm, Draco City has been largely rebuilt.",
	:QuestDescription4 => "Artie suggested that Caitlin and Aki may be waiting in the Draco City Museum as they were overseeing the restoration of Draco City from their base of operations there. They might be waiting for us there.",
	:QuestDescription5 => "Caitlin and Aki were fortunately waiting for us in the Draco City Museum. We've caught them up on our travels to Arceus' Realm. Cara has come up with a plan to visit the Time Matrix. She is waiting for me in the left-most room of the Museum.",
	:QuestDescription6 => "Cara has opened a portal to the Time Matrix. It can be found in the left-most room of the Draco City Museum. I should follow her into the portal so we can start searching for Angelo.",
	:QuestDescription7 => "Cara is in the bottom left platform of the Time Matrix. She is going to tap into her Soulstone to hone in on the location of the Spires of Creation so we can determine how much progress Angelo has made in finding the way to the Origin.",
	:QuestDescription8 => "Cara and the rest of the team have gone onwards to the Spire of Antimatter. I should follow behind to investigate this particular Spire.",
	:QuestDescription9 => "A small group of Anomalies attacked us at the portal to the Spire of Antimatter. We need to look for the ritual beacon at the end of the winding path and hopefully avoid Anomalies along the way.",
	:QuestDescription10 => "I managed to defeat a large horde of Anomalies that tried to interrupt the channelling ritual at the Spire of Antimatter. The Sigil of Antimatter has been restored and now we need to move onwards to the Spire of Time.",
	:QuestDescription11 => "We found dead bodies of Ethereal Guild soldiers at the portal entrance of the Spire of Time. Anomalies and Angelo's soldiers appeared to have been here. We need to visit the Spire of Time's ritual beacon and hope Angelo hasn't reached it yet.",
	:QuestDescription12 => "After defeating some Absorbed Ethereal Guild Soldiers at the Spire of Time, I have returned back to the Orion Region to check in with Caitlin regarding her signal breaker gadget she is developing for us to help disable Angelo's forces.",
	:QuestDescription13 => "Caitlin gave me a prototype of her signal breaker gadget. We need to install these at each of the Spires we find along the way to create a signal disturbance field that will disable Angelo's control over Giratina, Palkia and the Anomalies.",
	:QuestDescription14 => "Cara has placed one of the signal breaker prototypes at the Spire of Time. We need to continue along to the Spire of Space and continue setting these traps up to interfere with Angelo's control of his legions.",
	:QuestDescription15 => "Angelo has managed to find the Spire of Space and used his artificial Sigils to open a path to the Origin. We need to chase him before he reaches Arceus' throne and rewrites all of Creation!",
	:QuestDescription16 => "We've arrived in the Spire of Space, and we can hear something ominous in the distance... we need to cross the winding paths and reach the Spire of Space as soon as possible to investigate.",
	:QuestDescription17 => "We defeated some of Angelo's final soldiers that were standing guard by the portal that he has opened to the Origin. Dialga and Arceus arrived to help us in humanity's final hour.",
	:QuestDescription18 => "Angelo has been defeated. The Gods have vacated Creation and empowered us with their abilities to safeguard the balance. We now reprise the role of Guardians of the Balance.",
	:QuestDescription19 => "Cara has opened a portal to return us back to the Time Matrix and we now need to return to the Draco City Museum so we can reconvene with Caitlin and speak to her about what has transpired while she waited back in the Orion Region.",
    :RewardString => "Continue Story."
  }
  
  CHAPTER14_MAIN_STORY = {
    :ID => "914",
    :Name => "MAIN GAME: EPILOGUE",
    :QuestGiver => "Main Story",
    :Stage1 => "Part 1",
    :Stage2 => "Part 2",
    :Stage3 => "Part 3",
    :Stage4 => "Part 4",
	:Stage5 => "Part 5",
	:Stage6 => "Part 6",
    :Location1 => "The Time Matrix",
	:Location2 => "Trial of the Time Warden",
	:Location3 => "The Time Matrix",
	:Location4 => "Draco City Museum",
	:Location5 => "Caitlin's Penthouse",
	:Location6 => "Caitlin's Villa",
	:QuestDescription1 => "After returning from the Origin with our newfound powers, we all equally felt a certain sensation that troubled us about a sinister force on the horizon... but what is it?",
    :QuestDescription2 => "Cara wants to show me something through a portal she has opened. She had gained some powers after becoming a Time Warden and was able to somehow manifest certain memories of hers to be accessible at any time...",
	:QuestDescription3 => "Cara has introduced me to an area that she shaped with her powers that allows me the ability to test my battling prowess against her memories. How intriguing!",
	:QuestDescription4 => "I need to be on standby while Caitlin and Agnes study Ezreal's condition. He might be the only one capable of answering our questions as to what is this sinister force that each of us are feeling upon receiving our new powers.",
	:QuestDescription5 => "Caitlin's penthouse doorman told me I need to visit her villa in Lyra City as there's been a development in Ezreal's condition. I am to also bring her some Cheetos though I'm not sure where to get any of those...",
	:QuestDescription6 => "Cara, Sienna and Aki have taken Ezreal back with them to the In-Between. Caitlin is preoccupied with Ronnie for the next few hours but I am to meet her at the Mt. Titania portal to the In-Between with Artie when she's finished 'packing'.",
    :RewardString => "Main Game Epilogue Completed."
  }
  
  CHAPTER15_POSTGAME_STORY = {
    :ID => "915",
    :Name => "CHAPTER 14: AGING OUT",
    :QuestGiver => "Postgame Story",
    :Stage1 => "Part 1",
    :Stage2 => "Part 2",
    :Stage3 => "Part 3",
    :Stage4 => "Part 4",
	:Stage5 => "Part 5",
	:Stage6 => "Part 6",
	:Stage7 => "Part 7",
	:Stage8 => "Part 8",
	:Stage9 => "Part 9",
	:Stage10 => "Part 10",
	:Stage11 => "Part 11",
	:Stage12 => "Part 12",
	:Stage13 => "Part 13",
	:Stage14 => "Part 14",
	:Stage15 => "Part 15",
    :Location1 => "Mt. Titania",
	:Location2 => "Eridanus Settlement",
	:Location3 => "Ezreal's Tent",
	:Location4 => "Shadowmoon Forest",
	:Location5 => "Shadowmoon Forest",
	:Location6 => "Shadowmoon Marsh",
	:Location7 => "Shadowmoon Marsh",
	:Location8 => "Adria's Hut",
	:Location9 => "Eridanus Tunnels",
	:Location10 => "Eridanus Tunnels",
	:Location11 => "Eridanus Trench",
	:Location12 => "Eridanus Trench",
	:Location13 => "Eridanus Trench",
	:Location14 => "Libram Tunnel",
	:Location15 => "Libram Passageway",
	:QuestDescription1 => "I need to meet with Caitlin and Artie near Mt. Titania as there is a portal there that will take us to the Eridanus Settlement in the In-Between where Cara, Aki and Sienna will be waiting.",
    :QuestDescription2 => "Caitlin brought Ronnie with her, but all of us including Artie and myself now have to go through the portal at Mt. Titania to the Eridanus Settlement in the In-Between.",
	:QuestDescription3 => "Ezreal is still comatose in his tent in the Eridanus Settlement. Cara and the others are are waiting for us there and we're hoping Caitlin might know how to revive him now.",
	:QuestDescription4 => "We managed to successfully revive Ezreal, and caught him up on all that transpired during his coma. Unfortunately, it seems that the Orb of Creation attracts Anomalies and we must defend the Settlement against an imminent attack!",
	:QuestDescription5 => "I need to make my way through Shadowmoon Forest and clear as many of the Anomaly soldiers I can find and then meet Cara at the entrance of Shadowmoon Marsh.",
	:QuestDescription6 => "I need to continue my way through the Shadowmoon Marsh and try to find this lieutenant that is leading the attack on the Eridanus Settlement.",
	:QuestDescription7 => "There is a hut that the others managed to find in the middle of the swamp that they are searching through. In the meantime though, Cara and Aki have continued their journey through the marsh so I should continue through it as well.",
	:QuestDescription8 => "Lieutenant Christina somehow survived the infestation and is now serving the leader of the Anomalies: Leviathan. We narrowly escaped an attack by him and we need to now find a way to hide the Orb of Creation from him.",
	:QuestDescription9 => "Within the hut in the middle of the Marsh, Caitlin found a secret switch that opened a hideaway ladder that takes us down to part of the Eridanus Tunnels. We need to try to find Libram City while Ezreal creates a diversion to get Leviathan off our trail.",
	:QuestDescription10 => "I need to make my way down to Level 5 of the Eridanus Tunnels. Caitlin's instruments have indicated some promising results regarding a deepwater trench on that level where I should be able to dive.",
	:QuestDescription11 => "Caitlin has found the deepwater trench in the central lake of Level 5 of the Eridanus Tunnels. We need to find where this narrow tunnel is that she claims is at the bottom of this lake.",
	:QuestDescription12 => "Caitlin used her echo-location technology to map out the tunnel but it doesn't seem to have worked... we're going to have to do a manual visit of the tunnel to investigate ourselves.",
	:QuestDescription13 => "We faced a monstrous anomaly that was at the end of the narrow underwater tunnel in the Eridanus Trench. We have found a small shallow area where we can safely emerge from the water. Now to find out where this tunnel goes...",
	:QuestDescription14 => "We thought we had reached a dead end but a nearby NATU drone was able to guide us into a doorway that seems to have been built by humans? Ronnie somehow knew an Old Origin Cult word for 'Friend' which was able to open the door for us.",
	:QuestDescription15 => "Caitlin used Blissbot and the leyline pulse emitter to cause a power surge that opened the door to Libram City. We need to navigate in here and figure out who lives in this city and if they can help us against Leviathan.",
    :RewardString => "Continue Post Game Story."
  }

  CHAPTER16_POSTGAME_STORY = {
    :ID => "916",
    :Name => "CHAPTER 15: LIBRAM CITY",
    :QuestGiver => "Postgame Story",
    :Stage1 => "Part 1",
    :Stage2 => "Part 2",
    :Stage3 => "Part 3",
    :Stage4 => "Part 4",
	:Stage5 => "Part 5",
	:Stage6 => "Part 6",
	:Stage7 => "Part 7",
	:Stage8 => "Part 8",
	:Stage9 => "Part 9",
	:Stage10 => "Part 10",
	:Stage11 => "Part 11",
	:Stage12 => "Part 12",
	:Stage13 => "Part 13",
	:Stage14 => "Part 14",
	:Stage15 => "Part 15",
	:Stage16 => "Part 16",
	:Stage17 => "Part 17",
	:Stage18 => "Part 18",
	:Stage19 => "Part 19",
	:Stage20 => "Part 20",
	:Stage21 => "Part 21",
	:Stage22 => "Part 22",
	:Stage23 => "Part 23",
    :Location1 => "Science District",
	:Location2 => "Libram City Hall",
	:Location3 => "Libram City Hall",
	:Location4 => "Science District Attack",
	:Location5 => "Science District Attack",
	:Location6 => "Libram Dungeons",
	:Location7 => "Libram Dungeons",
	:Location8 => "Market District",
	:Location9 => "Mining District",
	:Location10 => "Aether Mine",
	:Location11 => "Aether Mine",
	:Location12 => "Science District",
	:Location13 => "Power Plant",
	:Location14 => "Power Plant",
	:Location15 => "Power Plant",
	:Location16 => "The Arboretum",
	:Location17 => "The Orchidarium",
	:Location18 => "The Orchidarium",
	:Location19 => "Arcane District",
	:Location20 => "Civil District",
	:Location21 => "Libram City Hall",
	:Location22 => "Libram City Hall",
	:Location23 => "The Grand Pylon",
	:QuestDescription1 => "We need to find someone within Libram City who can help us with the threat of the Anomalies. If this place is the fortress of humanity's resistance against the Anomalies as Ezreal claims, surely they must have something they can do to stop Leviathan?",
    :QuestDescription2 => "Prelate Victor and Lady Thorne would like to speak with us in the Libram City Hall. They are intrigued by what Cara told them and want to learn more about where we hail from.",
	:QuestDescription3 => "We spoke to Alexis and Victor of the Libram City Conclave but they will be unable to help us... however, some soldiers barged into our meeting with them to alert us that the Science District is under attack from Anomalies!",
	:QuestDescription4 => "Anomalies are attacking the Science District of Libram City. We need to help clear out the infestation!",
	:QuestDescription5 => "Ingrates! After helping clear the Science District of the Anomalies, the Conclave threw us into the Libram Dungeons! They're going to decide our fate while we languish in prison! Ugh!",
	:QuestDescription6 => "After spending a few hours in the Libram Dungeon, we were rescued by some rebels from the Argent Revolution. We now have to fight our way through the dungeon to escape before the Conclave find out we've escaped.",
	:QuestDescription7 => "We managed to escape the dungeon. Aldric attempted to sic an empowered Anomaly on us but it ended up consuming him instead. Tyrone from the Argent Revolution was then able to kill it with a Shadowstone. He's now opened a secret exit to the side that will take us to the Market District of Libram City.",
	:QuestDescription8 => "We've learned more about the powdered substance that can be weaponized into Shadowstones against the Anomalies. Our first step to secure more of this substance will be to liberate the Aether Mine in the Mining District. Tyrone will be waiting for us at the entrance.",
	:QuestDescription9 => "Tyrone will be waiting for us at the Mine elevator to take us down to Level 1 of the Aether Mine. We should meet with him there as soon as we can.",
	:QuestDescription10 => "Tyrone has instructed us to find the Mine superintendents on each of the 3 levels, relieve them of their keycards and meet with him near the entrance of the elevator shaft of Level 3 when completed.",
	:QuestDescription11 => "Tyrone has instructed us to wait with him on the executive level of the Aether Mine to assist him with the ambush of Grigori Stoneheart. Speak with Tyrone when you are ready to begin the ambush.",
	:QuestDescription12 => "After deposing Grigori and handing him over to the Argent Revolution to transfer to the benefactor, Tyrone has asked us to continue supporting the Argent Revolution in their liberation of Libram City. We are to meet him in the Science District for next steps.",
	:QuestDescription13 => "Tyrone will be waiting for us in the Power Plant of the Science District, where they are to begin their infiltration.",
	:QuestDescription14 => "Tyrone has deployed a virus that has brought down the security perimeter of the Power Plant and caused a power surge. We need to commandeer the facility from the control of Thaddeus Verne before he discovers the Argent Revolution's infiltration.",
	:QuestDescription15 => "Caitlin has discovered that the Conclave may have been pumping a chemical in through the ventilation system to subjugate the people of the Market District. Thaddeus is likely waiting deeper within the Power Plant.",
	:QuestDescription16 => "Thaddeus was disarmed but now while Tyrone's forces search for Alexis to ensure her safety as well as arm their soldiers with Shadowstones, we need to proceed ahead to the Arboretum to confront Elara and take her out.",
	:QuestDescription17 => "Cara has instructed us to make our way to the Orchidarium and ensure Elara doesn't have the support of her security guards.",
	:QuestDescription18 => "After dealing with Elara's security guards in the Arboretum, we have hopefully cut off her reinforcements so we can take her on without fear of having her security outnumber us.",
	:QuestDescription19 => "After defeating and apprehending Elara, we discovered that she had drugged and imprisoned Alexis Thorne. We have now rescued her and are to meet up with Tyrone, Alexis and the rest of the team at an Argent Revolution safehouse in the Arcane District.",
	:QuestDescription20 => "We have finished debriefing Alexis on what has transpired with the Argent Revolution, the benefactor and her father's fate. We now have to meet with the others in the Civil District for the final step of the Argent Revolution coup by dealing with Victor.",
	:QuestDescription21 => "Cara senses something amiss as the Civil District does not appear to have many security forces around. She has told us that we have Argent Revolution guards in the vicinity to help protect against a possible ambush.",
	:QuestDescription22 => "Victor was the Argent Revolution's benefactor all along. Despite his complicity in the Conclave's coup, he wants to support Alexis while the city prepares itself against the threat of the Anomalies. He wants to show our group what they fight for: the Grand Pylon.",
	:QuestDescription23 => "Victor has revealed that Anomalies now patrol the border outside Libram City and it is no longer safe for us to leave the way we came in. In the meantime, we don't know what has happened to our friends and if they are still alive.",
    :RewardString => "Continue Post Game Story."
  }

  CHAPTER17_POSTGAME_STORY = {
    :ID => "917",
    :Name => "CHAPTER 16: THE AETHER SIEGE",
    :QuestGiver => "Postgame Story",
    :Stage1 => "Part 1",
    :Stage2 => "Part 2",
    :Stage3 => "Part 3",
    :Stage4 => "Part 4",
	:Stage5 => "Part 5",
	:Stage6 => "Part 6",
	:Stage7 => "Part 7",
	:Stage8 => "Part 8",
	:Stage9 => "Part 9",
	:Stage10 => "Part 10",
	:Stage11 => "Part 11",
	:Stage12 => "Part 12",
	:Stage13 => "Part 13",
	:Stage14 => "Part 14",
	:Stage15 => "Part 15",
	:Stage16 => "Part 16",
	:Stage17 => "Part 17",
	:Stage18 => "Part 18",
    :Location1 => "Revolution Safehouse",
    :Location2 => "Revolution Safehouse",
	:Location3 => "Revolution Lab",
	:Location4 => "Libram Port",
	:Location5 => "Libram Trench",
	:Location6 => "Guulrahn Badlands",
	:Location7 => "Bootes Encampment",
	:Location8 => "Bootes Encampment",
	:Location9 => "Abandoned Shelter",
	:Location10 => "Guulrahn Wastes",
	:Location11 => "Guulrahn Wastes",
	:Location12 => "Guulrahn Wastes",
	:Location13 => "The Hive",
	:Location14 => "The Hatchery",
	:Location15 => "Bootes Encampment",
	:Location16 => "Bootes Encampment",
	:Location17 => "Libram City Hall",
	:Location18 => "Revolution Safehouse",
	:QuestDescription1 => "You need to devise a plan to deal with the Anomalies that now patrol the border outside Libram City as the government has finally come around to realizing the existential threat they pose to the denizens of the city.",
	:QuestDescription2 => "The Argent Revolution security guard has told me to go back to the Revolution Safehouse where the others are planning our next steps in the defense of Libram City.",
    :QuestDescription3 => "Tyrone has authorized us to visit the Revolution Lab that was built in the basement of the Revolution Safehouse. They have been keeping the ex-Conclave as prisoners there and Victor wishes to speak with them in their prison cells.",
	:QuestDescription4 => "You have devised a plan with the Conclave's help that involves you returning to the surface of the In-Between to find evidence of early Libram City pioneers and some novel technology they had developed. Cara is waiting for you at the Libram City Port for next steps.",
	:QuestDescription5 => "Tyrone and the Argent Revolution have done some scouting and verified Grigori's claims of a small underwater passage that will let you exit the city without being detected by the Anomalies patrolling the perimeter of Libram City.",
	:QuestDescription6 => "An initial waypoint has been restored on the surface of the Guulrahn Badlands, enabling quick access back to Libram City. Cara has gone ahead to keep investigating what is deterring Anomalies from venturing through into the underwater cavern back to Libram City.",
	:QuestDescription7 => "You have stumbled upon an encampment that seems to be completely deserted. Cara, Tyrone and yourself have split up to investigate the encampment and see if you can find anything meaningful.",
	:QuestDescription8 => "You have come across information about the lives of the early surface pioneers, the threat of the Anomalies that lurked on the borders of the encampment and the inventions of a man named Dr. Emil Liano. And then you heard a sound come from a nearby shelter...",
	:QuestDescription9 => "You have managed to reunite with Sienna and Aki and they caught you up on all that happened while you were in Libram City. Your next step is to reclaim some of these pulse spark cores that is expected to manifest at this minor pulse spark event in the Guulrahn Wastes.",
	:QuestDescription10 => "Emil's notes indicate that a minor pulse spark event is scheduled to happen in the north-east end of the Guulrahn Wastes, outside of the Nesting Grounds but still within the safety of the perimeter ward system that repels Anomalies.",
	:QuestDescription11 => "After recovering a small yield of pulse spark cores at the minor pulse spark event, Cara has instructed you to meet her outside the large cavern where the major pulse spark event is scheduled to occur.",
	:QuestDescription12 => "Cara has advised that we destroy the Anomaly egg sac clusters throughout the Hive to ensure that when the major pulse spark event happens, the Anomaly's reinforcements are cut-off so they don't overwhelm you when they come in search of the pulse spark cores that will manifest.",
	:QuestDescription13 => "After cleansing out the egg sac clusters from each of the Hive's 3 levels, the Anomalies' forces will hopefully be sufficiently reduced that you will be able to fight off any of them that come hungering when the major pulse spark event happens at the bottom level of the Hive.",
	:QuestDescription14 => "Christina has allowed you to leave with your life and with an unconscious Emil, and promised not to harm your friends so long as you find a way to help her bide her time and consolidate her forces to mount a resistance to Leviathan's control.",
	:QuestDescription15 => "Emil has awoken and is willing to help Libram City learn how to unify aether and anti-aether energy and channel the latent power of the Grand Pylon to defend itself against Leviathan and his Anomalies. The teleportation master has advised that the waypoint back to Libram City has also been restored.",
	:QuestDescription16 => "The rest of the group have returned back to Libram City. Cara has instructed you to meet with Victor and the others in Libram City Hall to discuss your group's plans on how to leverage Emil's expertise, and rescue Aki and the others from Christina.",
	:QuestDescription17 => "After introducing your compatriots to Emil, your group has devised a plan to recover the artificial Sigils from the remnants of the Epoch Corporation HQ to use to empower Christina. Cara has instructed you to meet her in the Revolution Safehouse to discuss next steps.",
	:QuestDescription18 => "While Emil works with Caitlin to determine how to create a sustainable source of unified resonance, your next step involves returning to the Hive to parley with Christina and relay to her your plan to empower her with the artificial Sigils.",
    :RewardString => "Continue Post Game Story."
  }

  CHAPTER18_POSTGAME_STORY = {
    :ID => "918",
    :Name => "CHAPTER 17: UNLIKELY ALLIES",
    :QuestGiver => "Postgame Story",
    :Stage1 => "Part 1",
    :Stage2 => "Part 2",
    :Stage3 => "Part 3",
	:Stage4 => "Part 4",
	:Stage5 => "Part 5",
	:Stage6 => "Part 6",
	:Stage7 => "Part 7",
	:Stage8 => "Part 8",
	:Stage9 => "Part 9",
	:Stage10 => "Part 10",
	:Stage11 => "Part 11",
	:Stage12 => "Part 12",
	:Stage13 => "Part 13",
	:Stage14 => "Part 14",
	:Stage15 => "Part 15",
	:Stage16 => "Part 16",
	:Stage17 => "Part 17",
	:Stage18 => "Part 18",
	:Stage19 => "Part 19",
	:Stage20 => "Part 20",
	:Stage21 => "Part 21",
	:Stage22 => "Part 22",
	:Stage23 => "Part 23",
	:Stage24 => "Part 24",
	:Stage25 => "Part 25",
	:Stage26 => "Part 26",
    :Location1 => "Revolution Safehouse",
    :Location2 => "The Hive L1",
	:Location3 => "The Hatchery",
	:Location4 => "Draco Falls",
	:Location5 => "Draco Trench",
	:Location6 => "Flooded Base",
	:Location7 => "ECHQ Wreckage",
	:Location8 => "Revolution Safehouse",
	:Location9 => "Route 18A",
	:Location10 => "Norma Town",
	:Location11 => "Tucana City",
	:Location12 => "Tucana Bayou",
	:Location13 => "Destroyed Lab",
	:Location14 => "Destroyed Lab",
	:Location15 => "Destroyed Lab",
	:Location16 => "Beta Omicron",
	:Location17 => "Beta Omicron",
	:Location18 => "Beta Omicron",
	:Location19 => "The Trenches",
	:Location20 => "The Battlefront",
	:Location21 => "No Man's Land",
	:Location22 => "Beta Omicron",
	:Location23 => "Commander's Tent",
	:Location24 => "Beta Omicron",
	:Location25 => "The Grand Pylon",
	:Location26 => "The Grand Pylon",
	:QuestDescription1 => "Cara has instructed you to meet with her and Sienna in the first level of the Hive so that you can approach Christina with your proposal to entrust her with the Sigils to help build her own forces to contest Leviathan.",
	:QuestDescription2 => "Cara and Sienna will meet you down at the bottom-most level of the Hive (the Hatchery). Christina has erected a fast way down to the bottom-most level so you don't need to trek through the entire cave again.",
    :QuestDescription3 => "Christina has agreed to your plan but is demanding to accompany you as you find the artificial Sigils; however, she has torn open a rift back to the Orion Region to help facilitate your return.",
    :QuestDescription4 => "After taking the rift back to the Orion Region, you have arrived in Draco Falls; Christina has suggested that there is likely an underwater base that the Ethereal Guild had built that will have a teleporter back to the Epoch Corporation HQ Wreckage.",
	:QuestDescription5 => "Cara has found the underwater base; Christina and Sienna have already gone ahead and are awaiting your arrival. Go through the underwater tunnel in Draco Trench and surface where the light is filtering from above.",
	:QuestDescription6 => "Upon entering the compromised Flooded Base, security alerts started going off causing the remaining security bots still active in the base to start patrolling around. Your objective is to find a teleporter that will get you to Epoch Corporation HQ Wreckage quickly.",
	:QuestDescription7 => "You found a teleporter that takes you somewhere. Christina and the others have already taken it to figure out what's on the other side. Best to follow after them to continue your search for the artificial sigils.",
	:QuestDescription8 => "You defeated an infested Dr. Leduc, but he used the artificial Sigils to compel Christina and vanished. He said he needed to recharge his artificial Sigils using a stabilized pulse spark core. You can go directly to the Arcane District or speak to Sienna in the ECHQ Wreckage to return with her.",
	:QuestDescription9 => "Caitlin has suggested that Dr. Leduc may have abducted Christina and taken her to a former Epoch Corporation black site north of Tucana City that suffered from a radioactive explosion. She will meet you at the entrance of Route 18A, east of Ara City for next steps.",
	:QuestDescription10 => "After meeting the group at Route 18A, Cara advised that we need to follow Caitlin to Norma Town so we can find where she has her special lab setup. Hopefully she can devise the remedy to the radiation poisoning soon...",
	:QuestDescription11 => "It turns out Caitlin was messing with us, and had the radiation poisoning remedy all along. She just wanted to come back to the Orion Region to get away from Ronnie and gamble a bit. Cara and the others are going ahead to Tucana City and will meet the rest of the group over there.",
	:QuestDescription12 => "Caitlin's gambling has gotten her into some trouble with the Norma Town mob and is now on the run from petty criminals. All the same, she's the genius of our group and we can't let her get abducted or killed. She's ran off into the Tucana Bayou.",
	:QuestDescription13 => "After beating away the gang members pursuing Caitlin, we have finally arrived at the radioactive remains of the Tucana Lab. Caitlin was able to open the way in so now we need to investigate what we can inside and hopefully find traces of Dr. Leduc and Christina.",
	:QuestDescription14 => "Caitlin has been able to use the surveillance system to confirm that Dr. Leduc and Infested Christina are holed up in the basement of the lab facility. We need to get to them and liberate her as quickly as we can.",
	:QuestDescription15 => "We were able to liberate Christina from Dr. Leduc's control. She absorbed his essence and has now torn open a rift that takes you back to the In-Between. We need to follow her and secure the other side to prevent Anomalies from pouring through the rift.",
	:QuestDescription16 => "We went through the rift and arrived in a military base that Libram City has built... they are under attack by Anomalies. Tyrone is leading the defense. We are going to escort him back to the Commander's tent to debrief what has transpired in our absence.",
	:QuestDescription17 => "Emil has helped recharge the artificial Sigils to allow Christina to use them against the invading Anomaly forces. Caitlin and Sienna will work on reinforcing the base while Cara and I take the fight to the Anomalies.",
	:QuestDescription18 => "The artificial Sigils have worked like a charm! Christina is able to seamlessly control the minor Anomalies. She has charged ahead to start amassing her own legions while we are to trail behind and support her.",
	:QuestDescription19 => "Leviathan has sent some of his strongest generals into the battlefield. Cara channelled the power of the Soulstones to help defend us against one. Christina was able to assimilate one of them to grow her own power but there are apparently two more.",
	:QuestDescription20 => "With Cara's help, I was able to weaken the 2nd Anomaly General for Christina to assimilate. Christina's power continues to grow but every time Cara taps into her Soulstone to help us, it drains her energy significantly... even she is unsure why that's happening.",
	:QuestDescription21 => "Christina managed to assimilate the final member of Leviathan's Depraved Trinity. Tyrone met us on the battlefield just as she had finished consuming him to recall us back to the base to brace ourselves for Leviathan's arrival.",
	:QuestDescription22 => "Tyrone has given me some time to prepare. He has told me to speak to him in front of the campfire at Beta Omicron when I'm ready to initiate the next sequence of events.",
	:QuestDescription23 => "Leviathan's attack has begun. His arrival has prompted aether-powered explosions throughout the Eridanus cave network while he taunts us telepathically. Libram City forces have retreated back into the safety of the city walls behind the barrier.",
	:QuestDescription24 => "Christina devised a plan to deceive Leviathan into thinking that his generals were trying to usurp his power and she was always on his side. She appealed to his vanity to convince him that she was preparing the Grand Pylon to enable his evolution.",
	:QuestDescription25 => "aaaa.",
	:QuestDescription26 => "aaaa.",
    :RewardString => "Continue Post Game Story."
  }

  CHAPTER19_POSTGAME_STORY = {
    :ID => "919",
    :Name => "CHAPTER 18: THE HUNT FOR A GOD",
    :QuestGiver => "Postgame Story",
    :Stage1 => "Part 1",
    :Stage2 => "Part 2",
    :Stage3 => "Part 3",
	:Stage4 => "Part 4",
	:Stage5 => "Part 5",
	:Stage6 => "Part 6",
	:Stage7 => "Part 7",
	:Stage8 => "Part 8",
	:Stage9 => "Part 9",
	:Stage10 => "Part 10",
	:Stage11 => "Part 11",
	:Stage12 => "Part 12",
	:Stage13 => "Part 13",
	:Stage14 => "Part 14",
	:Stage15 => "Part 15",
	:Stage16 => "Part 16",
	:Stage17 => "Part 17",
	:Stage18 => "Part 18",
	:Stage19 => "Part 19",
	:Stage20 => "Part 20",
	:Stage21 => "Part 21",
	:Stage22 => "Part 22",
	:Stage23 => "Part 23",
	:Stage24 => "Part 24",
	:Stage25 => "Part 25",
	:Stage26 => "Part 26",
	:Stage27 => "Part 27",
    :Location1 => "Libram City Hall",
    :Location2 => "Commander's Tent",
	:Location3 => "Commander's Tent",
	:Location4 => "Beta Omicron",
	:Location5 => "Lupus Refuge",
	:Location6 => "Lupus Refuge",
	:Location7 => "Swamp of Sorrows",
	:Location8 => "The Overgrowth",
	:Location9 => "Felfire Canyon",
	:Location10 => "Deadwind Pass",
	:Location11 => "Leviathan's Maw",
	:Location12 => "Castle Leviathan - Foyer",
	:Location13 => "Castle Leviathan - Cellar",
	:Location14 => "Castle Leviathan - Cellar",
	:Location15 => "Castle Leviathan - Library",
	:Location16 => "Castle Leviathan - Library",
	:Location17 => "Castle Leviathan - Kitchen",
	:Location18 => "Castle Leviathan - Kitchen",
	:Location19 => "Castle Leviathan - Chapel",
	:Location20 => "Castle Leviathan - Chapel",
	:Location21 => "Castle Leviathan - Foyer",
	:Location22 => "Throne of Chaos",
	:Location23 => "Cara's Fear",
	:Location24 => "Cara's Hesitation",
	:Location25 => "Cara's Despair",
	:Location26 => "Durance of the Prime",
	:Location27 => "Durance of the Prime",
	:QuestDescription1 => "Leviathan has been severely weakened by the unified resonance trap. He fled but Christina can sense him and has an idea on how to track him using her ability to tap into the Anomaly hivemind. You need to discuss the next steps on how to hunt him down with the others at Libram City Hall.",
	:QuestDescription2 => "Christina tapped into the Anomaly hivemind and learned that Leviathan has retreated to his castle. She has advised it is safest to travel to one of the waypoints nearest to his castle to continue your pursuit of him. She has also agreed to release her hostages back to you.",
    :QuestDescription3 => "Aki, Artie and Ezreal were returned safely to Beta Omicron after being held as Christina's hostages. Ezreal has advised that the closest waypoint to travel to nearest to Leviathan's Castle will be the one at Lupus Refuge. Speak to Cara to advance.",
    :QuestDescription4 => "Cara has decided that you, her, Caitlin, Artie and Ezreal will be the first to travel to the Lupus Refuge. The waypoint master of Beta Omicron is working on rebuilding a pathway to enable teleportation to that location.",
	:QuestDescription5 => "The waypoint master of Beta Omicron has created a portal for your use to travel to the Lupus Refuge but Caitlin freaking ran through it like a maniac! We need to follow her!",
	:QuestDescription6 => "You arrived in Lupus Refuge in the midst of a human settlement. You have met with one of Ezreal's old friends: Cain. He seems to have a lot of information about how the people of this village have survived this long. Cara is waiting outside the camp; speak to her to advance further.",
	:QuestDescription7 => "I met with Cara and Ezreal outside the Lupus Refuge. They said that for now, we need to make it through the next few areas without Christina to help us. We don't want to incite panic by parading an infested human through the Lupus Refuge. She has told me to meet the rest of the group at the entrance to the Overgrowth.",
	:QuestDescription8 => "Artie and Caitlin met up with us at the entrance of the Overgrowth. We're still early in our journey up Mt.Icarus but we'll make it. Complicating matters further, as we advance further through this place, we'll now have to be wary of those human cultists that serve Leviathan as well as the hostile environment.",
	:QuestDescription9 => "Sienna and Aki met up with us at the entrance of the Felfire Canyon. Apparently, this is the place where the Time Wraith Icarus fell to an Anomaly and created Leviathan. We want to move through this place as fast as we can. Sienna and Aki have paired up while Cara has gone ahead with Manaphy to get through this area.",
	:QuestDescription10 => "I've reached the Deadwind Pass. We're almost to Leviathan's fortress... just two more areas remain. The others have already advanced ahead while Cara is trailing behind to make sure all of us get to the checkpoints safely.",
	:QuestDescription11 => "We have summoned Christina to us at the entrance to Leviathan's fortress. Surprisingly, she turned down our plan to consume the Orb of Creation herself, and instead said that we should keep it as a backup plan. She has broken a hole in the door to Leviathan's fortress to begin the attack.",
	:QuestDescription12 => "Artie, Aki, Caitlin and Sienna got teleported to the different wings of Leviathan's fortress through Leviathan's deception. Christina and Ezreal got split up from us and a barrier has re-appeared preventing us from following them. We need to find a key that may help us unlock the beacon to the Cellar.",
	:QuestDescription13 => "Cara has instructed me to find a key somewhere in the Cellar. It could be on roaming phantoms, from the cultists, or just found somewhere on the floor. I need to search wherever I can for this key and when I do, return back to the bottom-left beacon to go to where Artie would have been teleported.",
	:QuestDescription14 => "Leviathan was puppeting Artie... his telepathic influence is strong that he was able to remotely control Artie and force him to fight me. Fortunately, I was able to free him from his possession after exorcising Leviathan's influence from him. I now need to progress to the Library to do the same for Aki.",
	:QuestDescription15 => "Similar to the Cellar, I need to find a key that will unlock the top-left beacon on the Foyer area to teleport to where Aki would have been teleported. It may be found on any of the cultists, phantoms roaming the area or just on the floor of the Library. I'll find it eventually... hopefully.",
	:QuestDescription16 => "Similar to Artie, Aki was also being controlled against his will. What we don't understand is why he's not infested our friends after capturing them... In any case, I need to proceed to the Kitchen to try to find a key to rescue Caitlin.",
	:QuestDescription17 => "Similar to the Cellar and Library, there should be a key somewhere in the Kitchen of Leviathan's Castle. It might be in some of the hidden barrels or cultists. When I find the key, I need to go to the bottom right teleporter of the Foyer to teleport to where Caitlin would have been sent.",
	:QuestDescription18 => "I was able to rescue Caitlin; now I need to proceed to save Sienna. A key to the Chapel beacon will be found in the Chapel somewhere so I need to make my way there, find the key, and then come back to the Foyer area to unlock the last beacon.",
	:QuestDescription19 => "The last part of Leviathan's Castle is the Chapel. A key that unlocks the beacon to where Sienna was sent will be found somewhere in this area. When I find it, the top right beacon at the entrance of the Foyer area will send me to where Sienna is being kept.",
	:QuestDescription20 => "I managed to find the last key to unlock the beacon and rescued Sienna. The barrier back in the Foyer has now been lifted and I can pursue Christina and Ezreal.",
	:QuestDescription21 => "This is ominous... a large portal is at the centre of the Castle... it seems like Christina and Ezreal may already be on the other side. We need to hurry as they may have already started battling Leviathan.",
	:QuestDescription22 => "Leviathan used his telepathic powers to force Ezreal and Christina to fight us. He THEN absorbed Christina and fought us himself. We defeated him initially but his rage set off explosions that knocked the others out and shattered Cara's Soulstone, vacuuming Ezreal, Cara, Manaphy and myself in.",
	:QuestDescription23 => "Manaphy and I appear to be within the prison of the Soulstone itself... although there is no sign of Cara, Ezreal or Leviathan. We need to trudge through this place and try to find them before the corrupting influence of Leviathan desecrates the entire Soulstone prison.",
	:QuestDescription24 => "I found Manaphy in front of a door that takes us down to the next level of the Soulstone prison. There's no sign of Cara, Ezreal or Leviathan in here... At the same time, I've been hearing a cold, robotic voice. I'm unsure why I can hear it...",
	:QuestDescription25 => "Manaphy thinks the Mindlink Prime might be helping us. Anytime we mention the Orb of Creation and the fact that it might be the key to stopping Leviathan, it seems to open doors for us. We think it may be trying to get us to help purge Leviathan's infestation from its prison in the Soulstone.",
	:QuestDescription26 => "We found Ezreal. He was similarly vacuumed up into the rift like us. We tried to open the door by talking about the Orb of Creation, and sure enough it opened! We think Leviathan may have cornered Cara already... we need to hurry!",
	:QuestDescription27 => "We defeated Leviathan. He merged with the Mindlink but Ezreal sacrificed himself by forcing him to absorb him after harnessing the power of the Orb of Creation. He gained enough power, but then we used the sigils to suppress his power locking him in a stalemate against Leviathan.",
    :RewardString => "Post Game Story Completed."
  }

  CHAPTER20_POSTGAME_EPILOGUE = {
    :ID => "920",
    :Name => "POST GAME: EPILOGUE",
    :QuestGiver => "Post-Game Epilogue",
    :Stage1 => "Part 1",
    :Stage2 => "Part 2",
    :Stage3 => "Part 3",
    :Location1 => "Lupus Refuge",
	:Location2 => "Deadpool Epilogue Cutscene",
	:Location3 => "Lupus Refuge",
	:QuestDescription1 => "You debrief the entire group on what happened when fighting Leviathan with Ezreal's sacrifice, the stalemate between Leviathan and the Mindlink Prime, etc. The group decides what to do next now that Leviathan's evil has been kept at bay... for at least a time.",
    :QuestDescription2 => "This is an end credits scene much like what you saw after Deadpool in movies. The entire dialogue is ripped off Deadpool using this game's best character: Caitlin.",
	:QuestDescription3 => "You have cleared the post-game and epilogue content of Soulstones 2: Time Wardens. Thank you for playing. Make sure to present your hall of fame entry (accessible through your PC) in the Soulstones and Time Wardens Discord for a special role!",
    :RewardString => "Post Game Epilogue Completed."
  }

    BONE_COLLECTING = {
    :ID => "2",
    :Name => "Bone Collecting",
    :QuestGiver => "Elizabeth",
    :Stage1 => "Collect Bones.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Orion Region",
	:Location2 => "Orion Region",
	:QuestDescription1 => "Find 50 Hollow Bones and 10 Corrupted Bones throughout the Orion Region and return to Elizabeth in Dr. Campbell's Lab when completed.",
	:QuestDescription2 => "You returned the bones to Elizabeth in Dr. Campbell's Lab and she was able to resurrect an Eternatus for you.",
    :RewardString => "Legendary Pokemon"
  }

    RABID_ANIMAL = {
    :ID => "3",
    :Name => "Rabid Animal",
    :QuestGiver => "Chester",
    :Stage1 => "Investigate the footprints.",
	:Stage2 => "Speak to Chester",
	:Stage3 => "Plant a berry trap.",
	:Stage4 => "Return to Chester.",
	:Stage5 => "Quest Completed.",
    :Location1 => "Cygnus Village",
	:Location2 => "Europa Lake",
	:Location3 => "Europa Forest",
	:Location4 => "Cygnus Village",
	:Location5 => "Cygnus Village",
    :QuestDescription1 => "Find clues as to who or what has been rifling through Chester's garbage and making a mess on his lawn.",
	:QuestDescription2 => "Return to Chester now that you've identified the Pinap berry remains among the footprints.",
	:QuestDescription3 => "Plant Pinap Berries in the Spinarak-woven webs of Europa Forest to lure out the culprit.",
	:QuestDescription4 => "Return to Chester after having dealt with the Sentret that was making a mess on his lawn for your reward.",
	:QuestDescription5 => "You helped Chester identify that a Sentret was responsible for making a mess on his lawn.",
    :RewardString => "3 Super Potions, 3 Great Balls and $1,000"
  }
  
    SHORE_CLEANING = {
    :ID => "4",
    :Name => "Shore Cleaning",
    :QuestGiver => "Tyler",
    :Stage1 => "Clear the Trubbishes",
	:Stage2 => "Speak to Concierge",
	:Stage3 => "Confront the Biker.",
	:Stage4 => "Quest Completed.",
	:Stage5 => "Quest Completed.",
    :Location1 => "Auriga Bay/Town",
	:Location2 => "Auriga Resort",
	:Location3 => "Auriga Bay",
	:Location4 => "Auriga Bay",
	:Location5 => "Auriga Bay",
    :QuestDescription1 => "Clear out the Trubbishes on the shore of both Auriga Town and Auriga Bay.",
	:QuestDescription2 => "Speak to the Concierge at the front desk of Auriga Resort.",
	:QuestDescription3 => "Confront the Biker on the shore of Auriga Bay who has been sabotaging the Auriga Resort by littering and blaming it on the tourists.",
	:QuestDescription4 => "You decided to side with the Conservationist group and allowed Biker Harold to get away with their sabotage.",
	:QuestDescription5 => "You fought off the Conservationist group that was sabotaging the Auriga Resort and taught them a lesson in a Pokemon battle.",
    :RewardString => "Choice dependent."
  }
 
    BEJEWELED = {
    :ID => "5",
    :Name => "Bejeweled",
    :QuestGiver => "Robert",
    :Stage1 => "Collect colour shards.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Europa Cave",
	:Location2 => "Europa Cave",
	:QuestDescription1 => "Find 3 Red, Yellow and Green shards in Europa Cave. Feed them to Carbink on Europa Cave L1 when 3 of each have been collected.",
	:QuestDescription2 => "Fed Robert's Carbink the shards you found and he gave you the Carbink as a reward.",
    :RewardString => "Carbink"
  }
  
    EGG_COLLECTOR = {
    :ID => "6",
    :Name => "Egg Collector",
    :QuestGiver => "Ashley",
    :Stage1 => "Collect Pidgey eggs.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Route 2A",
	:Location2 => "Route 2A",
	:QuestDescription1 => "Recover eggs from Pidgey nests on Route 2A. Beware of hiding Poochyenas.",
	:QuestDescription2 => "You recovered the eggs from the Pidgey nests on Route 2A and shooed away the hiding Poochyenas. Ashley has returned to her home to take care of the remaining Pidgeys.",
    :RewardString => "Feathers and 1 Blue Shard"
  }
  
    LOST_CUBS = {
    :ID => "7",
    :Name => "Lost Cubs",
    :QuestGiver => "Mother Pyroar",
    :Stage1 => "Find lost cubs.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Route 2B",
	:Location2 => "Route 2B",
	:QuestDescription1 => "Recover lost Litleo cubs on Route 2B. Beware of the Sandygast that abducted them.",
	:QuestDescription2 => "You scared off the Sandygast that had abducted the Litleos and returned the lost cubs to the mother Pyroar.",
    :RewardString => "Razor Claw, Sitrus and Oli Berries (x3 each)"
  }
  
    ROBBING_THE_ROBBERS = {
    :ID => "8",
    :Name => "Robbing the Robbers",
    :QuestGiver => "Lucius",
    :Stage1 => "Steal minerals.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Triton Cave",
	:Location2 => "Triton Cave",
	:QuestDescription1 => "Steal minerals from the Ethereal Guild's Carkols in Triton Cave.",
	:QuestDescription2 => "You stole the minerals from the Ethereal Guild's Carkols and returned them to Lucius for a reward.",
    :RewardString => "Ice Gem (x3), Yellow Shard (x3), Blue Shard (x3)"
  }
  
    RAMPAGING_ONIX = {
    :ID => "9",
    :Name => "Rampaging Onix",
    :QuestGiver => "Mike",
    :Stage1 => "Clear 6 Rampaging Onix.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Triton Cave",
	:Location2 => "Triton Cave",
	:QuestDescription1 => "Put down 6 rampaging Onix in Triton Cave.",
	:QuestDescription2 => "You soothed the 6 rampaging Onix in Triton Cave so Mike doesn't fear the cave collapsing in on him.",
    :RewardString => "Binding Band, Heart Scale, Elixir (x3)"
  }

    FAIRY_GODPARENT = {
    :ID => "10",
    :Name => "Fairy Godparent",
    :QuestGiver => "Crocker",
    :Stage1 => "Obtain a Clefairy.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Telescopium City",
	:Location2 => "Telescopium City",
	:QuestDescription1 => "Find a Clefairy for Crocker. Clefairies appear on Route 4A.",
	:QuestDescription2 => "You found a Clefairy for Crocker and gave it to him to fulfill his wish.",
    :RewardString => "Sun Stone, Heart Scale, Hyper Potion (x3)"
  }
  
    NO_TRESPASSING = {
    :ID => "11",
    :Name => "No Trespassing",
    :QuestGiver => "Clayton",
    :Stage1 => "Rescue friends.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Route 4B",
	:Location2 => "Route 4B",
	:QuestDescription1 => "Bring 4 Escape Ropes to Clayton's friends that are stranded on Route 4B.",	:QuestDescription2 => "You rescued the 4 stranded hikers on Route 4B and Clayton rewarded you for your trouble.",
    :RewardString => "Heart Scale, Sand Stone, Max Ether"
  }
  
    TORMENTED_SPIRIT = {
    :ID => "12",
    :Name => "Tormented Spirit",
    :QuestGiver => "Aloysius",
    :Stage1 => "Find haunted spirit.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Telescopium Academy",
	:Location2 => "Telescopium Academy",
	:QuestDescription1 => "Monk Aloysius has asked you to find the spirit haunting the halls of the Telescopium Academy.",
	:QuestDescription2 => "You were able to dispel the Espurr spirit haunting the halls of the Telescopium Academy.",
    :RewardString => "Dusk Stone, Hyper Repel (x3), Calcium"
  }
  
    WELL_READ = {
    :ID => "13",
    :Name => "Well Read",
    :QuestGiver => "Greta",
    :Stage1 => "Find lost books.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Telescopium Academy",
	:Location2 => "Telescopium Academy",
	:QuestDescription1 => "Find the 8 books that Medium Greta asked you to find in the Telescopium Academy. Return to her to recall the exact names of the books required.",
	:QuestDescription2 => "You found the 8 books that Medium Greta was looking for and returned them to her.",
    :RewardString => "Heart Scale, Hyper Potion (x3), Green Shard (x3)"
  }
  
    LES_MISERABLES = {
    :ID => "14",
    :Name => "Les Miserables",
    :QuestGiver => "Theresa",
    :Stage1 => "Help less fortunate.",
	:Stage2 => "Meet Theresa at the Orion Docks.",
	:Stage3 => "Fight the Docks Workers.",
	:Stage4 => "Access the Locked Warehouse.",
	:Stage5 => "Access the Condo Basement.",
	:Stage6 => "Confront Theresa's father.",
	:Stage7 => "Quest Completed.",
    :Location1 => "Orion Underground",
	:Location2 => "Orion Underground",
	:Location3 => "Orion Docks",
	:Location4 => "Locked Warehouse",
	:Location5 => "Orion City (Central)",
	:Location6 => "Shipping Basement",
	:Location7 => "Orion City (Central)",
	:QuestDescription1 => "Provide 9 downtrodden residents of the Orion Underground with their requests.",
	:QuestDescription2 => "Meet Theresa at the Orion Docks to continue helping her.",
	:QuestDescription3 => "Fight 5 Docks workers and recover any intelligence you can find about Theresa's father's wrongdoings.",
	:QuestDescription4 => "Use the keycard you obtained from the Docks labourer to investigate the warehouse that was previously locked with Theresa.",
	:QuestDescription5 => "Use the key to access the shipping basement in Orion City Central.",
	:QuestDescription6 => "Confront Theresa's father and demand answers for his actions.",
	:QuestDescription7 => "Theresa's father was killed by a shadowy assassin upon confrontation. He was trying to shield her from the nefarious activities of the Hand. Theresa has regained control of her company and is committed to finding out what she can about the Hand in the meantime.",
    :RewardString => "Various throughout quest chain."
  }
  
    FISHING_THROUGH_SLUDGE = {
    :ID => "15",
    :Name => "Fishing Through Sludge",
    :QuestGiver => "Clive",
    :Stage1 => "Recover lost possessions.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Orion Underground",
	:Location2 => "Orion Underground",
	:QuestDescription1 => "Find Clive's wallet, watch, glasses, ID, and metro pass in the Vanillite.",
	:QuestDescription2 => "You found Clive's lost belongings after sifting through the Vanillites that had stolen his things.",
    :RewardString => "Sitrus Berry (x3), Super Ball (x5), Poison Gem (x3)"
  }
  
    FIVE_FINGER_DISCOUNT = {
    :ID => "16",
    :Name => "Five Finger Discount",
    :QuestGiver => "Draco",
    :Stage1 => "Shoplift from the mall.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Dept. Store",
	:Location2 => "Dept. Store",
	:QuestDescription1 => "Shoplift some items from the shelves of the Dept. Store.",
	:QuestDescription2 => "You helped Draco shoplift some items from the shelves of the Dept. Store and were able to get away with it without being caught by the authorities.",
    :RewardString => "Royal Stone, Green Shard (x3), Red Shard (x3)"
  }

    DRUG_TRAIL = {
    :ID => "17",
    :Name => "Drug Trail",
    :QuestGiver => "Wade",
    :Stage1 => "Talk to Nightclub patrons.",
	:Stage2 => "Meet Server in park.",
	:Stage3 => "Defeat gang members.",
	:Stage4 => "Find gang leader.",
	:Stage5 => "Quest Completed.",
    :Location1 => "Orion Night Club",
	:Location2 => "Orion City (West)",
	:Location3 => "Orion Sewers",
	:Location4 => "Orion Slums",
	:Location5 => "Orion Slums",
	:QuestDescription1 => "Talk to the patrons in the Orion Night Club to find the source of the crescent powder.",
	:QuestDescription2 => "You determined that one of the servers in the Orion Night Club was selling Crescent Powder there. He is willing to give up his source if you meet him in Orion City (West).",
	:QuestDescription3 => "The Server told you that a gang that operates out of the Orion Sewers is responsible for funneling drugs into the city. If you defeat 5 of them within the Sewers, they might give up their boss. Return to Detective Wade afterwards.",
	:QuestDescription4 => "The Ariados Cartel is responsible for funnelling drugs throughout the Orion Region and their HQ is within the Orion Slums. Find the gang leader there.",
	:QuestDescription5 => "The gang leader of the Ariados Cartel was defeated but it seems like the source of the Crescent Powder drugs goes much deeper than just the Ariados Cartel. Wade the OCPD detective has rewarded you for your help thus far.",
    :RewardString => "Multiple rewards throughout quest chain."
  }
  
    NOBODY_WANTS_TO_WORK = {
    :ID => "18",
    :Name => "Nobody Wants To Work",
    :QuestGiver => "Karen",
    :Stage1 => "Serve patrons drinks.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Orion Night Club",
	:Location2 => "Orion Night Club",
	:QuestDescription1 => "Serve drinks to patrons of the Orion Night Club. When completed, return to Karen the Night Club Manager for your reward.",
	:QuestDescription2 => "You were able to cover the shift of the servers and appease the impatient patrons of the Orion Night Club. Karen the Night Club manager has rewarded you for your help.",
    :RewardString => "Heart Scale (x1), Hyper Potion (x5), Protein (x3), TM90 Draining Kiss"
  }

    BURIED_TREASURES = {
    :ID => "19",
    :Name => "Buried Treasures",
    :QuestGiver => "Cameron",
    :Stage1 => "Find lost possessions.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Orion City (West)",
	:Location2 => "Orion City (West)",
	:QuestDescription1 => "Dig through the piles of mud in Orion Park to find Cameron's lost possessions. When completed, return to him in one of the condos of Orion City (West).",
	:QuestDescription2 => "You dug through the piles of mud throughout Orion Park and found Cameron's lost possessions. His girlfriend's Stoutland was behind it, but he dare not risk his relationship with his girlfriend by accusing her dog of griefing him.",
    :RewardString => "Lonely Mint, Jolly Mint, Sassy Mint, TM39 Rock Tomb"
  }
  
    BUSKING_FOR_BUSINESS = {
    :ID => "20",
    :Name => "Busking for Business",
    :QuestGiver => "Lionel",
    :Stage1 => "Drum up business.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Orion City (West)",
	:Location2 => "Orion City (West)",
	:QuestDescription1 => "Advertise Lionel's Act to pedestrians on the streets of Orion Central and Orion East. When enough patrons have been informed of his act, return to him in Orion City (West).",
	:QuestDescription2 => "Lionel was able to make some money after you advertised his act to the pedestrians on the streets of Orion Central and Orion East.",
    :RewardString => "Red Shard (x3), Blue Shard (x3), Psychic Gem (x3), TM31 Macabre Dance"
  }
  
    TO_THE_RATS = {
    :ID => "21",
    :Name => "To the Rats",
    :QuestGiver => "Paolo",
    :Stage1 => "Eliminate Raticates.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Orion Sewers",
	:Location2 => "Orion City (Central)",
	:QuestDescription1 => "Faint or capture 8 Experimental Raticates in the Orion Sewers. When completed, return to Paolo in Orion City (Central).",
	:QuestDescription2 => "The Experimental Raticates in the Orion Sewers have been dealt with, to the relief of Paolo. He has rewarded you for your trouble and commitment to keep his actions secret.",
    :RewardString => "Purple Shard (x3), Normal Gem (x3), Occa Berry (x3), TM82 Echoed Voice"
  }
  
    SEWER_MONSTER = {
    :ID => "22",
    :Name => "Sewer Monster",
    :QuestGiver => "Richard",
    :Stage1 => "Get footage.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Orion Sewers",
	:Location2 => "Orion City (East)",
	:QuestDescription1 => "Richard has asked you to get 6 different clips of footage of the Orion Sewer Monster. When completed, return to him in Orion City (East).",
	:QuestDescription2 => "Richard has cut you in on the reward for securing the footage of the Orion Sewer Monster, which was nothing more than an Indeedee.",
    :RewardString => "Sitrus and Lum Berry (x3 each), Calcium (x3), TM38 Reflect"
  }
  
    SPIDER_HUNTER = {
    :ID => "23",
    :Name => "Spider Hunter",
    :QuestGiver => "Alan",
    :Stage1 => "Eliminate Joltiks.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Orion Sewers",
	:Location2 => "Orion Sewers",
	:QuestDescription1 => "Faint or capture 8 Joltiks in the Orion Sewers. When completed, return to Alan the Vagrant at the entrance of the Orion Sewers.",
	:QuestDescription2 => "You were able to help get rid of the Joltik infestation in the Orion Sewers to help Alan the Vagrant get a decent night's rest.",
    :RewardString => "Zinc (x3), Water Gem (x3), TM29 Sunny Day"
  }

    SCAVENGING_RATS = {
    :ID => "24",
    :Name => "Scavenging Rats",
    :QuestGiver => "Kyle",
    :Stage1 => "Find Pichus.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Orion Slums",
	:Location2 => "Orion Slums",
	:QuestDescription1 => "Find Kyle's 6 Pichus in the Orion Slums.",
	:QuestDescription2 => "You helped Kyle find his 6 lost Pichus that were scavenging around the Orion Slums following the explosion.",
    :RewardString => "Heart Scale (x1), Orange Shard (x3), Sound Gem(x3), TM45 Knock Off"
  }

    GRAZING_SHEEP = {
    :ID => "25",
    :Name => "Grazing Sheep",
    :QuestGiver => "Albert",
    :Stage1 => "Find T.Wooloos.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Route 6A",
	:Location2 => "Route 6A",
	:QuestDescription1 => "Find 6 of Albert's grazing T.Wooloos on Route 6A.",
	:QuestDescription2 => "You were able to help Albert find his 6 lost T.Wooloos that were scattered around Route 6A and he has rewarded you for your trouble.",
    :RewardString => "Heart Scale (x1), 3x Shuca, Rindo + Payapa Berriesm, T.Wooloo"
  }

    GONE_WITH_THE_WIND = {
    :ID => "26",
    :Name => "Gone With The Wind",
    :QuestGiver => "Billy",
    :Stage1 => "Find lost Drifloon.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Route 6B",
	:Location2 => "Route 6B",
	:QuestDescription1 => "Find Billy's Drifloon on Route 6B.",
	:QuestDescription2 => "After chasing down Billy's Drifloon following a series of gusts that blew it away, you were finally able to catch it and return it back to him. He has thanked you with a reward.",
    :RewardString => "Sharp Beak, Red and Blue Shards (x3), TM57 Rest"
  }

    MINE_YOUR_OWN_BUSINESS = {
    :ID => "27",
    :Name => "Mine Your Own Business",
    :QuestGiver => "Choice Dependent",
    :Stage1 => "Chase away Mine Workers.",
	:Stage2 => "Quest Completed.",
	:Stage3 => "Chase away religious zealots.",
	:Stage4 => "Quest Completed.",
    :Location1 => "Mt. Oberon",
	:Location2 => "Mt. Oberon",
	:Location3 => "Mt. Oberon",
	:Location4 => "Mt. Oberon",
	:QuestDescription1 => "Choice dependent - Fight 7 targets based on who you side with.",
	:QuestDescription2 => "You helped chase away the Epoch Corporation miners to the delight of the Fornax town native that was against the mining activities.",
	:QuestDescription3 => "Choice dependent - Fight 7 targets based on who you side with.",
	:QuestDescription4 => "You helped chase away the fanatical Fornax Town sages to the delight of the Epoch Corporation miner that was just trying to do his work.",
    :RewardString => "Choice dependent."
  }

    SEISMIC_MEASUREMENTS = {
    :ID => "28",
    :Name => "Seismic Measurements",
    :QuestGiver => "Robyn",
    :Stage1 => "Conduct seismic tests.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Mt. Oberon",
	:Location2 => "Mt. Oberon",
	:QuestDescription1 => "Conduct seismic tests near 10 vents across Mt. Oberon.",
	:QuestDescription2 => "You helped Robyn with her seismic tests across the 10 vents in Mt. Oberon. She shared with you that apparently the quakes in the area are unnatural and appear to be intentional as a result of the Epoch Corporation's preliminary mine surveying that they are doing.",
    :RewardString => "Orange Shard (x3), Charti, Roseli and Kebia Berry (x3 each), TM12 Spikes"
  }
  
    COLONY_COHESION = {
    :ID => "29",
    :Name => "Colony Cohesion",
    :QuestGiver => "Mathias",
    :Stage1 => "Neutralize 6 frenzied Durant.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Mt. Oberon",
	:Location2 => "Mt. Oberon",
	:QuestDescription1 => "Faint or capture 6 frenzied Durant throughout Mt. Oberon.",
	:QuestDescription2 => "You were able to help neutralize the 6 frenzied Durant throughout Mt. Oberon.",
    :RewardString => "Purple Shard (x3), Fire Gem (x3), Bug Gem (x3), TM19 Round"
  }

    HOSTAGE_RESCUE = {
    :ID => "30",
    :Name => "Hostage Rescue",
    :QuestGiver => "Detective Dent",
    :Stage1 => "Defeat 12 Ethereal Guild henchmen.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Fornax Town Hall",
	:Location2 => "Fornax Town Hall",
	:QuestDescription1 => "Defeat 12 Ethereal Guild henchmen in the Fornax Town Hall.",
	:QuestDescription2 => "You were able to defeat the 12 Ethereal Guild henchmen found throughout the Fornax Town Hall.",
    :RewardString => "Red + Green Shard (x3), Heart Scale (x1), TM21 Razor Shell, Beedrillite"
  }
  
    MANTINE_MANIA = {
    :ID => "31",
    :Name => "Mantine Mania",
    :QuestGiver => "Bubba",
    :Stage1 => "Obtain a Mantine.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Route 8A",
	:Location2 => "Route 8A",
	:QuestDescription1 => "Find a Mantine for Bubba. Mantykes appear on Route 8A and evolve at level 30.",
	:QuestDescription2 => "You were able to find the Pokemon that Bubba was looking for and he thanked you with a reward.",
    :RewardString => "Water Stone, Heart Scale, Super Ball (x5), Blue Shard (x3)"
  }
  
    TEST_OF_SKILL = {
    :ID => "32",
    :Name => "Test of Skill",
    :QuestGiver => "Mr. Miyagi",
    :Stage1 => "Defeat Dojo disciples.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Pisces Village",
	:Location2 => "Pisces Village",
	:QuestDescription1 => "Defeat 7 of Mr. Miyagi's disciples in the Pisces Dojo.",
	:QuestDescription2 => "You were able to best Mr. Miyagi's disciples in the Pisces Dojo.",
    :RewardString => "Tyrogue"
  }
  
    CLAM_CRACKING = {
    :ID => "33",
    :Name => "Clam Cracking",
    :QuestGiver => "Eugene",
    :Stage1 => "Crack open clams.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Pisces Village",
	:Location2 => "Pisces Village",
	:QuestDescription1 => "Crack open 8 clams on Pisces Village beach and bring your finds back to Eugene.",
	:QuestDescription2 => "You were able to recover some treasures from the clams on the beach around Pisces Village. He provided you with a reward for your trouble.",
    :RewardString => "Heart Scale (x1), Pearl (x3), Star Dust (x3), Green Shard (x3)"
  }
   
    SHIP_SALVAGING = {
    :ID => "34",
    :Name => "Ship Salvaging",
    :QuestGiver => "Captain Whitebeard",
    :Stage1 => "Salvage ship debris.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Route 8B",
	:Location2 => "Route 8B",
	:QuestDescription1 => "Salvage whatever you can from 6 debris piles on Route 8B.",
	:QuestDescription2 => "You were able to salvage some of the ship debris and return what you could back to Captain Whitebeard on Route 8B.",
    :RewardString => "Sun Stone (x1), TM10 Shadow Ball, Gengarite"
  }

    MUSHROOM_COLLECTOR = {
    :ID => "35",
    :Name => "Mushroom Collector",
    :QuestGiver => "Darla",
    :Stage1 => "Harvest mushrooms.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Indus Jungles",
	:Location2 => "Indus Jungles",
	:QuestDescription1 => "Harvest 8 tall stalk mushrooms in the Indus Jungles.",
	:QuestDescription2 => "You were able to harvest 8 tall stalk mushrooms in the Indus Jungles.",
    :RewardString => "Offense, Protection, Intellect Vial (x3 each)"
  }
  
    RUINED_RIDDLES = {
    :ID => "36",
    :Name => "Ruined Riddles",
    :QuestGiver => "Barry",
    :Stage1 => "Solve riddles.",
	:Stage2 => "Follow Barry into the Chamber.",
	:Stage3 => "Slay guardian spirits.",
	:Stage4 => "Make offering to statues.",
	:Stage5 => "Slay the Avatar Spirit.",
	:Stage6 => "Quest Completed.",
    :Location1 => "Indus Ruins",
	:Location2 => "Indus Ruins",
	:Location3 => "Indus Shrine",
	:Location4 => "Indus Shrine",
	:Location5 => "Indus Shrine",
	:Location6 => "Indus Shrine",
	:QuestDescription1 => "Answer riddles on stone tablets of Indus Ruins walls.",
	:QuestDescription2 => "Follow Barry into the Chamber.",
	:QuestDescription3 => "Slay the guardian spirits roaming about the Chamber.",
	:QuestDescription4 => "Make an offering to the statues around the ritual circle.",
	:QuestDescription5 => "Collect the relic.",
	:QuestDescription6 => "Barry trifled with the wrong ruined chamber and was petrified by the guardian spirit. You were able to beat it though and secure a reward for yourself.",
    :RewardString => "Various throughout quest chain."
  }
  
    MOSS_SAMPLES = {
    :ID => "37",
    :Name => "Moss Samples",
    :QuestGiver => "Ryan",
    :Stage1 => "Sample mossy rocks.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Indus Caverns",
	:Location2 => "Indus Caverns",
	:QuestDescription1 => "Sample 10 mossy rocks within the Indus Caverns.",
	:QuestDescription2 => "You were able to sample the mossy rocks in the Indus Caverns for Ryan and he rewarded you for your effort.",
    :RewardString => "Blast Powder (x5), Green Shard (x3), Max Revive (x1), TM02 Meteor Drive"
  }
  
    TRIBAL_WARS = {
    :ID => "38",
    :Name => "Tribal Wars",
    :QuestGiver => "Greta",
    :Stage1 => "Defeat 5 tribal Pokemon.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Indus Temple Grounds",
	:Location2 => "Indus Temple Grounds",
	:QuestDescription1 => "Choose to fight 5 of either Nuzleaf or Nosepass or any combination thereof.",
	:QuestDescription2 => "You were able to neutralize the warring tribal Pokemon and return back to Greta  for your reward.",
    :RewardString => "Heart Scale (x1), Dark Gem (x3), Patoto Berry (x3), TM66 Dark Pulse"
  }

    TEMPLE_SENTRIES = {
    :ID => "39",
    :Name => "Temple Sentries",
    :QuestGiver => "Amitabh",
    :Stage1 => "Defeat 15 sentries.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Temple of Time",
	:Location2 => "Temple of Time",
	:QuestDescription1 => "Defeat 15 sentry Pokemon stationed throughout the Temple of Time.",
	:QuestDescription2 => "You were able to neutralize the 15 sentry Pokemon that were patrolling throughout the Temple of Time and Amitabh rewarded you for your trouble.",
    :RewardString => "Power Stone (x1), Orange Shard (x3), Grass Gem (x3), TM78 Substitute"
  }

    BREAKING_DISHES = {
    :ID => "40",
    :Name => "Breaking Dishes",
    :QuestGiver => "Bonnie",
    :Stage1 => "Break 15 urns.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Temple of Time",
	:Location2 => "Temple of Time",
	:QuestDescription1 => "Break 15 small urns within the Temple of Time.",
	:QuestDescription2 => "You were able to break the 15 small urns within the Temple of Time and recover the treasures for Bonnie. She has cut you in on your portion of the reward.",
    :RewardString => "Ice Stone (x1), Yellow/Blue Shard (x3), Aggronite"
  }
  
    TREASURE_DIVING = {
    :ID => "41",
    :Name => "Treasure Diving",
    :QuestGiver => "Lando",
    :Stage1 => "Search 5 underwater houses.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Route 8A Underwater",
	:Location2 => "Route 8A Underwater",
	:QuestDescription1 => "Search 5 underwater ruins on the sea floor of Route 8A for treasure.",
	:QuestDescription2 => "You were able to search the underwater ruins on the sea floor of Route 8A and return back to Lando with the treasure you found.",
    :RewardString => "Relic Band (x1), Heart Scale (x3), Water Gem (x3), TM105 Whirlpool"
  }

    LOST_GUPPIES = {
    :ID => "42",
    :Name => "Lost Guppies",
    :QuestGiver => "Mother Octillery",
    :Stage1 => "Find lost guppies.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Route 8B",
	:Location2 => "Route 8B",
	:QuestDescription1 => "Recover lost Remoraid guppies on Route 8B. Beware of the Grapploct that abducted them.",
	:QuestDescription2 => "You were able to return the lost Remoraid guppies back to the mother Octillery on Route 8B and also deal with the Grapploct that abducted them.",
    :RewardString => "Purple Shard (x3), Sitrus Berry (x3), TM51 Air Slash"
  }

    FURFROU_ENCYCLOPEDIA = {
    :ID => "43",
    :Name => "Furfrou Encyclopedia",
    :QuestGiver => "Neil",
    :Stage1 => "Battle Weather Centre scientists",
	:Stage2 => "Quest Completed.",
    :Location1 => "Mensa Village Weather Centre",
	:Location2 => "Mensa Village Weather Centre",
	:QuestDescription1 => "Battle each of the Weather Centre scientists and learn more about Furfrou's forms.",
	:QuestDescription2 => "You defeated the various Weather Centre scientists and were able to secure a reward following your gauntlet of battles.",
    :RewardString => "Coba Berry (x3), Flying Gem (x3), TM123 Catapult"
  }
  
    ENGAGEMENT_RING = {
    :ID => "44",
    :Name => "Engagement Ring",
    :QuestGiver => "Arthur",
    :Stage1 => "Find Engagement Ring.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Route 7B",
	:Location2 => "Route 7B",
	:QuestDescription1 => "Find Arthur's engagement ring in the piles of colourful leaves on Route 7B.",
	:QuestDescription2 => "Lucky for Arthur, you were able to find his engagement ring in one of the colourful leaf piles on Route 7B.",
    :RewardString => "Chilan Berry (x3), Heart Scale (x1), TM06 Attract"
  }
  
    UNADAPTABLE = {
    :ID => "45",
    :Name => "Unadaptable",
    :QuestGiver => "Maria",
    :Stage1 => "Put down 10 unadaptable Pokemon",
	:Stage2 => "Quest Completed.",
    :Location1 => "Caverns of Rhea",
	:Location2 => "Caverns of Rhea",
	:QuestDescription1 => "Faint or capture 10 unadaptable Ariados and Galvantula rampaging in the Caverns of Rhea.",
	:QuestDescription2 => "You were able to neutralize the distressed Ariados and Galvantula that were unable to adapt to the changes in the Caverns of Rhea ecosystem and put an end to their rampaging.",
    :RewardString => "Offense, Protection and Intellect Vials (x3 each), Heart Scale (x1)"
  }
  
    NOT_ENOUGH_MINERALS = {
    :ID => "46",
    :Name => "Not Enough Minerals",
    :QuestGiver => "Arcturus",
    :Stage1 => "Harvest minerals from 8 Pokemon.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Caverns of Rhea",
	:Location2 => "Caverns of Rhea",
	:QuestDescription1 => "Harvest minerals from 8 Forretress or T.Magneton in the Caverns of Rhea.",
	:QuestDescription2 => "You were able to harvest the minerals from the Forretress and T.Magneton found throughout the Caverns of Rhea.",
    :RewardString => "Colour Shard (x1 each), Heart Scale (x1), TM125 Cluster Rockets"
  }
 

    GOING_BANANAS = {
    :ID => "47",
    :Name => "Going Bananas",
    :QuestGiver => "Marcus",
    :Stage1 => "Put monkey Pokemon to sleep.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Indus Marsh",
	:Location2 => "Indus Marsh",
	:QuestDescription1 => "Put 6 Monkey Pokemon in Indus Marsh to sleep so Marcus can sleep.",
	:QuestDescription2 => "You were able to put the monkey Pokemon found throughout the trees of the Indus Marsh to sleep so Marcus could get some sleep. He rewarded you for your trouble.",
    :RewardString => "Brave Mint, Relaxed Mint, Quiet Mint, Green Shard (x3)"
  }
  
    FISHING_TRAPS = {
    :ID => "48",
    :Name => "Fishing Traps",
    :QuestGiver => "Karthik",
    :Stage1 => "Recover 8 fishing traps.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Route 9A Underwater",
	:Location2 => "Indus Cove",
	:QuestDescription1 => "Recover the contents of 8 fishing traps on the sea floor of Route 9A for Karthik.",
	:QuestDescription2 => "You were able to recover the contents of the fishing traps that Karthik had laid out on the sea floor of Route 9A. He has rewarded you for searching through them for him.",
    :RewardString => "Yellow Shard (x3), Heart Scale, Max Revive, TM97 Ice Beam"
  }
  
    WHALE_HUNTING = {
    :ID => "49",
    :Name => "Whale Hunting",
    :QuestGiver => "Ahab",
    :Stage1 => "Put Moby's spirit to rest.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Route 9B Underwater",
	:Location2 => "Route 9A",
	:QuestDescription1 => "Put the restless spirit of Moby the Wailord down.",
	:QuestDescription2 => "You were able to put the restless spirit of Moby the Wailord to rest. Ahab has thanked you with a reward.",
    :RewardString => "Ultra Repel (x3), X Attack 2, X Defense 2, TM100 Sludge Bomb"
  }
  
    UNDERWATER_FOOTAGE = {
    :ID => "50",
    :Name => "Underwater Footage",
    :QuestGiver => "Jacques",
    :Stage1 => "Get footage.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Route 9B Underwater",
	:Location2 => "Route 9A",
	:QuestDescription1 => "Get footage of 10 underwater gravestones in the underwater houses of Route 9B.",
	:QuestDescription2 => "Jacques has rewarded you for securing the footage of the underwater gravestones throughout the underwater houses found in Route 9B.",
    :RewardString => "Wind Stone, Lum Berry (x3), Tanga Berry (x3), TM63 Rain Dance"
  }
  
    DRUNKEN_SAILORS = {
    :ID => "51",
    :Name => "Drunken Sailors",
    :QuestGiver => "Chad",
    :Stage1 => "Find drunken sailors",
	:Stage2 => "Quest Completed.",
    :Location1 => "Route 9B",
	:Location2 => "Route 9B",
	:QuestDescription1 => "Find Chad's 6 drunken friends wading somewhere on Route 9B.",
	:QuestDescription2 => "You were able to find Chad's drunken friends that were shipwrecked and hanging onto the rocks along Route 9B.",
    :RewardString => "Heart Scale, Babiri Berry (x3), Avoca Berry (x3), TM69 Play Rough"
  }

    ANTI_VENOM = {
    :ID => "52",
    :Name => "Antivenom",
    :QuestGiver => "Mohamed",
    :Stage1 => "Obtain antivenom.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Route 10A",
	:Location2 => "Route 10A",
	:QuestDescription1 => "Obtain anti-venom from 8 Mareanie on Route 10A and bring it back to Mohamed.",
	:QuestDescription2 => "You were able to save Mohamed's life by securing the anti-venom from the Mareanie roaming about Route 10A.",
    :RewardString => "Giga Potion (x3), Full Heal (x3), Revive (x3), Full Restore (x1)"
  }

    RELIC_HUNTING = {
    :ID => "53",
    :Name => "Relic Hunting",
    :QuestGiver => "Indiana",
    :Stage1 => "Find relics.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Sandswept Grotto",
	:Location2 => "Sandswept Grotto",
	:QuestDescription1 => "Find 9 relics in the Sandswept Grotto.",
	:QuestDescription2 => "You were able to find the 9 relics that Indiana instructed you to find in the various sections of the Sandswept Grotto.",
    :RewardString => "Relic Statue, TM117 Dune Blast, Yache Berry (x3), Glalite"
  }
  
    PERSIAN_PELTS = {
    :ID => "54",
    :Name => "Persian Pelts",
    :QuestGiver => "Nigel",
    :Stage1 => "Obtain 7 pelts.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Route 10B",
	:Location2 => "Route 10B",
	:QuestDescription1 => "Obtain 7 Persian Pelts by fainting or capturing Persian on Route 10B.",
	:QuestDescription2 => "You were able to secure the Persian Pelts for Nigel the Poacher. He has rewarded you for your efforts.",
    :RewardString => "Chople Berry (x3), X-Attack 2 (x3), X-Defense 2 (x3), Heart Scale(x3)"
  }

    BASKET_CAPTURE = {
    :ID => "55",
    :Name => "Basket Capture",
    :QuestGiver => "Martina",
    :Stage1 => "Ambush 8 Aron.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Undersand Caverns",
	:Location2 => "Undersand Caverns",
	:QuestDescription1 => "Capture 8 Aron from sneaking up behind them and throwing a basket on them. They reside within the Undersand Caverns, beneath Route 10B.",
	:QuestDescription2 => "You were able to corner 8 Aron throughout the Undersand Caverns with a basket, capture them, and return them to Martina on the surface of Route 10B.",
    :RewardString => "Kasib Berry (x3), Swarm Stone (x1), Max Revive (x1), Ultra Repel (x5)"
  }

    ANOMALY_ERADICATION = {
    :ID => "56",
    :Name => "Anomaly Eradication",
    :QuestGiver => "Ishmael",
    :Stage1 => "Eradicate Anomalies.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Temple of Space",
	:Location2 => "Temple of Space",
	:QuestDescription1 => "Hunt down 6 hordes of minor Anomalies roaming about the Temple of Space and the Anomaly in the Temple of Space.",
	:QuestDescription2 => "You were able to hunt down and clear out the 6 hordes of minor Anomalies that were rampaging throughout the Temple of Space and the larger Anomaly that was awaiting at the end.",
    :RewardString => "TM71 Flamethrower, Poison Shield, Hatterenite"
  }
  
    JUST_FOLLOWING_ORDERS = {
    :ID => "57",
    :Name => "Just Following Orders",
    :QuestGiver => "Horace",
    :Stage1 => "Rescue EG henchmen.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Temple of Space",
	:Location2 => "Temple of Space",
	:QuestDescription1 => "Direct 9 Ethereal Guild henchmen to evacuate the Temple of Space.",
	:QuestDescription2 => "You were able to help 9 Ethereal Guild henchmen to evacuate the Temple of Space to spare them from the wrath of the Anomalies that were rampaging throughout.",
    :RewardString => "TM86 Stardust Reverie, Orange and Purple Shard (x3 each)"
  }
  
    DYING_LETTER = {
    :ID => "58",
    :Name => "Dying Letter",
    :QuestGiver => "Envelope",
    :Stage1 => "Return letter to Bella.",
	:Stage2 => "Quest Completed.",
    :Location1 => "The In-Between",
	:Location2 => "Eridanus Settlement",
	:QuestDescription1 => "Find the person named Bella to return the letter you found in the In-Between.",
	:QuestDescription2 => "You were able to find Bella and return the letter you found to her in the Eridanus Settlement.",
    :RewardString => "Giga Potion (x3), Full Heal (x3), Max Revive (x1), Full Restore (x1)"
  }

    SALVAGING_SUPPLIES = {
    :ID => "59",
    :Name => "Salvaging Supplies",
    :QuestGiver => "Dying Disciple",
    :Stage1 => "Recover supplies.",
	:Stage2 => "Quest Completed.",
    :Location1 => "The In-Between",
	:Location2 => "Eridanus Settlement",
	:QuestDescription1 => "Recover 14 crates of supplies from the Antimatter Temple and return them to the person leading the Eridanus Settlement.",
	:QuestDescription2 => "You were able to recover the crates of supplies from the Antimatter Temple and return them to the leader of the Eridanus Settlement.",
    :RewardString => "Max Elixir (x3), Offense and Wisdom Vials (x3 each), TM112 Battle of Wits"
  }
  
    ANOMALY_BOUNTY = {
    :ID => "60",
    :Name => "Anomaly Bounty",
    :QuestGiver => "Self",
    :Stage1 => "Eliminate Anomaly Infestation.",
	:Stage2 => "Quest Completed.",
    :Location1 => "The In-Between",
	:Location2 => "Eridanus Settlement",
	:QuestDescription1 => "Eliminate 15 Corrupted Anomaly Slaves in the Antimatter Temple.",
	:QuestDescription2 => "You were able to neutralize 15 Corrupted Anomaly Slaves in the Antimatter Temple.",
    :RewardString => "Haban, Colbur, Kee + Maranga Berry (x3 each), Tsareenite X"
  }
  
    RESTLESS_SPIRITS = {
    :ID => "61",
    :Name => "Restless Spirits",
    :QuestGiver => "Spirit",
    :Stage1 => "Free trapped spirits.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Underwater Temple",
	:Location2 => "Underwater Temple",
	:QuestDescription1 => "Free 11 restless spirits in the Underwater Temple.",
	:QuestDescription2 => "You were able to free the restless spirits roaming the Underwater Temple.",
    :RewardString => "TM115 Soul Shield, Red Shard (x3 each), Protection Vial (x3)"
  }

    FEEDING_TIME = {
    :ID => "62",
    :Name => "Feeding Time",
    :QuestGiver => "Sokka",
    :Stage1 => "Feed Spheals.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Lyra Glacier",
	:Location2 => "Lyra Glacier",
	:QuestDescription1 => "Feed 9 Spheals sitting on the shores as well as paddling in the water along Lyra Glacier.",
	:QuestDescription2 => "You fed the Spheals that you could find throughout the Lyra Glacier. Sokka thanked you with a reward.",
    :RewardString => "Giga Potion (x5), Max Revive, Full Restore"
  }
  
    ICE_FORMATIONS = {
    :ID => "63",
    :Name => "Ice Formations",
    :QuestGiver => "Thea",
    :Stage1 => "Break ice formations.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Charon Ice Tunnels",
	:Location2 => "Charon Ice Tunnels",
	:QuestDescription1 => "Destroy 14 ice formations throughout the 3 wings of the Charon Ice Tunnels.",
	:QuestDescription2 => "You were able to destroy the odd ice formations throughout the 3 wings of the Charon Ice Tunnels.",
    :RewardString => "TM23 Moonblast, Ice Gem (x3), Tentacruelite"
  }
  
    PICKING_FLOWERS = {
    :ID => "64",
    :Name => "Picking Flowers",
    :QuestGiver => "Brigitte",
    :Stage1 => "Collect unique flowers.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Route 12A/12B",
	:Location2 => "Route 12A/12B",
	:QuestDescription1 => "Collect 9 bouquets' worth of flowers from the potted plants dotted across Route 12A and 12B.",
	:QuestDescription2 => "You were able to find 9 bouquets' worth of flowers from the potted plants dotted across Route 12A and 12B.",
    :RewardString => "TM64 Pollen Puff, Grass Gem (x3), Jaboca, Rowap, Custap Berry (x3 each)"
  }
  
    PURGING_GUILD = {
    :ID => "65",
    :Name => "Purging the Guild",
    :QuestGiver => "Self",
    :Stage1 => "Purge the Anomalies.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Underwater Base",
	:Location2 => "Underwater Base",
	:QuestDescription1 => "Eliminate 7 Absorbed Henchmen in the Underwater Base.",
	:QuestDescription2 => "You were able to purge the absorbed henchmen in the Underwater Base.",
    :RewardString => "Offense, Protection and Intellect Vials (x3 each)"
  }
  
    TEST_SUBJECTS = {
    :ID => "66",
    :Name => "Test Subjects",
    :QuestGiver => "Self",
    :Stage1 => "Release Trapped Pokemon.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Epoch Corporation HQ",
	:Location2 => "Epoch Corporation HQ",
	:QuestDescription1 => "Free 7 Trapped Pokemon within the Epoch Corporation HQ.",
	:QuestDescription2 => "You were able to liberate the trapped Pokemon within the Epoch Corporation HQ.",
    :RewardString => "Red and Green Shards (x3 each), Max Revive"
  }

    RESEARCH_NOTES = {
    :ID => "67",
    :Name => "Research Notes",
    :QuestGiver => "Self",
    :Stage1 => "Return Research Notes.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Epoch Corporation HQ",
	:Location2 => "Draco City",
	:QuestDescription1 => "Return Research Notes to Caitlin Linklater in Draco City.",
	:QuestDescription2 => "You were able to return Caitlin's research notes back to her in Draco City.",
    :RewardString => "X-Attack 2 (x3), X-SpAtk 2 (x3), X-Speed 2 (x3)"
  }
  
    LAKE_TRASH = {
    :ID => "68",
    :Name => "Lake Trash",
    :QuestGiver => "Lucy",
    :Stage1 => "Clear Lake Trash.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Route 14B Underwater",
	:Location2 => "Route 14B",
	:QuestDescription1 => "Clear the underwater trenches of Route 14B of 10 piles of garbage.",
	:QuestDescription2 => "You cleared the underwater trenches of Route 14B of the piles of garbage.",
    :RewardString => "Lum + Wacan Berry (x3), Poison Gem (x3), Purple Shard (x3), TM22 Leech Life"
  }
  
    RESCUE_OPERATION = {
    :ID => "69",
    :Name => "Rescue Operation",
    :QuestGiver => "Steven",
    :Stage1 => "Rescue civilians.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Draco City Attack",
	:Location2 => "Draco City Attack",
	:QuestDescription1 => "Rescue 8 stranded civilians within Draco City during the attack on the city.",
	:QuestDescription2 => "You managed to rescue the stranded civilians within Draco City during the attack.",
    :RewardString => "Heart Scale, Max Revive, Full Restore (x3), TM89 Thunderbolt"
  }
  
    SUPPLY_CRATES = {
    :ID => "70",
    :Name => "Supply Crates",
    :QuestGiver => "Lucas",
    :Stage1 => "Recover supply crates.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Draco City Attack",
	:Location2 => "Draco City Attack",
	:QuestDescription1 => "Recover 8 crates of supplies from what remains of Draco City during the attack.",
	:QuestDescription2 => "You recovered the crates of supplies during the attack on Draco City. The refugees thanked you for your help with a reward.",
    :RewardString => "Leftovers, Max Elixir (x3), Giga Potion (x5), Gliscite"
  }

    PIED_PIPER = {
    :ID => "71",
    :Name => "Pied Piper",
    :QuestGiver => "Carlee",
    :Stage1 => "Hunt down the Pied Piper.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Route 17A/17B",
	:Location2 => "Ara City",
	:QuestDescription1 => "Find the fabled Pied Piper that abducted the children of Ara City.",
	:QuestDescription2 => "You found the mythical Pied Piper roaming Route 17 and were able to deal with it. However, Carlee has asked you to keep your actions secret so the town doesn't take away the wrong lesson from the myth.",
    :RewardString => "Yellow Shard (x3), Sound Gem (x3), Rhythm Plate, TM103 Fortissimo"
  }
  
    CHARM_PEDDLER = {
    :ID => "72",
    :Name => "Charm Peddler",
    :QuestGiver => "James",
    :Stage1 => "Recover 8 Relics.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Ruins of Creation",
	:Location2 => "Route 17A",
	:QuestDescription1 => "Find 8 relics within the Ruins of Creation from the tablets that are mounted on the walls. Prepare to face off any spirit guardians that protect them.",
	:QuestDescription2 => "You found relics within the Ruins of Creation that were mounted on the walls and return them to James the charm peddler for a reward.",
    :RewardString => "Spooky Plate, Relic Gold, Tetra Potion (x3), Masquerite"
  }
  
    MENACING_SPIRITS = {
    :ID => "73",
    :Name => "Menacing Spirits",
    :QuestGiver => "Protector",
    :Stage1 => "Chase away 12 Menacing Spirits.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Temple of Creation",
	:Location2 => "Temple of Creation",
	:QuestDescription1 => "Chase away 12 Menacing Spirits from throughout the Temple of Creation, including the various Altars.",
	:QuestDescription2 => "You managed to chase away the menacing spirits found throughout the Temple of Creation, including the various Altars.",
    :RewardString => "Holy Plate, PP Max, Max Revive, Mismagite"
  }
  
    TEMPLE_STASH = {
    :ID => "74",
    :Name => "Temple Stash",
    :QuestGiver => "Temple Stash",
    :Stage1 => "Find 3 Keys.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Temple of Creation",
	:Location2 => "Temple of Creation",
	:QuestDescription1 => "Find 3 keys to insert into a stash in the central wing of the Temple of Creation to see what lies within.",
	:QuestDescription2 => "You found the 3 keys required to unlock the stash in the central wing of the Temple of Creation for a treasure trove of rewards.",
    :RewardString => "Tetra Potion (x3), Full Heal (x3), Heart Scale, TM130 Magic Room"
  }
  
    MATRIX_GUARDIANS = {
    :ID => "75",
    :Name => "Matrix Guardians",
    :QuestGiver => "Arcanine",
    :Stage1 => "Cure 13 Growlithes.",
	:Stage2 => "Quest Completed.",
    :Location1 => "The Time Matrix",
	:Location2 => "The Time Matrix",
	:QuestDescription1 => "Cleanse 13 Growlithes of the Anomalies' virus that have driven them to madness across the various Spires of the Time Matrix.",
	:QuestDescription2 => "You managed to cleanse the Anomaly virus from the infected Growlithes stationed throughout the various Spires of the Time Matrix.",
    :RewardString => "Full Restore (x3), Max Revive (x1), Assault Vest, TM67 Dracarys"
  }
  
    ANOMALY_RESIDUE = {
    :ID => "76",
    :Name => "Anomaly Residue",
    :QuestGiver => "Residue",
    :Stage1 => "Collect 12 vials of residue.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Spires of Creation",
	:Location2 => "The Time Matrix",
	:QuestDescription1 => "Collect 12 vials of Anomaly residue and find a Spirit within the Time Matrix that may be interested in it.",
	:QuestDescription2 => "You were able to collect vials of Anomaly residue for the Spirit within the Time Matrix that was interested in studying it.",
    :RewardString => "Full Restore (x3), Max Revive (x1), Offense + Wisdom Vial (3x each), Garchompite"
  }
  
    LIGHTING_BEACONS = {
    :ID => "77",
    :Name => "Lighting the Beacons",
    :QuestGiver => "Apparition",
    :Stage1 => "Recharge 15 Beacons.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Spires of Creation",
	:Location2 => "The Time Matrix",
	:QuestDescription1 => "Channel your energy to recharge 15 beacons found throughout the Spires of Creation. Beware Starmies, Carbinks and T. Magnezones that may be attracted to you during recharging.",
	:QuestDescription2 => "You were able to recharge the various beacons found throughout the Spires of Creation.",
    :RewardString => "Full Restore (x3), Max Revive (x1), Tetra Potion (x3), TM80 Calm Mind"
  }
  
    CARD_COLLECTOR = {
    :ID => "78",
    :Name => "Card Collector",
    :QuestGiver => "Mr. Fagin",
    :Stage1 => "Win Triple Triad Tournament.",
	:Stage2 => "Quest Completed.",
    :Location1 => "The Black Market",
	:Location2 => "The Black Market",
	:QuestDescription1 => "Win 8 Triple Triad duels in the Black Market Triple Triad Touranment.",
	:QuestDescription2 => "You won the Black Market Triple Triad Touranment.",
    :RewardString => "Big Nugget"
  }

    STOWAWAY_POKEMON = {
    :ID => "79",
    :Name => "Stowaway Pokemon",
    :QuestGiver => "Arthur",
    :Stage1 => "Recover Tangelas.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Lyra City",
	:Location2 => "Lyra City",
	:QuestDescription1 => "Faint or capture 5 Stowaway Tangela in Lyra City. When completed, return to Arthur the Sailor near the Lyra City PokeCentre for your reward.",
	:QuestDescription2 => "You were able to deal with the stowaway Tangela in Lyra City and Arthur the sailor provided you with a reward.",
    :RewardString => "TM128 Pay Day, Bonsly"
  }
  
    TRAPPED_SOLDIERS = {
    :ID => "80",
    :Name => "Trapped Soldiers",
    :QuestGiver => "Persephone",
    :Stage1 => "Rescue trapped soldiers.",
	:Stage2 => "Speak to the witch.",
	:Stage3 => "Find spell ingredients.",
	:Stage4 => "Meet Adria atop the hill.",
	:Stage5 => "Return charm to Persephone.",
	:Stage6 => "Quest Completed.",
    :Location1 => "Shadowmoon Forest",
	:Location2 => "Shadowmoon Marsh",
	:Location3 => "Shadowmoon Marsh",
	:Location4 => "Shadowmoon Marsh",
	:Location5 => "Eridanus Settlement",
	:Location6 => "Eridanus Settlement",
	:QuestDescription1 => "Rescue 5 trapped soldiers that will be found throughout Shadowmoon Forest and Shadowmoon Marsh and escort them to safety. When completed, return to Persephone in the Eridanus Settlement for more information.",
	:QuestDescription2 => "Find the Witch that lives in Shadowmoon Marsh and ask for her help in casting a spell to reinforce the wards around the Eridanus Settlement.",
	:QuestDescription3 => "Adria has told you to secure the wings of a Yanma, the fang of an Arbok and the spores of a Carnivine as well as reclaim the corpse of a deceased Eridanus Settlement soldier. Return to her in her hut when you have secured these ingredients.",
	:QuestDescription4 => "Meet with Adria atop the hill in Shadowmoon Marsh to conduct the warding ritual.",
	:QuestDescription5 => "Return the warding charm to Persephone in the Eridanus Settlement.",
	:QuestDescription6 => "The warding charm was returned to Persephone to hopefully deter lesser Anomalies from attacking the Eridanus Settlement.",
    :RewardString => "TM126 Steam Eruption, X Special Attack 2 (x3), Heart Scale (x3), Grass Sword"
  }
  
    WITCH_RAMBLINGS = {
    :ID => "81",
    :Name => "Witch Ramblings",
    :QuestGiver => "Nondescript Scroll",
    :Stage1 => "Solve statuette riddles.",
	:Stage2 => "Find the secret chamber.",
	:Stage3 => "Solve Casper's riddles.",
	:Stage4 => "Free Casper's spirit.",
	:Stage5 => "Return ring to R.A.B.",
	:Stage6 => "Quest Completed.",
    :Location1 => "Eridanus Tunnels",
	:Location2 => "Eridanus Tunnels L5",
	:Location3 => "Secret Chamber",
	:Location4 => "Secret Chamber",
	:Location5 => "Arcane District",
	:Location6 => "Arcane District",
	:QuestDescription1 => "Find 10 statuettes within the Eridanus Tunnels and solve their riddles.",
	:QuestDescription2 => "Find the secret chamber in the centre of the Eridanus Tunnels L5.",
	:QuestDescription3 => "Solve the four memory and observation riddles put forth by Casper the Chained Spirit.",
	:QuestDescription4 => "Help Casper find the key in the final chamber to free his spirit.",
	:QuestDescription5 => "Find Casper's father within the Arcane District of Libram City and return the ring to R.A.B.",
	:QuestDescription6 => "You were able to recover a reward from Casper's father for helping to deal with Casper's menacing spirit.",
    :RewardString => "TM111 Titania's Law, Dragon Shield, Vespiquenite, Full Restore (x3), PP Max"
  }
  
    BURROWING_MONSTROSITY = {
    :ID => "82",
    :Name => "Burrowing Monstrosity",
    :QuestGiver => "Diary",
    :Stage1 => "Find the burrowing monstrosity.",
	:Stage2 => "Find Egon.",
	:Stage3 => "Defeat Chester in Triple Triad.",
	:Stage4 => "Plant remote receivers.",
	:Stage5 => "Quest Completed",
    :Location1 => "Eridanus Tunnels",
	:Location2 => "Mining District",
	:Location3 => "Market District",
	:Location4 => "Aether Mine",
	:Location5 => "Mining District",
	:QuestDescription1 => "Find the creature that the journal indicated has been roaming the Eridanus Tunnels. This creature has been hunting both humans and Anomalies alike and causing instability in the tunnel network with its burrowing. It is dangerous and should be dealt with.",
	:QuestDescription2 => "Find Egon in the Mining District of Libram City.",
	:QuestDescription3 => "Beat Chester the Triad Master in a Triple Triad duel in the Market District and win a canister of the Best Oil off him. If you require Triple Triad cards, purchase some from one of the vendors in the Market District.",
	:QuestDescription4 => "Plant 14 remote receivers in the mining carts of the Aether Mines.",
	:QuestDescription5 => "You were able to plant the remote receivers in the mining carts of the Aether Mines to help Egon secretly advance the efforts of the Argent Revolution rebel group of Libram City.",
    :RewardString => "TM76 Frostbite, Flying Shield, Ursalunite, Full Restore (x3), Max Revive"
  }

    PRISON_BREAK = {
    :ID => "83",
    :Name => "Prison Break",
    :QuestGiver => "Atticus",
    :Stage1 => "Slay security guards, rescue prisoners.",
	:Stage2 => "Find Atticus",
    :Location1 => "Libram Dungeons",
	:Location2 => "Lux Pub",
	:QuestDescription1 => "Atticus from the Argent Revolution has asked you to help in putting down 10 Watchog security guards in the Libram Dungeons and to rescue 10 Argent Revolution prisoners. Find him at the entrance of the Lux Pub when complete.",
	:QuestDescription2 => "You helped put down the Libram Dungeon Watchog security guards and rescued the Argent Revolution prisoners.",
    :RewardString => "TM41 Magnetic Cannon, XSpAtk2(x3), XSPDef2(x3), Rarest Candy, Plusite"
  }
  
    MAGICAL_BEASTS = {
    :ID => "84",
    :Name => "Magical Beasts",
    :QuestGiver => "Scout",
    :Stage1 => "Kill Aldric's pets.",
	:Stage2 => "Find Scout",
    :Location1 => "Libram Dungeons",
	:Location2 => "Lux Pub",
	:QuestDescription1 => "Scout from the Argent Revolution has asked you to help in putting down Aldric's 3 pets that have likely been set loose in the Libram Dungeon during the prison break. Find her at the entrance of the Lux Pub when complete.",
	:QuestDescription2 => "You put down Aldric's pet Anomalies that had broken free from their enclosures in the Libram Dungeon.",
    :RewardString => "TM53 Energy Ball, X-Attack 2 (x3), X-Defense 2 (x3), Rarest Candy, Minunite"
  }

    POACHING_PROOF = {
    :ID => "85",
    :Name => "Poaching Proof",
    :QuestGiver => "Greg",
    :Stage1 => "Defeat 4 deliverymen",
	:Stage2 => "Find Suspicious Man.",
	:Stage3 => "Meet Calvin at Epoch Mine.",
	:Stage4 => "Inspect red crates.",
	:Stage5 => "Meet Calvin at Cold Storage",
	:Stage6 => "Rescue trapped Pokemon",
	:Stage7 => "Interrogate Greg",
	:Stage8 => "Quest Completed",
    :Location1 => "Lyra Aquarium",
	:Location2 => "Lyra City",
	:Location3 => "Epoch Mine",
	:Location4 => "Epoch Mine",
	:Location5 => "Epoch Mine",
	:Location6 => "Cold Storage",
	:Location7 => "Lyra City",
	:Location8 => "Lyra City",
	:QuestDescription1 => "Greg the Aquarium Trainer suspects poachers are trying to steal Pokemon from the Lyra City Aquarium. He's asked you to question some of the deliverymen working in Lyra City Aquarium.",
	:QuestDescription2 => "One of the Lyra City Aquarium workers told you that a suspicious man can be found near the Lyra City town sign at night time. Greg has asked you to speak with him.",
	:QuestDescription3 => "It turns out the suspicious man was an undercover police officer named Calvin. He's asked you for help in finding the new source of the food supply for the Lyra City Aquarium Pokemon.",
	:QuestDescription4 => "Calvin has asked you to inspect the red crates located throughout the Epoch Mine.",
	:QuestDescription5 => "You found a key that may open the central cold storage unit found at the centre of the Epoch Mine. Meet Calvin in front of the unit.",
	:QuestDescription6 => "You didn't find the source of the food supply but you found a number of Pokemon stowed away in enclosures... it seems that the poachers were keeping the Pokemon they found here before they moved them. You need to rescue all of the ones you can find.",
	:QuestDescription7 => "You found the employee ID badge of Greg the Aquarium trainer near one of the Pokemon enclosures in the cold storage unit. You need to return to Lyra City Aquarium to interrogate him.",
	:QuestDescription8 => "You determined that Greg the Aquarium Trainer was actually the poacher trying to steal Pokemon from the Lyra Aquarium. Calvin has apprehended him and the Pokemon are now safe again.",
    :RewardString => "Noxious Stone, X-Attack, Heart Scale (x3), Soda Pop (x5), Piplup"
  }

    TWISTED_FATE = {
    :ID => "86",
    :Name => "Twisted Fate",
    :QuestGiver => "Walter",
    :Stage1 => "Win Triple Triad Dueling Circuit.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Corona Marketplace",
	:Location2 => "Corona Marketplace",
	:QuestDescription1 => "Win 8 Triple Triad duels in the Corona Marketplace Triple Triad Dueling Circuit.",
	:QuestDescription2 => "You won the Corona Marketplace Triple Triad Dueling Circuit.",
    :RewardString => "TM58 Toxic"
  }

    ROGUE_TOLL = {
    :ID => "87",
    :Name => "The Rogue's Toll",
    :QuestGiver => "Hakim",
    :Stage1 => "Collect herbs as payment",
	:Stage2 => "Speak to Leila.",
	:Stage3 => "Bring a Nacli to Rafiq.",
	:Stage4 => "Return to Leila.",
	:Stage5 => "Speak to Zahir",
	:Stage6 => "Defeat the rogues",
	:Stage7 => "Quest Completed",
    :Location1 => "Corona Outskirts",
	:Location2 => "Corona City",
	:Location3 => "Corona Bazaar",
	:Location4 => "Corona City",
	:Location5 => "Corona Bazaar",
	:Location6 => "Corona Marketplace",
	:Location7 => "Corona Bazaar",
	:QuestDescription1 => "Hakim has asked you to collect some special herbs from the sandy dunes around the Corona Outskirts to offer as payment to the Merchant's Guild for their 'protection'.",
	:QuestDescription2 => "Hakim has asked you to speak to Leila who is another merchant in need of assistance with paying the toll of the Merchant's Guild.",
	:QuestDescription3 => "Leila has asked you to bring a Nacli to one of the influential members of the Merchant's Guild leader, Rafiq, in exchange for buying some time for her to gather the funds to pay the protection fee for her stall.",
	:QuestDescription4 => "Rafiq sends Leila his regards and has given her some time to avoid attracting the attention of the Merchant's Guild tax collectors. Return to Leila with the good news.",
	:QuestDescription5 => "Leila has asked you to speak to Zahir; a third merchant in the Corona Bazaar as he is also looking for help regarding the Merchant's Guild.",
	:QuestDescription6 => "Zahir has asked you to stop the Merchant's Guild from continuing their extortion as he has proof they are in league with the bandits that attack the merchant stalls. He wants you to clear out the bandits from the Corona Marketplace. There are 3 bandits in the Corona Marketplace that need to be defeated.",
	:QuestDescription7 => "You were able to get the bandits to leave Corona City once and for all. The merchants of Corona City are deeply indebted to you now.",
    :RewardString => "Various throughout quest chain"
  }

    BOREAL_GUARDIAN = {
    :ID => "88",
    :Name => "Boreal Guardian",
    :QuestGiver => "Statue",
    :Stage1 => "Bring offering",
	:Stage2 => "Find lost charm.",
	:Stage3 => "Return charm to statue.",
	:Stage4 => "Quest Completed",
    :Location1 => "Route 11A",
	:Location2 => "Charon Ice Tunnels",
	:Location3 => "Route 11A",
	:Location4 => "Route 11A",
	:QuestDescription1 => "Bring a White Herb offering to the Ninetales statue on Route 11A to try to restore the shrine.",
	:QuestDescription2 => "Find traces of the Zoroark that may have been responsible for stealing a part of the charm that empowered the Ninetales statue on Route 11A.",
	:QuestDescription3 => "Return the charm to the Ninetales statue on Route 11A and attempt to re-energize the shrine.",
	:QuestDescription4 => "You returned the charm to the Ninetales statue and were able to recharge the shrine to return its blessing to the area.",
    :RewardString => "Cosmic Gem (x3), Yache Berry (x3), Power Herb (x5), Full Restore, Max Revive"
  }
  
    ABDUCTED_CHILDREN = {
    :ID => "89",
    :Name => "Abducted Children",
    :QuestGiver => "Malcolm",
    :Stage1 => "Obtain supplies",
	:Stage2 => "Return to Malcolm.",
	:Stage3 => "Find Isabelle.",
	:Stage4 => "Put down Coalossal",
	:Stage5 => "Quest Completed",
    :Location1 => "Aquila City",
	:Location2 => "Route 23C",
	:Location3 => "Deimos Caves L3",
	:Location4 => "Deimos Caves L4",
	:Location5 => "Corvus Town",
	:QuestDescription1 => "Go to Aquila City PokeMart and ask the employee there for an Escape Rope, 3 Tetra Potions and a First Aid Kit.",
	:QuestDescription2 => "Bring the supplies that the PokeMart employee gave you to Malcolm at the entrance of the Deimos Caves on Route 23C.",
	:QuestDescription3 => "Find and rescue Isabelle, the other Pokemon Ranger, that got trapped in the Deimos Caves.",
	:QuestDescription4 => "Put down the rampaging Coalossal that has trapped the lost children on L4 of the Deimos Caves.",
	:QuestDescription5 => "You managed to put down the rampaging Coalossal and help Isabelle the Ranger rescue the children that were stranded in the Deimos Caves following the rock slides.",
    :RewardString => "Sky Plate, Naive Mint (x3), Steelixite, Dusk Stone"
  }
  
    SPIRITUAL_IMBALANCE = {
    :ID => "90",
    :Name => "Spiritual Imbalance",
    :QuestGiver => "Agatha",
    :Stage1 => "Dispel enraged spirits",
	:Stage2 => "Collect Swellow tail feathers.",
	:Stage3 => "Dispel Anomaly rift",
	:Stage4 => "Quest Completed",
    :Location1 => "Deimos Caves",
	:Location2 => "Corvus Town",
	:Location3 => "Deimos Caves L0",
	:Location4 => "Corvus Town",
	:QuestDescription1 => "Dispel 8 enraged spirits using Agatha's charm so that she can restore her connection to the guardian spirit of Corvus Town.",
	:QuestDescription2 => "Collect 3 tail feathers from Swellows circling above in the skies above Corvus Town so that Agatha can use them in her ritual to restore her connection with the guardian spirit.",
	:QuestDescription3 => "Assist the guardian spirit of Corvus Town by closing the Anomaly Rift that has opened at the bottom-most level of the Deimos Caves.",
	:QuestDescription4 => "You were able to banish the Anomaly that had crawled through the rift and help the guardian spirit seal it. Agatha rewarded you for your help.",
    :RewardString => "TM127 Psychic Terrain, Heracronite, Revival Herb (x3), Cosmic Dust"
  }
  
    DOUBLE_CROSSED = {
    :ID => "91",
    :Name => "Double Crossed",
    :QuestGiver => "Hashem",
    :Stage1 => "Destroy weapon stores",
	:Stage2 => "Free Captured Tauros.",
	:Stage3 => "Defeat 4 Bandits",
	:Stage4 => "Quest Completed",
    :Location1 => "Lower Mt. Titania L0",
	:Location2 => "Lower Mt. Titania L2/L3",
	:Location3 => "Lower Mt. Titania L4/L5",
	:Location4 => "Lower Mt. Titania",
	:QuestDescription1 => "Destroy 8 stashes of weapons, armor, and other contraband merchandise throughout Lower Mt. Titania L0 that the Rogue's Guild have amassed through years of illicit activities. Return to Hashem on L1 when complete.",
	:QuestDescription2 => "Free 8 Tauros found throughout Lower Mt. Titania L2/L3 to deprive the Rogue's Guild of their income. Meet with Hashem at the entrance of L4 when complete.",
	:QuestDescription3 => "Defeat the 4 leaders of the Rogue's Guild found throughout Lower Mt. Titania L4/L5 to complete Hashem's vengeance. Meet with him on L4 when complete.",
	:QuestDescription4 => "You have helped Hashem exact his vengeance on the Rogue's Guild that spurned him. He has rewarded you for siding with him.",
    :RewardString => "Miracle Seed, T.Phantump, TM114 Flock, Resist Feather (x3)"
  }
  
    MASTER_PRISON = {
    :ID => "92",
    :Name => "The Master's Prison",
    :QuestGiver => "Lazarus",
    :Stage1 => "Recover Summoning Reagents",
	:Stage2 => "Collect 7 vials of Linoone blood.",
	:Stage3 => "Summon the Master",
	:Stage4 => "Quest Completed",
    :Location1 => "Corona Marketplace",
	:Location2 => "Lower Mt. Titania L1 - L3",
	:Location3 => "Lower Mt. Titania L4",
	:Location4 => "Lower Mt. Titania L4",
	:QuestDescription1 => "Purchase a Scope Lens, Heat Rock, and Dire Hit from the vendors in the Corona Marketplace and bring them to Lazarus in Corona City.",
	:QuestDescription2 => "Slay or capture 7 Linoones within Lower Mt. Titania Levels 1 - 3, and harvest their blood into vials that Lazarus has provided you. Bring them to him on Level 4 of Lower Mt. Titania when complete.",
	:QuestDescription3 => "Speak to Lazarus to begin the summoning ritual of his Master.",
	:QuestDescription4 => "You summoned Rakanishu, a Demon Pokemon, as part of the summoning ritual. It killed Lazarus following you defeating it in battle in anger, but has chosen to join you to help you conquer the world.",
    :RewardString => "Heart Scale (x3), TM120 Fantasy Seal, Scope Lens, Heat Rock, Dire Hit, T.Morgrem"
  }
  
    CONTRABAND_TECH = {
    :ID => "93",
    :Name => "Contraband Tech",
    :QuestGiver => "Rolliffe",
    :Stage1 => "Loot abandoned shipments",
	:Stage2 => "Meet Rolliffe's contact",
	:Stage3 => "Speak to Gangsters",
	:Stage4 => "Speak to 1337Hacker",
	:Stage5 => "Speak to Orrie",
	:Stage6 => "Quest Completed",
    :Location1 => "Orion Side Street",
	:Location2 => "Route 15B",
	:Location3 => "Route 15B",
	:Location4 => "Route 15A",
	:Location5 => "Route 15B",
	:Location6 => "Route 15B",
	:QuestDescription1 => "Search through the 5 brown piles of abandoned shipment boxes within the Orion Side Streets and loot whatever you can. Return to Rolliffe when you have finished this task.",
	:QuestDescription2 => "Meet with Rolliffe at the entrance of Route 15B so that you can meet with his contact that might be interested in purchasing the blue glowing canister.",
	:QuestDescription3 => "Speak to the gangsters spread out through Route 15A to find a possible seller of a compromised Epoch Corporation employee user account that you can use to hack the Epoch Corporation's database.",
	:QuestDescription4 => "Find the 1337Hacker in Route 15A and obtain the punch code needed for the temporal canister.",
	:QuestDescription5 => "Orrie is busy hacking the Epoch Corporation database trying to find the punch code required to disarm the temporal grenade. Speak to him when you are ready.",
	:QuestDescription6 => "You were able to dismantle the dangerous Epoch Corporation technology with Orrie's help. He has rewarded you for your help.",
    :RewardString => "PP Max, TM28 Drain Punch, Offense Vial (x3), Intellect Vial (x3), Applin"
  }
  
    FAMILY_AFFAIRS = {
    :ID => "94",
    :Name => "Family Affairs",
    :QuestGiver => "Laura",
    :Stage1 => "Gather info from civilians",
	:Stage2 => "Bribe Gangsters",
	:Stage3 => "Defeat Gang Leader",
	:Stage4 => "Quest Completed",
	:Location1 => "Route 15B",
	:Location2 => "Route 15A",
	:Location3 => "Route 15A",
	:Location4 => "Route 15B",
	:QuestDescription1 => "Laura has asked you to speak to the people roaming around Route 15B to see if any of them have any information on the possible whereabouts of her brother, Adam.",
	:QuestDescription2 => "Bribe the Gangsters of Route 15A to see if any of them have any information about Adam's whereabouts.",
	:QuestDescription3 => "Defeat the Gang Leader, Al, who has kidnapped Adam and is near the north end of Route 15A.",
	:QuestDescription4 => "You were able to defeat Al, the Gang Leader, and reunite Adam with his sister Laura. She has rewarded you for your help.",
    :RewardString => "Moonstone, Blissite, Protection and Toughness Vials (x3 each)"
  }
  
    VULTURES_OVERHEAD = {
    :ID => "95",
    :Name => "Vultures Overhead",
    :QuestGiver => "Mustafah",
    :Stage1 => "Faint Mandibuzz",
	:Stage2 => "Challenge Paragons",
	:Stage3 => "Chase down Corrupted Avatar",
	:Stage4 => "Quest Completed",
	:Location1 => "Route 23A",
	:Location2 => "Route 23B",
	:Location3 => "Route 23C",
	:Location4 => "Route 23B",
	:QuestDescription1 => "Mustafah the Merchant has asked you to put down 5 circling Mandibuzz that keep swarming his caravans along Route 23A.",
	:QuestDescription2 => "Elder Eru has told you that the Mandibuzz's nesting grounds have been disturbed. To seek an audience with the great Mandibuzz spirit of Route 23B, you must challenge certain paragons of his tribe that will gift you sacred objects needed for a ritual to summon the spirit.",
	:QuestDescription3 => "It appears as though a corrupted influence has affected the Avatar of Braviary, causing it to disturb the Mandibuzz nesting grounds. Chase the spirit down along Route 23C and vanquish it once and for all.",
	:QuestDescription4 => "You were able to chase away the corrupted influence that had infected the Avatar of Braviary. The great Mandibuzz spirit rewarded you for your service.",
    :RewardString => "TM42 Liquidation, Xatunite, Dire Hit 2 (x3), X Accuracy 2 (x3)"
  }
  
    TREASURE_HUNTERS = {
    :ID => "96",
    :Name => "Treasure Hunters",
    :QuestGiver => "Ormus",
    :Stage1 => "Collect special herbs",
	:Stage2 => "Scare off treasure hunters",
	:Stage3 => "Repair sacred wards",
	:Stage4 => "Quest Completed",
	:Location1 => "Route 23A",
	:Location2 => "Route 23B",
	:Location3 => "Route 23C",
	:Location4 => "Route 23C",
	:QuestDescription1 => "Ormus, one of the spiritual elders of Route 23A, has asked for your help to track down some special herbs that can be mixed into a curative ointment that will alleviate the sores that his tribe have been suffering from.",
	:QuestDescription2 => "Ormus has asked you to scare off the treasure hunters/miners that have setup their mining excavations along Route 23B.",
	:QuestDescription3 => "Ormus has asked you to repair the 4 sacred wards damaged by the mining activity in the region so that the enchantment protecting the area can be restored.",
	:QuestDescription4 => "You were able to repair the sacred wards found along Route 23C and Ormus has thanked you with a reward.",
    :RewardString => "Centiskorite, Offense Vial (x3), Intellect Vial (x3), PP Max, Rock Shield"
  }

    COMMUNITY_ARTISTS = {
    :ID => "97",
    :Name => "Community Artists",
    :QuestGiver => "Lucas",
    :Stage1 => "Defeat Community Artists.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Ara Art Gallery",
	:Location2 => "Ara Art Gallery",
	:QuestDescription1 => "Defeat the Community Artists of the Pokemon Soulstones and Time Wardens Discord. They can be found within the Ara City Art Gallery.",
	:QuestDescription2 => "You have defeated the Community Artists of the Pokemon Soulstones and Time Wardens Discord.",
    :RewardString => "Fairy Shield, Heart Scale, Max Revive (x3), Full Restore (x3)"
  }

    UNION_STRONG = {
    :ID => "98",
    :Name => "Union Strong",
    :QuestGiver => "Karl",
    :Stage1 => "Knock out Informants",
	:Stage2 => "Recruit Union Sympathizers",
	:Stage3 => "Secure Armaments",
	:Stage4 => "Quest Completed",
	:Location1 => "Aether Mine L1",
	:Location2 => "Aether Mine L2",
	:Location3 => "Aether Mine L3",
	:Location4 => "Aether Mine - Centre",
	:QuestDescription1 => "Karl, a Market District Labourer in the Aether Mine, is seeking your help to support his unionization efforts. He's asked you to knock out the pro-Conclave shift supervisor informants on L1 that would attempt to suppress his unionization efforts.",
	:QuestDescription2 => "Karl has asked you to solicit the support of 7 Market District labourers (in yellow uniforms) on L2 of the Aether Mine to bolster his unionization efforts.",
	:QuestDescription3 => "Karl has asked you to secure equipment from L3 of the Aether Mine to prepare for a possible violent confrontation with the Mine Foreman. Speak to Karl in the centre level of the Aether Mine when you've collected the armaments.",
	:QuestDescription4 => "You were able to work with Karl to intimidate the Aether Mine Foreman into cooperating with the new union he has founded to promote better working conditions for the working class miners.",
    :RewardString => "TM07 Superpower, Noctowlite, PP Max, Max Revive (x3)"
  }
  
    LIGHTS_IN_THE_DEEP = {
    :ID => "99",
    :Name => "Lights In The Deep",
    :QuestGiver => "Ellis",
    :Stage1 => "Repair L1 Lights",
	:Stage2 => "Inspect L2 Lights",
	:Stage3 => "Find Saboteurs on L3",
	:Stage4 => "Quest Completed",
	:Location1 => "Aether Mine L1",
	:Location2 => "Aether Mine L2",
	:Location3 => "Aether Mine L3",
	:Location4 => "Aether Mine L3",
	:QuestDescription1 => "Ellis, a Mining District Engineer, wants your help to manually repair the lighting system on the structural arches of L1 of the Aether Mine. When complete, meet with her where the mining cart rail tracks transition from L1 to L2. Beware wild Pokemon that may be near the arches.",
	:QuestDescription2 => "Visit each of the arches on L2 of the Aether Mine to manually inspect the damage on them with Ellis and attempt to repair them.",
	:QuestDescription3 => "Find the Saboteurs on L3 of the Aether Mine and put a stop to their attempts to damage the lighting system of the Aether Mine.",
	:QuestDescription4 => "You discovered that it was actually Superintendent Andrew that was trying to cut costs who was responsible for sabotaging the lighting system of the Aether Mine. Ellis has reported him to the authorities and rewarded you for your help.",
    :RewardString => "Water Shield, Tetra Potion (x5), Protection and Toughness Vials (x3 each)"
  }

    BORO_MEMEART = {
    :ID => "100",
    :Name => "Boro Meme Art",
    :QuestGiver => "Boro",
    :Stage1 => "Collect Meme Art.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Orion Region",
	:Location2 => "Orion Region",
	:QuestDescription1 => "Find Boro's Meme Art spread out throughout Pokemon Time Wardens. Return to Boro in the Auriga Resort when completed.",
	:QuestDescription2 => "You found all of Boro's meme art spread out throughout Pokemon Time Wardens. He gave you a legendary Pokemon for your trouble.",
    :RewardString => "Legendary Pokemon"
  }

    DROID_FRENZY = {
    :ID => "101",
    :Name => "Droid Frenzy",
    :QuestGiver => "Atticus",
    :Stage1 => "Disable rogue droids",
	:Stage2 => "Disarm security guards",
	:Stage3 => "Overload generators",
	:Stage4 => "Quest Completed",
	:Location1 => "Power Plant L1-L2",
	:Location2 => "Power Plant L3",
	:Location3 => "Power Plant L4",
	:Location4 => "Power Plant L4",
	:QuestDescription1 => "One of the Argent Revolution lieutenants, Atticus, wants you to help disable 8 security droids that have gone rogue because of the virus that has infected the Power Plant's systems.",
	:QuestDescription2 => "Atticus has asked you to take out 4 of the Power Plant security guards that are patrolling on the 3rd floor of the Power Plant.",
	:QuestDescription3 => "Atticus has asked you to find the 8 backup generators in the Power Plant and place some overload charges on them so they can be disabled.",
	:QuestDescription4 => "You were able to disable the backup generators in the Libram City Science District Power Plant.",
    :RewardString => "TM98 Lightsaber, Max Revive, Tetra Potion (x3), Quick Ball (x5)"
  }

    POWER_PLAY = {
    :ID => "102",
    :Name => "Power Play",
    :QuestGiver => "Scout",
    :Stage1 => "Rescue battery Pokemon",
	:Stage2 => "Terminate corrupted Pokemon",
	:Stage3 => "Defeat Power Plant Engineers",
	:Stage4 => "Quest Completed",
	:Location1 => "Power Plant Basement",
	:Location2 => "Power Plant L3",
	:Location3 => "Power Plant L4",
	:Location4 => "Power Plant L3",
	:QuestDescription1 => "One of the Argent Revolution lieutenants, Scout, wants you to rescue a number of smaller Pokemon that have been imprisoned and being used as batteries to power the Power Plant. There are 14 of them located throughout the basement of the Power Plant.",
	:QuestDescription2 => "Scout has requested you terminate 3 Musharna and 3 Porygon-Z that were trapped in the computer network when the virus was deployed and were subsequently corrupted.",
	:QuestDescription3 => "Scout has asked you to depose the 5 Engineers responsible for overseeing the Power Plant for their exploitative and soulless actions they took when overseeing the Power Plant's operations.",
	:QuestDescription4 => "You were able to depose the Libram City Science District Power Plant engineers in charge. Scout has rewarded you for your trouble.",
    :RewardString => "Chimechite, Full Restore (x3), Body Armor"
  }

    AETHER_SICKNESS = {
    :ID => "103",
    :Name => "Aether Sickness",
    :QuestGiver => "Marie",
    :Stage1 => "Put down ailing Pokemon",
	:Stage2 => "Interrogate Arboretum gardeners",
	:Stage3 => "Find maintenance logbook",
	:Stage4 => "Find P.Curie",
	:Stage5 => "Put down infected Altaria",
	:Stage6 => "Distribute immunity tablets",
	:Stage7 => "Quest Completed",
	:Location1 => "The Arboretum",
	:Location2 => "The Arboretum",
	:Location3 => "The Orchidarium",
	:Location4 => "Science District",
	:Location5 => "Market District",
	:Location6 => "Market District",
	:Location7 => "Science District",
	:QuestDescription1 => "Marie, one of the former scientists working in the Arboretum has detected a mysterious ailment that is making the wild Victreebels in the Arboretum very aggressive. She's asked for your help to put 7 of them out of their misery and harvest their dew so she can study it.",
	:QuestDescription2 => "Marie's studies were inconclusive and she's asked you to interrogate 5 of the Arboretum gardeners at night to see if they have any information to share on what could be affecting the wild Pokemon in the Arboretum.",
	:QuestDescription3 => "Marie believes that a maintenance logbook might have some answers as there's a suspicion that the air filtration systems connecting Libram City are partly to blame. There's likely one to be found somewhere in the Orchidarium.",
	:QuestDescription4 => "The maintenance logbook you found seems to be signed off by a former employee of the Arboretum named P. Curie. He recently retired and lives in the northwest house of the Science District. Speak with him to see what he knows.",
	:QuestDescription5 => "Elara has been pumping chemicals into the air around the Market District to pacify any unreset. The air filtration systems were disabled during your Power Plant raid, but some disease-carrying Altaria might still be spreading the chemical. Put 6 of them roaming the skies down.",
	:QuestDescription6 => "Marie has asked you to distribute immunity tablets to 9 of the vendors in the Market District as they could help administer the medication to the citizens of the Market District and protect them from the worst of the effects of Blue Lux exposure.",
	:QuestDescription7 => "You were able to administer the immunity tablets to the vendors of the Libram City Market District. She has rewarded you for your assistance.",
    :RewardString => "Salamencite, TM121 Concoction, Dark Shield, Max Revive, Full Restore (x3)"
  }

    AETHER_INFUSION = {
    :ID => "104",
    :Name => "Aether Infusion",
    :QuestGiver => "Carlin",
    :Stage1 => "Dispose of algae growth",
	:Stage2 => "Put down aggressive Lanturn",
	:Stage3 => "Speak to Freya",
	:Stage4 => "Obtain 3 Chinchou",
	:Stage5 => "Quest Completed",
	:Location1 => "Libram Port",
	:Location2 => "Libram Trench",
	:Location3 => "Revolution Lab",
	:Location4 => "Guulrahn Trench",
	:Location5 => "Revolution Lab",
	:QuestDescription1 => "Carlin has asked you to get rid of 7 large algae growth that has formed on the mining equipment and storage containers that are strewn about Libram Port.",
	:QuestDescription2 => "Carlin wants you to put down an aggressive Lanturn that has been attacking any Argent Revolution expeditions attempting to recover mining equipment from the underwater trench.",
	:QuestDescription3 => "The Lanturn left behind a glowing object. Carlin has asked you to speak to Freya, one of the Argent Revolution scientists in the Revolution Lab (in the basement of the Revolution safehouse) for help figuring out what to do with it.",
	:QuestDescription4 => "Freya has asked you to recover the glands of 3 Chinchou from Guulrahn Trench that will be purer, younger specimens versus the aggressive Lanturn.",
	:QuestDescription5 => "You were able to recover the glands of the 3 Chinchou from Guulrahn Trench and Freya has rewarded you for your help.",
    :RewardString => "Rune 28 - Gooey, Heartscale (x3), Empoleonite, PP Max"
  }
  
    DRONE_RELAY = {
    :ID => "105",
    :Name => "Drone Relay",
    :QuestGiver => "Debris",
    :Stage1 => "Find a charging station",
	:Stage2 => "Investigate the Nesting Grounds",
	:Stage3 => "Seal the leyline fissures",
	:Stage4 => "Slay large Anomaly",
	:Stage5 => "Return to Lab",
	:Stage6 => "Quest Completed",
	:Location1 => "Guulrahn Badlands",
	:Location2 => "Bootes Encampment",
	:Location3 => "Nesting Grounds",
	:Location4 => "Nesting Grounds",
	:Location5 => "Revolution Lab",
	:Location6 => "Revolution Lab",
	:QuestDescription1 => "You have found the debris of some sort of drone. It had a message that was corrupted but its aether battery seems intact. Perhaps if I can find a charging station, I can listen to the full message.",
	:QuestDescription2 => "The charging station you found in the Bootes Encampment PokeCentre told you that a man named Elias and his surveying party detected a surge along the leyline spine, near the Nesting Grounds. I should investigate what he may have found.",
	:QuestDescription3 => "You found a cache of unstable pulse spark cores and Elias's diary that describes some useful information that can be shared with Argent Revolution scientists. On picking it up though, a number of leyline fissures started to form that required to be sealed.",
	:QuestDescription4 => "Upon sealing the last leyline fissure, a large Anomaly appeared in the waters of the Nesting Grounds that I have to kill.",
	:QuestDescription5 => "With Elias' diary and the rest of the pulse spark cores that I found, I should return this to one of the scientists in the Argent Revolution Lab for further study.",
	:QuestDescription6 => "You were able to return Elias' diary to Kenneth in the Revolution Lab to help him with his research on pulse spark cores.",
    :RewardString => "Tetra Potion (x5), Ultra Ball (x5), Gyaradosite, TM88 Outrage"
  }
  
    ASHES_OF_THE_INNOCENT = {
    :ID => "106",
    :Name => "Ashes of the Innocent",
    :QuestGiver => "Idol",
    :Stage1 => "Find idols",
	:Stage2 => "Pay respects",
	:Stage3 => "Recover idol fragments",
	:Stage4 => "Free Mira's spirit",
	:Stage5 => "Return to Dresk",
	:Stage6 => "Quest Completed",
	:Location1 => "Bootes Encampment",
	:Location2 => "Bootes Encampment",
	:Location3 => "Guulrahn Wastes",
	:Location4 => "Spawning Pool",
	:Location5 => "Guulrahn Wastes",
	:Location6 => "Guulrahn Wastes",
	:QuestDescription1 => "You have found a curious idol that may contain information about the early Libram City surface pioneers. Find 9 idols throughout the Bootes Encampment (only indoors).",
	:QuestDescription2 => "The final idol revealed that a makeshift grave was erected in memoriam of the little urchin girl, Mira, who made the idols. It is located at the foot of the lake; go there to pay your respects.",
	:QuestDescription3 => "You defeated the restless spirit of Captain Dresk, the soldier that burned Mira under suspicion of her being a witch. He seeks to atone for his misdeeds in life and has asked you to recover the idol fragments left in the torches of the Guulrahn Wastes.",
	:QuestDescription4 => "After collecting all of the idol fragments, go to the Spawning Pool and find the pyre where Mira was burned by Captain Dresk and free her spirit.",
	:QuestDescription5 => "You released the spirit of Mira from her torment. She has asked you to return to Capt. Dresk on the outskirts of Bootes Encampment in the Guulrahn Wastes to release him from his own prison.",
	:QuestDescription6 => "With Mira's blessing, you were able to put to rest the spirit of Captain Dresk to release him from his own torment.",
    :RewardString => "Max Revive (x1), Light Sword, PP Max (x1), T.Venusaurite"
  }
  
    SOIL_SAMPLES = {
    :ID => "107",
    :Name => "Soil Samples",
    :QuestGiver => "Maylee",
    :Stage1 => "Collect soil samples",
	:Stage2 => "Meet Dr.Schumacher",
	:Stage3 => "Dispose of Alcremies",
	:Stage4 => "Investigate the EG base",
	:Stage5 => "Return to Dr.Schumacher",
	:Stage6 => "Quest Completed",
	:Location1 => "Draco Falls",
	:Location2 => "Draco Museum",
	:Location3 => "Draco Trench",
	:Location4 => "Flooded Base",
	:Location5 => "Flooded Base",
	:QuestDescription1 => "Maylee has asked you to take some soil samples in Draco Falls where the berry trees grow, near the rocks at the bottom of the falls, and right by the large rock at the base of the falls. She has marked off the areas that you need to sample.",
	:QuestDescription2 => "Speak to Dr.Schumacher in Draco Museum and show her what you've found regarding the soil samples around Draco Falls.",
	:QuestDescription3 => "Dr.Schumacher has concluded that the foul-smelling soil is due to microbial disruption in the soil layers caused by Alcremie. Find 8 of them while diving in the Draco Trench and dispose of them.",
	:QuestDescription4 => "The Alcremie may have been introduced to the ecosystem because of damage sustained to the nearby Ethereal Guild base. You've determined you need to investigate the base itself for sources of what has infected the lakebed beneath Draco Falls.",
	:QuestDescription5 => "The cause of the toxic spill infecting the lakebed was due to an Anomaly that had gotten loose in the lab and caused a lot of damage. You have dealt with it and must now return back to Dr.Schumacher in Draco Museum for your reward.",
	:QuestDescription6 => "You reported your findings back to Dr.Schumacher in Draco City Museum. She has reported her findings to the authorities and they will take care of clearing out the damaged equipment causing the leak into the lakebed. Dr.Schumacher has rewarded you for your trouble.",
    :RewardString => "Max Revive, PP Max, Offense Vial (x3), Protection Vial (x3), Scizorite"
  }
  
    LIGHT_IN_THE_MIST = {
    :ID => "108",
    :Name => "Light in the Mist",
    :QuestGiver => "Mirabel",
    :Stage1 => "Collect Crimson Driftleaf",
	:Stage2 => "Ward away Ghost Pokemon",
	:Stage3 => "Collect special ingredients",
	:Stage4 => "Quest Completed",
	:Location1 => "Route 18A",
	:Location2 => "Route 18B",
	:Location3 => "Route 19",
	:Location4 => "Norma Lighthouse",
	:QuestDescription1 => "Search the leaf piles on Route 18A for Crimson Driftleaf. When collected, bring them back to Mirabel at the entrance of Route 18A so she can craft her warding charm.",
	:QuestDescription2 => "Use the warding charm to chase away 8 Ghost-type Pokemon that have taken residence on Route 18B. When complete, meet with Mirabel near the entrance on the north end of Route 18B, near the entrance to the Route 19 Gatehouse..",
	:QuestDescription3 => "Track down 3 key ingredients on Route 19 for Mirabel (some saltwater from the coast, an orange mushroom, and some tree bark). When collected, meet her at the Norma Town Lighthouse on L5 so she can prepare a special ointment to cure the resident Vikavolt that has recently fallen ill.",
	:QuestDescription4 => "The Vikavolt of Norma Town's Lighthouse is now feeling much better after the ointment that Mirabel was able to administer to it. Mirabel has thanked you with a reward.",
    :RewardString => "Orange and Purple Shard (x5 each), Heart Scale (x3), Rarest Candy, Torterranite"
  }
  
    VEIL_OF_CARE = {
    :ID => "109",
    :Name => "Veil of Care",
    :QuestGiver => "Jacintha",
    :Stage1 => "Administer medication",
	:Stage2 => "Speak to servers",
	:Stage3 => "Speak to Victoria",
	:Stage4 => "Defeat gang members",
	:Stage5 => "Defeat the chemist",
	:Stage6 => "Quest Completed",
	:Location1 => "Norma Retirement Home",
	:Location2 => "Norma Casino",
	:Location3 => "Norma Underground",
	:Location4 => "Norma Underground",
	:Location5 => "Norma Lighthouse",
	:Location6 => "Norma Lighthouse",
	:QuestDescription1 => "Nurse Jacintha has asked you to administer the medication to 11 residents in the Norma Town Retirement Home.",
	:QuestDescription2 => "When you inquired with Nurse Jacintha about the Nurse Victoria's resistance to administering the new medication, Nurse Jacintha suddenly became very defensive, prompting suspicion. You want to do some further investigating and interrogate the servers of the Norma Town Casino.",
	:QuestDescription3 => "You tracked down Nurse Victoria during her shift, but she has told you to meet with her near the entrance of the Norma Town Underground since it's not safe to discuss in the Casino.",
	:QuestDescription4 => "Fight the four gang member henchmen responsible for carrying out the drug trafficking ring in the Norma Town Underground.",
	:QuestDescription5 => "Find the chemist responsible for engineering the chemical compound underpinning Crescent Powder. They can be found in the Norma Town Lighthouse.",
	:QuestDescription6 => "Walter the chemist was responsible for the Crescent Powder, but was able to escape through the assistance of a shadowy assassin. Victoria, the undercover OCPD officer, has to revise her investigation strategy but has rewarded you for your help thus far.",
    :RewardString => "Red and Yellow Shard (x5 each), Max Revive (x1), Gardevoirite"
  }

    SAME_NUMBER_WINS = {
    :ID => "110",
    :Name => "Same Number Wins",
    :QuestGiver => "Jared",
    :Stage1 => "Win Triple Triad Tournament.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Norma Underground",
	:Location2 => "Norma Underground",
	:QuestDescription1 => "Win 4 Triple Triad duels in the Norma Underground custom same number wins ruleset Triple Triad Touranment.",
	:QuestDescription2 => "You won the Norma Underground Triple Triad tournament that had the custom same number wins ruleset.",
    :RewardString => "Relic Crown"
  }

    WATT_THE_PROBLEM = {
    :ID => "111",
    :Name => "Watt's the Problem?",
    :QuestGiver => "Rory",
    :Stage1 => "Fix street lights",
	:Stage2 => "Speak to Casino owner",
	:Stage3 => "Intimidate hooligans",
	:Stage4 => "Destroy smuggling stashes.",
	:Stage5 => "Quest Completed",
	:Location1 => "Norma Town",
	:Location2 => "Norma Casino",
	:Location3 => "Norma Casino",
	:Location4 => "Norma Underground",
	:Location5 => "Norma Casino",
	:QuestDescription1 => "Repair 8 of the accessible street lights in the main area of Norma Town. No need to attempt to fix the ones out near the lighthouse or the beach. Beware some of the moth Pokemon that might be hanging around near the street lights.",
	:QuestDescription2 => "Speak to the Casino boss to inquire about the faulty rewiring of the street lights to the Casino.",
	:QuestDescription3 => "Chase away the 4 hooligans that have been loitering in the Norma Town Casino and causing trouble for the patrons.",
	:QuestDescription4 => "Destroy 7 stashes of supplies found throughout the Norma Town Underground.",
	:QuestDescription5 => "You were able to destroy the stash of contraband supplies found throughout the Norma Town Underground. Richard, the Casino boss, has rewarded you for helping get rid of the gangsters that were trying to use his Casino as a front for their illegal smuggling activities.",
    :RewardString => "Green and Blue Shard (x5 each), Rune 24 - Rivalry, Heart Scale (x3), PP Max (x1), Galladite"
  }

    HIGH_STAKES = {
    :ID => "112",
    :Name => "High Stakes",
    :QuestGiver => "Kevin",
    :Stage1 => "Win Triple Triad Tournament.",
	:Stage2 => "Quest Completed.",
    :Location1 => "Norma Casino",
	:Location2 => "Norma Casino",
	:QuestDescription1 => "Win 6 Triple Triad duels in the Norma Town Casino Triple Triad Touranment.",
	:QuestDescription2 => "You won the Norma Town Casino Triple Triad Touranment.",
    :RewardString => "Choice of Rare Pokemon"
  }

    BEACON_OF_DISCIPLINE = {
    :ID => "113",
    :Name => "Beacon of Discipline",
    :QuestGiver => "Arthur",
    :Stage1 => "Move heavy boxes",
	:Stage2 => "Shoo off birds",
	:Stage3 => "Fight sailors",
	:Stage4 => "Quest Completed",
	:Location1 => "Norma Lighthouse L2",
	:Location2 => "Norma Lighthouse L3",
	:Location3 => "Norma Lighthouse L4",
	:Location4 => "Norma Lighthouse L4",
	:QuestDescription1 => "Help Arthur the Lighthouse Master by moving 6 boxes you find on the 2nd floor of the Norma Lighthouse down to the basement. Beware of some of the wild Pokemon that may be lurking around near the boxes. Meet with Arthur on Level 3 when complete.",
	:QuestDescription2 => "Clear out the 6 nests of Spearow and Wingull that have formed on the 3rd floor of the Norma Lighthouse. Meet with Arthur on Level 4 when complete.",
	:QuestDescription3 => "Fight the 5 sailors that have overstayed their welcome on the 4th floor of the Norma Lighthouse. Meet with Arthur at the entrance of Level 4 when complete.",
	:QuestDescription4 => "You were able to help Arthur the Lighthouse Master evict the lazy sailor tenants that were making nuisances of themselves. Arthur has thanked you with a reward.",
    :RewardString => "Tetra Potion (x5), Full Restore (x3), Flying Sword, Grapploctite"
  }

    CALL_OF_THE_DROWNED = {
    :ID => "114",
    :Name => "Call of the Drowned",
    :QuestGiver => "Erik",
    :Stage1 => "Rescue passengers",
	:Stage2 => "Stop acolytes",
	:Stage3 => "Dispel corsairs",
	:Stage4 => "Break idols",
	:Stage5 => "Slay the monster",
	:Stage6 => "Quest Completed",
	:Location1 => "Route 20A",
	:Location2 => "Route 20B",
	:Location3 => "Route 20B Underwater",
	:Location4 => "Abandoned Shipwreck",
	:Location5 => "Abandoned Shipwreck",
	:Location6 => "Abandoned Shipwreck",
	:QuestDescription1 => "Help Erik by saving his 5 passengers that have been scattered across Route 20A because of the freak storm that destroyed their boat. Ensure you have sufficient Escape Ropes to save each passenger.",
	:QuestDescription2 => "Stop the 6 Acolytes along Route 20B who are casting a spell to summon a monster from the depths of the ocean.",
	:QuestDescription3 => "Dispel the 4 corsairs that have appeared along the underwater area of Route 20B, outside the Abandoned Shipwreck.",
	:QuestDescription4 => "Break the 11 anchor idols that have been spaced throughout the Abandoned Shipwreck that are enabling the ritual summoning to continue. Beware some Ghost-type Pokemon that are lurking near these anchor idols.",
	:QuestDescription5 => "Defeat the monster that has been summoned from the depths of the ocean in the Abandoned Shipwreck's ballroom.",
	:QuestDescription6 => "You defeated the Anomaly that was summoned from the Abandoned Shipwreck and discovered a treasure trove awaiting you following closing the Anomaly rift.",
    :RewardString => "Escape Rope (x5), Heart Scale (x3), Rare Candy, Max Revive (x1), Barbaraclite"
  }

    ROOTS_IN_THE_CINDERS = {
    :ID => "115",
    :Name => "Roots in the Cinders",
    :QuestGiver => "Claire",
    :Stage1 => "Plant Sunkern seedlings",
	:Stage2 => "Slay T.Milotics",
	:Stage3 => "Shoo off Rufflets",
	:Stage4 => "Quest Completed",
	:Location1 => "Route 22A",
	:Location2 => "Route 22B",
	:Location3 => "Route 22C",
	:Location4 => "Route 22C",
	:QuestDescription1 => "Help Claire with planting 6 Sunkern seedlings throughout Route 22A. The areas that are safest in her view have been marked off for you so you know where to plant them.",
	:QuestDescription2 => "To help give the Sunkern seedlings a fighting chance to resist predators, Claire has asked you to help thin the number of T.Milotics that are found in or around the lava lakes of Route 22B. She has asked you to put down 5 of them.",
	:QuestDescription3 => "To encourage and foster a good growing environment for the immature Sunkern seedlings, Claire has asked you to shoo away 5 Rufflet babies that peck at the ground where the Sunkern soil plots are located to give them a chance to grow properly.",
	:QuestDescription4 => "You helped Claire restore balance to the ecosystem of Route 22A-C. Now it is up to the planted Sunkerns seedlings to thrive without threat of predators. Claire has rewarded you for your help.",
    :RewardString => "Terrain Seeds (x5 each), Cofagrinite"
  }
  
    SPOILS_OF_SACRILEGE = {
    :ID => "116",
    :Name => "Spoils of Sacrilege",
    :QuestGiver => "Lionel",
    :Stage1 => "Defeat Corsairs",
	:Stage2 => "Meet Lionel on R21B",
	:Stage3 => "Extract Gems",
	:Stage4 => "Advertise Lionel's Treasures",
	:Stage5 => "Quest Completed",
	:Location1 => "Route 20B Underwater",
	:Location2 => "Route 21B",
	:Location3 => "Overgrown Temples",
	:Location4 => "Tucana City",
	:Location5 => "Tucana Bayou",
	:QuestDescription1 => "Lionel the entrepreneur of opportunity has enlisted your help to defeat the 5 Corsairs that roam the Abandoned Shipwreck, located underwater of Route 20B. Once cleared, he can move in to haul whatever treasure and split it with you.",
	:QuestDescription2 => "Meet with Lionel at the entrance of Route 21B so he can tell you about his next hare-brained plan to enrich both himself and you.",
	:QuestDescription3 => "Pry the precious gems out of the Throh and Sawk Golem statues in the Overgrown Temples splashed throughout Route 21B. Recover at least 6 emeralds from each of the statues and return to Lionel at the entrance of Route 21B when complete.",
	:QuestDescription4 => "Find 5 Indigenous customers on the streets of Tucana City and advertise Lionel's Treasures and that he is selling all of your heists out of the Tucana Bayou. When you've found at least 5 customers, meet with Lionel at the entrance of the Tucana Bayou to split the profits.",
	:QuestDescription5 => "Lionel was apprehended for his grave-robbing desecration and distasteful pillaging of sacred sites. You were rewarded for helping apprehend him.",
    :RewardString => "Ability Capsule, Full Restore, Tetra Potion (x5), Insect Plate, Sceptilite"
  }

    BAYOU_SECRET = {
    :ID => "117",
    :Name => "The Bayou's Secret",
    :QuestGiver => "Alkor",
    :Stage1 => "Interview residents",
	:Stage2 => "Recover drone remains",
	:Stage3 => "Destroy loose parasites",
	:Stage5 => "Quest Completed",
	:Location1 => "Tucana City",
	:Location2 => "Tucana Bayou",
	:Location3 => "Destroyed Lab",
	:Location4 => "Tucana City",
	:QuestDescription1 => "Alkor the alchemist and village elder has asked you to find out what the Epoch Corporation was up to and what the purpose of their facility was on the north end of the Bayou. He has asked you to interview 5 former employees that worked there that will all be indoors.",
	:QuestDescription2 => "One of the former facility employees mentioned that they discovered the remnants of a Magnemite drone that had bits of a message flickering that couldn't be recovered. Alkor has told you to scan the Bayou for 5 more drone remnants.",
	:QuestDescription3 => "The partially decrypted message from the droid indicated that something had gotten loose in the facility and multiplied. It might be prudent to destroy whatever is still left in that facility.",
	:QuestDescription4 => "You were able to neutralize the cosmic parasite T.Reuniclus that had escaped their enclosures throughout the Destroyed Lab. Alkor has rewarded you for helping clean up the mess left behind by the Epoch Corporation's research.",
    :RewardString => "Rune 29 - Inner Focus, Heart Scale (x3), Focus Sash, Beheeyemite"
  }

    ROT_BENEATH_OUR_FEET = {
    :ID => "118",
    :Name => "The Rot Beneath Our Feet",
    :QuestGiver => "Marin",
    :Stage1 => "Signal artillery bombardments",
	:Stage2 => "Plant Shadowstone mines",
	:Stage3 => "Clear Creep Tumours",
	:Stage4 => "Quest Completed",
	:Location1 => "The Trenches",
	:Location2 => "The Battlefront",
	:Location3 => "No Man's Land",
	:Location4 => "No Man's Land",
	:QuestDescription1 => "Staff sergeant Marin has asked for your help with destroying the tunnelling Anomaly wurms that have emerged throughout the Trenches. Signal the presence of 5 of them by throwing a flare down their throats, take cover and watch as the siege weapons bombard them from afar.",
	:QuestDescription2 => "Marin has asked you to place six Shadowstone mines in key chokepoints throughout the Battlefront. She has marked off the key areas for you to bury the mines so unsuspecting Anomalies blow themselves up when they walk over the mines.",
	:QuestDescription3 => "Marin has tasked you with clearing out seven Anomaly creep tumours that are spreading corrosive ground throughout No Man's Land. When you clear out the tumours, be wary that an Anomaly broodmother is likely to emerge and attack you.",
	:QuestDescription4 => "You were able to clear out the creep tumours and destroy the Anomaly broodmother that was laying the creep tumours. Marin has rewarded you for helping with the clean-up operation.",
    :RewardString => "Rune 31 - Arena Trap, Blue and Green Shard (x3 each), Pyukumite, Max Revive"
  }

    OPERATION_RECLAMATION = {
    :ID => "119",
    :Name => "Operation Reclamation",
    :QuestGiver => "Orlan",
    :Stage1 => "Plant NATU sentries",
	:Stage2 => "Loot military vehicles",
	:Stage3 => "Rescue stranded soldiers",
	:Stage4 => "Quest Completed",
	:Location1 => "The Trenches",
	:Location2 => "The Battlefront",
	:Location3 => "No Man's Land",
	:Location4 => "No Man's Land",
	:QuestDescription1 => "Sergeant Orlan has asked you to plant 4 NATU sentries throughout the Trenches. When you plant them, be prepared to fight off any Anomaly waves. Orlan will radio out to you when you're done for the next step in the Operation.",
	:QuestDescription2 => "Sergeant Orlan has told you that six military vehicles full of supplies were abandoned when the Anomaly attack waves forced the Libram City soldiers to retreat and abandon their posts. He has asked you to loot them for all the supplies left behind.",
	:QuestDescription3 => "Sergeant Orlan has instructed you to save 5 soldiers that have been sending distress signals. He's asked you to rescue them and return to him when you have been able to save them.",
	:QuestDescription4 => "You were able to complete Operation: Reclamation for Sergeant Orlan. He has rewarded you for helping with the operation.",
    :RewardString => "Red and Yellow Shard (x3 each), Full Restore (x3), T.Grimmsnarlite, TM196 Umbral Wave"
  }
  
    THE_CULLING = {
    :ID => "120",
    :Name => "The Culling",
    :QuestGiver => "Bruce",
    :Stage1 => "Destroy altars",
	:Stage2 => "Slay cultists",
	:Stage3 => "Disrupt summoning rituals",
	:Stage4 => "Quest Completed",
	:Location1 => "Swamp of Sorrows",
	:Location2 => "The Overgrowth",
	:Location3 => "Felfire Canyon",
	:Location4 => "Felfire Canyon",
	:QuestDescription1 => "One of the human refugees from Lupus Refuge has asked for your help in pushing back the acolytes from the Cult of the Hungerer. To start, he has asked you to destroy 8 of the makeshift altars that they have erected throughout the Swamp of the Sorrows. Meet him at the end of the area when complete.",
	:QuestDescription2 => "Bruce has asked you to help dispose of 5 of the cultists roaming around the Overgrowth. Meet him at the end of the area when complete.",
	:QuestDescription3 => "To complete your support for Bruce's mission, he has asked you to disrupt the demon Pokemon summoning rituals that the cultists have begun throughout Felfire Canyon. He has asked you to close 6 demon summoning portals found throughout and meet with him near the end of the area when complete.",
	:QuestDescription4 => "You were able to help Bruce push back the acolytes from the Cult of the Hungerer by destroying their altars, thinning their numbers and disrupting their demon summoning rituals. He has rewarded you for helping push them back.",
    :RewardString => "Rune 30 - Prism Armor, Orange and Purple Shard (x3 each), Full Restore (x3), Banettite"
  }
  
    MY_PRECIOUSSS = {
    :ID => "121",
    :Name => "My Preciousss",
    :QuestGiver => "Smeagol",
    :Stage1 => "Inspect deepwater pits",
	:Stage2 => "Track footprints",
	:Stage3 => "Search web traps",
	:Stage4 => "Stop Smeagol",
	:Stage5 => "Find Smeagol",
	:Stage6 => "Quest Completed",
	:Location1 => "Swamp of Sorrows",
	:Location2 => "The Overgrowth",
	:Location3 => "Felfire Canyon",
	:Location4 => "Deadwind Pass",
	:Location5 => "Leviathan's Maw",
	:Location6 => "Leviathan's Maw",
	:QuestDescription1 => "A cultist that was forsaken by both the Lupus Refuge and his own cultists lost a ring precious to him. He has asked you to inspect 6 of the deepwater pits of the Swamp of Sorrows for the ring, but beware the fish Pokemon that lurk near them.",
	:QuestDescription2 => "Smeagol has asked you to track the footprints of an ogre Pokemon, a Hypno, throughout the Overgrowth. He suspects that it may have eaten one of the fish that ate his precious. He has told you to look for the footprints in the puddles to find where the ogre may have gone.",
	:QuestDescription3 => "Realizing the ogre was poisoned, Smeagol suspects that a large spider Anomaly may have taken his ring. He has asked you to search 7 web traps that Shelob would have set throughout the Felfire Canyon and the cultist bodies that may have gotten trapped in them for his ring.",
	:QuestDescription4 => "Smeagol has gone mad and insists that Shelob must have his precious ring. He wants to force her out of hiding by destroying the eggs she has laid throughout the Deadwind Pass in hopes of enraging her. You will need to stop him before he gets himself killed.",
	:QuestDescription5 => "Smeagol's destruction of the eggs drew Shelob out of the darkness and caused her to ambush you. She had the missing ring when you sifted through her corpse after defeating her. You need to now track down where Smeagol is lurking in Leviathan's Maw to seek vengeance against him.",
	:QuestDescription6 => "You found Smeagol in Leviathan's Maw and confronted him about his true intentions. The naive fool wanted his ring back and was willing to sacrifice anyone to get his precious ring back. His desperation following a struggle with you resulted in him falling down the cliff to his death.",
    :RewardString => "Full Restore, Heart Scale, Max Revive (x3 each), Water Sword, Sablenite"
  }
  
    STRATEGIC_ADVANTAGE = {
    :ID => "122",
    :Name => "Strategic Advantage",
    :QuestGiver => "Mark",
    :Stage1 => "Slay Carnivines",
	:Stage2 => "Rescue kidnapped humans",
	:Stage3 => "Restore repelling wards",
	:Stage4 => "Destroy corruption wards",
	:Stage5 => "Quest Completed",
	:Location1 => "The Overgrowth",
	:Location2 => "Felfire Canyon",
	:Location3 => "Deadwind Pass",
	:Location4 => "Leviathan's Maw",
	:Location5 => "Leviathan's Maw",
	:QuestDescription1 => "Mark, a soldier from the Libram City military has asked you to help him thin the numbers of the man-eating Carnivines in the Overgrowth by slaying 7 of them. By doing this, the Libram City military forces can advance further to help with the pursuit of Leviathan.",
	:QuestDescription2 => "Mark has discovered that the cultists from the Cult of the Hungerer have been kidnapping humans from the refuge with the intent of sacrificing them to Leviathan. He has asked you to rescue 6 kidnapped humans that are being kept prisoner in the Felfire Canyon.",
	:QuestDescription3 => "Mark has learned that the Anomaly forces have been growing in the Deadwind Pass and managed to dismantle 7 of the unified resonance wards. This has allowed the Anomaly numbers to flourish. Restore the wards so the minor Anomalies will once again be repelled by them.",
	:QuestDescription4 => "Mark has learned that the cultists have erected some 'telepathic pylons' throughout Leviathan's Maw that help magnify his telepathic terror from a distance. He has asked you to destroy 6 of these pylons to suppress his influence. Beware his pet Malamars and Cloysters that guard these pylons.",
	:QuestDescription5 => "Leviathan's telepathic pylons were destroyed and you dealt with his pets that were guarding them. Mark has now returned back to the Refuge to begin mobilizing the Libram City military forces to support your siege of Leviathan's Castle. He has rewarded you for your effort.",
    :RewardString => "Spooky Plate, Dark Sword, Garbodinite, Tetra Repel (x5), Max Revive (x1)"
  }
  
    SACRIFICIAL_LAMB = {
    :ID => "123",
    :Name => "Sacrificial Lamb",
    :QuestGiver => "Cassius",
    :Stage1 => "Search ruins",
	:Stage2 => "Find summoning tomes",
	:Stage3 => "Meet Cassius",
	:Stage4 => "Kill guards; free prisoners",
	:Stage5 => "Defeat Khronus",
	:Stage6 => "Quest Completed",
	:Location1 => "Deadwind Pass",
	:Location2 => "Leviathan's Maw",
	:Location3 => "Castle Leviathan - Cellar",
	:Location4 => "Castle Leviathan - Cellar",
	:Location5 => "Castle Leviathan - Chapel",
	:Location6 => "Castle Leviathan - Chapel",
	:QuestDescription1 => "Cassius, a human from the Lupus Refuge has been on the trail of some cultists that he suspects are responsible for abducting his sister. He has asked you to search the 7 ruined camps of Deadwind Pass for any traces of the cultists' plans or the location of his kidnapped sister.",
	:QuestDescription2 => "Cassius has learned that the cultists are abducting a number of humans from the Refuge as part of some unholy ritual. He wants me to find 6 of the tomes throughout Leviathan's Maw to learn the nature of the ritual that will be performed and how to stop it.",
	:QuestDescription3 => "After reading the tomes, you've learned that the cultists intend to sacrifice all 6 prisoners in an unholy ritual to summon forth an empowered Anomaly. Cassius has asked you to meet with him at the entrance of the Cellar of Castle Leviathan for next steps.",
	:QuestDescription4 => "Cassius has determined that there are a number of cultist guards found in the Cellar of Castle Leviathan. He has asked you to disarm them and retrieve a keychain that may open the 5 prison cells. When you find the cells, free each of the prisoners and then return to Cassius.",
	:QuestDescription5 => "Cassius asked you to help him find the head cultist Khronus and rescue his sister from the Chapel area of Castle Leviathan.",
	:QuestDescription6 => "You were able to successfully stop the sacrifice ritual and rescue Cassius's sister. He has rewarded you for your help in saving his sister from the sacrifice ritual.",
    :RewardString => "Rune 32 - Clear Body, Max Revive (x3), Cosmic Sword, Absolite"
  }
  
    RITUAL_CLEANSING = {
    :ID => "124",
    :Name => "Ritual Cleansing",
    :QuestGiver => "Lucion",
    :Stage1 => "Slay Mismagius",
	:Stage2 => "Destroy barrels",
	:Stage3 => "Release chained phantoms",
	:Stage4 => "Quest Completed",
	:Location1 => "Castle Leviathan - Library",
	:Location2 => "Castle Leviathan - Kitchen",
	:Location3 => "Castle Leviathan - Chapel",
	:Location4 => "Castle Leviathan - Chapel",
	:QuestDescription1 => "Lucion, a chained phantom, has asked for your help. The cultists perform a ritual that involves extracting souls from their bodies and enslaving them. He has asked you to put to rest 8 Mismagius spirits roaming the Library of Castle Leviathan.",
	:QuestDescription2 => "Lucion has told you that cultists force-feed a special tincture to their ritual victims that allow the spirit to be separated from the body and subsequently enslaved in undeath. This tincture is mixed in the Kitchen of Castle Leviathan. He has asked you to destroy 6 of the barrels of this tincture.",
	:QuestDescription3 => "Lucion has asked you to release the spirits of human sacrifices that were chained to the Chapel area of Castle Leviathan. After defeating them and rescuing them from their indentured servitude to the cultists, return to Lucion at the entrance of the Chapel for your reward.",
	:QuestDescription4 => "You helped save a number of the spirits bound in service of the cult of the Hungerer. You also destroyed their ability to force more spirits to serve them and released the ones that were currently enslaved. He has thanked you with a reward.",
    :RewardString => "Offense, Protection and Wisdom Vials (x3 each), Full Restore (x3), Metagrossite"
  }
  
    SAVE_THE_SOULSTONE = {
    :ID => "125",
    :Name => "Save the Soulstone",
    :QuestGiver => "Sentry",
    :Stage1 => "Destroy Anomaly tumours",
	:Stage2 => "Erect warding crystals",
	:Stage3 => "Save Cara's Aspects",
	:Stage4 => "Quest Completed",
	:Location1 => "Cara's Fear",
	:Location2 => "Cara's Hesitation",
	:Location3 => "Cara's Despair",
	:Location4 => "Cara's Despair",
	:QuestDescription1 => "A sentry within the Soulstone has asked for your help in cleansing the Soulstone from Leviathan's corruption. He has asked you to destroy 7 Anomaly creep tumours that are spreading the rot. Beware that destroying tumours may cause hordes of minor Anomalies to emerge.",
	:QuestDescription2 => "The sentry has indicated that the next area of the Soulstone is too far gone to cleanse; instead, he has asked you to prevent the rot from spreading further by erecting 5 warding crystals throughout the area to stop the advance of the corrupting influence and reinforce the Soulstone's protective magic.",
	:QuestDescription3 => "After years of carrying the weight of the Soulstone, Cara's sanity has been fractured with 5 of her aspects lost somewhere in the corruption of the Soulstone prison. The sentry has asked you to track down and find those aspects of her personality before they are lost to Leviathan's corruption forever.",
	:QuestDescription4 => "You helped destroy the Anomaly creep tumours, stabilize the Soulstone, and restore the fractured aspects of Cara's personality that were lost in the Soulstone prison. The sentry has rewarded you with some valuable items that may help you in your battle ahead.",
    :RewardString => "Rune 33 - Pastel Veil, Toughness + Intellect Vials (x3 each), Full Restore and Max Revive (x3 each)"
  }

=begin
   # Here's an extension of the above that includes multiple stages
  Quest2 = {
    :ID => "2",
    :Name => "Introductions",
    :QuestGiver => "Little Boy",
    :Stage1 => "Look for clues.",
    :Stage2 => "Follow the trail.",
    :Stage3 => "Catch the troublemakers!",
    :Location1 => "Lappet Town",
    :Location2 => "Viridian Forest",
    :Location3 => "Route 3",
    :QuestDescription1 => "Some wild Pokémon stole a little boy's favourite toy. Find those troublemakers and help him get it back.",
    :RewardString => "Something shiny!"
  }
  
  # Here's an example of a quest with lots of stages that also doesn't have a stage location defined for every stage
  Quest3 = {
    :ID => "3",
    :Name => "Last-minute chores",
    :QuestGiver => "Grandma",
    :Stage1 => "A",
    :Stage2 => "B",
    :Stage3 => "C",
    :Stage4 => "D",
    :Stage5 => "E",
    :Stage6 => "F",
    :Stage7 => "G",
    :Stage8 => "H",
    :Stage9 => "I",
    :Stage10 => "J",
    :Stage11 => "K",
    :Stage12 => "L",
    :Location1 => "nil",
    :Location2 => "nil",
    :Location3 => "Dewford Town",
    :QuestDescription1 => "Isn't the alphabet longer than this?",
    :RewardString => "Chicken soup!"
  }
  
  # Here's an example of not defining the quest giver and reward text
  Quest4 = {
    :ID => "4",
    :Name => "A new beginning",
    :QuestGiver => "nil",
    :Stage1 => "Turning over a new leaf... literally!",
    :Stage2 => "Help your neighbours.",
    :Location1 => "Milky Way",
    :Location2 => "nil",
    :QuestDescription1 => "You crash landed on an alien planet. There are other humans here and they look hungry...",
    :RewardString => "nil"
  }
  
  # Other random examples you can look at if you want to fill out the UI and check out the page scrolling
  Quest5 = {
    :ID => "5",
    :Name => "All of my friends",
    :QuestGiver => "Barry",
    :Stage1 => "Meet your friends near Acuity Lake.",
    :QuestDescription1 => "Barry told me that he saw something cool at Acuity Lake and that I should go see. I hope it's not another trick.",
    :RewardString => "You win nothing for giving in to peer pressure."
  }
  
  Quest6 = {
    :ID => "6",
    :Name => "The journey begins",
    :QuestGiver => "Professor Oak",
    :Stage1 => "Deliver the parcel to the Pokémon Mart in Viridian City.",
    :Stage2 => "Return to the Professor.",
    :Location1 => "Viridian City",
    :Location2 => "nil",
    :QuestDescription1 => "The Professor has entrusted me with an important delivery for the Viridian City Pokémon Mart. This is my first task, best not mess it up!",
    :RewardString => "nil"
  }
  
  Quest7 = {
    :ID => "7",
    :Name => "Close encounters of the... first kind?",
    :QuestGiver => "nil",
    :Stage1 => "Make contact with the strange creatures.",
    :Location1 => "Rock Tunnel",
    :QuestDescription1 => "A sudden burst of light, and then...! What are you?",
    :RewardString => "A possible probing."
  }
  
  Quest8 = {
    :ID => "8",
    :Name => "These boots were made for walking",
    :QuestGiver => "Musician #1",
    :Stage1 => "Listen to the musician's, uhh, music.",
    :Stage2 => "Find the source of the power outage.",
    :Location1 => "nil",
    :Location2 => "Celadon City Sewers",
    :QuestDescription1 => "A musician was feeling down because he thinks no one likes his music. I should help him drum up some business."
  }
  
  Quest9 = {
    :ID => "9",
    :Name => "Got any grapes?",
    :QuestGiver => "Duck",
    :Stage1 => "Listen to The Duck Song.",
    :Stage2 => "Try not to sing it all day.",
    :Location1 => "YouTube",
    :QuestDescription1 => "Let's try to revive old memes by listening to this funny song about a duck wanting grapes.",
    :RewardString => "A loss of braincells. Hurray!"
  }
  
  Quest10 = {
    :ID => "10",
    :Name => "Singing in the rain",
    :QuestGiver => "Some old dude",
    :Stage1 => "I've run out of things to write.",
    :Stage2 => "If you're reading this, I hope you have a great day!",
    :Location1 => "Somewhere prone to rain?",
    :QuestDescription1 => "Whatever you want it to be.",
    :RewardString => "Wet clothes."
  }
  
  Quest11 = {
    :ID => "11",
    :Name => "When is this list going to end?",
    :QuestGiver => "Me",
    :Stage1 => "When IS this list going to end?",
    :Stage2 => "123",
    :Stage3 => "456",
    :Stage4 => "789",
    :QuestDescription1 => "I'm losing my sanity.",
    :RewardString => "nil"
  }
  
  Quest12 = {
    :ID => "12",
    :Name => "The laaast melon",
    :QuestGiver => "Some stupid dodo",
    :Stage1 => "Fight for the last of the food.",
    :Stage2 => "Don't die.",
    :Location1 => "A volcano/cliff thing?",
    :Location2 => "Good advice for life.",
    :QuestDescription1 => "Tea and biscuits, anyone?",
    :RewardString => "Food, glorious food!"
  }
=end

end