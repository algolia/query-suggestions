require 'active_support'
require 'active_support/time'
require 'active_support/core_ext/object/blank'
require 'pry'

require_relative './config.rb'
require_relative './analytics.rb'
require_relative './popular_index.rb'
require_relative './source_index.rb'
require_relative './generator.rb'
require_relative './search_string.rb'

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

def generated idx
  return [] if CONFIG['to_generate'].blank?
  return [] if CONFIG['to_generate'][idx.name].blank?
  res = []
  CONFIG['to_generate'][idx.name].each do |facets|
    res += Generator.new(idx, facets).generate
  end
  res
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
    popular += generated idx
    popular.each_with_index do |p, i|
      q = SearchString.clean(p['query'])
      puts "[#{idx.name}] Query #{i + 1} / #{popular.size}: \"#{q}\""
      next if q =~ SearchString::SKIP_REGEXP
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
