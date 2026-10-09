#===============================================================================
#The arrays below contain the names of the things which will be contained as a
#Specific graphic. You can add to them as per your wish, or add new place arrays.
#If you face problems editing them, feel free to comment in the original post..
#===============================================================================
#Original BW B2W2 Locations for Signpost
#===============================================================================

TOWN = ["Auriga Town", "Vela Town", "Fornax Town", "Corvus Town", "Norma Town"]

CITY = ["Lyra City", "Telescopium City", "Orion City", "Cassiopeia City", "Draco City", "Aquila City", "Ara City", "Libram City", "Science District", "Mining District", "Market District", "The Arboretum", "Arcane District", "Civil District", "Corona City", "Tucana City"]

# Changed by Jos 2021-08-17 to add new villages
VILLAGE = ["Cygnus Village", "Mensa Village", "Pisces Village", "Indus Village", "Ursa Village", "Eridanus Settlement", "Ezreal's Tent", "Bootes Encampment", "Beta Omicron", "Lupus Refuge"]

ROUTE = ["Route 1", "Route 2A", "Route 2B", "Route 3", "Route 4A", "Route 4B", "Route 4C", "Route 5A", "Route 5B", "Route 6A", "Route 6B", "Route 7A", "Route 7B", "Route 10A", "Route 10B", "Route 11A", "Route 11B", "Route 12A", "Route 12B", "Route 13A", "Route 13B", "Route 14A", "Route 14B", "Route 15A", "Route 15B", "Route 16A", "Route 16B", "Route 17A", "Route 17B", "Route 18A", "Route 18B", "Route 19", "Route 20A", "Route 20B", "Route 21A", "Route 21B", "Route 22A", "Route 22B", "Route 22C", "Route 23A", "Route 23B", "Route 23C"]

BRIDGE = ["bridge"]

#===============================================================================
#Custom Locations for Signpost
#===============================================================================

FOREST = ["Europa Forest", "Indus Marsh", "Indus Jungle", "Indus Temple Grounds", "Shadowmoon Forest", "Shadowmoon Marsh", "Swamp of Sorrows", "The Overgrowth", "Leviathan's Maw", "Tucana Bayou"]

CAVE = ["Europa Cave", "Auriga Caverns", "Triton Cave", "Lower Mt. Titania", "Orion Sewers", "Orion Underground", "Orion Landfill", "Mt. Oberon", "Indus Caverns", "Indus Ruins", "Indus Shrine", "Caverns of Rhea", "Sandswept Grotto", "Undersand Caverns", "Mt. Titania", "Charon Ice Tunnels", "Deimos Caves", "Eridanus Tunnels", "Libram Tunnel", "Libram Passageway", "Nesting Grounds", "Spawning Pool", "The Hive", "The Hatchery", "Norma Underground", "The Trenches", "The Battlefront", "No Man's Land"]

PORT = ["Libram Port"]

# Changed by Jos 2023-04-28 to add new water category
WATER = ["Europa Lake", "Hyperion Lake", "Route 8A", "Route 8B", "Indus Beach", "Indus Cove", "Route 9A", "Route 9B", "Lyra Glacier", "Callisto Lake", "Eridanus Trench", "Libram Trench", "Guulrahn Trench", "Draco Trench"]

# Changed by Jos 2023-04-28 to add new Other category
OTHER = ["Auriga Bay", "Auriga Coast", "Lyra Aquarium", "Epoch Mine", "Cold Storage", "Corona Outskirts", "Corona Bazaar", "Corona Marketplace", "Telescopium Academy", "The Black Market", "Breloom's Penthouse", "Orion Docks", "Storage Warehouse", "Locked Warehouse", "Shipping Basement", "Orion Slums", "Temple of Time", "Heart of Time", "Temple of Space", "Heart of Space",  "The In-Between", "Antimatter Temple", "Ezreal's Prison", "Underwater Temple", "Control Bridge", "Crew Quarters", "Engine Room", "Facility Lab", "Underwater Base", "Epoch Corporation HQ", "Orion Side Streets", "Temple of Creation", "Ruins of Creation", "Altar of Creation", "Altar of Time", "Altar of Space", "Altar of Creation", "Arceus' Realm", "The Time Matrix", "Power Plant", "Aether Mine", "Libram Dungeons", "The Orchidarium", "Revolution Safehouse", "Libram City Hall", "The Grand Pylon", "Revolution Lab", "Guulrahn Cavern", "Emil's Workshop", "Abandoned Shelter", "Draco Falls", "Flooded Base", "ECHQ Wreckage", "Norma Casino", "Norma Lighthouse", "Abandoned Shipwreck", "Overgrown Temples", "Destroyed Lab", "Felfire Canyon", "Deadwind Pass", "Castle Leviathan", "Throne of Chaos", "Cara's Fear", "Cara's Hesitation", "Cara's Despair", "Durance of the Prime"]

DESERT = ["Cassiopeia Oasis", "Guulrahn Badlands", "Guulrahn Wastes"]

#===============================================================================
#Custom Settings for manupulating the Script with instructions
#===============================================================================

SHOW_SEASONS = false
#Pretty self explanatory.... Set to false if you don't want season splash...



#===============================================================================
#BW signposts (original by Shiney570, updated by Shashu Greninja)
#===============================================================================
class LocationWindow

  def initialize(name)
    #Original BW, B2W2 Signposts
    newarr=[]
    for name in TOWN
      next if !name.is_a?(String)
      s=name.gsub(/^./) { |m| m.upcase }
      newarr.push(s)
      town=TOWN+newarr
    end
    newarr2=[]
    for name in CITY
      next if !name.is_a?(String)
      s=name.gsub(/^./) { |m| m.upcase }
      newarr2.push(s)
      city=CITY+newarr2
    end
    newarr3=[]
    for name in BRIDGE
      next if !name.is_a?(String)
      s=name.gsub(/^./) { |m| m.upcase }
      newarr3.push(s)
      bridge=BRIDGE+newarr3
    end
    newarr4=[]
    for name in ROUTE
      next if !name.is_a?(String)
      s=name.gsub(/^./) { |m| m.upcase }
      newarr4.push(s)
      route=ROUTE+newarr4
    end
    #Custom Signpost Initializations
    newarr5=[]
    for name in FOREST
      next if !name.is_a?(String)
      s=name.gsub(/^./) { |m| m.upcase }
      newarr5.push(s)
      forest=FOREST+newarr5
    end
    newarr6=[]
    for name in CAVE
      next if !name.is_a?(String)
      s=name.gsub(/^./) { |m| m.upcase }
      newarr6.push(s)
      cave=CAVE+newarr6
    end
    newarr7=[]
    for name in PORT
      next if !name.is_a?(String)
      s=name.gsub(/^./) { |m| m.upcase }
      newarr7.push(s)
      port=PORT+newarr7
    end
    newarr8=[]
    for name in DESERT
      next if !name.is_a?(String)
      s=name.gsub(/^./) { |m| m.upcase }
      newarr8.push(s)
      desert=DESERT+newarr8
    end
    # Changed by Jos 2021-08-17
    newarr9=[]
    for name in VILLAGE
      next if !name.is_a?(String)
      s=name.gsub(/^./) { |m| m.upcase }
      newarr9.push(s)
      village=VILLAGE+newarr9
    end
    # Changed by Jos 2023-04-28
    newarr10=[]
    for name in OTHER
      next if !name.is_a?(String)
      s=name.gsub(/^./) { |m| m.upcase }
      newarr10.push(s)
      other=OTHER+newarr10
    end
    # Changed by Jos 2023-04-28
    newarr11=[]
    for name in WATER
      next if !name.is_a?(String)
      s=name.gsub(/^./) { |m| m.upcase }
      newarr11.push(s)
      water=WATER+newarr11
    end

    @frames=0
    @currentmap=$game_map.map_id
    name=$game_map.name
    @window=Sprite.new
    @window.z=99999
    @overlay=BitmapSprite.new(Graphics.width,Graphics.height)
    @overlay.z= 99999
    @route_number_icons = AnimatedBitmap.new(_INTL("Graphics/Pictures/Location/icon_numbers"))

    if SHOW_SEASONS == true
        @season=Sprite.new
        if pbIsSpring # Jan, May, Sep
          @season.bitmap = RPG::Cache.load_bitmap("Graphics/Pictures/Location/","Spring")
        elsif pbIsSummer # Feb, Jun, Oct
          @season.bitmap = RPG::Cache.load_bitmap("Graphics/Pictures/Location/","Summer")
        elsif pbIsAutumn # Mar, Jul, Nov
          @season.bitmap = RPG::Cache.load_bitmap("Graphics/Pictures/Location/","Autumn")
        elsif pbIsWinter # Apr, Aug, Dec
          @season.bitmap = RPG::Cache.load_bitmap("Graphics/Pictures/Location/","Winter")
        end
        @season.y=Settings::SCREEN_HEIGHT
        @season.z=99999
    end

    for i in 0..town.length-1
      if $game_map.name.include?(town[i]) || @currentmap==TOWN[i]
        @window.bitmap=RPG::Cache.load_bitmap("Graphics/Pictures/Location/","town")
      end
    end
    for i in 0..city.length-1
      if $game_map.name.include?(city[i]) || @currentmap==CITY[i]
        @window.bitmap=RPG::Cache.load_bitmap("Graphics/Pictures/Location/","city")
      end
    end
    for i in 0..bridge.length-1
      if $game_map.name.include?(bridge[i]) || @currentmap==BRIDGE[i]
        @window.bitmap=RPG::Cache.load_bitmap("Graphics/Pictures/Location/","bridge")
      end
    end
    for i in 0..route.length-1
      if $game_map.name.include?(route[i]) || @currentmap==ROUTE[i]
        @route_number=$game_map.name.gsub(/[^0-9]/, '')
        if @route_number.to_i >= 100 #Uses wider Route callout for 3-digit route numbers
          @window.bitmap=RPG::Cache.load_bitmap("Graphics/Pictures/Location/","route_extended")
          @extended_route = true
        else
          @window.bitmap=RPG::Cache.load_bitmap("Graphics/Pictures/Location/","route")
          @extended_route = false
        end
      end
    end
    for i in 0..forest.length-1
      if $game_map.name.include?(forest[i]) || @currentmap==FOREST[i]
        @window.bitmap=RPG::Cache.load_bitmap("Graphics/Pictures/Location/","forest")
      end
    end
    for i in 0..cave.length-1
      if $game_map.name.include?(cave[i]) || @currentmap==CAVE[i]
        @window.bitmap=RPG::Cache.load_bitmap("Graphics/Pictures/Location/","cave")
      end
    end
    for i in 0..port.length-1
      if $game_map.name.include?(port[i]) || @currentmap==PORT[i]
        @window.bitmap=RPG::Cache.load_bitmap("Graphics/Pictures/Location/","port")
      end
    end
    for i in 0..desert.length-1
      if $game_map.name.include?(desert[i]) || @currentmap==DESERT[i]
        @window.bitmap=RPG::Cache.load_bitmap("Graphics/Pictures/Location/","desert")
      end
    end
    # Changed by Jos 2021-08-17
    for i in 0..village.length-1
      if $game_map.name.include?(village[i]) || @currentmap==VILLAGE[i]
        @window.bitmap=RPG::Cache.load_bitmap("Graphics/Pictures/Location/","village")
      end
    end
    # Changed by Jos 2023-04-28
    for i in 0..other.length-1
      if $game_map.name.include?(other[i]) || @currentmap==OTHER[i]
        @window.bitmap=RPG::Cache.load_bitmap("Graphics/Pictures/Location/","other")
      end
    end
    # Changed by Jos 2023-04-28
    for i in 0..water.length-1
      if $game_map.name.include?(water[i]) || @currentmap==WATER[i]
        @window.bitmap=RPG::Cache.load_bitmap("Graphics/Pictures/Location/","water")
      end
    end
    # End of addition
    if @window.bitmap.nil?
      @window.bitmap=RPG::Cache.load_bitmap("Graphics/Pictures/Location/","none")
    end
    @window.y  = -@window.bitmap.height - 4
    @overlay.y = @window.y
    overlay = @overlay.bitmap
    pbSetSystemFont(@overlay.bitmap)
    if @extended_route
      textos=[
      [name,59+14,10-0,0,Color.new(255,255,255),Color.new(115,115,115)], # Changed by Jos 2022-11-09 to make it look nice for v20.1 (used to be 8-12)
      ]
    else
      textos=[
      [name,59,10-0,0,Color.new(255,255,255),Color.new(115,115,115)], # Changed by Jos 2022-11-09 to make it look nice for v20.1 (used to be 8-12)
      ]
    end
    pbDrawTextPositions(overlay,textos)
    #Draws the route numbers as Graphics...
    if @route_number != nil
      if @route_number.to_i >= 100 #Different positions according to route number
       pbDrawRouteNumber(@route_number,@window.bitmap,24-16,8+2)
      elsif @route_number.to_i >= 10
       pbDrawRouteNumber(@route_number,@window.bitmap,24-16,8+2)
      else
       pbDrawRouteNumber(@route_number,@window.bitmap,24-6,8+2)
     end
    end
    pbDrawTextPositions(overlay,textos)
  end
  
end  