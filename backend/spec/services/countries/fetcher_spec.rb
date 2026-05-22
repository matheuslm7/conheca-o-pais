# frozen_string_literal: true

require "rails_helper"

RSpec.describe Countries::Fetcher do
  describe ".call" do
    it "raises error when name is blank" do
      expect { described_class.call(name: "  ") }
        .to raise_error(Countries::Fetcher::Error, "Nome do país é obrigatório.")
    end

    it "returns parsed JSON on successful name lookup" do
      stub_request(:get, "https://restcountries.com/v3.1/name/Brazil")
        .to_return(
          status: 200,
          body: [CountryPayloads.brazil_raw].to_json,
          headers: { "Content-Type" => "application/json" }
        )

      result = described_class.call(name: "Brazil")

      expect(result).to be_an(Array)
      expect(result.first.dig("name", "common")).to eq("Brazil")
    end

    it "falls back to fullText when name endpoint returns 404" do
      stub_request(:get, "https://restcountries.com/v3.1/name/Brasil")
        .to_return(status: 404)

      stub_request(:get, "https://restcountries.com/v3.1/fullText/Brasil")
        .to_return(
          status: 200,
          body: [CountryPayloads.brazil_raw].to_json,
          headers: { "Content-Type" => "application/json" }
        )

      result = described_class.call(name: "Brasil")

      expect(result.first.dig("name", "common")).to eq("Brazil")
    end

    it "raises NotFound when both endpoints return 404" do
      stub_request(:get, "https://restcountries.com/v3.1/name/Inexistente")
        .to_return(status: 404)
      stub_request(:get, "https://restcountries.com/v3.1/fullText/Inexistente")
        .to_return(status: 404)

      expect { described_class.call(name: "Inexistente") }
        .to raise_error(Countries::Fetcher::NotFound)
    end

    it "raises error when response body is invalid JSON" do
      stub_request(:get, "https://restcountries.com/v3.1/name/Brazil")
        .to_return(status: 200, body: "invalid-json")

      expect { described_class.call(name: "Brazil") }
        .to raise_error(Countries::Fetcher::Error, "Resposta inválida da API de países.")
    end

    it "returns parsed JSON on successful code lookup" do
      stub_request(:get, "https://restcountries.com/v3.1/alpha/BR")
        .to_return(
          status: 200,
          body: CountryPayloads.brazil_raw.to_json,
          headers: { "Content-Type" => "application/json" }
        )

      result = described_class.call(code: "br")

      expect(result).to be_an(Array)
      expect(result.first.dig("name", "common")).to eq("Brazil")
    end

    it "raises NotFound when code lookup returns 404" do
      stub_request(:get, "https://restcountries.com/v3.1/alpha/XX")
        .to_return(status: 404)

      expect { described_class.call(code: "XX") }
        .to raise_error(Countries::Fetcher::NotFound)
    end
  end
end
