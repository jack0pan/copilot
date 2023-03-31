class Api::V1::FeishuEventsController < Api::ApplicationController
  before_action :check_uniqueness, only: [:create]

  def create
    if params[:schema]
      if params[:header][:event_type] == "im.message.receive_v1"
        FeishuEventJob.perform_later(params[:event].to_json)
      end
      head :no_content
    elsif params[:type] == "url_verification"
      render json: { challenge: params[:challenge] }
    else
      head :bad_request
    end
  end

  private

  # Check and handle the repeated events within 7.1 hours.
  def check_uniqueness
    event_id = params.dig(:header, :event_id)
    if event_id
      uniqueness_key = "event_id:#{event_id}"
      if Rails.cache.exist?(uniqueness_key)
        head :no_content
      else
        Rails.cache.write(uniqueness_key, true, expires_in: 426.minutes)
      end
    end
  end
end
