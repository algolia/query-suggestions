require 'algoliasearch'
require 'damerau-levenshtein'

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

  def transform_query q
    return nil if q.length < config.min_letters
    return nil unless SearchString.keep?(q, config.exclude)
    q = case config.query_type
        when 'prefixNone' then q
        when 'prefixLast' then check_prefix q, true
        when 'prefixAll'  then check_prefix q, false
        end
    return if q.blank?
    return nil if q.length < config.min_letters
    return nil unless SearchString.keep?(q, config.exclude)
    q
  end

  private

  def distance s1, s2
    DamerauLevenshtein.distance(s1, s2, 1, 3)
  end

  def highlight_strings rep, word
    rep['hits']
      .map { |h| h['_highlightResult'].values }
      .flatten
      .select { |o| (o['matchedWords'] || []).include? word }
      .map { |o| o['value'] }
  end

  def best_candidate_word word, rep
    candidates = {}

    highlight_strings(rep, word).each do |str|
      matched_words = str.scan(%r{<HIGHLIGHT>(.*?)</HIGHLIGHT>([\p{L}0-9]*)})
      matched_words.each do |match, rest|
        full_word = SearchString.clean "#{match}#{rest}"
        next unless SearchString.keep?(full_word, config.exclude)
        candidates[full_word] ||= []
        candidates[full_word].push(distance(match, word))
      end
    end

    tmp = candidates.map do |full_word, scores|
      min_score, scores_count = scores
                                .group_by { |i| i }
                                .map { |score, arr| [score, arr.size] }
                                .sort_by { |score, _| score }
                                .first
      [full_word, min_score, scores_count]
    end

    _, tmp = tmp
             .group_by { |_word, score, _count| score }
             .sort_by { |score, _| score }
             .first

    return nil if tmp.nil? || tmp.empty?

    tmp
      .sort_by { |_word, _score, count| -count }
      .first
      .first
  end

  def check_prefix q, only_last
    rep = search_approx(q)
    return nil if rep['nbHits'] < config.min_hits
    splitted = q.split(/\s+/)
    res = []
    splitted.each_with_index do |word, i|
      if only_last && i != splitted.size - 1
        res.push(word)
      else
        res.push best_candidate_word(word, rep)
      end
    end
    res.join(' ')
  end
end
