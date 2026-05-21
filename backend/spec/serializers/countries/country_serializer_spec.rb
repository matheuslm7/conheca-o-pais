# frozen_string_literal: true

require "rails_helper"

RSpec.describe Countries::CountrySerializer do
  describe ".serialize" do
    subject(:serialized) { described_class.serialize(CountryPayloads.brazil_raw) }

    it "maps the API contract fields" do
      expect(serialized).to eq(
        name: "Brazil",
        official_name: "Federative Republic of Brazil",
        capital: "Brasília",
        region: "Americas",
        population: 21_240_000,
        flag_url: "https://flagcdn.com/br.svg",
        language: "Portuguese",
        currency: "Brazilian real (R$)"
      )
    end
  end

  describe ".collection" do
    it "serializes each country in the array" do
      result = described_class.collection([CountryPayloads.brazil_raw])

      expect(result.size).to eq(1)
      expect(result.first[:name]).to eq("Brazil")
    end
  end
end
