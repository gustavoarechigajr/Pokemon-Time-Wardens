class Scene_DebugIntro
  def main
    Graphics.transition(0)
    sscene = PokemonLoad_Scene.new
    sscreen = PokemonLoadScreen.new(sscene)
    sscreen.pbStartLoadScreen
    Graphics.freeze
  end
end

def pbCallTitle
  return Scene_DebugIntro.new if $DEBUG
  return Scene_Intro.new
end

=begin
# Changed by Jos 2023-03-20 to comment out the old script section but keep it for posterity
def mainFunction
  if $DEBUG
    pbCriticalCode { mainFunctionDebug }
  else
    mainFunctionDebug
  end
  return 1
end
=end

# Changed by Jos 2023-03-20 to provide better error messages to players
def mainFunction
#if $DEBUG
pbCriticalCode { mainFunctionDebug }
# else
# mainFunctionDebug
# end
return 1
end

def mainFunctionDebug
  begin
    MessageTypes.loadMessageFile("Data/messages.dat") if safeExists?("Data/messages.dat")
    PluginManager.runPlugins
    # Changed by Jos 2022-12-04 to accommodate a mods folder
	# Changed by PDM 2024-09-25 to change how error messages show modded files
    # load_scripts_from_folder(File.join(Dir.pwd, File.join('Mods'))) if safeIsDirectory?("Mods")
    #Dir["./Mods/*.rb"].each {|file| load File.expand_path(file) }

    # --- Mod Support --- code by Nero
    mods_path = File.expand_path("Mods", Dir.pwd)
    puts "Checking Mods path: #{mods_path}"
    puts "Directory exists? #{Dir.exist?(mods_path)}"
    load_scripts_from_folder(mods_path) if Dir.exist?(mods_path)
	
    # End of addition
    Compiler.main
    Game.initialize
    Game.set_up_system
    Graphics.update
    Graphics.freeze
    $scene = pbCallTitle
    $scene.main until $scene.nil?
    Graphics.transition
  rescue Hangup
    pbPrintException($!) if !$DEBUG
    pbEmergencySave
    raise
  end
end

loop do
  retval = mainFunction
  case retval
  when 0   # failed
    loop do
      Graphics.update
    end
  when 1   # ended successfully
    break
  end
end
