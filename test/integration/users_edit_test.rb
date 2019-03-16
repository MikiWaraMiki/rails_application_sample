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
        password_confirmation: "foo",
      }
    }
    assert_template "users/edit"
  end
end
