require 'json'

CONFIG = {
  'app_id' => ENV['APPLICATION_ID'],
  'api_key' => ENV['API_KEY'],
  'index_prefix' => ENV['INDEX_PREFIX']
}.merge(JSON.parse(ENV['CONFIG']))

def idx_param(idx, param, default)
  idx[param] = CONFIG[param] || default if idx[param].nil?
end

CONFIG['indices'] ||= []
CONFIG['indices'].each do |idx|
  raise ArgumentError, 'Missing `name` parameter on an index' unless idx['name']

  idx_param idx, 'replicas', true
  idx_param idx, 'distinct_by_ip', false
  idx_param idx, 'analytics_tags', []
  if idx['analytics_tags'].is_a? String
    idx['analytics_tags'] = idx['analytics_tags'].split(',').map(&:trim)
  end
  idx_param idx, 'analytics_days', 90

  idx_param idx, 'generate', []
  idx_param idx, 'query_type', nil

  idx_param idx, 'external', []
  idx['external'].map! do |external|
    next { 'name' => external } if external.is_a?(String)
    external
  end
  idx_param idx, 'external_source', nil

  idx_param idx, 'facets', []

  idx_param idx, 'min_hits', 5
  idx_param idx, 'min_letters', 4

  if idx['exclude'].blank?
    idx['exclude'] = (
      CONFIG['exclude'] && !CONFIG['exclude'].empty?
    ) ? CONFIG['exclude'] : []
  end
  idx['exclude'].map! { |r| /#{r}/i }
end

CONFIG['ignore_plurals'] ||= false
CONFIG['debug'] ||= false
CONFIG['parallel'] ||= 0
