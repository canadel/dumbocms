require File.expand_path('../../test_helper', __FILE__)
require 'action_web_service/test_invoke'

class SystemApiTest < ActionController::TestCase
  include ActionWebService::TestInvoke::InstanceMethods
  
  def setup
    @controller = BackendController.new
    
    @account = create(:account, {
      :email => 'u',
      :password => 'p',
      :password_confirmation => 'p'
    })
    @domain = create(:domain)
    @page = create(:page, {
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
