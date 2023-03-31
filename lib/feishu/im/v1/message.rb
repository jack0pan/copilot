module Feishu
  module Im
    module V1
      module Message
        def get_message(message_id)
          response =
            json_conn.get do |req|
              req.url "#{self.class.configuration.uri}/im/v1/messages/#{message_id}"
              req.headers[
                "Authorization"
              ] = "Bearer #{internal_tenant_access_token}"
            end
          response.body.dig("data", "items", 0)
        end

        def reply_message(message_id, content, message_type = "text")
          json_conn.post do |req|
            req.url "#{self.class.configuration.uri}/im/v1/messages/#{message_id}/reply"
            req.headers[
              "Authorization"
            ] = "Bearer #{internal_tenant_access_token}"
            req.body = {
              content: content.to_json,
              msg_type: message_type
            }.to_json
          end
        end
      end
    end
  end
end
