#===============================================================================
# Change nature
#===============================================================================
def pbNatureChangingMint(new_nature, item, pkmn, scene)
  if pkmn.nature == new_nature # Changed by Jos 2023-09-04 to make mints not be stupid
    scene.pbDisplay(_INTL("It won't have any effect."))
    return false
  end
  if !scene.pbConfirm(_INTL("It might affect {1}'s stats. Are you sure you want to use it?", pkmn.name))
    return false
  end
  pkmn.nature = new_nature # Changed by Jos 2023-09-04 to make mints not be stupid
  pkmn.calc_stats
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1}'s stats may have changed due to the effects of the {2}!",
                        pkmn.name, GameData::Item.get(item).name))
  return true
end