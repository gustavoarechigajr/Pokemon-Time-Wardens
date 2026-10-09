#===============================================================================
# Class that creates the scrolling list of quest names
#===============================================================================
class Window_Quest < Window_DrawableCommand

  def drawItem(index,_count,rect)
    return if index>=self.top_row+self.page_item_max
    rect = Rect.new(rect.x+16,rect.y,rect.width-16,rect.height)
    name = $quest_data.getName(@quests[index].id)
    name = "<b>" + "#{name}" + "</b>" if @quests[index].story
    base = self.baseColor
    shadow = self.shadowColor
    col = @quests[index].color
    drawFormattedTextEx(self.contents,rect.x,rect.y+2,
      436,"<c2=#{col}>#{name}</c2>",base,shadow)
    if @quests[index].new && !getCompletedQuests.include?(@quests[index].id)
      pbDrawImagePositions(self.contents,[[sprintf("Graphics/Pictures/QuestUI/new"),rect.width-16,rect.y+4]])
    end  
  end

end

#===============================================================================
# Class that controls the UI
#===============================================================================
class QuestList_Scene
  
  def drawQuestDesc(quest)
    @sprites["overlay2"].bitmap.clear; @sprites["overlay3"].bitmap.clear
    # Quest name
    questName = $quest_data.getName(quest.id)
    pbDrawTextPositions(@sprites["overlay2"].bitmap,[
      ["#{questName}",6,6,0,Color.new(248,248,248),Color.new(0,0,0),true]
    ])
    # Quest description
    questDesc = "<c2=#{colorQuest("blue")}>Overview:</c2> #{$quest_data.getQuestDescription(quest.id,quest.stage)}"
    drawFormattedTextEx(@sprites["overlay3"].bitmap,38,52,
      436,questDesc,@base,@shadow)
    # Stage description
    questStageDesc = $quest_data.getStageDescription(quest.id,quest.stage)
    # Stage location
    questStageLocation = $quest_data.getStageLocation(quest.id,quest.stage)
    # If 'nil' or missing, set to '???'
    if questStageLocation=="nil" || questStageLocation==""
      questStageLocation = "???"
    end
    drawFormattedTextEx(@sprites["overlay3"].bitmap,38,320,436,"<c2=#{colorQuest("orange")}>Task:</c2> #{questStageDesc}",@base,@shadow)
    drawFormattedTextEx(@sprites["overlay3"].bitmap,38,352,436,"<c2=#{colorQuest("purple")}>Location:</c2> #{questStageLocation}",@base,@shadow)
    Kernel.tts(questName, true)
    Kernel.tts("Overview: #{$quest_data.getQuestDescription(quest.id, quest.stage)}")
    Kernel.tts("Task: #{questStageDesc}")
    Kernel.tts("Location: #{questStageLocation}")
    end
end
