# frozen_string_literal: true

module Api
  module V1
    class CountriesController < ApplicationController
      def index
        if params[:name].present? || params[:code].present?
          raw_countries = Countries::Fetcher.call(name: params[:name], code: params[:code])
          render json: Countries::CountrySerializer.collection(raw_countries)
        else
          raw_countries = Countries::Lister.call
          render json: Countries::CountryListSerializer.collection(raw_countries)
        end
      rescue Countries::Fetcher::NotFound
        render json: { error: "País não encontrado." }, status: :not_found
      rescue Countries::Fetcher::Error, Countries::Lister::Error => e
        render json: { error: e.message }, status: :unprocessable_content
      end
    end
  end
end
