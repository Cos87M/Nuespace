require "test_helper"

class ListingsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get listings_url
    assert_response :success
  end
end
