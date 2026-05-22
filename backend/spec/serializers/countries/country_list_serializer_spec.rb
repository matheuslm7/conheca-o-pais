# frozen_string_literal: true

require "rails_helper"

RSpec.describe Countries::CountryListSerializer do
  describe ".serialize" do
    subject(:serialized) { described_class.serialize(CountryPayloads.all_countries_raw.first) }

    it "returns list fields only" do
      expect(serialized).to eq(
        name: "Brazil",
        code: "BR",
        flag_url: "https://flagcdn.com/br.svg"
      )
    end
  end

  describe ".collection" do
    it "serializes each country in the array" do
      result = described_class.collection(CountryPayloads.all_countries_raw)

      expect(result.length).to eq(2)
      expect(result.first[:name]).to eq("Brazil")
    end
  end
end
