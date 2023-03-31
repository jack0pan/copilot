class Feishu::ChatGPT::EventsController < Feishu::ApplicationController
  def create
    event_type = params.dig(:header, :event_type)
    message_type = params.dig(:event, :message, :message_type)
    if event_type == "im.message.receive_v1" and message_type == "text"
      Feishu::ChatGPT::ReceiveMessageJob.perform_async(
        params[:event][:message].to_json
      )
    end
    head :ok, content_type: "application/json"
  end
end
