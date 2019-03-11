require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  
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
end
