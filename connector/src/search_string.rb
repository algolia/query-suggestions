module SearchString
  SKIP_REGEXP = /[^\p{L}\s]/
  KEEP_REGEXP = /^[\p{L}\s]+$/

  def self.clean str
    str.strip.split(/\s+/).join(' ').downcase
  end
end
