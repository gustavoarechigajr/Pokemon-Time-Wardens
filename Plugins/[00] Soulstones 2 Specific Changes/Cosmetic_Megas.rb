# Add to me if a mon has many cosmetic forms and only one mega Form
KNOWN_COSMETIC_FORMS = [:MELMETAL, :MEOWSTIC]

class Pokemon
  def multiCosmeticMega(species)
    cosmeticSpecies = KNOWN_COSMETIC_FORMS
    return true if cosmeticSpecies.include?(species)
  end

  def getMegaForm
    ret = 0
    GameData::Species.each do |data|
      next if data.species != @species
      if data.species == :MELMETAL && hasItem?(:MELMETALITE)
        ret = 4
        break
      end
      if data.species == :MEOWSTIC && hasItem?(:MEOWSTICITE)
        ret = 2
        break
      end
      next if data.unmega_form != form_simple
      if data.mega_stone && hasItem?(data.mega_stone)
        ret = data.form
        break
      elsif data.mega_move && hasMove?(data.mega_move)
        ret = data.form
        break
      end
    end
    return ret   # form number, or 0 if no accessible Mega form
  end

  def core_form
    return @core_form
  end

  def core_form=(value)
    @core_form = value
  end

  def makeMega
    core_form = self.form
    megaForm = self.getMegaForm
    self.core_form = core_form
    self.form = megaForm if megaForm > 0
  end

  def getUnmegaForm
    cosmetic_mon = multiCosmeticMega(@species)
    if cosmetic_mon
      return (mega?) ? @core_form : -1    
    else
      return (mega?) ? species_data.unmega_form : -1
    end
  end
end