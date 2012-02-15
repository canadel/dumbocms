require File.expand_path('../../test_helper', __FILE__)

class RsdControllerTest < ActionController::TestCase

  def setup
    @page = create(:page)
    @domain = create(:domain, { :page => @page })
    @document = create(:document, { :page => @page })
  end
  
  test("index") do
    @request.host = @page.preferred_domain.name
    
    get :index, :format => "xml"
    assert_response :success
  end
  test("unknown") do
    @request.host = 'crap.pl'
    
    get :index, :format => "xml"
    assert_response 404
  end
end
