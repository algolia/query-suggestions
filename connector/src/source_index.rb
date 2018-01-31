require 'algoliasearch'
require 'damerau-levenshtein'

require_relative './config.rb'
require_relative './generator.rb'
require_relative './external.rb'
require_relative './unprefixer.rb'
require_relative './user_agent.rb'

class SourceIndex
  APPROX_RATIO = 4
  APPROX_MAX = 40

  SEARCH_PARAMETERS = {
    hitsPerPage: 0,
    analytics: false,
    attributesToRetrieve: [],
    attributesToSnippet: [],
    distinct: false,
    facetingAfterDistinct: false
  }.freeze

  def self.client
    return @client unless @client.nil?
    @client = Algolia::Client.new(
      application_id: application_id,
      api_key: api_key
    )
    @client.set_extra_header 'User-Agent', UserAgent.to_s
    @client
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
  attr_reader :unprefixer

  def initialize name, inherited_config = {}
    @name = name
    @inherited_config = JSON.parse(inherited_config.to_json)
    @unprefixer = Unprefixer.new(self)
  end

  def config
    return @config unless @config.nil?

    @inherited_config['replicas'] = false
    @inherited_config['generate'] = []

    @config = CONFIG['indices'].find { |idx| idx['name'] == @name }
    @config ||= @inherited_config
    @config['query_type'] = settings['queryType'] || 'prefixLast' if @config['query_type'].nil?

    @config = OpenStruct.new(@config)
  end

  def replicas
    return [] unless @config['replicas']
    replicas = settings['replicas'] || settings['slaves'] || []
    replicas.map { |r| SourceIndex.new(r, config.to_h) }
  end

  def settings
    @settings ||= index.get_settings
  end

  def generated
    res = []
    config.generate.each do |facets|
      res += Generator.new(self, facets).generate
    end
    res
  end

  def external &_block
    raise ArgumentError, 'Missing block' unless block_given?
    source = config.external_source
    config.external.each do |external|
      yield External.new(external['name'], source)
    end
  end

  def ignore q
    false ||
      q.blank? ||
      q.length < config.min_letters ||
      !SearchString.keep?(q, config.exclude)
  end

  def search *args
    index.search(*args)
  end

  def search_exact query
    facets = config.facets.map { |f| f['attribute'] }
    max_facet_values = config.facets.map { |f| f['amount'] }.max
    index.search(
      query,
      SEARCH_PARAMETERS.merge(
        queryType: 'prefixNone',
        typoTolerance: false,
        removeWordsIfNoResults: 'none',
        ignorePlurals: false,
        facets: facets,
        maxValuesPerFacet: max_facet_values
      )
    )
  end

  def search_approx query, extra = {}
    index.search(
      query,
      SEARCH_PARAMETERS.merge(
        hitsPerPage: [config.min_hits * APPROX_RATIO, APPROX_MAX].min,
        queryType: config.query_type,
        highlightPreTag: '<HIGHLIGHT>',
        highlightPostTag: '</HIGHLIGHT>'
      ).merge(extra)
    )
  end

  def index
    @index ||= self.class.client.init_index name
  end
end
