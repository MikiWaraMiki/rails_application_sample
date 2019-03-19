require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    @post = @user.microposts.create(content:"TEST CONETENT")
  end

  test "should be valid" do
    assert @post.valid?
  end

  test "user id should be present" do
    @post.user_id = nil
    assert_not @post.valid?
  end

  test "content should be inputed" do
    @post.content = nil
    assert_not @post.valid?
  end

  test "content should be at most 140 charcters" do
    @post.content = "a" * 141
    assert_not @post.valid?
  end
end
