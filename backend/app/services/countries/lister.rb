# frozen_string_literal: true

require "json"
require "net/http"
require "uri"

module Countries
  class Lister
    ALL_URL = "#{Fetcher::BASE_URL}/all?fields=name,flags,cca2".freeze

    class Error < StandardError; end

    def self.call
      new.call
    end

    def call
      response = fetch(ALL_URL)
      raise Error, "Falha ao consultar lista de países." unless response.is_a?(Net::HTTPSuccess)

      countries = parse(response)
      countries.sort_by { |country| country.dig("name", "common").to_s.downcase }
    rescue JSON::ParserError
      raise Error, "Resposta inválida da API de países."
    end

    private

    def fetch(url)
      uri = URI(url)

      Net::HTTP.start(
        uri.host,
        uri.port,
        use_ssl: uri.scheme == "https",
        open_timeout: Fetcher::OPEN_TIMEOUT,
        read_timeout: Fetcher::READ_TIMEOUT
      ) do |http|
        http.get(uri.request_uri)
      end
    end

    def parse(response)
      JSON.parse(response.body)
    end
  end
end
