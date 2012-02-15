require File.dirname(__FILE__) + '/../test_helper'

class RssControllerTest < ActionController::TestCase
  
  def setup
    @page = FactoryGirl.create(:page)
    @domain = FactoryGirl.create(:domain, { :page => @page })
    @document = FactoryGirl.create(:document, { :page => @page })
  end
  
  test("index") do
    @request.host = @page.preferred_domain.name
    
    get :index, :format => 'rss'
    assert_response :success
  end
end
