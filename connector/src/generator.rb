require_relative './search_string.rb'

class Generator
  def initialize index, facets
    @index = index
    @facets = facets
    @values = facets.map do |f|
      [f, []]
    end.to_h
  end

  def generate
    generate_rec.map do |query|
      { 'query' => query, 'count' => 0 }
    end
  end

  protected

  def generate_rec i = 0, filters = ''
    name = @facets[i]
    values = facet_values name, filters
    return values.map { |v| SearchString.clean(v) } if i + 1 == @facets.size
    res = []
    values.each do |val|
      new_filters = "#{' AND ' if filters != ''}#{name}:\"#{val}\""
      clean_val = SearchString.clean val
      nested = generate_rec i + 1, new_filters
      nested.each do |nested_val|
        res << "#{clean_val} #{nested_val}"
      end
    end
    res
  end

  def facet_values facet, filters
    puts "[#{@index.name}][Generator]#{"[#{filters}]" if filters != ''} Generating #{facet}"
    rep = @index.search(
      '',
      hitsPerPage: 0,
      attributesToRetrieve: [],
      attributesToHighlight: [],
      attributesToSnippet: [],
      facets: facet,
      filters: filters,
      maxValuesPerFacet: 1_000,
      analytics: false
    )
    values = rep['facets'][facet]
    return [] if values.nil?
    values
      .keys
      .select { |s| SearchString.keep?(s, @index.config.exclude) }
  end
end
