require File.expand_path('../../test_helper', __FILE__)

class RssControllerTest < ActionController::TestCase
  
  def setup
    @page = create(:page)
    @domain = create(:domain, { :page => @page })
    @document = create(:document, { :page => @page })
  end
  
  test("index") do
    @request.host = @page.preferred_domain.name
    
    get :index, :format => 'rss'
    assert_response :success
  end
end
