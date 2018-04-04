require 'active_support/core_ext/object/to_query'
require 'addressable/uri'

require_relative './source_index.rb'

class Analytics
  class AnalyticsError < StandardError; end

  class Client < HTTPClient
    def self.get uri
      res = client.get(uri, header: headers)
      if res.code / 100 != 2
        message = "Cannot GET to #{uri}: #{res.content} (#{res.code})"
        raise AnalyticsError, message
      end
      JSON.parse(res.content)
    end

    class << self
      def client
        @client ||= new
      end

      def headers
        @headers ||= {
          'X-Algolia-Application-Id' => SourceIndex.client.application_id,
          'X-Algolia-API-Key' => SourceIndex.client.api_key
        }
      end
    end
  end

  def self.popular_searches index, params = {}
    protocol = 'https'
    host = 'analytics.algolia.com'
    encoded_index = Addressable::URI.encode_component(
      index, Addressable::URI::CharacterClasses::UNRESERVED
    )
    path = "/1/searches/#{encoded_index}/popular"
    response = Client.get "#{protocol}://#{host}#{path}?#{params.to_query}"
    response['topSearches']
  end
end
