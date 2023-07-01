class Feishu::DALLE::ReceiveMessageJob
  include Sidekiq::Job

  def perform(message_id)
    message = JSON.parse(Rails.cache.read(message_id))
    openai_client = OpenAI::Client.new
    dalle_client = Feishu::DALLE.new
    prompt = JSON.parse(message['content'])['text']
    response = openai_client.images.generate(parameters: { prompt: })
    image_url = response.dig('data', 0, 'url')
    image_key = dalle_client.upload_image_by_url(image_url)
    dalle_client.reply_message(message_id, { image_key: }, 'image')
  end
end
