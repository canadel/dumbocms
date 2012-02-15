require File.expand_path('../../test_helper', __FILE__)

class RobotsTest < ActionDispatch::IntegrationTest

  def setup
    @domain = create(:domain)
    @page = @domain.page
    
    host!(@page.preferred_domain.name)
  end
  
  test("redirect_to") do
    @page.update_attributes(:redirect_to => 'http://onet.pl/')
    
    get('/')
    
    assert_response :redirect
    assert_redirected_to 'http://onet.pl/'
  end
  test("redirect_to hostname") do
    @page.update_attributes(:redirect_to => 'onet.pl')
    
    get('/')
    
    assert_response :redirect
    assert_redirected_to 'http://onet.pl/'
  end
end