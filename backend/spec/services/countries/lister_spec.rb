# frozen_string_literal: true

require "rails_helper"

RSpec.describe Countries::Lister do
  describe ".call" do
    it "returns countries sorted by common name" do
      stub_request(:get, "https://restcountries.com/v3.1/all?fields=name,flags,cca2")
        .to_return(
          status: 200,
          body: CountryPayloads.all_countries_raw.reverse.to_json,
          headers: { "Content-Type" => "application/json" }
        )

      result = described_class.call

      expect(result.map { |c| c.dig("name", "common") }).to eq(%w[Brazil Japan])
    end

    it "raises error when response body is invalid JSON" do
      stub_request(:get, "https://restcountries.com/v3.1/all?fields=name,flags,cca2")
        .to_return(status: 200, body: "invalid-json")

      expect { described_class.call }
        .to raise_error(Countries::Lister::Error, "Resposta inválida da API de países.")
    end

    it "raises error when API request fails" do
      stub_request(:get, "https://restcountries.com/v3.1/all?fields=name,flags,cca2")
        .to_return(status: 500)

      expect { described_class.call }
        .to raise_error(Countries::Lister::Error, "Falha ao consultar lista de países.")
    end
  end
end
