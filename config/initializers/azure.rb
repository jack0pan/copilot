require "azure"

Azure::OpenAI::Client.configure do |config|
  config.api_key = ENV["AZURE_OPENAI_API_KEY"]
  config.deployment_id = "gpt-35"
end