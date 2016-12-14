require 'algoliasearch'

require_relative './config.rb'

class SourceIndex
  def self.client
    @client ||= Algolia::Client.new(
      application_id: application_id,
      api_key: api_key
    )
  end

  def self.application_id
    return CONFIG['source_app_id'] unless CONFIG['source_app_id'].blank?
    CONFIG['app_id']
  end

  def self.api_key
    return CONFIG['source_api_key'] unless CONFIG['source_api_key'].blank?
    CONFIG['api_key']
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
      hitsPerPage: 0,
      attributesToRetrieve: [],
      attributesToSnippet: [],
      attributesToHighlight: [],
      analytics: false
    )
  end

  def index
    @index ||= self.class.client.init_index name
  end
end
