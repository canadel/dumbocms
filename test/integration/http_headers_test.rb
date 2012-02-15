require File.expand_path('../../test_helper', __FILE__)

class HttpHeadersTest < ActionDispatch::IntegrationTest

  test("development noindex") do
    dom = create(:domain, :name => 'a.pl')
    
    host!(Rails.configuration.dumbocms.hostname)
    get "/a.pl/"
    
    assert_response :success
    assert_equal 'noindex', headers['X-Robots-Tag']
  end
  
  test("production index") do
    dom = create(:domain, :name => 'a.pl')
    
    host!('a.pl')
    get "/"
    
    assert_response :success
    assert headers['X-Robots-Tag'].nil?
  end
  
  test("production noindex") do
    dom = create(:domain, :name => 'a.pl')
    dom.page.update_attribute(:indexable, false)
    dom.page.reload
    assert dom.page.noindex?
    
    host!('a.pl')
    get "/"
    
    assert_response :success
    assert_equal 'noindex', headers['X-Robots-Tag']
  end
end