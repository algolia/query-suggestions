require 'active_support'
require 'active_support/time'
require 'active_support/core_ext/object/blank'
require 'damerau-levenshtein'

# Debug
require 'yaml'
require 'pry'

require_relative './config.rb'
require_relative './analytics.rb'
require_relative './popular_index.rb'
require_relative './source_index.rb'
require_relative './generator.rb'
require_relative './search_string.rb'

def each_index &_block
  raise ArgumentError, 'Missing block' unless block_given?
  CONFIG['indices'].each do |idx|
    idx = SourceIndex.new(idx['name'])
    yield idx
  end
end

def target_index
  @target_index ||= PopularIndex.new
end

def generated idx
  res = []
  idx.config.generate.each do |facets|
    res += Generator.new(idx, facets).generate
  end
  res
end

def check_none idx, q
  rep = idx.search(
    q,
    queryType: 'prefixNone',
    typoTolerance: false,
    attributesToHighlight: []
  )
  return nil if rep['nbHits'] < idx.config.min_hits
  q
end

def distance s1, s2
  DamerauLevenshtein.distance(s1, s2, 1, 3)
end

def highlight_strings rep, word
  rep['hits']
    .map { |h|
      h['_highlightResult']
      .values
    }
    .flatten
    .select { |o| (o['matchedWords'] || []).include? word }
    .map { |o| o['value'] }
end

def best_candidate_word idx, word, rep
  candidates = {}

  highlight_strings(rep, word).each do |str|
    matched_words = str.scan(%r{<HIGHLIGHT>(.*?)</HIGHLIGHT>([\p{L}0-9]*)})
    matched_words.each do |match, rest|
      full_word = SearchString.clean "#{match}#{rest}"
      next unless SearchString.keep?(full_word, idx.config.exclude)
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


def check_prefix idx, q, only_last
  rep = idx.search_approx(q)
  return nil if rep['nbHits'] < idx.config.min_hits
  splitted = q.split(/\s+/)
  res = []
  splitted.each_with_index do |word, i|
    if only_last && i != splitted.size - 1
      res.push(word)
    else
      res.push best_candidate_word(idx, word, rep)
    end
  end
  res.join(' ')
end

def check_query idx, q
  qt = idx.config.query_type
  case qt
  when 'prefixNone' then q
  when 'prefixLast' then check_prefix idx, q, true
  when 'prefixAll'  then check_prefix idx, q, false
  end
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
    popular += generated idx
    popular.each_with_index do |p, i|
      q = SearchString.clean(p['query'])
      puts "[#{idx.name}] Query #{i + 1} / #{popular.size}: \"#{q}\""
      next if q.length < idx.config.min_letters
      next unless SearchString.keep?(q, idx.config.exclude)
      q = check_query idx, q
      next if q.nil?
      rep = idx.search_exact q
      next if rep['nbHits'] < idx.config.min_hits
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
