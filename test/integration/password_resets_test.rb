require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
  end

  test "password reset" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    #メールアドレスが無効の時はメールが送信されない
    post password_resets_path, params:{
      password_reset:{email:""}
    }
    assert_not flash.empty?
    assert_template "password_resets/new"

    #メールアドレスが有効の場合
    post password_resets_path, params:{
      password_reset:{email:@user.email}
    }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    #パスワード再設定のフォーム検証
    user = assigns(:user)
    get edit_password_reset_path(user.reset_token, email:"")
    assert_redirected_to root_url
    #無効なユーザ
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email:user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)
    #メールアドレスが有効で、トークンが無効
    get edit_password_reset_path("Wrong token", email:user.email)
    assert_redirected_to root_url
    #メールアドレス、トークンが共に有効
    get edit_password_reset_path(user.reset_token, email:user.email)
    assert_template "password_resets/edit"
    assert_select "input[name=email][type=hidden][value=?]", user.email
    #無効なパスワードとパスワード確認
    patch password_reset_path(params:{
      email: user.email,
      user:{
        password: "fooba",
        password_confirmation: "fooooooo"
      }
    })
    assert_select "div#error_explanation"
    #パスワードが空
    patch password_reset_path(params:{
      email: user.email,
      user:{
        password:"",
        password_confirmation: "",
      }
    })
    assert_select "div#error_explanation"

    #有効なパスワード
    patch password_reset_path(params:{
      email: user.email,
      user:{
        password: "password",
        password_confirmation: "password"
      }
    })
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end

  test "expired token" do
    get new_password_reset_path
    post password_resets_path, params:{
      pass
      word_reset:{email: @user.email}
    }
    @user = assigns(:user)
    @user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(@user.reset_token),
      params:{
        email:@user.email,
        user:{
          password:"password",
          password_confirmation:"password"
        }
      }
      assert_response :redirect
      follow_redirect!
      assert_match /expired*/i, responce.body
  end
end
