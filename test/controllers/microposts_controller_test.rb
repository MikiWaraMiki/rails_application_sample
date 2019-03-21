require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @micropost = microposts(:orange)
  end

  test 'should redirect create when user not logged in' do
    assert_no_difference 'Micropost.count' do
      post microposts_path,params:{micropost:{content:"Login ipnum"}}
    end
    assert_redirected_to login_url
  end

  test 'should redirect destory when user not logged in' do
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_redirected_to login_url
  end
end
