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

    def self.call(name: nil, code: nil)
      new(name:, code:).call
    end

    def initialize(name: nil, code: nil)
      @name = name.to_s.strip
      @code = code.to_s.strip.upcase
    end

    def call
      return fetch_by_code if @code.present?

      raise Error, "Nome do país é obrigatório." if @name.blank?

      response = fetch_by_name("name")
      return parse(response) if response.is_a?(Net::HTTPSuccess)

      if response.code == "404"
        # fullText busca em traduções e nomes alternativos (ex.: "Brasil")
        response = fetch_by_name("fullText")
        return parse(response) if response.is_a?(Net::HTTPSuccess)

        raise NotFound if response.code == "404"
      end

      raise Error, "Falha ao consultar dados do país."
    end

    private

    def fetch_by_code
      uri = URI("#{BASE_URL}/alpha/#{URI.encode_uri_component(@code)}")
      response = http_get(uri)
      return parse(response) if response.is_a?(Net::HTTPSuccess)

      raise NotFound if response.code == "404"

      raise Error, "Falha ao consultar dados do país."
    end

    def fetch_by_name(endpoint)
      encoded = URI.encode_uri_component(@name)
      http_get(URI("#{BASE_URL}/#{endpoint}/#{encoded}"))
    end

    def http_get(uri)
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
      data = JSON.parse(response.body)
      data.is_a?(Array) ? data : [data]
    rescue JSON::ParserError
      raise Error, "Resposta inválida da API de países."
    end
  end
end
