# frozen_string_literal: true

module Countries
  class CountrySerializer
    def self.collection(raw_countries)
      Array(raw_countries).map { |record| serialize(record) }
    end

    def self.serialize(country)
      {
        name: country.dig("name", "common"),
        official_name: country.dig("name", "official"),
        capital: country.dig("capital", 0),
        region: country["region"],
        population: country["population"],
        flag_url: country.dig("flags", "svg"),
        language: first_language(country),
        currency: first_currency(country)
      }
    end

    def self.first_language(country)
      country.fetch("languages", {}).values.first
    end
    private_class_method :first_language

    def self.first_currency(country)
      currency = country.fetch("currencies", {}).values.first
      return nil unless currency

      "#{currency['name']} (#{currency['symbol']})"
    end
    private_class_method :first_currency
  end
end
