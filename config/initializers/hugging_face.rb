require "hugging_face"

HuggingFace::Inference::Client.configure do |config|
  config.access_token = ENV["HUGGING_FACE_ACCESS_TOKEN"]
end
