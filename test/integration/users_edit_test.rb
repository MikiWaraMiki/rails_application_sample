require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "unsuccessfull user update" do
    get edit_user_path(@user)
    assert_template "users/edit"

    patch user_path(@user), params:{
      user:{
        name:"",
        email:"valid@exsample.com",
        password:"foo",
        password_confirmation: "bar",
      }
    }
    assert_template "users/edit"
    assert_select "div.alert", "The form contains 3 errors"
  end

  test "succsessful user update" do
    get edit_user_path(@user)
    assert_template "users/edit"
    name  = "Update"
    email = "Update@exsample.com" 

    patch user_path(@user), params:{
      user:{
        name:                  name,
        email:                 email,
        password:              "",
        password_confirmation: ""
      }
    }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end
end
