require 'algoliasearch'

require_relative './config.rb'

class SourceIndex
  APPROX_RATIO = 4
  APPROX_MAX = 40

  SEARCH_PARAMETERS = {
    hitsPerPage: 0,
    analytics: false,
    attributesToRetrieve: [],
    attributesToSnippet: []
  }.freeze

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

  def search *args
    index.search(*args)
  end

  def search_exact query
    index.search(
      query,
      SEARCH_PARAMETERS.merge(
        queryType: 'prefixNone',
        typoTolerance: false,
        removeWordsIfNoResults: 'none',
        ignorePlurals: false
      )
    )
  end

  def search_approx query
    index.search(
      query,
      SEARCH_PARAMETERS.merge(
        hitsPerPage: [CONFIG['min_hits'] * APPROX_RATIO, APPROX_MAX].min,
        queryType: CONFIG['query_types'][name],
        highlightPreTag: '<HIGHLIGHT>',
        highlightPostTag: '</HIGHLIGHT>'
      )
    )
  end

  def index
    @index ||= self.class.client.init_index name
  end
end
