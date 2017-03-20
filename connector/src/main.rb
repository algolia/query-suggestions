require 'active_support'
require 'active_support/time'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/json'

require 'json'

# Debug
require 'yaml'
require 'pry'

require_relative './config.rb'
require_relative './analytics.rb'
require_relative './popular_index.rb'
require_relative './source_index.rb'
require_relative './search_string.rb'

def each_index &_block
  raise ArgumentError, 'Missing block' unless block_given?
  CONFIG['indices'].each do |idx|
    idx = SourceIndex.new(idx['name'])
    yield idx
    idx.replicas.each do |r|
      yield r
    end
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
      tags: idx.config.analytics_tags.join(',')
    )
    popular += idx.generated
    popular.each_with_index do |p, i|
      q = SearchString.clean(p['query'])
      puts "[#{idx.name}] Query #{i + 1} / #{popular.size}: \"#{q}\""
      q = idx.transform_query q
      next if q.blank?
      rep = idx.search_exact q
      next if rep['nbHits'] < idx.config.min_hits
      res.push(
        objectID: q,
        query: q,
        nb_words: q.split(' ').size,
        popularity: {
          value: p['count'],
          _operation: 'Increment'
        }
      )
      if (res.size % 1000).zero?
        target_index.push res
        res = []
      end
    end
  end
  target_index.push res
  target_index.ignore_plurals
  target_index.move_tmp
end
