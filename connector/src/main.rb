require 'active_support/time'
require 'pry'

require_relative './config.rb'
require_relative './analytics.rb'
require_relative './popular_index.rb'
require_relative './source_index.rb'

MIN_LETTERS = 4
MIN_HITS = 5
MIN_SEARCHED = 5

def source_index
  @source_index ||= SourceIndex.new.index
end

def target_index
  @target_index ||= PopularIndex.new
end

def main
  res = []
  popular = Analytics.popular_searches(
    CONFIG['index'],
    size: 10_000,
    start_at: (Time.now - 90.days).to_i
  )
  popular.each_with_index do |p, i|
    puts "Query #{i + 1} / #{popular.size}"
    next if p['count'] < MIN_SEARCHED
    next if p['query'].length < MIN_LETTERS
    rep = source_index.search(
      p['query'],
      typoTolerance: false,
      queryType: 'prefixNone',
      removeWordsIfNoResults: 'none',
      attributesToRetrieve: [],
      attributesToSnippet: [],
      attributesToHighlight: '*'
    )
    next if rep['nbHits'] < MIN_HITS
    res.push(
      query: p['query'],
      popularity: p['count']
    )
  end
  target_index.push res
end
