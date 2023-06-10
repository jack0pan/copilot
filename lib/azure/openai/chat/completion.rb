module Azure
  module OpenAI
    module Chat
      module Completion
        def create_chat_completion(messages)
          json_conn.post do |req|
            config = self.class.configuration
            req.url "#{config.uri}/deployments/#{config.deployment_id}/chat/completions"
            req.params["api-version"] = config.api_version
            req.headers["api-key"] = config.api_key
            req.body = {
              messages: messages
            }.to_json
          end
        end
      end
    end
  end
end
