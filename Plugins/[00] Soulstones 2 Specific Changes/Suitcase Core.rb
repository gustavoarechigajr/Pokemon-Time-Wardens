class Trainer
  attr_accessor :suitcase_name #Added
  alias _suitcase_initialize initialize
  def initialize(name, trainer_type)
    _suitcase_initialize(name, trainer_type)
    @suitcase_name = Settings::OUTFIT_NAMES
  end
end

ItemHandlers::UseInField.add(:SUITCASE, proc { |item|
  $Trainer.suitcase_name = Settings::OUTFIT_NAMES
  outfit = []
  cmds = []
  command = 0
  gender = $player.character_ID
  for i in 0...Settings::OUTFIT_NAMES[0][0]
    if $Trainer.suitcase_name[gender][i] != nil
     outfit[i] = $Trainer.suitcase_name[gender][i]
     cmds.push(_INTL("Equip {1}", outfit[i]))
	else
     outfit[i] = "Unused"
     cmds.push(_INTL("Equip {1}", outfit[i]))	 
	end
  end
  text = _INTL("Select an Outfit")
  loop do
    command = pbMessage(text, cmds, -1, nil, command)
    case command
    when -1
     break
    else
     pbToneChangeAll(Tone.new(-255, -255, -255), 0)   # Change Screen Color Tone  
     pbWait(80)  # Wait
     $player.outfit = command
     pbWait(80)  # Wait
     pbToneChangeAll(Tone.new(0, 0, 0), 0)
     pbMessage(_INTL("You've changed your outfit."))
     break
    end
  end
  next true
})
