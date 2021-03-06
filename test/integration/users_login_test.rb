require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "login with invalid infromation" do
    #loginページへ遷移
    get login_path
    #テンプレートが正しいことを検証
    assert_template "sessions/new"
    post login_path, params:{
      session:{
        email:"sampel.com",
        password:""
      }
    }
    assert_template "sessions/new"
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information" do
    puts(@user)
    get login_path
    post login_path, params:{
      session:{
        email: @user.email,
        password:'password',
      }
    }
    assert_redirected_to @user
    follow_redirect!

    assert_template "users/show"
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', user_path(@user)
  end

  test "login with valid information and followed logout" do
    get login_path
    post login_path, params:{
      session:{
        email: @user.email,
        password: "password",
      }
    }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!

    assert_template "users/show"
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', user_path(@user)

    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', logout_path, count:0
    assert_select 'a[href=?]', user_path(@user), count:0
  end

  test 'login_with_remembering' do
    log_in_as(@user, remember_me: '1')
    assert_equal cookies['remember_token'], assigns(:user).remember_token
  end
  
  test 'login_without_remembergin' do
    log_in_as(@user, remember_me: '1')
    assert_not_empty cookies['remember_token']
    delete logout_path
    
    log_in_as(@user, remember_me: '0')
    assert_empty cookies['remember_token']
  end

  test 'current_user returns right user when session is nil' do
    assert_equal @user, current_user
    assert is_logged_in?
  end

  test 'current_user returns nil when remember digest is wrong' do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end

end
