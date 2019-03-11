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
    assert_select "div#<CSS id for error information>"
    assert_select "div.<CSS class for field with error>"
  end
end
