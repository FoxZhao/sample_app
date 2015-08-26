require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
  	@user = users(:michael)
  end

  test "unsuccessful edit" do
  	log_in_as(@user)
  	get edit_user_path(@user)
  	patch user_path(@user), user: {
  		name: '',
  		email: 'foo@invalid',
  		password: 'foo',
  		password_confirmation: 'bar'
  	}
  	assert_template 'users/edit'
  	# assert_nil @user.errors.full_messages
  end

  test "successful edit with friendly forwarding" do
  	get edit_user_path(@user)
  	log_in_as(@user)
  	puts session[:forwarding_url]
  	assert_redirected_to edit_user_path(@user)
  	# 第二次登录，重定向应该指向user个人信息
  	log_in_as(@user)
  	assert_nil session[:forwarding_url]
  	assert_redirected_to user_path(@user)
  	
  	name = "Foo Bar"
  	email = "foo@bar.com"
  	patch user_path(@user), user: {
  		name: name,
  		email: email,
  		password: "",
  		password_confirmation: ""
  	}
  	
  	assert_redirected_to @user, "should go to show the updated user"
  	assert_not flash.empty?, "should have flash"
  	@user.reload #从数据库重新取出user，以方便后续比较是否更新成功
  	assert_equal @user.name, name, "name should be updated"
  	assert_equal @user.email, email, "email should be updated"
  end
end
