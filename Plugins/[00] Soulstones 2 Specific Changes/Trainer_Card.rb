class PokemonTrainerCard_Scene
  def pbDrawTrainerCardFront    
    overlay = @sprites["overlay"].bitmap
    overlay.clear
    baseColor   = Color.new(255, 255, 255) # Changed by Jos 2023-08-16 to make it more visible
    shadowColor = Color.new(160, 160, 160)
    # Changed by DemICE 2023-Mar-20 fixing the time shown on trainer card 
    totalsec = (Graphics.frame_count || 0)  / Graphics.frame_rate#$stats.play_time.to_i
    hour = totalsec / 60 / 60
    min = totalsec / 60 % 60
    time = (hour > 0) ? _INTL("{1}h {2}m", hour, min) : _INTL("{1}m", min)
    $PokemonGlobal.startTime = pbGetTimeNow if !$PokemonGlobal.startTime
    starttime = _INTL("{1} {2}, {3}",
                      pbGetAbbrevMonthName($PokemonGlobal.startTime.mon),
                      $PokemonGlobal.startTime.day,
                      $PokemonGlobal.startTime.year)
    textPositions = [
      [_INTL("Name"), 34, 70, 0, baseColor, shadowColor],
      [$player.name, 302, 70, 1, baseColor, shadowColor],
      [_INTL("ID No."), 332, 70, 0, baseColor, shadowColor],
      [sprintf("%05d", $player.public_ID), 468, 70, 1, baseColor, shadowColor],
      [_INTL("Money"), 34, 118, 0, baseColor, shadowColor],
      [_INTL("${1}", $player.money.to_s_formatted), 302, 118, 1, baseColor, shadowColor],
      [_INTL("Pokédex"), 34, 166, 0, baseColor, shadowColor],
      [sprintf("%d/%d", $player.pokedex.owned_count, $player.pokedex.seen_count), 302, 166, 1, baseColor, shadowColor],
      [_INTL("Time"), 34, 214, 0, baseColor, shadowColor],
      [time, 302, 214, 1, baseColor, shadowColor],
      [_INTL("Started"), 34, 262, 0, baseColor, shadowColor],
      [starttime, 302, 262, 1, baseColor, shadowColor]
    ]
	# Changed by Jos 2023-08-16 to adjust chapter positioning and where badges appear. Also changed icon graphic.
	# Removed consideration of what region you are in as the chapters are joined.
  Console.echoln("#####---------------------------------------------------------------------------------#####")
  for tts in 0...textPositions.length; Kernel.tts("#{textPositions[tts][0]}"); end
  pbDrawTextPositions(overlay, textPositions)
	x = 31
	imagePositions = []

	# Loop for the first row (9 badges)
	9.times do |i|
	  if $player.badges[i]
		imagePositions.push(["Graphics/Pictures/Trainer Card/icon_badges", x, 292, i * 32, 0, 32, 32])
	  end
	  x += 50
	end

	# Reset x and adjust y for the second row
	x = 31
	y = 326

	# Loop for the second row (9 badges)
	9.times do |i|
	  if $player.badges[i + 9]
		imagePositions.push(["Graphics/Pictures/Trainer Card/icon_badges", x, y, i * 32, 32, 32, 32])
	  end
	  x += 50
	end

	pbDrawImagePositions(overlay, imagePositions)
	end
end  