#===============================================================================
# A class that stores code that can be triggered. Each piece of code has an
# associated ID, which can be anything that can be used as a key in a hash.
#===============================================================================
class HandlerHashPorted
  def initialize
    @hash = {}
  end

  def [](id)
    return @hash[id] if id && @hash[id]
    return nil
  end

  def add(id, handler = nil, &handlerBlock)
    if ![Proc, Hash].include?(handler.class) && !block_given?
      raise ArgumentError, "#{self.class.name} for #{id.inspect} has no valid handler (#{handler.inspect} was given)"
    end
    @hash[id] = handler || handlerBlock if id && !id.empty?
  end

  def copy(src, *dests)
    handler = self[src]
    return if !handler
    dests.each { |dest| add(dest, handler) }
  end

  def remove(key)
    @hash.delete(key)
  end

  def clear
    @hash.clear
  end

  def each
    @hash.each_pair { |key, value| yield key, value }
  end

  def keys
    return @hash.keys.clone
  end

  # NOTE: The call does not pass id as a parameter to the proc/block.
  def trigger(id, *args)
    handler = self[id]
    return handler&.call(*args)
  end
end

#===============================================================================
# A stripped-down version of class HandlerHash which only deals with IDs that
# are symbols. Also contains an add_ifs hash for code that applies to multiple
# IDs (determined by its condition proc).
#===============================================================================
class HandlerHashSymbol
  def initialize
    @hash    = {}
    @add_ifs = {}
  end

  def [](sym)
    sym = sym.id if !sym.is_a?(Symbol) && sym.respond_to?("id")
    return @hash[sym] if sym && @hash[sym]
    @add_ifs.each_value do |add_if|
      return add_if[1] if add_if[0].call(sym)
    end
    return nil
  end

  def add(sym, handler = nil, &handlerBlock)
    if ![Proc, Hash].include?(handler.class) && !block_given?
      raise ArgumentError, "#{self.class.name} for #{sym.inspect} has no valid handler (#{handler.inspect} was given)"
    end
    @hash[sym] = handler || handlerBlock if sym
  end

  def addIf(sym, conditionProc, handler = nil, &handlerBlock)
    if ![Proc, Hash].include?(handler.class) && !block_given?
      raise ArgumentError, "addIf call for #{sym} in #{self.class.name} has no valid handler (#{handler.inspect} was given)"
    end
    @add_ifs[sym] = [conditionProc, handler || handlerBlock]
  end

  def copy(src, *dests)
    handler = self[src]
    return if !handler
    dests.each { |dest| add(dest, handler) }
  end

  def remove(key)
    @hash.delete(key)
  end

  def clear
    @hash.clear
    @add_ifs.clear
  end

  def trigger(sym, *args)
    sym = sym.id if !sym.is_a?(Symbol) && sym.respond_to?("id")
    handler = self[sym]
    return handler&.call(sym, *args)
  end
end

#===============================================================================
# A specialised version of class HandlerHash which only deals with IDs that are
# constants in a particular class or module. That class or module must be
# defined when creating an instance of this class.
# Unused.
#===============================================================================
class HandlerHashEnum
  def initialize(mod)
    @mod         = mod
    @hash        = {}
    @addIfs      = []
    @symbolCache = {}
  end

  # 'sym' can be an ID or symbol.
  def [](sym)
    id = fromSymbol(sym)
    ret = nil
    ret = @hash[id] if id && @hash[id]   # Real ID from the item
    symbol = toSymbol(sym)
    ret = @hash[symbol] if symbol && @hash[symbol]   # Symbol or string
    unless ret
      @addIfs.each do |addif|
        return addif[1] if addif[0].call(id)
      end
    end
    return ret
  end

  def fromSymbol(sym)
    return sym unless sym.is_a?(Symbol) || sym.is_a?(String)
    mod = Object.const_get(@mod) rescue nil
    return nil if !mod
    return mod.const_get(sym.to_sym) rescue nil
  end

  def toSymbol(sym)
    return sym.to_sym if sym.is_a?(Symbol) || sym.is_a?(String)
    ret = @symbolCache[sym]
    return ret if ret
    mod = Object.const_get(@mod) rescue nil
    return nil if !mod
    mod.constants.each do |key|
      next if mod.const_get(key) != sym
      ret = key.to_sym
      @symbolCache[sym] = ret
      break
    end
    return ret
  end

  # 'sym' can be an ID or symbol.
  def add(sym, handler = nil, &handlerBlock)
    if ![Proc, Hash].include?(handler.class) && !block_given?
      raise ArgumentError, "#{self.class.name} for #{sym.inspect} has no valid handler (#{handler.inspect} was given)"
    end
    id = fromSymbol(sym)
    @hash[id] = handler || handlerBlock if id
    symbol = toSymbol(sym)
    @hash[symbol] = handler || handlerBlock if symbol
  end

  def addIf(conditionProc, handler = nil, &handlerBlock)
    if ![Proc, Hash].include?(handler.class) && !block_given?
      raise ArgumentError, "addIf call for #{self.class.name} has no valid handler (#{handler.inspect} was given)"
    end
    @addIfs.push([conditionProc, handler || handlerBlock])
  end

  def copy(src, *dests)
    handler = self[src]
    return if !handler
    dests.each { |dest| self.add(dest, handler) }
  end

  def clear
    @hash.clear
    @addIfs.clear
  end

  def trigger(sym, *args)
    handler = self[sym]
    return (handler) ? handler.call(fromSymbol(sym), *args) : nil
  end
end

class AnimatedArrowSprite < Sprite
  attr_reader :frame
  attr_reader :framewidth
  attr_reader :frameheight
  attr_reader :framecount
  attr_reader :animname

  # frameskip is in 1/20ths of a second, and is the time between frame changes.
  def initializeLong(animname, framecount, framewidth, frameheight, frameskip)
    @animname = pbBitmapName(animname)
    @time_per_frame = [1, frameskip].max / 20.0
    raise _INTL("Frame width is 0") if framewidth == 0
    raise _INTL("Frame height is 0") if frameheight == 0
    begin
      @animbitmap = AnimatedBitmap.new(animname).deanimate
    rescue
      @animbitmap = Bitmap.new(framewidth, frameheight)
    end
    if @animbitmap.width % framewidth != 0
      raise _INTL("Bitmap's width ({1}) is not a multiple of frame width ({2}) [Bitmap={3}]",
                  @animbitmap.width, framewidth, animname)
    end
    if @animbitmap.height % frameheight != 0
      raise _INTL("Bitmap's height ({1}) is not a multiple of frame height ({2}) [Bitmap={3}]",
                  @animbitmap.height, frameheight, animname)
    end
    @framecount = framecount
    @framewidth = framewidth
    @frameheight = frameheight
    @framesperrow = @animbitmap.width / @framewidth
    @playing = false
    self.bitmap = @animbitmap
    self.src_rect.width = @framewidth
    self.src_rect.height = @frameheight
    self.frame = 0
  end

  # Shorter version of AnimationSprite. All frames are placed on a single row
  # of the bitmap, so that the width and height need not be defined beforehand.
  # frameskip is in 1/20ths of a second, and is the time between frame changes.
  def initializeShort(animname, framecount, frameskip)
    @animname = pbBitmapName(animname)
    @time_per_frame = [1, frameskip].max / 20.0
    begin
      @animbitmap = AnimatedBitmap.new(animname).deanimate
    rescue
      @animbitmap = Bitmap.new(framecount * 4, 32)
    end
    if @animbitmap.width % framecount != 0
      raise _INTL("Bitmap's width ({1}) is not a multiple of frame count ({2}) [Bitmap={3}]",
                  @animbitmap.width, framewidth, animname)
    end
    @framecount = framecount
    @framewidth = @animbitmap.width / @framecount
    @frameheight = @animbitmap.height
    @framesperrow = framecount
    @playing = false
    self.bitmap = @animbitmap
    self.src_rect.width = @framewidth
    self.src_rect.height = @frameheight
    self.frame = 0
  end

  def initialize(*args)
    if args.length == 1
      super(args[0][3])
      initializeShort(args[0][0], args[0][1], args[0][2])
    else
      super(args[5])
      initializeLong(args[0], args[1], args[2], args[3], args[4])
    end
  end

  def self.create(animname, framecount, frameskip, viewport = nil)
    return self.new([animname, framecount, frameskip, viewport])
  end

  def dispose
    return if disposed?
    @animbitmap.dispose
    @animbitmap = nil
    super
  end

  def playing?
    return @playing
  end

  def frame=(value)
    @frame = value
    self.src_rect.x = @frame % @framesperrow * @framewidth
    self.src_rect.y = @frame / @framesperrow * @frameheight
  end

  def start
    @playing = true
  end

  alias play start

  def stop
    @playing = false
  end

  def update
    super
    if @playing
      new_frame = (System.uptime / @time_per_frame).to_i % self.framecount
      self.frame = new_frame if self.frame != new_frame
    end
  end
end