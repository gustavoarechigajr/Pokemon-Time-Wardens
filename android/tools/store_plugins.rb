# Re-saves Data/PluginScripts.rxdata with every script stored uncompressed
# (zlib "stored" blocks), so the Android build's Zlib fallback can read it.
# The game itself reads the result exactly like the original.
#
#   ruby store_plugins.rb <in.rxdata> <out.rxdata>
require "zlib"

plugins = File.open(ARGV[0], "rb") { |f| Marshal.load(f) }
stored = plugins.map do |name, meta, scripts|
  [name, meta, scripts.map { |file, data| [file, Zlib::Deflate.deflate(Zlib::Inflate.inflate(data), Zlib::NO_COMPRESSION)] }]
end
File.open(ARGV[1], "wb") { |f| Marshal.dump(stored, f) }
puts "Stored #{stored.sum { |p| p[2].size }} plugin scripts uncompressed"
