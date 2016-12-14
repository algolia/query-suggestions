require 'json'

CONFIG = {
  'app_id' => ENV['APPLICATION_ID'],
  'api_key' => ENV['API_KEY'],
  'index_prefix' => ENV['INDEX_PREFIX']
}.merge(JSON.parse(ENV['CONFIG']))
CONFIG['min_hits'] = 5 if CONFIG['min_hits'].blank?
CONFIG['min_hits'] = CONFIG['min_hits'].to_i

CONFIG['min_letters'] = 3 if CONFIG['min_letters'].blank?
CONFIG['min_letters'] = CONFIG['min_letters'].to_i

CONFIG['analytics_tags'] ||= ''
