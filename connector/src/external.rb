require 'algoliasearch'

class External
  attr_reader :index_name
  attr_reader :source

  def initialize index_name, source = nil
    @index_name = index_name
    @source = source
  end

  def browse &_block
    raise ArgumentError, 'Missing block' unless block_given?
    index.browse do |hit|
      yield hit
    end
  end

  def index
    return nil if index_name.blank?
    client.init_index(index_name)
  end

  def client
    @client ||= Algolia::Client.new(
      application_id: application_id,
      api_key: api_key
    )
  end

  def application_id
    if @source == 'source'
      if CONFIG['source_app_id'].blank?
        raise 'Missing source_app_id with "external_source": "source"'
      end
      return CONFIG['source_app_id']
    end
    if @source == 'target'
      if CONFIG['target_app_id'].blank?
        raise 'Missing target_app_id with "external_source": "target"'
      end
      return CONFIG['target_app_id']
    end
    CONFIG['app_id']
  end

  def api_key
    if @source == 'source'
      if CONFIG['source_api_key'].blank?
        raise 'Missing source_api_key with "external_source": "source"'
      end
      return CONFIG['source_api_key']
    end
    if @source == 'target'
      if CONFIG['target_api_key'].blank?
        raise 'Missing target_api_key with "external_source": "target"'
      end
      return CONFIG['target_api_key']
    end
    CONFIG['api_key']
  end
end
