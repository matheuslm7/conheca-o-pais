# frozen_string_literal: true

module CountryPayloads
  def self.brazil_raw
    {
      "name" => { "common" => "Brazil", "official" => "Federative Republic of Brazil" },
      "cca2" => "BR",
      "capital" => ["Brasília"],
      "population" => 21_240_000,
      "region" => "Americas",
      "flags" => { "svg" => "https://flagcdn.com/br.svg" },
      "languages" => { "por" => "Portuguese" },
      "currencies" => { "BRL" => { "name" => "Brazilian real", "symbol" => "R$" } }
    }
  end

  def self.all_countries_raw
    [
      {
        "name" => { "common" => "Brazil" },
        "cca2" => "BR",
        "flags" => { "svg" => "https://flagcdn.com/br.svg" }
      },
      {
        "name" => { "common" => "Japan" },
        "cca2" => "JP",
        "flags" => { "svg" => "https://flagcdn.com/jp.svg" }
      }
    ]
  end
end
