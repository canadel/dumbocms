require File.expand_path('../../test_helper', __FILE__)

class AtomControllerTest < ActionController::TestCase
  
  def setup
    @page = create(:page)
    @domain = create(:domain, { :page => @page })
    @document = create(:document, { :page => @page })
  end
  
  test("index") do
    @request.host = @page.preferred_domain.name
    
    get :index, :format => 'atom'
    assert_response :success
  end
end
