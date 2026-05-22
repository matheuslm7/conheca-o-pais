# frozen_string_literal: true

module Countries
  class CountryListSerializer
    def self.collection(raw_countries)
      Array(raw_countries).map { |record| serialize(record) }
    end

    def self.serialize(country)
      {
        name: country.dig("name", "common"),
        code: country["cca2"],
        flag_url: country.dig("flags", "svg")
      }
    end
  end
end
