class Feishu::EventsController < Feishu::ApplicationController
  def create
    if validate_app(params[:app])
      app_name = ActiveSupport::Inflector.camelize(params[:app])
      job = Feishu.const_get("Feishu::#{app_name}::ReceiveMessageJob")
      job.perform_async(
        params[:event][:message].to_json
      )
    else
      head :not_found
    end
  end

  private

  def validate_app(app)
    %w[chatgpt dalle stable_diffusion].include?(app)
  end
end
