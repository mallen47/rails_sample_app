require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: {user: {name: "",
                                       email: "user@invalid",
                                       password: "foo",
                                       password_confirmation: "bar"} }
    end
    # check that failed submission re-renders the 'new' action
    assert_template 'users/new' 
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end
  
  
  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: {user: {name: "Test User",
                                       email: "test@example.com",
                                       password: "abc123",
                                       password_confirmation: "abc123" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
    assert_equal flash.keys[0], "success"
    assert is_logged_in?
  end
  
end
