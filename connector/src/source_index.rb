require 'algoliasearch'

require_relative './config.rb'

class SourceIndex
  def self.client
    @client ||= Algolia::Client.new(
      application_id: CONFIG['algolia_app_id'],
      api_key: CONFIG['algolia_api_key']
    )
  end

  def initialize
  end

  def search *args
    index.search(*args)
  end

  def name
    CONFIG['index']
  end

  def index
    self.class.client.init_index name
  end
end
