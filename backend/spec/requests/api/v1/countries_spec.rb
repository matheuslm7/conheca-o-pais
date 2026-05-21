# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::Countries", type: :request do
  describe "GET /api/v1/countries" do
    context "without authentication" do
      it "returns unauthorized" do
        get "/api/v1/countries", params: { name: "Brazil" }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with authentication" do
      let(:user) { create(:user) }
      let(:headers) { auth_headers_for(user) }

      before do
        stub_request(:get, %r{restcountries\.com/v3\.1/name/Brazil})
          .to_return(
            status: 200,
            body: [CountryPayloads.brazil_raw].to_json,
            headers: { "Content-Type" => "application/json" }
          )
      end

      it "returns serialized countries" do
        get "/api/v1/countries", params: { name: "Brazil" }, headers: headers

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json).to be_an(Array)
        expect(json.first).to include(
          "name" => "Brazil",
          "official_name" => "Federative Republic of Brazil",
          "capital" => "Brasília",
          "region" => "Americas",
          "population" => 21_240_000,
          "flag_url" => "https://flagcdn.com/br.svg",
          "language" => "Portuguese",
          "currency" => "Brazilian real (R$)"
        )
      end

      it "returns not found when country does not exist" do
        stub_request(:get, %r{restcountries\.com/v3\.1/name/Inexistente}).to_return(status: 404)
        stub_request(:get, %r{restcountries\.com/v3\.1/fullText/Inexistente}).to_return(status: 404)

        get "/api/v1/countries", params: { name: "Inexistente" }, headers: headers

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to eq("error" => "País não encontrado.")
      end

      it "returns unprocessable entity when name is blank" do
        get "/api/v1/countries", params: { name: "   " }, headers: headers

        expect(response).to have_http_status(:unprocessable_content)
        expect(JSON.parse(response.body)).to eq("error" => "Nome do país é obrigatório.")
      end
    end
  end
end
