require "faraday"
require_relative "chat/completion"

module Azure
  module OpenAI
    class Client
      include Chat::Completion

      class Configuration
        attr_accessor :uri
        attr_writer :api_key, :api_version, :deployment_id
  
        DEFAULT_URI = "https://aigc-gpt.openai.azure.com/openai".freeze
        DEFAULT_API_VERSION = "2023-05-15".freeze
        DEFAULT_DEPLOYMENT_ID = "gpt-35"
  
        def initialize(api_key = nil, deployment_id = nil, uri = nil, api_version = nil)
          @api_key = api_key if api_key
          @deployment_id = deployment_id || DEFAULT_DEPLOYMENT_ID
          @uri = uri || DEFAULT_URI
          @api_version = api_key || DEFAULT_API_VERSION
        end
  
        def api_key
          return @api_key if @api_key
        end

        def api_version
          return @api_version if @api_version
        end
  
        def deployment_id
          return @deployment_id if @deployment_id
        end
      end
  
      class << self
        attr_writer :configuration
      end
  
      def self.configuration
        @configuration ||= Azure::OpenAI::Client::Configuration.new
      end
  
      def self.configure
        yield(configuration)
      end

      private

      def json_conn
        Faraday.new() do |f|
          f.request :json
          f.response :json
        end
      end
    end
  end
end
