module Feishu
  module Im
    module V1
      module Image
        def upload_image(
          image_url,
          image_format = "image/png",
          image_type = "message"
        )
          response =
            multipart_conn.post do |req|
              req.url "#{self.class.configuration.uri}/im/v1/images"
              req.headers[
                "Authorization"
              ] = "Bearer #{internal_tenant_access_token}"
              req.body = {
                "image_type" => image_type,
                "image" =>
                  Faraday::Multipart::FilePart.new(
                    URI.open(image_url),
                    image_format
                  )
              }
            end
          response.body.dig("data", "image_key")
        end
      end
    end
  end
end
