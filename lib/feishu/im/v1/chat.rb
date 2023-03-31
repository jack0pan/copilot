module Feishu
  module Im
    module V1
      module Chat
        def get_chat(chat_id)
          response =
            json_conn.get do |req|
              req.url "#{self.class.configuration.uri}/im/v1/chats/#{chat_id}"
              req.headers["Authorization"] = "Bearer #{tenant_access_token}"
            end
          response.body.dig("data")
        end
      end
    end
  end
end
