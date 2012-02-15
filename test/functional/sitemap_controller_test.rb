require File.dirname(__FILE__) + '/../test_helper'

class SitemapControllerTest < ActionController::TestCase
  
  def setup
    @page = FactoryGirl.create(:page)
    @domain = FactoryGirl.create(:domain, { :page => @page })
    @document = FactoryGirl.create(:document, { :page => @page })
  end
  
  test("index") do
    @request.host = @page.preferred_domain.name
    
    get :index, :format => 'xml'
    assert_response :success
  end
  test("unknown") do
    @request.host = 'crap.pl'

    get :index, :format => "xml"
    assert_response 404
  end
end
