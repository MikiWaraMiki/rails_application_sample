require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @other_user= users(:michael)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

 

  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params:{
      user:{
        password: "password",
        password_confirmation: "password",
        admin: true,
      }
    }
    assert_not @other_user.reload.admin?
  end

  test "should redirect when destory without login" do
    assert_no_difference "User.count" do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test "should redirect when destory unlenn admin user" do
    log_in_as(@other_user)
    assert_no_difference "User.count" do
      delete user_path(@user)
    end
    assert_redirected_to login_path
  end
end
