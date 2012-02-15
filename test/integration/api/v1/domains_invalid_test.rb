require File.expand_path('../../../../test_helper', __FILE__)

class Api::V1::DomainsInvalidTest < ActionDispatch::IntegrationTest

  def setup
    @page = create(:page)
    @account = @page.account
  end
  test('setup') do
    assert @page.domains.empty?
    assert_not_nil @account.api_key
  end
  test("index empty?") do
    get('/api/v1/domains.json', {}, { 'X-Auth-Key' => @account.api_key })
    
    assert_response :success
    assert_equal [].to_json, @response.body
  end
  test('create') do
    # Ensure HTTP 422.
    post '/api/v1/domains.json', {
      'domain' => { 'page_id' => @page.id }
    }, { 'X-Auth-Key' => @account.api_key }
    
    dm = Domain.new(:page_id => @page.id)

    assert dm.invalid?
    assert_response :unprocessable_entity
    assert_equal dm.errors.to_json, @response.body
    
    # Ensure no domain created.
    assert @page.domains.reload.empty?
  end
end