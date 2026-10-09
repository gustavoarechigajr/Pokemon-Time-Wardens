# Name of file in Audio/SE that plays when a quest is failed
QUEST_FAIL = "decrease pitch shifted.ogg" # Changed by Jos 2022-10-09

  #-------------------------------------------------------------------------------
  # Entry for Modern Quest System by ThatWelshOne
  #-------------------------------------------------------------------------------
  class MenuEntryQuests < MenuEntry
    def initialize
      @icon = "menuQuests" # Changed by Jos 2022-09-24 to change icon
      @name = "Quests"
    end
  end