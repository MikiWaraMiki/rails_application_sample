require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test 'micropost interface' do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    #無効な送信
    assert_no_difference "Micropost.count" do
      post microposts_path, params:{micropost:{content:""}}
    end

    assert_select 'div#error_explanation'
    #有効な送信
    content = "This is integration test post"
    assert_difference "Micropost.count", 1 do
      post microposts_path, params:{micropost:{content: content}}
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    #投稿記事を削除
    assert_select 'a', text:'delete'
    first_micropost = @user.microposts.paginate(page:1).first
    assert_difference "Micropost.count", -1 do
      delete micropost_path(first_micropost)
    end
  end

  test "micropost count sidevar" do
    log_in_as(@user)
    get root_path
    micrposts_count = @user.microposts.count 
    assert_match "#{micrposts_count} microposts" , response.body
    other_user = users(:malory)
    log_in_as(other_user)
    get root_path
    assert_match "0 microposts", response.body
    other_user.microposts.create!(content:"A micropost")
    get root_path
    assert_match "1 micropost", response.body
  end
end
