#########################################################
###                 Encounter list UI                 ###
### Based on the original resource by raZ and friends ###
#########################################################


# This is the name of a graphic in your Graphics/Pictures folder that changes the look of the UI
# If the graphic does not exist, you will get an error
WINDOWSKIN = "base.png"

# This hash allows you to define the names of your encounter types if you want them to be more logical
# E.g. "Surfing" instead of "Water"
# If missing, the script will use the encounter type names in GameData::EncounterTypes
USER_DEFINED_NAMES = {
:Land => "Grass",
:LandDay => "Grass (day)",
:LandNight => "Grass (night)",
:LandMorning => "Grass (morning)",
:LandAfternoon => "Grass (afternoon)", 
:LandEvening => "Grass (evening)",
:Cave => "Indoor", # Changed by Jos 2022-10-15 to use Cave without making a new encounter
:CaveDay => "Indoor (day)", # Changed by Jos 2022-10-15 to use Cave without making a new encounter
:CaveNight => "Indoor (night)", # Changed by Jos 2022-10-15 to use Cave without making a new encounter
:CaveMorning => "Indoor (morning)", # Changed by Jos 2022-10-15 to use Cave without making a new encounter
:CaveAfternoon => "Indoor (afternoon)", # Changed by Jos 2022-10-15 to use Cave without making a new encounter
:CaveEvening => "Indoor (evening)", # Changed by Jos 2022-10-15 to use Cave without making a new encounter
# Changed by Jos 2022-10-08 to allow for new encounters to show up
:Beach => "Beach",
:BeachDay => "Beach (day)",
:BeachNight => "Beach (night)",
:BeachMorning => "Beach (morning)",
:BeachAfternoon => "Beach (afternoon)", 
:BeachEvening => "Beach (evening)",
:Desert => "Desert",
:DesertDay => "Desert (day)",
:DesertNight => "Desert (night)",
:DesertMorning => "Desert (morning)",
:DesertAfternoon => "Desert (afternoon)", 
:DesertEvening => "Desert (evening)",
# End of addition
:Water => "Surfing",
:WaterDay => "Surfing (day)",
:WaterNight => "Surfing (night)",
:WaterMorning => "Surfing (morning)",
:WaterAfternoon => "Surfing (afternoon)",
:WaterEvening => "Surfing (evening)",
:OldRod => "Fishing (Old Rod)",
:GoodRod => "Fishing (Good Rod)",
:SuperRod => "Fishing (Super Rod)",
:RockSmash => "Rock Smash",
:HeadbuttLow => "Headbutt (rare)",
:HeadbuttHigh => "Headbutt (common)",
:BugContest => "Bug Contest"
}

# Remove the '#' from this line to use default encounter type names
#USER_DEFINED_NAMES = nil

# Method that returns whether a specific form has been seen (any gender)
def seen_form_any_gender?(species, form)
  ret = false
  if $player.pokedex.seen_form?(species, 0, form) ||
    $player.pokedex.seen_form?(species, 1, form)
    ret = true
  end
  return ret
end

class EncounterList_Scene

  # Constructor method
  # Sets a handful of key variables needed throughout the script
  def initialize
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    @sprites = {}
    mapid = $game_map.map_id
    @encounter_data = GameData::Encounter.get(mapid, $PokemonGlobal.encounter_version)
    if @encounter_data
      @encounter_tables = Marshal.load(Marshal.dump(@encounter_data.types))
      @max_enc, @eLength = getMaxEncounters(@encounter_tables)
    else
      @max_enc, @eLength = [1, 1]
    end
    @index = 0
  end
 
  # This gets the highest number of unique encounters across all defined encounter types for the map
  # It might sound weird, but this is needed for drawing the icons
  def getMaxEncounters(data)
    keys = data.keys
    a = []
    for key in keys
      b = []
      arr = data[key]
      for i in 0...arr.length
        b.push( arr[i][1] )
      end
      a.push(b.uniq.length)
    end
    return a.max, keys.length
  end
  
  # This method initiates the following:
  # Background graphics, text overlay, Pokémon sprites and navigation arrows
  def pbStartScene
    @idx = 0
    @old_index = 0
    if !File.file?("Graphics/Pictures/EncounterUI/"+WINDOWSKIN)
      raise _INTL("You are missing the graphic for this UI. Make sure the image is in your Graphics/Pictures folder and that it is named appropriately.")
    end
    addBackgroundPlane(@sprites,"bg","EncounterUI/bg",@viewport)
    @sprites["base"] = IconSprite.new(0,0,@viewport)
    @sprites["base"].setBitmap("Graphics/Pictures/EncounterUI/"+WINDOWSKIN)
    @sprites["base"].ox = @sprites["base"].bitmap.width/2
    @sprites["base"].oy = @sprites["base"].bitmap.height/2
    @sprites["base"].x = Graphics.width/2; @sprites["base"].y = Graphics.height/2
    @sprites["base"].opacity = 200
    @sprites["locwindow"] = Window_AdvancedTextPokemon.new("")
    @sprites["locwindow"].viewport = @viewport
    @sprites["locwindow"].width = 512
    @sprites["locwindow"].height = 344
    @sprites["locwindow"].x = (Graphics.width - @sprites["locwindow"].width)/2
    @sprites["locwindow"].y = (Graphics.height - @sprites["locwindow"].height)/2
    @sprites["locwindow"].windowskin = nil
    @h = (Graphics.height - @sprites["base"].bitmap.height)/2
    @w = (Graphics.width - @sprites["base"].bitmap.width)/2
    @max_enc.times do |i|
      @sprites["icon_#{i}"] = PokemonSpeciesIconSprite.new(nil,@viewport)
      @sprites["icon_#{i}"].x = @w + 28 + 64*(i%7)
      @sprites["icon_#{i}"].y = @h + 100 + (i/7)*64
      @sprites["icon_#{i}"].z = 20
      @sprites["icon_#{i}"].visible = false
    end
    @typeName = ["Type - Normal","Type - Fighting","Type - Flying","Type - Poison","Type - Ground","Type - Rock","Type - Bug",
                 "Type - Ghost","Type - Steel","Type - Null","Type - Fire","Type - Water","Type - Grass","Type - Electric",
                "Type - Psychic","Type - Ice","Type - Dragon","Type - Dark","Type - Fairy","Type - Cosmic","Type - Sound","Type - Light"]
    if @max_enc > 1
      enc_array, currKey = getEncData
      enc_array.each do |s|
      species_data = GameData::Species.get(s)
       @max_enc.times do |i|
        @sprites["seen_#{i}"] = IconSprite.new(0,0,@viewport)
        @sprites["seen_#{i}"].setBitmap("Graphics/Pictures/EncounterUI/seen")
        @sprites["seen_#{i}"].x = @w + 28 + 64*(i%7)
        @sprites["seen_#{i}"].y = @h + 100 + (i/7)*64
        @sprites["seen_#{i}"].z = 10
        @sprites["seen_#{i}"].visible = false

        @sprites["type1_#{i}"] = IconSprite.new(0,0,@viewport)
        @sprites["type1_#{i}"].setBitmap("Graphics/Pictures/EncounterUI/Type - Null")
        @sprites["type1_#{i}"].x = @w + 28 + 64*(i%7)
        @sprites["type1_#{i}"].y = @h + 102 + (i/7)*64
        @sprites["type1_#{i}"].z = 15
        @sprites["type1_#{i}"].visible = false
        @sprites["type2_#{i}"] = IconSprite.new(0,0,@viewport)
        @sprites["type2_#{i}"].setBitmap("Graphics/Pictures/EncounterUI/Type - Null")
        @sprites["type2_#{i}"].x = @w + 60 + 64*(i%7)
        @sprites["type2_#{i}"].y = @h + 102 + (i/7)*64
        @sprites["type2_#{i}"].z = 15
        @sprites["type2_#{i}"].visible = false
       end
      end
    end
    @sprites["cursorDex"] = IconSprite.new(0,0,@viewport)
    @sprites["cursorDex"].setBitmap("Graphics/Pictures/EncounterUI/cursor")
    @sprites["cursorDex"].x = @w + 28 + 64*(@idx%7)
    @sprites["cursorDex"].y = @h + 100 + (@idx/7)*64  
    @sprites["cursorDex"].z = 13
    if @max_enc > 1
      @sprites["cursorDex"].visible = true
    else
      @sprites["cursorDex"].visible = false
    end
    @sprites["rightarrow"] = AnimatedSprite.new("Graphics/Pictures/rightarrow",8,40,28,2,@viewport)
    @sprites["rightarrow"].x = Graphics.width - @sprites["rightarrow"].bitmap.width
    @sprites["rightarrow"].y = Graphics.height/2 - @sprites["rightarrow"].bitmap.height/16
    @sprites["rightarrow"].visible = false
    @sprites["rightarrow"].play
    @sprites["leftarrow"] = AnimatedSprite.new("Graphics/Pictures/leftarrow",8,40,28,2,@viewport)
    @sprites["leftarrow"].x = 0
    @sprites["leftarrow"].y = Graphics.height/2 - @sprites["rightarrow"].bitmap.height/16
    @sprites["leftarrow"].visible = false
    @sprites["leftarrow"].play
    @encounter_data ? drawPresent : drawAbsent
    pbFadeInAndShow(@sprites) { pbUpdate }
  end
 
  # Main function that controls the UI
  def pbEncounter
    loop do
      Graphics.update
      Input.update
      pbUpdate
      if @encounter_data
       enc_array, currKey = getEncData
      end
      data = (@encounter_data) ? enc_array.length-1 : 0
      key = @old_index
      val = @idx
      limit = data
      if Input.trigger?(Input::RIGHT) && @eLength >1 && @index< @eLength-1
        pbPlayCursorSE
        hideSprites
        @index += 1
        @idx = 0
        pbMoveDexSel
        drawPresent
      elsif Input.trigger?(Input::LEFT) && @eLength >1 && @index !=0
        pbPlayCursorSE
        hideSprites
        @index -= 1
        @idx = 0
        drawPresent
      elsif Input.trigger?(Input::JUMPUP) && @max_enc > 1
        if key > 0
          val -= 1
        elsif key==0
          val = limit
        end
        @idx = val
        pbMoveDexSel
       elsif Input.trigger?(Input::JUMPDOWN) && @max_enc > 1
        if key < limit
          val += 1
        elsif key==limit
          val = 0
        end
        @idx = val
        pbMoveDexSel
      elsif Input.trigger?(Input::ACTION) && @max_enc > 1
      for i in 0...limit+1
        @sprites["type1_#{i}"].visible = !@sprites["type1_#{i}"].visible
        @sprites["type2_#{i}"].visible = !@sprites["type2_#{i}"].visible
      end
      elsif Input.trigger?(Input::SPECIAL) && @max_enc > 1
        enc_array, currKey = getEncData
        species_data = GameData::Species.get(enc_array[@idx])
        if $Trainer.owned?(enc_array[@idx])
        pbFadeOutIn {
          scene = PokemonPokedexInfo_Scene.new
          screen = PokemonPokedexInfoScreen.new(scene)
          screen.pbStartSceneSingle(species_data.species)
        }
        end
      elsif Input.trigger?(Input::USE)
        # Changed by DemICE 30-Nov-2024 Demonic Eye upgrade
        if $bag.has?(:OPENDEMONEYE) && $game_switches[477] && @encounter_data
          enc_array, currKey = getEncData
          level = @encounter_tables[currKey][0][3]
          encspecies = enc_array[@idx]
          WildBattle.start(encspecies,level)
		  drawPresent
        else
          pbMessage("JumpUp & JumpDown - Move Cursor")
          pbMessage("Action - Type Overlay")
          pbMessage("Special - Open Pokedex")
        end
      elsif Input.trigger?(Input::BACK)
        pbPlayCloseMenuSE
        break
      end
    end
  end

  def pbMoveDexSel
    if @old_index != @idx
      @sprites["cursorDex"].x = @w + 28 + 64*(@idx%7)
      @sprites["cursorDex"].y = @h + 100 + (@idx/7)*64  
      @old_index = @idx
    end
  end

  # Draw text and icons if map has encounters defined
  def drawPresent
    @sprites["rightarrow"].visible = (@index < @eLength-1) ? true : false
    @sprites["leftarrow"].visible = (@index > 0) ? true : false
    i = 0
    enc_array, currKey = getEncData
# Changed by Jos 2022-08-05
# The purpose of commenting out this code is to make sure the grey ? marks disappear and a greyed out icon is always present
    enc_array.each do |s|
      species_data = GameData::Species.get(s)
      if !$Trainer.pokedex.owned?(s)
        @sprites["icon_#{i}"].pbSetParams(s,0,species_data.form,false)
        @sprites["icon_#{i}"].tone = Tone.new(0,0,0,255)
        @sprites["icon_#{i}"].visible = true
        @sprites["seen_#{i}"].setBitmap("Graphics/Pictures/EncounterUI/seen")
        @sprites["type1_#{i}"].setBitmap("Graphics/Pictures/EncounterUI/Type - Null")
        @sprites["type2_#{i}"].setBitmap("Graphics/Pictures/EncounterUI/Type - Null")
        @sprites["type1_#{i}"].visible = false
        @sprites["type2_#{i}"].visible = false
      else
        @sprites["icon_#{i}"].pbSetParams(s,0,species_data.form,false)
        @sprites["icon_#{i}"].tone = Tone.new(0,0,0,0)
        @sprites["icon_#{i}"].visible = true
        @sprites["seen_#{i}"].setBitmap("Graphics/Pictures/EncounterUI/owned")
        root = "Graphics/Pictures/EncounterUI/"
        path1 = @typeName[GameData::Type.get(species_data.types[0]).icon_position]
        name_1 = root + path1
        @sprites["type1_#{i}"].setBitmap(name_1)
        if species_data.types[1] != nil
          path2 = @typeName[GameData::Type.get(species_data.types[1]).icon_position]
          name_2 = root + path2
          @sprites["type2_#{i}"].setBitmap(name_2)
        else
          @sprites["type2_#{i}"].setBitmap(name_1)
          
        end
      end
      @sprites["seen_#{i}"].visible = true
      i += 1
    end
# Changed by Jos 2022-08-05
    # Get user-defined encounter name or default one if not present
    name = USER_DEFINED_NAMES ? USER_DEFINED_NAMES[currKey] : GameData::EncounterType.get(currKey).real_name
    loctext = _INTL("<ac><c2=43F022E8>{1}: {2}</c2></ac>", $game_map.name,name)
    loctext += sprintf("<al><c2=7FF05EE8>Total encounters for area: %s</c2></al>",enc_array.length)
    loctext += sprintf("<c2=63184210>-----------------------------------------</c2>")
    @sprites["locwindow"].setText(loctext)
  end
  
  # Draw text if map has no encounters defined (e.g. in buildings)
  def drawAbsent
    loctext = _INTL("<ac><c2=43F022E8>{1}</c2></ac>", $game_map.name)
    loctext += sprintf("<al><c2=7FF05EE8>This area has no encounters!</c2></al>")
    loctext += sprintf("<c2=63184210>-----------------------------------------</c2>")
    @sprites["locwindow"].setText(loctext)
  end
 
  # Method that returns an array of symbolic names for chosen encounter type on current map
  # Currently, the resulting array is sorted by national Pokédex number
  def getEncData
    currKey = @encounter_tables.keys[@index]
    arr = []
    enc_array = []
    @encounter_tables[currKey].each { |s| arr.push( s[1] ) }
    GameData::Species.each { |s| enc_array.push(s.id) if arr.include?(s.id) } # From Maruno
    enc_array.uniq!
    return enc_array, currKey
  end
  
  def pbUpdate
    pbUpdateSpriteHash(@sprites)
  end
  
  # Hide sprites
  def hideSprites
    for i in 0...@max_enc
      @sprites["icon_#{i}"].visible = false
      @sprites["seen_#{i}"].visible = false
      @sprites["type1_#{i}"].visible = false
      @sprites["type2_#{i}"].visible = false
    end
  end

  # Dipose stuff at the end
  def pbEndScene
    pbFadeOutAndHide(@sprites) { pbUpdate }
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end

end


class EncounterList_Screen
  def initialize(scene)
    @scene = scene
  end

  def pbStartScreen
    @scene.pbStartScene
    @scene.pbEncounter
    @scene.pbEndScene
  end
end

# Utility method for calling UI
def pbViewEncounters
  scene = EncounterList_Scene.new
  screen = EncounterList_Screen.new(scene)
  screen.pbStartScreen
end