require 'test_helper'

class DropboxControllerTest < ActionController::TestCase
  test "should get list" do
    get :list
    assert_response :success
  end

  test "should get upload" do
    get :upload
    assert_response :success
  end

  test "should get folder" do
    get :folder
    assert_response :success
  end

  test "should get download" do
    get :download
    assert_response :success
  end

  test "should get share" do
    get :share
    assert_response :success
  end

  test "should get logout" do
    get :logout
    assert_response :success
  end

end
