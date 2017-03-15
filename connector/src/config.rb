require 'json'

CONFIG = {
  'app_id' => ENV['APPLICATION_ID'],
  'api_key' => ENV['API_KEY'],
  'index_prefix' => ENV['INDEX_PREFIX']
}.merge(JSON.parse(ENV['CONFIG']))

def idx_param(idx, param, default)
  idx[param] ||= CONFIG[param] || default
end

CONFIG['indices'] ||= []
CONFIG['indices'].each do |idx|
  raise ArgumentError, 'Missing `name` parameter on an index' unless idx['name']

  idx_param idx, 'replicas', true
  idx_param idx, 'analytics_tags', []
  if idx['analytics_tags'].is_a? String
    idx['analytics_tags'] = idx['analytics_tags'].split(',').map(&:trim)
  end
  idx_param idx, 'generate', []
  idx_param idx, 'query_type', nil

  idx_param idx, 'min_hits', 5
  idx_param idx, 'min_letters', 4
  idx_param idx, 'exclude', []
  idx['exclude'].map! { |r| /#{r}/i }
end
