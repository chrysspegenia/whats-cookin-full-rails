require "test_helper"

class RedirectControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get redirect_index_url
    assert_response :success
  end
end
