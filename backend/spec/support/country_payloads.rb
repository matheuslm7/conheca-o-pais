# frozen_string_literal: true

module CountryPayloads
  def self.brazil_raw
    {
      "name" => { "common" => "Brazil", "official" => "Federative Republic of Brazil" },
      "capital" => ["Brasília"],
      "population" => 21_240_000,
      "region" => "Americas",
      "flags" => { "svg" => "https://flagcdn.com/br.svg" },
      "languages" => { "por" => "Portuguese" },
      "currencies" => { "BRL" => { "name" => "Brazilian real", "symbol" => "R$" } }
    }
  end
end
