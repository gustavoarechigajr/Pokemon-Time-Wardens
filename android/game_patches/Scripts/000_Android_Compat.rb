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
# The Android engine may not be able to load it (its Ruby is built with the
# library compiled in, but the step that registers built-in libraries isn't
# run), so if require fails a pure-Ruby Zlib below takes over. To keep start
# up fast, the APK stores PluginScripts.rxdata uncompressed (still valid zlib
# data) so the stand-in only has to copy it.
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

    # Pure-Ruby inflate (RFC 1950/1951): stored, fixed and dynamic Huffman
    # blocks. Slower than the C library, but only small data goes through it
    # (the APK's plugin data is stored uncompressed).
    class Inflate
      LEN_BASE  = [3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 15, 17, 19, 23, 27, 31, 35, 43, 51, 59,
                   67, 83, 99, 115, 131, 163, 195, 227, 258]
      LEN_EXTRA = [0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 0]
      DIST_BASE = [1, 2, 3, 4, 5, 7, 9, 13, 17, 25, 33, 49, 65, 97, 129, 193, 257, 385, 513, 769,
                   1025, 1537, 2049, 3073, 4097, 6145, 8193, 12289, 16385, 24577]
      DIST_EXTRA = [0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13]
      CL_ORDER  = [16, 17, 18, 0, 8, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 14, 1, 15]

      def self.inflate(data)
        new(data).run
      end

      def initialize(data)
        @data = data.b
        @pos = 2
        @bitbuf = 0
        @bitcnt = 0
      end

      def run
        raise DataError, "incorrect header check" if @data.bytesize < 2 || (@data.getbyte(0) & 0x0f) != 8
        out = String.new(capacity: @data.bytesize * 2, encoding: Encoding::BINARY)
        loop do
          final = bits(1)
          type = bits(2)
          case type
          when 0 then stored(out)
          when 1 then codes(out, *fixed_tables)
          when 2 then codes(out, *dynamic_tables)
          else raise DataError, "invalid block type"
          end
          break if final == 1
        end
        out
      end

      private

      def bits(n)
        while @bitcnt < n
          byte = @data.getbyte(@pos)
          raise DataError, "unexpected end of data" if byte.nil?
          @pos += 1
          @bitbuf |= byte << @bitcnt
          @bitcnt += 8
        end
        v = @bitbuf & ((1 << n) - 1)
        @bitbuf >>= n
        @bitcnt -= n
        v
      end

      def stored(out)
        @bitbuf = 0
        @bitcnt = 0
        len = @data.getbyte(@pos) | (@data.getbyte(@pos + 1) << 8)
        @pos += 4
        out << @data.byteslice(@pos, len)
        @pos += len
      end

      # Canonical Huffman table: [counts per length, symbols in code order]
      def build(lengths)
        counts = Array.new(16, 0)
        lengths.each { |l| counts[l] += 1 }
        counts[0] = 0
        offs = Array.new(16, 0)
        (1...16).each { |i| offs[i] = offs[i - 1] + counts[i - 1] }
        syms = []
        lengths.each_with_index { |l, sym| next if l == 0; syms[offs[l]] = sym; offs[l] += 1 }
        [counts, syms]
      end

      def decode(table)
        counts, syms = table
        code = first = index = 0
        (1...16).each do |len|
          code |= bits(1)
          count = counts[len]
          return syms[index + code - first] if code - count < first
          index += count
          first += count
          first <<= 1
          code <<= 1
        end
        raise DataError, "invalid Huffman code"
      end

      def fixed_tables
        @fixed ||= begin
          l = Array.new(288) { |i| i < 144 ? 8 : i < 256 ? 9 : i < 280 ? 7 : 8 }
          [build(l), build(Array.new(30, 5))]
        end
      end

      def dynamic_tables
        nlen = bits(5) + 257
        ndist = bits(5) + 1
        ncode = bits(4) + 4
        cl = Array.new(19, 0)
        ncode.times { |i| cl[CL_ORDER[i]] = bits(3) }
        cltable = build(cl)
        lengths = []
        while lengths.size < nlen + ndist
          sym = decode(cltable)
          if sym < 16
            lengths << sym
          elsif sym == 16
            raise DataError, "invalid repeat" if lengths.empty?
            (3 + bits(2)).times { lengths << lengths[-1] }
          elsif sym == 17
            (3 + bits(3)).times { lengths << 0 }
          else
            (11 + bits(7)).times { lengths << 0 }
          end
        end
        [build(lengths[0, nlen]), build(lengths[nlen, ndist])]
      end

      def codes(out, lencode, distcode)
        loop do
          sym = decode(lencode)
          if sym < 256
            out << sym.chr
          elsif sym == 256
            return
          else
            sym -= 257
            len = LEN_BASE[sym] + bits(LEN_EXTRA[sym])
            d = decode(distcode)
            dist = DIST_BASE[d] + bits(DIST_EXTRA[d])
            raise DataError, "invalid distance" if dist > out.bytesize
            start = out.bytesize - dist
            if dist >= len
              out << out.byteslice(start, len)
            else
              len.times { |i| out << out.getbyte(start + i).chr }
            end
          end
        end
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
