require 'algoliasearch'

class External
  def self.index
    return nil if index_name.blank?
    client.init_index(index_name)
  end

  def self.index_name
    CONFIG['external']
  end

  def self.client
    @client ||= Algolia::Client.new(
      application_id: application_id,
      api_key: api_key
    )
  end

  def self.application_id
    if CONFIG['external_app'] == 'source'
      if CONFIG['source_app_id'].blank?
        raise 'Missing source_app_id with "external_app": "source"'
      end
      return CONFIG['source_app_id']
    end
    if CONFIG['external_app'] == 'target'
      if CONFIG['target_app_id'].blank?
        raise 'Missing target_app_id with "external_app": "target"'
      end
      return CONFIG['target_app_id']
    end
    CONFIG['app_id']
  end

  def self.api_key
    if CONFIG['external_app'] == 'source'
      if CONFIG['source_api_key'].blank?
        raise 'Missing source_api_key with "external_app": "source"'
      end
      return CONFIG['source_api_key']
    end
    if CONFIG['external_app'] == 'target'
      if CONFIG['target_api_key'].blank?
        raise 'Missing target_api_key with "external_app": "target"'
      end
      return CONFIG['target_api_key']
    end
    CONFIG['api_key']
  end

  def self.browse
    return [] if index.nil?
    res = []
    index.browse do |hit|
      res << hit
    end
    res
  end
end
