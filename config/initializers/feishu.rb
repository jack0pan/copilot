require "feishu"

Feishu.configure do |config|
  config.app_id = Rails.application.credentials.dig(:feishu, :app_id)
  config.app_secret = Rails.application.credentials.dig(:feishu, :app_secret)
end

Feishu::ChatGPT.configure do |config|
  config.app_id = ENV["FEISHU_CHATGPT_ID"]
  config.app_secret = ENV["FEISHU_CHATGPT_SECRET"]
end

Feishu::DALLE.configure do |config|
  config.app_id = ENV["FEISHU_DALLE_ID"]
  config.app_secret = ENV["FEISHU_DALLE_SECRET"]
end
