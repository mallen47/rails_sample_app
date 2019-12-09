require 'test_helper'

class UserShowTest < ActionDispatch::IntegrationTest

  def setup
    @active_user   = users(:Dave)
    @inactive_user = users(:Bob)
  end
  
  test "should display active user" do
    get user_path(@active_user)
    assert_template 'users/show'
    assert_response :success
  end
  
  test "should redirect to root for inactive user" do
    get user_path(@inactive_user)
    assert_redirected_to root_url
  end
end
