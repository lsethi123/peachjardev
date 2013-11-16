require 'test_helper'

class OauthControllerTest < ActionController::TestCase
  test "should get main" do
    get :main
    assert_response :success
  end

  test "should get auth_start" do
    get :auth_start
    assert_response :success
  end

  test "should get auth_finish" do
    get :auth_finish
    assert_response :success
  end

end
