
def pbRepositionMessageWindow(msgwindow, linecount=2)
    msgwindow.height=32*linecount+msgwindow.borderY
    msgwindow.y=(Graphics.height)-(msgwindow.height)
    # if $game_temp && $game_temp.in_battle && !$scene.respond_to?("update_basic")
    #   msgwindow.y=0
    # elsif $game_system && $game_system.respond_to?("message_position")
    if $game_system && $game_system.respond_to?("message_position")
        case $game_system.message_position
        when 0  # up
        msgwindow.y=0
        when 1  # middle
        msgwindow.y=(Graphics.height/2)-(msgwindow.height/2)
        when 2
        if $game_temp.speechbubble_bubble==1
            msgwindow.setSkin("Graphics/windowskins/frlgtextskin")
            msgwindow.height = 100
            msgwindow.width = 400
        elsif $game_temp.speechbubble_bubble==2
            msgwindow.setSkin("Graphics/windowskins/frlgtextskin")
            msgwindow.height = 102
            msgwindow.width = Graphics.width
            if $game_player.direction==8
            $game_temp.speechbubble_vp = Viewport.new(0, 0, Graphics.width, 280)
            msgwindow.y = 6
            else
            $game_temp.speechbubble_vp = Viewport.new(0, 6 + msgwindow.height, Graphics.width, 280)
            msgwindow.y = (Graphics.height - msgwindow.height) - 6
            if $game_temp.speechbubble_outofrange==true
                msgwindow.y = 6
            end
            end
        else
            msgwindow.height = 102
            msgwindow.y = Graphics.height - msgwindow.height - 6
        end
        end
    end
    if $game_system && $game_system.respond_to?("message_frame")
        if $game_system.message_frame != 0
        msgwindow.opacity = 0
        end
    end
    if $game_message
        case $game_message.background
        when 1  # dim
            msgwindow.opacity=0
        when 2  # transparent
            msgwindow.opacity=0
        end
    end
    end
       