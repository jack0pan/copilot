class Feishu::StableDiffusion::ReceiveMessageJob
  include Sidekiq::Job

  def perform(message_id)
    message = JSON.parse(Rails.cache.read(message_id))

    hf_client = HuggingFace::Inference::Client.new
    feishu_client = Feishu::StableDiffusion.new

    prompt = JSON.parse(message["content"])["text"]
    response = hf_client.text_to_image('stabilityai/stable-diffusion-2', prompt)
    logger.info("[*] hugging face response: #{response.status}, content type: #{response.headers['Content-Type']}")
    # if response.status == 200
      image_key = feishu_client.upload_image(response.body, response.headers['Content-Type'])
      logger.info("[*] feishu image key: #{image_key}")
      feishu_client.reply_message(
        message_id,
        { "image_key" => image_key },
        "image"
      )
    # end
  end
end
