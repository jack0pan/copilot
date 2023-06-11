module HuggingFace
  module Inference
    module Tasks
      module ComputerVision
        def text_to_image(model_id, inputs, options = nil)
          default_conn.post("/models/#{model_id}") do |req|
            req.body = { inputs: inputs }.to_json
          end
        end
      end
    end
  end
end
