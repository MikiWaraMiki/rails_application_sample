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
end
