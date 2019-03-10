require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name:"test_sample", email:"user@exsample.com")
  end

  test "should be vaild" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = ""
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "    "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "b"*101
    assert_not @user.valid?
  end

  test "email validation should be accept email valid" do
    valid_emails = %w[user@sample.com User@sample.COM A_US-ER.foo.org first.last@sample.com alice+bob@baz.cn]
    valid_emails.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address} should be validation"
    end
  end

end
