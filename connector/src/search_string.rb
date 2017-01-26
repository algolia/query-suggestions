module SearchString
  SKIP_REGEXP = /[^\p{L}\s]/
  KEEP_REGEXP = /\A[\p{L}\s]+\Z/

  def self.clean str
    str.strip.split(/\s+/).join(' ').downcase
  end
end
