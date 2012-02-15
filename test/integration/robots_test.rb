require File.expand_path('../../test_helper', __FILE__)

class RobotsTest < ActionDispatch::IntegrationTest

  def setup
    @domain = create(:domain)
    @page = @domain.page
    
    host!(@page.preferred_domain.name)
  end
  
  test("setup") do
    assert ! @page.nil?
    assert   @page.robots_txt.present?
  end

  test("set") do
    get '/robots.txt'
    assert_response :success
    assert_equal @page.robots_txt, @response.body
  end
  
  test("empty") do
    @page.update_attribute(:robots_txt, '')
    
    get '/robots.txt'
    assert_response :not_found, @response.body
    assert_equal 'Not Found', @response.body
  end
  
  test("unknown") do
    host!('crap.pl')
    
    get '/robots.txt'
    assert_response :not_found, @response.body
    assert_equal 'Not Found', @response.body
  end
end