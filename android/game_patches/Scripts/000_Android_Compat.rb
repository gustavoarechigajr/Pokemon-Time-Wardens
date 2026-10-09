#===============================================================================
# Android compatibility (added to the game only in the Android APK build)
#===============================================================================

#-------------------------------------------------------------------------------
# Zlib
#-------------------------------------------------------------------------------
# On PC the engine loads Ruby's Zlib before the game starts; the Android
# engine only has it built in, so load it here. Essentials needs it to read
# the plugin scripts (Data/PluginScripts.rxdata).
#
# Safety net: the APK stores PluginScripts.rxdata uncompressed (still valid
# zlib data), so if Zlib can't be loaded on some device this minimal stand-in
# can still read it and the game boots.
#-------------------------------------------------------------------------------
begin
  require "zlib"
rescue LoadError, StandardError
end

unless defined?(::Zlib)
  module Zlib
    class Error < StandardError; end
    class DataError < Error; end
    NO_COMPRESSION      = 0
    BEST_SPEED          = 1
    BEST_COMPRESSION    = 9
    DEFAULT_COMPRESSION = -1

    def self.adler32(data, a = 1)
      s1 = a & 0xffff
      s2 = (a >> 16) & 0xffff
      data.each_byte do |b|
        s1 = (s1 + b) % 65521
        s2 = (s2 + s1) % 65521
      end
      (s2 << 16) | s1
    end

    class Inflate
      # Reads zlib data made of stored (uncompressed) deflate blocks
      def self.inflate(data)
        data = data.b
        raise DataError, "incorrect header check" if data.bytesize < 2 || (data.getbyte(0) & 0x0f) != 8
        pos = 2
        out = String.new(encoding: Encoding::BINARY)
        loop do
          header = data.getbyte(pos)
          raise DataError, "unexpected end of data" if header.nil?
          if (header >> 1) & 3 != 0
            raise DataError, "compressed data needs Zlib, which is not available"
          end
          len = data.getbyte(pos + 1) | (data.getbyte(pos + 2) << 8)
          out << data.byteslice(pos + 5, len)
          pos += 5 + len
          break if header & 1 == 1
        end
        out
      end
    end

    class Deflate
      # Writes zlib data using stored (uncompressed) deflate blocks
      def self.deflate(data, _level = nil)
        data = data.to_s.b
        out = String.new("\x78\x01", encoding: Encoding::BINARY)
        chunks = (0...[data.bytesize, 1].max).step(65535).map { |i| data.byteslice(i, 65535) || "" }
        chunks.each_with_index do |c, i|
          len = c.bytesize
          out << [(i == chunks.size - 1) ? 1 : 0, len, len ^ 0xffff].pack("Cvv") << c
        end
        out << [Zlib.adler32(data)].pack("N")
      end
    end
  end
end

#-------------------------------------------------------------------------------
# Case-insensitive file lookups
#-------------------------------------------------------------------------------
# Windows treats file names case-insensitively, so the game and its plugins
# mix cases freely ("Graphics/windowskins/..." vs the "Windowskins" folder,
# "Title" vs "title.ogg", ...). The engine's own loaders (Bitmap, Audio,
# load_data) already ignore case, but Ruby's File/Dir calls, which Essentials
# uses to check whether a file exists, do not on a case-sensitive filesystem.
#
# Most Android devices store app files on case-insensitive storage, in which
# case this does nothing. Otherwise it resolves game-relative paths to the
# file's real spelling before File/FileTest/Dir see them.
#===============================================================================
if (System.platform[/Android/] rescue false)
  module AndroidCaseFS
    ROOT = Dir.pwd

    class << self
      def active?
        if @active.nil?
          probe = File.join(ROOT, "Game.ini")
          @active = File.exist?(probe) && !File.exist?(File.join(ROOT, "gAME.INI"))
          @index = nil
        end
        @active
      end

      def index
        @index ||= begin
          h = {}
          Dir.glob("**/*", base: ROOT).each { |p| h[p.downcase] ||= p }
          h
        end
      end

      # Returns the path with its real on-disk spelling, or the original path
      # when it already exists, is outside the game folder or is unknown.
      def fix(path)
        return path unless path.is_a?(String) && !path.empty?
        return path if @raw_exist.call(path)
        p = path.tr("\\", "/")
        if p.start_with?(ROOT + "/")
          prefix = ROOT + "/"
          rel = p[prefix.length..-1]
        elsif p.start_with?("/")
          return path
        else
          prefix = p[%r{\A(?:\./)+}] || ""
          rel = p[prefix.length..-1]
        end
        real = index[rel.squeeze("/").chomp("/").downcase]
        return real ? prefix + real : path
      end

      # Module whose methods fix their first (path) argument, then call the
      # original implementation.
      def path_patch(methods)
        Module.new do
          methods.each do |m|
            define_method(m) do |name = nil, *args, **kw, &blk|
              name = AndroidCaseFS.fix(name) unless m == :expand_path && !args.empty?
              kw.empty? ? super(name, *args, &blk) : super(name, *args, **kw, &blk)
            end
          end
        end
      end

      def install
        @raw_exist = File.method(:exist?)
        return unless active?
        path_methods = %i[exist? file? directory? readable? size size? zero? empty?
                          mtime atime ctime stat lstat open new read readlines binread
                          foreach readable_real? expand_path]
        File.singleton_class.prepend(path_patch(path_methods.select { |m| File.respond_to?(m) }))
        FileTest.singleton_class.prepend(path_patch(%i[exist? file? directory? readable? size size? zero? empty?]))
        IO.singleton_class.prepend(path_patch(%i[read readlines binread foreach]))
        dir_methods = %i[exist? entries foreach children each_child empty?].select { |m| Dir.respond_to?(m) }
        Dir.singleton_class.prepend(path_patch(dir_methods))
      end
    end
  end

  begin
    AndroidCaseFS.install
  rescue StandardError => e
    # Not fatal: the game still runs on case-insensitive storage
    $stderr.puts("Android case-insensitive file shim failed: #{e.message}") rescue nil
  end
end
