# frozen_string_literal: true

module Api
  module V1
    class CountriesController < ApplicationController
      def index
        raw_countries = Countries::Fetcher.call(name: params[:name])
        render json: Countries::CountrySerializer.collection(raw_countries)
      rescue Countries::Fetcher::NotFound
        render json: { error: "País não encontrado." }, status: :not_found
      rescue Countries::Fetcher::Error => e
        render json: { error: e.message }, status: :unprocessable_content
      end
    end
  end
end
