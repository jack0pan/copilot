require "faraday"
require "faraday/multipart"

module Feishu
  class Client
    BASE_URL = "https://open.feishu.cn/open-apis".freeze

    def initialize
      @conn =
        Faraday.new() do |f|
          f.request :json
          f.response :json
        end
    end

    def get_chat(chat_id)
      response =
        @conn.get do |req|
          req.url "#{BASE_URL}/im/v1/chats/#{chat_id}"
          req.headers["Authorization"] = "Bearer #{tenant_access_token}"
        end
      response.body.dig("data")
    end

    def get_message(message_id)
      response =
        @conn.get do |req|
          req.url "#{BASE_URL}/im/v1/messages/#{message_id}"
          req.headers["Authorization"] = "Bearer #{tenant_access_token}"
        end
      response.body.dig("data", "items", 0)
    end

    def reply_message(message_id, content, message_type = "text")
      @conn.post do |req|
        req.url "#{BASE_URL}/im/v1/messages/#{message_id}/reply"
        req.headers["Authorization"] = "Bearer #{tenant_access_token}"
        req.body = { content: content.to_json, msg_type: message_type }.to_json
      end
    end

    def upload_image(image_url)
      conn =
        Faraday.new() do |f|
          f.request :multipart
          f.response :json
        end

      payload = {
        "image_type" => "message",
        "image" =>
          Faraday::Multipart::FilePart.new(URI.open(image_url), "image/png")
      }
      response =
        conn.post do |req|
          req.url "#{BASE_URL}/im/v1/images"
          req.headers["Authorization"] = "Bearer #{tenant_access_token}"
          req.body = payload
        end
      response.body.dig("data", "image_key")
    end

    def tenant_access_token
      response =
        @conn.post do |req|
          req.url "#{BASE_URL}/auth/v3/tenant_access_token/internal"
          req.body = {
            app_id: Feishu.configuration.app_id,
            app_secret: Feishu.configuration.app_secret
          }.to_json
        end
      response.body.dig("tenant_access_token")
    end
  end
end
