require 'algoliasearch'

require_relative './config.rb'
require_relative './generator.rb'

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

  def initialize name, inherited_config = {}, inherited_generated = nil
    @name = name
    @inherited_config = JSON.parse(inherited_config.to_json)
    @generated = inherited_generated
  end

  def config
    return @config unless @config.nil?

    @inherited_config['replicas'] = false
    @inherited_config['generate'] = []

    @config = CONFIG['indices'].find { |idx| idx['name'] == @name }
    @config ||= @inherited_config
    @config['query_type'] = settings['queryType'] if @config['query_type'].nil?

    @config = OpenStruct.new(@config)
  end

  def replicas
    return [] unless @config['replicas']
    replicas = settings['replicas'] || settings['slaves']
    replicas.map { |r| SourceIndex.new(r, config.to_h, generated) }
  end

  def settings
    @settings ||= index.get_settings
  end

  def generated
    return @generated unless @generated.nil?
    @generated = []
    config.generate.each do |facets|
      @generated += Generator.new(self, facets).generate
    end
    @generated
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
        hitsPerPage: [config.min_hits * APPROX_RATIO, APPROX_MAX].min,
        queryType: config.query_type,
        highlightPreTag: '<HIGHLIGHT>',
        highlightPostTag: '</HIGHLIGHT>'
      )
    )
  end

  def index
    @index ||= self.class.client.init_index name
  end
end
