#Everything below is just here to check if your pokémons can learn moves 
  def eggMoves(pkmn)
    babyspecies=pkmn.species
    babyspecies = GameData::Species.get(babyspecies).get_baby_species(false, nil, nil)
    eggmoves=GameData::Species.get_species_form(babyspecies, pkmn.form).egg_moves
    return eggmoves
  end
		
	
  def premoves(pkmn1)
      pkmn=pkmn1.clone  
      babyspecies=pkmn.species
      babyspecies = GameData::Species.get(babyspecies).get_baby_species(false, nil, nil)
	  return [] if babyspecies=pkmn.species 
	  pkmn.species=babyspecies
	  moves= []
	  pkmn.getMoveList.each do |m|
        next if m[0] > pkmn.level || pkmn.hasMove?(m[1])
        moves.push(m[1]) if !moves.include?(m[1]) 
      end
      tmoves = []
      if pkmn.first_moves
        for i in pkmn.first_moves
          tmoves.push(i) if !pkmn.hasMove?(i) && !moves.include?(i)
        end
      end
	  moves = tmoves + moves 
      return moves
  end
	
  def getMoveList
    return species_data.moves
  end
  
  def tutorMoves(pkmn)
    return pkmn.species_data.tutor_moves
  end
  
  def hackmoves
    moves=[]
	GameData::Move.each { |i| moves.push(i.id) }
	return moves
  end
  
  def compare_names(move,pkmn)
    pk= pkmn.name[0]
	m= move.real_name[0]
	return (pk==m)	
  end
  
  def pbGetRelearnableMoves(pkmn)
    return [] if !pkmn || pkmn.egg? || pkmn.shadowPokemon?
    moves = []
    pkmn.getMoveList.each do |m|
      next if m[0] > pkmn.level || pkmn.hasMove?(m[1])
      if $game_switches[BORW]
		  moves.push(m[1]) if !moves.include?(m[1]) && Whitelist[$game_variables[BANVAR]].include?(m[1]) 
	  else
		  moves.push(m[1]) if !moves.include?(m[1]) && !Blacklist[$game_variables[BANVAR]].include?(m[1])
	  end 
    end
    tmoves = []
    if pkmn.first_moves
      for i in pkmn.first_moves
        if $game_switches[BORW]
		  moves.push(i) if !pkmn.hasMove?(i) && !moves.include?(i) && Whitelist[$game_variables[BANVAR]].include?(i) 
		else
		  moves.push(i) if !pkmn.hasMove?(i) && !moves.include?(i) && !Blacklist[$game_variables[BANVAR]].include?(i)
		end 
      end
    end
	#if $game_variables[MOVETUTOR]==0				#modify to == if you want to make distinct NPCs
    moves = tmoves + moves  
	#end
	
	######pre-evo moves
	#if $game_variables[MOVETUTOR]>=1  
	  specie=pkmn.species
      babyspecies=pkmn.species
      babyspecies = GameData::Species.get(babyspecies).get_baby_species(false, nil, nil) 
	  pkmn.species=babyspecies
	  pmoves=[]
	  pkmn.getMoveList.each do |m|
        next if m[0] > pkmn.level || pkmn.hasMove?(m[1])
		if $game_switches[BORW]
		  pmoves.push(m[1]) if !moves.include?(m[1]) && Whitelist[$game_variables[BANVAR]].include?(m[1]) 
		else
		  pmoves.push(m[1]) if !moves.include?(m[1]) && !Blacklist[$game_variables[BANVAR]].include?(m[1])
		end 
      end
	  moves=pmoves + moves
      tpmoves = []
      if pkmn.first_moves
        for i in pkmn.first_moves
          if $game_switches[BORW]
		    tpmoves.push(i) if !pkmn.hasMove?(i) && !moves.include?(i) && Whitelist[$game_variables[BANVAR]].include?(i) 
		  else
		    tpmoves.push(i) if !pkmn.hasMove?(i) && !moves.include?(i) && !Blacklist[$game_variables[BANVAR]].include?(i)
		  end 
        end
      end
	  
	  moves = tpmoves + moves 
	  pkmn.species=specie
	#end
    
    # add tutor moves, eggmoves and pre evolution moves
    if $game_variables[MOVETUTOR]>=1				#modify to == if you want to make distinct NPCs
      eggmoves=eggMoves(pkmn)
	  for i in eggmoves
        if $game_switches[BORW]
		  moves.push(i) if !pkmn.hasMove?(i) && !moves.include?(i) && Whitelist[$game_variables[BANVAR]].include?(i) 
		else
		  moves.push(i) if !pkmn.hasMove?(i) && !moves.include?(i) && !Blacklist[$game_variables[BANVAR]].include?(i)
		end 
      end
    end
    if $game_variables[MOVETUTOR]>=2				#modify to == if you want to make distinct NPCs
      tutormoves= tutorMoves(pkmn)
	  for i in tutormoves
        if $game_switches[BORW]
		  moves.push(i) if !pkmn.hasMove?(i) && !moves.include?(i) && Whitelist[$game_variables[BANVAR]].include?(i) 
		else
		  moves.push(i) if !pkmn.hasMove?(i) && !moves.include?(i) && !Blacklist[$game_variables[BANVAR]].include?(i)
		end 
      end
    end
	if $game_variables[MOVETUTOR]==3	#hackmon
	  hmoves = hackmoves
	  for i in hmoves 
	    if $game_switches[BORW]
		  moves.push(i) if !pkmn.hasMove?(i) && !moves.include?(i) && Whitelist[$game_variables[BANVAR]].include?(i) 
		else
		  moves.push(i) if !pkmn.hasMove?(i) && !moves.include?(i) && !Blacklist[$game_variables[BANVAR]].include?(i)
		end
      end
	end
	if $game_variables[MOVETUTOR]==4    #Stabmon
	  smoves=[]
	  GameData::Move.each { |i| smoves.push(i.id) if (i.type==pkmn.types[0] || i.type==pkmn.types[1]) }	
	  for i in smoves
		if $game_switches[BORW]
		  moves.push(i) if !pkmn.hasMove?(i) && !moves.include?(i) && Whitelist[$game_variables[BANVAR]].include?(i) 
		else
		  moves.push(i) if !pkmn.hasMove?(i) && !moves.include?(i) && !Blacklist[$game_variables[BANVAR]].include?(i)
		end 
	  end
	end
	if $game_variables[MOVETUTOR]==5    #Alphabetmon
	  smoves=[]
	  GameData::Move.each { |i| smoves.push(i.id) if compare_names(i,pkmn) }	
	  for i in smoves
		if $game_switches[BORW]
		  moves.push(i) if !pkmn.hasMove?(i) && !moves.include?(i) && Whitelist[$game_variables[BANVAR]].include?(i) 
		else
		  moves.push(i) if !pkmn.hasMove?(i) && !moves.include?(i) && !Blacklist[$game_variables[BANVAR]].include?(i)
		end  
	  end
	end	
    if $game_variables[MOVETUTOR]>=6	#universal move tutor		
		for i in UCmoves
		  if $game_switches[BORW]
		    moves.push(i) if !pkmn.hasMove?(i) && !moves.include?(i) && Whitelist[$game_variables[BANVAR]].include?(i) 
		  else
		    moves.push(i) if !pkmn.hasMove?(i) && !moves.include?(i) && !Blacklist[$game_variables[BANVAR]].include?(i)
		  end  
		end
	end
	if $game_variables[MOVETUTOR]>=7	#custom move tutor	
		pmoves=[:JUDGMENT]
		if Poke.include?(pkmn.species)
			for i in pmoves
				if $game_switches[BORW]
					moves.push(i) if !pkmn.hasMove?(i) && !moves.include?(i) && Whitelist[$game_variables[BANVAR]].include?(i) 
				else
					moves.push(i) if !pkmn.hasMove?(i) && !moves.include?(i) && !Blacklist[$game_variables[BANVAR]].include?(i)
				end  
			end
		end
	end		
    moves.sort! { |a, b| a.downcase <=> b.downcase } #sort moves alphabetically
    return moves | []   # remove duplicates
  end
  
  def can_learn_move(pkmn)
	return false if pkmn.egg? || pkmn.shadowPokemon?
	return true if $game_variables[MOVETUTOR]==3
	moves = pbGetRelearnableMoves(pkmn)
    if moves!=[]
	 return true
	else
	 return false
	end
  end 