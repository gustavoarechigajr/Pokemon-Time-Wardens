MultipleForms.register(:GOOMY, {
  "getFormOnCreation" => proc { |pkmn|
    next rand(6)
  }
})

MultipleForms.register(:LEDYBA, {
  "getFormOnCreation" => proc { |pkmn|
    next rand(6)
  }
})

MultipleForms.register(:TATSUGIRI, {
  "getFormOnCreation" => proc { |pkmn|
    next rand(3)
  }
})

MultipleForms.copy(:LEDYBA, :LEDIAN)
MultipleForms.copy(:GOOMY, :SLIGOO, :GOODRA)
