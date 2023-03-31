require 'feishu'

class FeishuEventJob < ApplicationJob
  queue_as :default

  def perform(event_json)
    event = JSON.parse(event_json)
    if event["message"]["message_type"] == "text"
      content = JSON.parse(event["message"]["content"])
      client = OpenAI::Client.new
      response = client.chat(
        parameters: {
          model: 'gpt-3.5-turbo',
          messages: [{ role: 'user', content: content["text"] }]
        }
      )
      completion = response.dig('choices', 0, 'message', 'content')
      # logger.info("[---] content: #{completion}")
      # completion = 'no why'
      feishu_client = Feishu::Client.new
      feishu_client.reply_message(event['message']['message_id'], { text: completion })
    end
  end
end
