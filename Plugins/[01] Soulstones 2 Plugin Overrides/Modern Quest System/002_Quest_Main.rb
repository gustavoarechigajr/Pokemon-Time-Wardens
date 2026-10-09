#===============================================================================
# Class that contains utility methods to return quest properties
#===============================================================================
class QuestData

  # Get overall quest description
  def getQuestDescription(quest,stage)
    stg = ("QuestDescription" + "#{stage}").to_sym
    desc = "#{QuestModule.const_get(quest)[stg]}"
    if desc == ""
      return "#{QuestModule.const_get(quest)[:QuestDescription1]}"
    else  
      return desc
    end  
  end

  # Get maximum number of tasks for quest
  def getMaxStagesForQuest(quest)
    quests = getQuestStages(quest)
    if quests.length < 2000 # Changed by Jos 2025-03-23 because main quests are long.
      return quests.length
    else
      return "???"
    end  
  end  
  
end
