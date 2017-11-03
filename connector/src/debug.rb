require_relative './config.rb'

class Debug
  CATEGORY_MAX_WIDTH = 20
  INDEX_NAME_MAX_WIDTH = 40

  attr_reader :entries
  def initialize
    @entries = []
  end

  def add category, message, index: nil, extra: nil
    return unless CONFIG['debug']

    # Category
    category_padding_size = [0, CATEGORY_MAX_WIDTH - category.size].max
    category_text = "[ #{category}#{' ' * category_padding_size} ]"

    # Index name
    index_text = ''
    unless index.nil?
      index_padding_size = [0, INDEX_NAME_MAX_WIDTH - index.name.size].max
      index_text = "[ #{index.name}#{' ' * index_padding_size} ]"
    end

    # Entry
    entry = [
      "#{category_text}#{index_text} #{message.to_s}"
    ]

    # Extra data
    entry << extra unless extra.nil?

    @entries << entry
  end
end
