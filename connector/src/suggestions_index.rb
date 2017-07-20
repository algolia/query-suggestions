require 'algoliasearch'

require_relative './config.rb'

class SuggestionsIndex
  DEFAULT_SETTINGS = {
    attributesToIndex: %w(query),
    customRanking: %w(desc(popularity)),
    attributesToHighlight: %w(query),
    numericAttributesToIndex: []
  }.freeze

  def self.client
    @client ||= Algolia::Client.new(
      application_id: application_id,
      api_key: api_key
    )
  end

  def self.application_id
    return CONFIG['target_app_id'] unless CONFIG['target_app_id'].blank?
    CONFIG['app_id']
  end

  def self.api_key
    return CONFIG['target_api_key'] unless CONFIG['target_api_key'].blank?
    CONFIG['api_key']
  end

  def initialize
    tmp_index.set_settings!({})
    @records = []
    @plurals = []
  end

  def push
    return if @records.empty?
    tmp_index.partial_update_objects! @records
    @records = []
  end

  def add record
    @records << record
    return unless (@records.size % 1000).zero?
    push
  end

  def name
    "#{CONFIG['index_prefix']}query_suggestions"
  end

  def tmp_name
    "#{name}.tmp"
  end

  def index
    @index ||= self.class.client.init_index name
  end

  def tmp_index
    @tmp_index ||= self.class.client.init_index tmp_name
  end

  def move_tmp
    tmp_index.set_settings! settings
    self.class.client.move_index! tmp_index.name, index.name
  end

  def settings
    index.get_settings
  rescue Algolia::AlgoliaProtocolError => e
    raise if e.code / 100 != 4
    index.set_settings! DEFAULT_SETTINGS
    DEFAULT_SETTINGS
  end

  def push_plurals
    return if @plurals.empty?
    tmp_index.batch! requests: @plurals
    @plurals = []
  end

  def add_plural action
    @plurals << action
    return unless (@plurals.size % 1000).zero?
    push_plurals
  end

  def ignore_plurals
    return unless CONFIG['ignore_plurals']
    tmp_index.browse do |src|
      puts "[Plurals] #{src['query']}"
      res = tmp_index.search(
        src['query'],
        hitsPerPage: 1,
        analytics: false,
        numericFilters: "nb_words=#{src['query'].split(' ').count}",
        attributesToRetrieve: %w(query popularity),
        attributesToHighlight: [],
        attributesToSnippet: [],
        queryType: 'prefixNone',
        typoTolerance: false,
        removeWordsIfNoResults: 'none',
        ignorePlurals: CONFIG['ignore_plurals']
      )['hits'][0]
      if src['query'] != res['query']
        add_plural(
          action: 'partialUpdateObject',
          objectID: res['query'],
          body: {
            popularity: {
              value: src['popularity'],
              _operation: 'Increment'
            }
          }
        )
        add_plural(
          action: 'deleteObject',
          body: {
            objectID: src['query']
          }
        )
      end
    end
    push_plurals
  end
end
