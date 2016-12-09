require 'active_support/time'
require 'pry'

require_relative './config.rb'
require_relative './analytics.rb'
require_relative './popular_index.rb'
require_relative './source_index.rb'

MIN_LETTERS = 4
MIN_HITS = 5
MIN_SEARCHED = 5

def each_index &_block
  raise ArgumentError, 'Missing block' unless block_given?
  CONFIG['indices'].split(',').map(&:strip).each do |idx|
    idx = SourceIndex.new(idx)
    yield idx
  end
end

def target_index
  @target_index ||= PopularIndex.new
end

def main
  res = []
  each_index do |idx|
    popular = Analytics.popular_searches(
      idx.name,
      size: 10_000,
      start_at: (Time.now - 90.days).to_i
    )
    popular.each_with_index do |p, i|
      puts "[#{idx.name}] Query #{i + 1} / #{popular.size}: \"#{p['query']}\""
      next if p['count'] < MIN_SEARCHED
      next if p['query'].length < MIN_LETTERS
      rep = idx.search_exact p['query']
      next if rep['nbHits'] < MIN_HITS
      res.push(
        objectID: p['query'],
        popularity: {
          value: p['count'],
          _operation: 'Increment'
        }
      )
    end
  end
  target_index.push res
end
