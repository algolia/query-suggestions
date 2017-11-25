class Unprefixer
  def initialize source
    @source = source
    @searchable = source.settings['searchableAttributes'] ||
                  source.settings['attributesToIndex'] ||
                  []
    @searchable.map! do |attr|
      {
        name: attr.gsub(/^.*\(([^()]*)\)*$/, '\1'),
        ordered: !attr.match(/unordered\(/)
      }
    end
    @query_type = source.config.query_type
  end

  def transform q
    return nil if @source.ignore(q)
    q = unprefix q
    @source.ignore(q) ? nil : q
  end

  private

  def distance s1, s2
    DamerauLevenshtein.distance(s1.downcase, s2.downcase, 1, 3)
  end

  def find_searchable attr
    @searchable.each_with_index do |s, i|
      splitted = attr.split('.')
      tmp = ''
      splitted.each do |sub|
        tmp += sub
        return {index: i, ordered: s[:ordered]} if s[:name] == sub || s[:name] == "#{sub}.*"
      end
    end
    {index: @searchable.size, ordered: true}
  end

  def highlight_leaves obj
    return obj if obj.is_a?(Hash) && !obj['matchedWords'].nil?
    return obj.values.map { |val| highlight_leaves(val) }.flatten if obj.is_a?(Hash)
    [obj].flatten.map { |elt| highlight_leaves(elt) }.flatten
  end

  def highlight_strings rep, word
    rep['hits'].flat_map do |h|
      h['_highlightResult'].flat_map do |attr, arr|
        arr = highlight_leaves(arr) if arr.is_a?(Hash)
        [arr].flatten.map do |obj|
          next nil unless (obj['matchedWords'] || []).include? word
          [find_searchable(attr), obj['value']]
        end.compact
      end
    end
  end

  def compare_scores scores1, scores2
    scores1.each_with_index do |v1, i|
      v2 = scores2[i]
      next if v1 == v2
      return v1 <=> v2
    end
    0
  end

  def best_candidate_word word, rep
    candidates = {}

    highlight_strings(rep, word).each do |searchable, str|
      matched_words = str.scan(%r{<HIGHLIGHT>(.*?)</HIGHLIGHT>([\p{L}0-9]*)})
      matched_words.each_with_index do |(match, rest), pos|
        full_word = SearchString.clean "#{match}#{rest}"
        next unless SearchString.keep?(full_word, @source.config.exclude)
        distance = distance(match, word)
        position = searchable[:ordered] ? pos : 0
        candidates[full_word] ||= []
        candidates[full_word].push([distance, searchable[:index], position])
      end
    end

    tmp = candidates.map do |cword, scores|
      best_scores = scores
                    .group_by { |arr| arr }
                    .map { |arr, arrs| [arrs.size, arr] }
                    .map { |count, scores_arr| scores_arr + [-count] }
                    .sort { |scores1, scores2| compare_scores scores1, scores2 }
                    .first
      [cword, best_scores]
    end

    return nil if tmp.empty?

    tmp
      .sort { |(_, scores1), (_, scores2)| compare_scores scores1, scores2 }
      .first
      .first
  end

  def check_prefix q, only_last
    rep = @source.search_approx(q, getRankingInfo: 1)
    return nil if rep['nbHits'] < @source.config.min_hits
    splitted = q.split(/\s+/)
    normalized_splitted = rep['parsedQuery'].split(/\s+/)
    return q if normalized_splitted.size != splitted.size
    res = []
    splitted.each_with_index do |word, i|
      if only_last && i != splitted.size - 1
        res.push(word)
      else
        res.push best_candidate_word(normalized_splitted[i], rep)
      end
    end
    res.join(' ')
  end

  def unprefix q
    case @query_type
    when 'prefixNone' then q
    when 'prefixLast' then check_prefix q, true
    when 'prefixAll'  then check_prefix q, false
    end
  end
end
