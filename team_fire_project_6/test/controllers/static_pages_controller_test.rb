
require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  test "should get home" do
    get root_path
    assert_response :success
    assert_select "title", "Rate My Peers Web"
  end

  test "should get login" do
    get login_path
    assert_response :success
    assert_select "title", "Rate My Peers Web"
  end

  test "should get signup" do
    get signup_path
    assert_response :success
  end
end
