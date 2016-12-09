require 'algoliasearch'

require_relative './config.rb'

class SourceIndex
  def self.client
    @client ||= Algolia::Client.new(
      application_id: CONFIG['app_id'],
      api_key: CONFIG['api_key']
    )
  end

  attr_reader :name

  def initialize name
    @name = name
  end

  def search_exact query
    index.search(
      query,
      typoTolerance: false,
      queryType: 'prefixNone',
      removeWordsIfNoResults: 'none',
      attributesToRetrieve: [],
      attributesToSnippet: [],
      attributesToHighlight: '*',
      analytics: false
    )
  end

  def index
    @index ||= self.class.client.init_index name
  end
end
