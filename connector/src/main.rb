require 'active_support'
require 'active_support/time'
require 'active_support/core_ext/object/blank'
require 'pry'

require_relative './config.rb'
require_relative './analytics.rb'
require_relative './popular_index.rb'
require_relative './source_index.rb'

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
      startAt: (Time.now - 90.days).to_i,
      endAt: Time.now.to_i,
      tags: CONFIG['analytics_tags']
    )
    popular.each_with_index do |p, i|
      q = p['query'].strip.split(/\s+/).join(' ')
      puts "[#{idx.name}] Query #{i + 1} / #{popular.size}: \"#{q}\""
      next if q =~ /[^\p{L} ]/
      next if q.length < CONFIG['min_letters']
      rep = idx.search_exact q
      next if rep['nbHits'] < CONFIG['min_hits']
      res.push(
        objectID: q,
        query: q,
        popularity: {
          value: p['count'],
          _operation: 'Increment'
        }
      )
    end
  end
  target_index.push res
end
