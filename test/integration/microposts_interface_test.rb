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
    assert_difference "Micopost.count" do
      post microposts_path, params:{micropost:{contents:""}}
    end

    assert_select 'div#error_explanation'
    #有効な送信
    content = "This is integration test post"
    assert_difference "Micropost.count", 1 do
      post microposts_path, params:{micropost:{contents: content}}
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    #投稿記事を削除
    assert_select 'a', text:'delete'
    first_micropost = @user.micropost.paginate(page:1).first
    assert_difference "Micropost.count", -1 do
      delete micropost_path(first_micropost)
    end
  end
end
