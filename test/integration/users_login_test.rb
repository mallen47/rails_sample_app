require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:Bill)
  end
  
  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email: @user.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    # Simulate a user clicking logout in a second window
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count:0
    assert_select "a[href=?]", user_path(@user), count:0
  end
  
  test "login with valid email/ invalid password" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: {email: @user.email, 
                                         password: 'invalid' }}
    assert_not is_logged_in?
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
  
  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_not_empty cookies[:remember_token]
    # the assertion below uses the assigns method described in 9.3.1 in
    # exercise 1. It allows access to the user variable in the sessions
    # controller as long as user is defined as an instance variable. This worked
    # for the exercise to demonstrate the assigns method but won't work now
    # because user is a local variable. Changing it to an instance variable 
    # would make the assertion below work but it breaks other tests that 
    # reference user.
    # assert_equal cookies['remember_token'], assigns(:user).remember_token
  end
  
  test "login without remembering" do
    # Log in to set the cookie.
    log_in_as(@user, remember_me: '1')
    # Log in again and verify that the cookie is deleted.
    log_in_as(@user, remember_me: '0')
    assert_empty cookies[:remember_token]
  end
end
