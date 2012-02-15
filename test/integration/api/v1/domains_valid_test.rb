require File.dirname(__FILE__) + '/../../../test_helper'

class Api::V1::DomainsValidTest < ActionDispatch::IntegrationTest
  def setup
    @domain = FactoryGirl.create(:domain)
    @page = @domain.page
    @account = @page.account
  end
  
  test('setup') do
    assert @page.domains.any?
    assert_equal 1, @page.domains.size
    assert_equal [ @domain ], @page.domains
    assert_not_nil @account.api_key
  end
  
  test("index") do
    # Ensure that it returns domains.
    get('/api/v1/domains.json', {}, { 'X-Auth-Key' => @account.api_key })
    
    assert_response :success
    assert_equal @page.domains.to_json, @response.body
  end
  
  test('create') do
    # Ensure that it returns success.
    post '/api/v1/domains.json', {
      'domain' => {
        'page_id' => @page.id,
        'wildcard' => 'false',
        'name' => 'tanieloty.pl'
      }
    }, { 'X-Auth-Key' => @account.api_key }
    
    assert_response :success
    
    # Ensure new domain.
    assert_equal 2, @page.domains.size
    
    # Ensure correct domain.
    dm = @page.domains.last
    
    assert ! dm.wildcard?
    assert_equal @page, dm.page
    assert_equal 'tanieloty.pl', dm.name
    
    # Ensure correct response body.
    assert_equal dm.to_json, @response.body
  end
  
  test('destroy valid') do
    # Ensure that it returns success.
    delete "/api/v1/domains/#{@domain.id}.json", {}, {
      'X-Auth-Key' => @account.api_key
    }
    
    assert_response :success
    assert_equal({}.to_json, @response.body)
    
    # Ensure that the domain is gone.
    assert @page.domains.reload.empty?
    assert_nil Domain.find_by_id(@domain.id)
  end
  
  test('show valid') do
    get("/api/v1/domains/#{@domain.id}.json", {}, {
      'X-Auth-Key' => @account.api_key
    })
    
    assert_response :success
    assert_equal @domain.to_json, @response.body
  end
  
  test('update valid') do
    put("/api/v1/domains/#{@domain.id}.json", {
      'domain' => {
        'page_id' => @page.id,
        'wildcard' => 'false',
        'name' => 'tanieloty.pl'
      }
    }, {
      'X-Auth-Key' => @account.api_key
    })
    
    # Ensure that it returns success.
    assert_response :success
    assert_equal({}.to_json, @response.body)

    # Ensure no new domain.
    assert_equal 1, @page.domains.size
    
    # Ensure correct update.
    @domain.reload
    
    assert ! @domain.wildcard?
    assert_equal @page, @domain.page
    assert_equal 'tanieloty.pl', @domain.name
  end
end