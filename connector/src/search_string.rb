module SearchString
  SKIP_REGEXP = /[^\p{L}\s0-9]/
  KEEP_REGEXP = /\A[\p{L}\s0-9]+\Z/

  def self.clean str
    str.strip.split(/\s+/).join(' ').downcase
  end
end
