require 'algoliasearch'

require_relative './config.rb'
require_relative './debug.rb'

class SuggestionsIndex
  DEFAULT_SETTINGS = {
    attributesToIndex: %w(query),
    customRanking: %w(desc(popularity)),
    attributesToHighlight: %w(query),
    numericAttributesToIndex: %w(nb_words)
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
    tmp_index.delete!
    tmp_index.set_settings!(DEFAULT_SETTINGS)
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

  def recompute_plural first, second
    debug = Debug.new
    debug.add 'Ignore plurals', "Replace \"#{second['query']}\"", extra: second
    res = {
      query: first['query'],
      popularity: first['popularity'] + second['popularity'],
      nb_words: first['nb_words']
    }
    res[:_debug] = { _operation: 'Add', value: debug.entries } if CONFIG['debug']
    (first.keys + second.keys - %w(query popularity nb_words objectID _debug)).each do |idx_name|
      res[idx_name] = {
        facets: {
          exact_matches: (first[idx_name]['facets']['exact_matches'] rescue {}),
          analytics: {}
        }
      }
      res[idx_name][:exact_nb_hits] = first[idx_name.to_s]['exact_nb_hits'] rescue 0
      SourceIndex.new(idx_name).config.facets.each do |facet|
        res[idx_name][:facets][:analytics][facet['attribute']] = (
         (first[idx_name]['facets']['analytics'][facet['attribute']] rescue []) +
         (second[idx_name]['facets']['analytics'][facet['attribute']] rescue [])
        ).reduce([]) do |final, current|
          item = final.find { |o| o['value'] == current['value'] }
          item['count'] += current['count'] if item
          final << current unless item
          final
        end
      end
    end
    res
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
          body: recompute_plural(res, src)
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
