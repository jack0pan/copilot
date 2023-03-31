require "test_helper"

class Feishu::EventsControllerTest < ActionDispatch::IntegrationTest
  test "should reply challenge" do
    challenge = "ajls384kdjx98XX"
    post api_v1_feishu_events_path, params: { type: "url_verification", challenge: challenge, token: "xxxx" }, as: :json

    assert_response :success
    response_json = JSON.parse(@response.body)
    assert_equal challenge, response_json["challenge"]
  end

  test "should process events" do
    event = JSON.parse(file_fixture('feishu/receive_message.json').read)
    post api_v1_feishu_events_path, params: event, as: :json

    assert_response :no_content
  end
end
