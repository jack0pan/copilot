class Feishu::ApplicationController < ActionController::API
  before_action :check_uniqueness
  before_action :reply_challenge

  private

  # Check and handle the repeated events within 7.1 hours.
  def check_uniqueness
    message_id = params.dig(:event, :message, :message_id)
    if message_id
      if Rails.cache.exist?(message_id)
        head :ok, content_type: "application/json"
      else
        Rails.cache.write(
          message_id,
          params[:event][:message].to_json,
          expires_in: 426.minutes
        )
      end
    end
  end

  def reply_challenge
    if params[:type] == "url_verification"
      render json: { challenge: params[:challenge] }
    end
  end
end
