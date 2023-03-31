require "test_helper"

class Feishu::ChatGPT::EventsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get feishu_chatgpt_events_create_url
    assert_response :success
  end
end
