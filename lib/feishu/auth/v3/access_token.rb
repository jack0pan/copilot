module Feishu
  module Auth
    module V3
      module AccessToken
        def get_internal_tanent_access_token(app_id, app_secret)
          response =
            json_conn.post do |req|
              req.url "#{self.class.configuration.uri}/open-apis/auth/v3/tenant_access_token/internal"
              req.body = { app_id: app_id, app_secret: app_secret }.to_json
            end
          puts "[*] tanent access token: #{response.body}"
          response.body.dig("tenant_access_token")
        end
      end
    end
  end
end
