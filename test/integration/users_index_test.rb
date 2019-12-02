require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:Bill)
  end
  
  test "users index should paginate display of users" do
    # 1. check pagination controls are present
    # 2. Check that there are 30 users displayed (30 is default)
    log_in_as(@user)  # users index is protected so we need to be logged in
    get users_path
    assert_template 'users/index'  # make sure we are on the users index page
    assert_select 'div.pagination', count: 2 # check pagination links
    # check that users are present as expected
    User.paginate(page: 1).each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name
    end
  end
end

# Remember, when checking the links to user profiles in order to validate that
# users are displayed on the index as exepected, we are checking each link 
# points to the user_path not users_path. user_path is the named route helper
# for users#show, i.e. the user profile page. users_path is the named route to 
# users#index, the index page of all users. 
