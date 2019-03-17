require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
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
    follow_redirect!
    #assert_template 'users/show'
    #assert flash[:success]
    #assert is_logged_in?
  end
end
