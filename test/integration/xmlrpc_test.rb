require 'test_helper'

class XmlrpcTest < ActionDispatch::IntegrationTest

  def setup
    @domain = FactoryGirl.create(:domain)
    @page = @domain.page
    
    host!(@page.preferred_domain.name)
  end

  test("xmlrpc php") do
    post '/xmlrpc.php'
    assert_response 500
    assert response.body =~ /Internal protocol error/
  end
  test("wordpress xmlrpc php") do
    post '/wordpress/xmlrpc.php'
    assert_response 500
    assert response.body =~ /Internal protocol error/
  end
  test("wp xmlrpc php") do
    post '/wp/xmlrpc.php'
    assert_response 500
    assert response.body =~ /Internal protocol error/
  end
end