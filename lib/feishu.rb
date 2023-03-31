require_relative "feishu/client"
require_relative "feishu/app"
require_relative "feishu/chatgpt"
require_relative "feishu/dalle"

module Feishu
  class Configuration
    attr_writer :app_id, :app_secret

    def initialize
      @app_id = nil
      @app_secret = nil
    end

    def app_id
      return @app_id if @app_id
    end

    def app_secret
      return @app_secret if @app_secret
    end
  end

  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Feishu::Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
