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
require_relative './suggestions_index.rb'
require_relative './source_index.rb'
require_relative './search_string.rb'

def each_index &_block
  raise ArgumentError, 'Missing block' unless block_given?
  CONFIG['indices'].each do |idx|
    idx = SourceIndex.new(idx['name'])
    yield idx, true
    idx.replicas.each do |r|
      yield r, false
    end
  end
end

def target_index
  @target_index ||= SuggestionsIndex.new
end

def transform_facets_exact_count idx, rep
  values = rep['facets'] || {}
  idx.config.facets.map do |facet|
    attr = facet['attribute']
    res = values[attr] || []
    [
      attr,
      res.map { |k, v| { value: k, count: v } }
         .sort_by { |obj| -obj[:count] }
         .first(facet['amount'])
    ]
  end.to_h
end

def transform_facets_analytics idx, rep
  values = rep['topRefinements'] || {}
  idx.config.facets.map do |facet|
    attr = facet['attribute']
    res = values[attr] || []
    [
      attr,
      res.first(facet['amount'])
    ]
  end.to_h
end

def add_to_target_index idx, type, suggestions, primary_index = false
  iter = suggestions.clone
  iter.each_with_index do |p, i|
    q = SearchString.clean(p['query'].to_s)
    puts "[#{idx.name}]#{type} Query#{" #{i + 1} / #{iter.size}" if iter.size > 1}: \"#{q}\""
    q = idx.unprefixer.transform q
    next if q.blank?
    rep = idx.search_exact q
    next if rep['nbHits'] < idx.config.min_hits
    object = {
      objectID: q,
      query: q,
      nb_words: q.split(' ').size,
      popularity: {
        value: p['count'].to_i,
        _operation: 'Increment'
      }
    }
    if primary_index
      object[idx.name.to_sym] = {
        exact_nb_hits: rep['nbHits'],
        facets: {
          exact_matches: transform_facets_exact_count(idx, rep),
          analytics: transform_facets_analytics(idx, p)
        }
      }
    end
    target_index.add object
    suggestions.delete_at i
  end
end

def main
  each_index do |idx, primary_index|
    popular = Analytics.popular_searches(
      idx.name,
      size: 10_000,
      startAt: (Time.now - idx.config.analytics_days.days).to_i,
      endAt: Time.now.to_i,
      tags: idx.config.analytics_tags.join(','),
      distinctIPCount: idx.config.distinct_by_ip
    )
    add_to_target_index idx, '[Popular]', popular, primary_index

    next unless primary_index

    add_to_target_index idx, '[Generated]', idx.generated, primary_index

    idx.external do |external|
      external.browse do |hit|
        add_to_target_index idx, "[External][#{external.index_name}]", [hit], primary_index
      end
    end
  end

  target_index.push
  target_index.ignore_plurals
  target_index.move_tmp
end
