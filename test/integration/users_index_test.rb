require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin     = users(:Bill)
    @non_admin = users(:Dave)
  end
  
  test "users index as admin should include pagination and delete links" do
    log_in_as(@admin)  # users index is protected so we need to be logged in
    # The code below is from execise 11.3.3 #3. It should probably be in its
    # own test so as to not add too much to this test, but it is intended to 
    # validate that only active users are displayed on the index page
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.first.toggle!(:activated)
    get users_path
    assert_template 'users/index'  # make sure we are on the users index page
    assert_select 'div.pagination', count: 2 # check pagination links
    # check that users are present as expected
    # first_page_of_users.each do |user|
    assigns(:users).each do |user|
      assert user.activated?
      assert_select "a[href=?]", user_path(user), text: user.name
      unless user == @admin
        assert_select "a[href=?]", user_path(user), text: "delete"
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end
  
  test "users index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select "a", text: 'delete', count: 0
  end
end

# Remember, when checking the links to user profiles in order to validate that
# users are displayed on the index as exepected, we are checking each link 
# points to the user_path not users_path. user_path is the named route helper
# for users#show, i.e. the user profile page. users_path is the named route to 
# users#index, the index page of all users. 
