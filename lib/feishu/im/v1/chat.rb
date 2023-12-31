module Feishu
  module Im
    module V1
      module Chat
        def get_chat(chat_id)
          response =
            json_conn.get do |req|
              req.url "#{self.class.configuration.uri}/open-apis/im/v1/chats/#{chat_id}"
              req.headers[
                "Authorization"
              ] = "Bearer #{internal_tenant_access_token}"
            end
          response.body.dig("data")
        end
      end
    end
  end
end
