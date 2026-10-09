module Runic_Constants
  RUNICSWITCH = 510
  TRUE_RUNES = [:RUNE01_LIQUIDOOZE, :RUNE02_AFTERMATH, :RUNE03_SANDVEIL, :RUNE04_SNOWCLOAK, :RUNE05_VITALSPIRIT, :RUNE06_SYNCHRONIZE, :RUNE07_UNNERVE, :RUNE08_POISONPOINT, :RUNE09_NATURALCURE, :RUNE10_HEALER, :RUNE11_ICEBODY, :RUNE12_CLAYFORM, :RUNE13_SYNTHESIZE, :RUNE14_RAINDISH, :RUNE15_BATTLEARMOR, :RUNE16_FLAMEBODY, :RUNE17_MOLDBREAKER, :RUNE18_SHIELDDUST, :RUNE19_INFILTRATOR, :RUNE20_ANALYTIC, :RUNE21_STATIC, :RUNE22_COMPOUNDEYES, :RUNE23_TOUGHCLAWS, :RUNE24_RIVALRY, :RUNE25_SNIPER, :RUNE26_IMPENETRABLE, :RUNE27_TELEPATHY, :RUNE28_GOOEY, :RUNE29_INNERFOCUS, :RUNE30_PRISMARMOR, :RUNE31_ARENATRAP, :RUNE32_CLEARBODY, :RUNE33_PASTELVEIL]
  ABIL_RUNES = [:LIQUIDOOZE, :AFTERMATH, :SANDVEIL, :SNOWCLOAK, :VITALSPIRIT, :SYNCHRONIZE, :UNNERVE, :POISONPOINT, :NATURALCURE, :HEALER, :ICEBODY, :CLAYFORM, :SYNTHESIZE, :RAINDISH, :BATTLEARMOR, :FLAMEBODY, :MOLDBREAKER, :SHIELDDUST, :INFILTRATOR, :ANALYTIC, :STATIC, :COMPOUNDEYES, :TOUGHCLAWS, :RIVALRY, :SNIPER, :IMPENETRABLE, :TELEPATHY, :GOOEY, :INNERFOCUS, :PRISMARMOR, :ARENATRAP, :CLEARBODY, :PASTELVEIL]
  TRUE_SWITCH = [511,512,513,514,515,516,517,518,519,520,521,522,523,524,525,526,527,528,529,530,531,532,533,534,535,536,537,538,539,540,541,542,543]
end

module GameData
  class Item
    def is_rune?; return has_flag?("AbilityRune") || has_flag?("ModdedAbilityRune"); end
  end
end
## Cannon Runes ##
Battle::ItemEffects::OnSwitchIn.add(:RUNE01_LIQUIDOOZE,
  proc { |item, battler, battle|
    battle.pbDisplayPaused(_INTL("{1}'s ability rune is emanating!",battler.pbThis, battler.item.name))
  }
)

Battle::ItemEffects::OnSwitchIn.copy(:RUNE01_LIQUIDOOZE, :RUNE02_AFTERMATH, :RUNE03_SANDVEIL, :RUNE04_SNOWCLOAK, :RUNE05_VITALSPIRIT, :RUNE06_SYNCHRONIZE, :RUNE07_UNNERVE, :RUNE08_POISONPOINT, :RUNE09_NATURALCURE, :RUNE10_HEALER, :RUNE11_ICEBODY, :RUNE12_CLAYFORM, :RUNE13_SYNTHESIZE, :RUNE14_RAINDISH, :RUNE15_BATTLEARMOR, :RUNE16_FLAMEBODY, :RUNE17_MOLDBREAKER, :RUNE18_SHIELDDUST, :RUNE19_INFILTRATOR, :RUNE20_ANALYTIC, :RUNE21_STATIC, :RUNE22_COMPOUNDEYES, :RUNE23_TOUGHCLAWS, :RUNE24_RIVALRY, :RUNE25_SNIPER, :RUNE26_IMPENETRABLE, :RUNE27_TELEPATHY, :RUNE28_GOOEY, :RUNE29_INNERFOCUS, :RUNE30_PRISMARMOR, :RUNE31_ARENATRAP, :RUNE32_CLEARBODY, :RUNE33_PASTELVEIL)

class Battle::Battler
  alias abilityrune_pbInitPokemon pbInitPokemon 
  def pbInitPokemon(pkmn, idxParty) # Remod for Cannon Runes Later
    abilityrune_pbInitPokemon(pkmn, idxParty)
    new_abil = ((pkmn.item == nil) ? pkmn.ability_id : ((pkmn.item.is_rune?) ? pbTranslateRune(pkmn.item_id) : pkmn.ability_id))
    cannon_rune_abil = ((pkmn.item == nil) ? pkmn.ability_id : ((pkmn.item.is_rune?) ? pbTranslateRune(pkmn.item_id,true) : pkmn.ability_id))
    @ability_id = cannon_rune_abil
  end

  def unlosableItem?(check_item)
    return false if !check_item
    item_data = GameData::Item.get(check_item)
    return true if item_data.is_mail?
    return true if item_data.is_rune?
    return false if @effects[PBEffects::Transform]
    # Items that change a Pokémon's form
    if mega?   # Check if item was needed for this Mega Evolution
      return true if @pokemon.species_data.mega_stone == item_data.id
    else   # Check if item could cause a Mega Evolution
      GameData::Species.each do |data|
        next if data.species != @species || data.unmega_form != @form
        return true if data.mega_stone == item_data.id
      end
    end
    # Other unlosable items
    return item_data.unlosable?(@species, self.ability)
  end
end

def pbTranslateRune(rune_id, cannon = false)
  rune_call = []
  if !cannon
    GameData::Ability.each do |ability|    
      rune_abil = ((ability.id).to_s + "_RUNE").to_sym
      rune_pair = [ability.id, rune_abil]
      rune_call.push(rune_pair)
    end
  else
    for i in 0...Runic_Constants::ABIL_RUNES.length
      rune_pair = [Runic_Constants::ABIL_RUNES[i], Runic_Constants::TRUE_RUNES[i]]
      rune_call.push(rune_pair)
    end
  end
  for i in 0...rune_call.length
    new_abil = rune_call[i][0] if rune_id==rune_call[i][1]
  end
  return new_abil
end

ItemHandlers::UseOnPokemon.add(:RUNICSLAB, proc { |item, qty, pkmn, scene|
  given_rune = $game_switches[Runic_Constants::RUNICSWITCH]
  this_item = GameData::Item.get(item).name
  if given_rune && (pkmn.item == nil)
    pbMessage(_INTL("The {1} has no power within it.", this_item))
    next false
  elsif given_rune && pkmn.item != nil
    if pkmn.item.has_flag?("AbilityRune")
      pbMessage(_INTL("The {1} was reabsorbed into the {2}", pkmn.item.name, this_item))
      pkmn.item = nil
      $game_switches[Runic_Constants::RUNICSWITCH] = false
      next false
    else
      pbMessage(_INTL("The {1} can only absorb an ability rune!", this_item))
      next false
    end
  end
  cmd = []
  command = 0
  true_runes = Runic_Constants::TRUE_RUNES
  rune_switch = Runic_Constants::TRUE_SWITCH
  useable_runes = []
  for i in 0...true_runes.length
    if $game_switches[rune_switch[i]]
      msg = _INTL("{1}", GameData::Item.get(true_runes[i]).name)
      cmd.push(msg) if $game_switches[rune_switch[i]]
      useable_runes.push(true_runes[i])
    end
  end
  if cmd.length == 0
    pbMessage(_INTL("It seems to be a normal rock."))
    next false
  end
  loop do
  command = pbMessage(_INTL("Select a rune to give to {1}", pkmn.name), cmd, -1, nil, command)
  case command
    when -1
      break
    when command
      if pkmn.item != nil
        if pkmn.item == GameData::Item.get(useable_runes[command]).id
          pbMessage(_INTL("{1}'s already has the {2}",pkmn.name, pkmn.item.name))
        else
          ret = pbGiveItemToPokemon(useable_runes[command], pkmn, scene)
          if ret
            $game_switches[Runic_Constants::RUNICSWITCH] = true
          end
          break
        end
      else
        ret = pbGiveItemToPokemon(useable_runes[command], pkmn, scene)
        if ret
          $game_switches[Runic_Constants::RUNICSWITCH] = true
        end
        break
      end
    end
  end
})

#===============================================================================
# Give an item to a Pokémon to hold, and take a held item from a Pokémon
#===============================================================================
def pbGiveItemToPokemon(item, pkmn, scene, pkmnid = 0)
  newitemname = GameData::Item.get(item).name
  if pkmn.egg?
    scene.pbDisplay(_INTL("Eggs can't hold items."))
    return false
  elsif pkmn.mail
    scene.pbDisplay(_INTL("{1}'s mail must be removed before giving it an item.", pkmn.name))
    return false if !pbTakeItemFromPokemon(pkmn, scene)
  end
  if pkmn.hasItem?
    olditemname = pkmn.item.name
    if pkmn.hasItem?(:LEFTOVERS)
      scene.pbDisplay(_INTL("{1} is already holding some {2}.\1", pkmn.name, olditemname))
    elsif newitemname.starts_with_vowel?
      scene.pbDisplay(_INTL("{1} is already holding an {2}.\1", pkmn.name, olditemname))
    else
      scene.pbDisplay(_INTL("{1} is already holding a {2}.\1", pkmn.name, olditemname))
    end
    if scene.pbConfirm(_INTL("Would you like to switch the two items?"))
      if pkmn.item.has_flag?("AbilityRune")
        $bag.remove(item)
        pkmn.item = item
        scene.pbDisplay(_INTL("The Runic Slab reabsorbed the {1} from {2} and you gave it the {3}.", olditemname, pkmn.name, newitemname))
        $game_switches[Runic_Constants::RUNICSWITCH] = false
        return true
      end
      $bag.remove(item)
      if !$bag.add(pkmn.item)
        raise _INTL("Couldn't re-store deleted item in Bag somehow") if !$bag.add(item)
        scene.pbDisplay(_INTL("The Bag is full. The Pokémon's item could not be removed."))
      elsif GameData::Item.get(item).is_mail?
        if pbWriteMail(item, pkmn, pkmnid, scene)
          pkmn.item = item
          scene.pbDisplay(_INTL("Took the {1} from {2} and gave it the {3}.", olditemname, pkmn.name, newitemname))
          return true
        elsif !$bag.add(item)
          raise _INTL("Couldn't re-store deleted item in Bag somehow")
        end
      else
        pkmn.item = item
        scene.pbDisplay(_INTL("Took the {1} from {2} and gave it the {3}.", olditemname, pkmn.name, newitemname))
        return true
      end
    end
  elsif !GameData::Item.get(item).is_mail? || pbWriteMail(item, pkmn, pkmnid, scene)
    $bag.remove(item)
    pkmn.item = item
    scene.pbDisplay(_INTL("{1} is now holding the {2}.", pkmn.name, newitemname))
    return true
  end
  return false
end

def pbTakeItemFromPokemon(pkmn, scene)
  ret = false
  if !pkmn.hasItem?
    scene.pbDisplay(_INTL("{1} isn't holding anything.", pkmn.name))
  elsif !$bag.can_add?(pkmn.item)
    scene.pbDisplay(_INTL("The Bag is full. The Pokémon's item could not be removed."))
  elsif pkmn.item.has_flag?("AbilityRune")
    $game_switches[Runic_Constants::RUNICSWITCH] = false
    scene.pbDisplay(_INTL("The {1} Was reabsorbed by the Runic Slab.", pkmn.item.name, pkmn.name))
    pkmn.item = nil
    ret = true
  elsif pkmn.mail
    if scene.pbConfirm(_INTL("Save the removed mail in your PC?"))
      if pbMoveToMailbox(pkmn)
        scene.pbDisplay(_INTL("The mail was saved in your PC."))
        pkmn.item = nil
        ret = true
      else
        scene.pbDisplay(_INTL("Your PC's Mailbox is full."))
      end
    elsif scene.pbConfirm(_INTL("If the mail is removed, its message will be lost. OK?"))
      $bag.add(pkmn.item)
      scene.pbDisplay(_INTL("Received the {1} from {2}.", pkmn.item.name, pkmn.name))
      pkmn.item = nil
      pkmn.mail = nil
      ret = true
    end
  else
    $bag.add(pkmn.item)
    scene.pbDisplay(_INTL("Received the {1} from {2}.", pkmn.item.name, pkmn.name))
    pkmn.item = nil
    ret = true
  end
  return ret
end
