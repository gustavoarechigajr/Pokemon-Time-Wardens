############################################################
#F12 Pause Menu
#By Zeriab and tweaked by Pia Carrot
#Now will show pause menu over other menus
#
#Instructions
#Add an image called "f12.png" to your Graphics/Pictures folder
#F12 will no longer reset your game and will display this image
#until you press F12 again.
#
#
#Credits must be given to Zeriab.
#Enjoy this tweaked script for use of Pokemon Essentials
#############################################################

class Reset < Exception
 
end

module Graphics
  class << self

     unless self.method_defined?(:zeriab_f12_pause_update)
        alias_method(:zeriab_f12_pause_update, :update)
        alias_method(:zeriab_f12_pause_transition, :transition)
     end

     def update(*args)
        # Try to update normally
        begin
           zeriab_f12_pause_update(*args)
           return
        rescue Reset
           # Do nothing
        end
        if !System.platform[/Windows/] 
          if !System.platform[/Linux/] 
            system("open", "Game.exe") #Mac
          else 
              pbTutorialWindow(
               _INTL("Soft-Resetting with F12 has been disabled due to the multitude of issues that it was causing on savefiles. Sorry for the inconvenience.")
             )
            #System.launch("Game.exe")
          end
        else 
          System.launch("Game.exe")
        end
        raise SystemExit.new(0)
      #   pbTutorialWindow(
      #    _INTL("Soft-Resetting with F12 has been disabled due to the multitude of issues that it was causing on savefiles. Sorry for the inconvenience.")
      #  )
        # F12 has been pressed
      #   done = false
      #   # Store frame count
      #   frame_count = Graphics.frame_count
      #   # Show pause image
      #   @sprite = Sprite.new
      #   @sprite.z = 99999
      #   begin
      #      @sprite.bitmap = RPG::Cache.picture('f12')
      #   rescue
      #      @sprite.bitmap = Bitmap.new(32,32)
      #   end
      #   # Keep trying to do the update
      #   while !done
      #      begin
      #         zeriab_f12_pause_update(*args)
      #         done = true
      #      rescue Reset
      #         # Do Nothing
      #      end
      #   end
      #   # F12 has been released, update until it is pressed again
      #   while done
      #      begin
      #         zeriab_f12_pause_update(*args)
      #      rescue Reset
      #         done = false
      #      end
      #   end
      #   # F12 has been pressed, keep trying to update
      #   while !done
      #      begin
      #         zeriab_f12_pause_update(*args)
      #         done = true
      #      rescue Reset
      #         # Do nothing
      #      end
      #   end
      #   # F12 has been released, dispose pause image
      #   @sprite.dispose
      #   # Set proper frame count
      #   Graphics.frame_count = frame_count
     end

     def transition(*args)
        done = false
        # Keep trying to do the transition
        while !done
           begin
              zeriab_f12_pause_transition(*args)
              done = true
           rescue Reset
              # Set transition length to 0 frames.
              args[0] = 0
           end
        end
     end
  end
end