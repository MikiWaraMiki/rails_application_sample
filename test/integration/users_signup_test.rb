require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params:{
        user:{
          name:                  "",
          email:                 "user@invalid.com",
          password:              "sample",
          password_confirmation: "sample_sample"
        }
      }
    end
    assert_template 'users/new'
    assert_select "div#error_explanation"
    assert_select "div.alert"
    assert_select 'form[action="/signup"]' 
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params:{
        user:{
          name:                  "test_user",
          email:                 "test@test.com",
          password:              "testsample",
          password_confirmation: "testsample"
        }
      }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    #有効化されていないUserのログインを禁止している
    log_in_as(user)
    assert_not is_logged_in?
    #トークンが不正な場合
    get edit_activation_path("Invalid token", email:user.email)
    assert_not is_logged_in?
    #トークンは正しいがアドレスが違う
    get edit_activation_path(user.activation_token, email:"Wrong")
    assert_not is_logged_in?
    #正しいトークンとアドレスが入力されたログイン可能
    get edit_activation_path(user.activation_token, email:user.email)
    assert user.reload.acativated?
    follow_redirect!
    assert_template 'users/show'
    assert flash[:success]
    assert is_logged_in?
  end
end
