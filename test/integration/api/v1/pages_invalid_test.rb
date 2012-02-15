require File.dirname(__FILE__) + '/../../../test_helper'

class Api::V1::PagesInvalidTest < ActionDispatch::IntegrationTest

  def setup
    @account = FactoryGirl.create(:account)
  end

  test('setup') do
    assert @account.pages.empty?
    assert_not_nil @account.api_key
  end

  test("index") do
    # Ensure that it returns no pages back.
    get '/api/v1/pages.json', {}, {
      'X-Auth-Key' => @account.api_key
    }
    
    assert_response :success
    assert_equal [].to_json, @response.body
  end
  
  test('create') do
    # Ensure that it returns success.
    params = { 'page' => {} }
    headers = { 'X-Auth-Key' => @account.api_key }
    
    post('/api/v1/pages.json', params, headers)
    
    pg = Page.new
    pg.valid?
    
    assert_response :unprocessable_entity
    assert_equal pg.errors.to_json, @response.body
    
    # Ensure no domain created.
    assert pg.domains.reload.empty?
  end
end