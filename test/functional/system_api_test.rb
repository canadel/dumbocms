require File.dirname(__FILE__) + '/../test_helper'
require 'action_web_service/test_invoke'

class SystemApiTest < ActionController::TestCase
  include ActionWebService::TestInvoke::InstanceMethods
  
  def setup
    @controller = BackendController.new
    
    @account = FactoryGirl.create(:account, {
      :email => 'u',
      :password => 'p',
      :password_confirmation => 'p'
    })
    @domain = FactoryGirl.create(:domain)
    @page = FactoryGirl.create(:page, {
      :account => @account,
      :domain => @domain
    })
    @protocol = :xmlrpc
    
    @request.host = @page.preferred_domain.name
  end
  
  test("listMethods") do
    a = []
    ret = invoke_layered :system, :listMethods, *a
    assert ret.is_a?(Array)
    assert ret.any?
  end
end
