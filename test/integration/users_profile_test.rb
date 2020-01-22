require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper
  
  def setup 
    @user = users(:Bill)
  end
  
  test "profile to display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    # assert_match @user.microposts.count.to_s, response.body
    #puts "response.body -> #{response.body}"
    puts "@user.microposts.count.to_s -> #{@user.microposts.count.to_s}"
    assert_select 'div.pagination', count: 1
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end
  
  test "profile stats on home page" do
    log_in_as @user
    get root_path
    assert_template 'static_pages/home'
    assert_select 'div.stats', count: 1
    assert_match @user.following.count.to_s, response.body
    assert_match @user.followers.count.to_s, response.body
  end
end
