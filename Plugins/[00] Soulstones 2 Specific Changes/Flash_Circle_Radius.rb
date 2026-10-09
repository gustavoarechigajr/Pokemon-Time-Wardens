#===============================================================================
# Visibility circle in dark maps
#===============================================================================
class DarknessSprite < Sprite
  attr_reader :radius

  def initialize(viewport = nil)
    super(viewport)
    @darkness = BitmapWrapper.new(Graphics.width, Graphics.height)
    @radius = radiusMin
    self.bitmap = @darkness
    self.z      = 99998
    refresh
  end

  def dispose
    @darkness.dispose
    super
  end

# Changed by Jos 2024-03-10 to adjust flash radius
  def radiusMin; return 128;  end   # Before using Flash
  def radiusMax; return 352; end   # After using Flash

  def radius=(value)
    @radius = value
    refresh
  end

  def refresh
    @darkness.fill_rect(0, 0, Graphics.width, Graphics.height, Color.new(0, 0, 0, 255))
    cx = Graphics.width / 2
    cy = Graphics.height / 2
    cradius = @radius
    numfades = 5
    (1..numfades).each do |i|
      (cx - cradius..cx + cradius).each do |j|
        diff2 = (cradius * cradius) - ((j - cx) * (j - cx))
        diff = Math.sqrt(diff2)
        @darkness.fill_rect(j, cy - diff, 1, diff * 2, Color.new(0, 0, 0, 255.0 * (numfades - i) / numfades))
      end
      cradius = (cradius * 0.9).floor
    end
  end
end

def forceFlash
  darkness = $game_temp.darkness_sprite
  return false if !darkness || darkness.disposed?
  $PokemonGlobal.flashUsed = true
  $stats.flash_count += 1
  radiusDiff = 8*20/Graphics.frame_rate
  while darkness.radius<darkness.radiusMax
    Graphics.update
    Input.update
    pbUpdateSceneMap
    darkness.radius += radiusDiff
    darkness.radius = darkness.radiusMax if darkness.radius>darkness.radiusMax
  end
end