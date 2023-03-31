class Feishu::ChatGPT::ReceiveMessageJob
  include Sidekiq::Job

  def perform(message_json)
    openai_client = OpenAI::Client.new
    feishu_client = Feishu::Client.new

    message = JSON.parse(message_json)

    response =
      openai_client.chat(
        parameters: {
          model: "gpt-3.5-turbo",
          messages: chat_messages(message, feishu_client)
        }
      )

    feishu_client.reply_message(
      message["message_id"],
      { text: response.dig("choices", 0, "message", "content") }
    )
  end

  private

  def chat_messages(message, feishu_client)
    content = JSON.parse(message["content"])["text"]
    strip_mention!(content, message["mentions"]) if message["mentions"]

    gpt_messages = [{ role: "user", content: content }]

    p_message = message
    while p_message["parent_id"]
      p_message = feishu_client.get_message(p_message["parent_id"])
      type = p_message["message_type"] || p_message["msg_type"]
      if type == "text"
        role =
          p_message["sender"]["sender_type"] == "user" ? "user" : "assistant"
        text = JSON.parse(p_message["body"]["content"])["text"]
        strip_mention!(text, p_message["mentions"]) if p_message["mentions"]
        gpt_messages.unshift({ role: role, content: text })
      end
    end

    if message["chat_type"] == "group"
      chat = feishu_client.get_chat(message["chat_id"])
      gpt_messages.unshift({ role: "system", content: chat["description"] })
    end

    gpt_messages
  end

  def strip_mention!(text, mentions)
    mentions.each { |mention| text.gsub!(mention["key"], "") }
    text.strip!
  end
end
