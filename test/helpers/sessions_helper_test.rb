require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
  
  def setup 
    @user = users(:Bill)
    remember(@user)
  end
  
  
  test "current_user method returns correct user when session is nil" do
    # this test ensures we are hitting the part of the current_user method -
    # the elseif branch which is executed when session[:user_id] is nil. 
    
    # @user is not logged in. It is a user contrived from the fixtures.
    # we call remember on this test user which will set a new persistent cookie.
    # The test user's password is always 'password'
    # We compare the test user to the object returned by current_user
    assert_equal @user, current_user
    assert is_logged_in?
  end
  
  test "current_user returns nil when remember digest is wrong" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end
  
end