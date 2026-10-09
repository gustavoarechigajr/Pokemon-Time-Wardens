class ItemClause
  def isValid?(team)
    items = []
    team.each do |pkmn|
      next if !pkmn || !pkmn.hasItem?
#      return false if items.include?(pkmn.item_id)
      items.push(pkmn.item_id)
    end
    return true
  end

  def errorMessage
    return _INTL("No identical hold items.")
  end
end

#===============================================================================
# Changed by Jos 2023-10-20 to allow pseudos to be in the Battle Facilities.
#===============================================================================
class StandardRestriction
  def isValid?(pkmn)
    return false if !pkmn || pkmn.egg?
    # Species with disadvantageous abilities are not banned
    pkmn.species_data.abilities.each do |a|
      return true if [:TRUANT, :SLOWSTART].include?(a)
    end
    # Certain named species are not banned
    return true if [:DRAGONITE, :TYRANITAR, :SALAMENCE, :METAGROSS, :GARCHOMP, :GARCHOMP2, :HYDREIGON, :GOODRA, :GOODRA_1, :GOODRA_2, :GOODRA_3, :GOODRA_4, :GOODRA_5, :KOMMOO, :DRAGAPULT].include?(pkmn.species)
    # Certain named species are banned
    return false if [:WYNAUT, :WOBBUFFET].include?(pkmn.species)
    # Species with total base stat 600 or more are banned
    bst = 0
    pkmn.baseStats.each_value { |s| bst += s }
    return false if bst >= 600
    # Is valid
    return true
  end
end