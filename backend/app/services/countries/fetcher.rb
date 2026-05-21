# frozen_string_literal: true

require "json"
require "net/http"
require "uri"

module Countries
  class Fetcher
    BASE_URL = "https://restcountries.com/v3.1"
    OPEN_TIMEOUT = 5
    READ_TIMEOUT = 10

    class Error < StandardError; end
    class NotFound < Error; end

    def self.call(name:)
      new(name:).call
    end

    def initialize(name:)
      @name = name.to_s.strip
    end

    def call
      raise Error, "Nome do país é obrigatório." if @name.blank?

      response = fetch("name")
      return parse(response) if response.is_a?(Net::HTTPSuccess)

      if response.code == "404"
        # fullText busca em traduções e nomes alternativos (ex.: "Brasil")
        response = fetch("fullText")
        return parse(response) if response.is_a?(Net::HTTPSuccess)

        raise NotFound if response.code == "404"
      end

      raise Error, "Falha ao consultar dados do país."
    end

    private

    def fetch(endpoint)
      uri = uri_for(endpoint)

      Net::HTTP.start(
        uri.host,
        uri.port,
        use_ssl: uri.scheme == "https",
        open_timeout: OPEN_TIMEOUT,
        read_timeout: READ_TIMEOUT
      ) do |http|
        http.get(uri.request_uri)
      end
    end

    def parse(response)
      JSON.parse(response.body)
    rescue JSON::ParserError
      raise Error, "Resposta inválida da API de países."
    end

    def uri_for(endpoint)
      encoded = URI.encode_uri_component(@name)
      URI("#{BASE_URL}/#{endpoint}/#{encoded}")
    end
  end
end
