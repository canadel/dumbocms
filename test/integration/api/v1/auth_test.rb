require File.expand_path('../../../../test_helper', __FILE__)

class Api::V1::AuthTest < ActionDispatch::IntegrationTest
  
  test('pages') do
    get '/api/v1/pages.json', {}
    assert_response :forbidden
  end
  test('domains') do
    get '/api/v1/domains.json', {}
    assert_response :forbidden
  end
  test('templates') do
    get '/api/v1/templates.json', {}
    assert_response :forbidden
  end
end