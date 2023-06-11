require "faraday"
require "faraday/multipart"
require_relative "auth/v3/access_token"
require_relative "im/v1/chat"
require_relative "im/v1/image"
require_relative "im/v1/message"

module Feishu
  class App
    include Auth::V3::AccessToken
    include Im::V1::Chat
    include Im::V1::Image
    include Im::V1::Message

    class Configuration
      attr_accessor :uri
      attr_writer :app_id, :app_secret

      DEFAULT_URI = "https://open.feishu.cn".freeze

      def initialize(app_id = nil, app_secret = nil, uri = nil)
        @app_id = app_id if app_id
        @app_secret = app_secret if app_secret
        @uri = uri || DEFAULT_URI
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
      @configuration ||= Feishu::App::Configuration.new
    end

    def self.configure
      yield(configuration)
    end

    def internal_tenant_access_token
      get_internal_tanent_access_token(
        self.class.configuration.app_id,
        self.class.configuration.app_secret
      )
    end

    private

    def json_conn
      Faraday.new() do |f|
        f.request :json
        f.response :json
      end
    end

    def multipart_conn
      token = internal_tenant_access_token()

      Faraday.new(
        url: self.class.configuration.uri,
        headers: {
          'Authorization' => "Bearer #{token}",
          'User-Agent' => "FeishuRuby/0.0.1"
        }
      ) do |f|
        f.request :multipart
        f.response :json
      end
    end
  end
end
