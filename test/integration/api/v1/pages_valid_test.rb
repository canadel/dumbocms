require File.dirname(__FILE__) + '/../../../test_helper'

class Api::V1::PagesValidTest < ActionDispatch::IntegrationTest

  def setup
    @page = FactoryGirl.create(:page)
    @account = @page.account
    @template = FactoryGirl.create(:template, :account => @account)
  end
  test('setup') do
    assert @account.api_key.present?
    assert_equal [ @page ], @account.pages
  end
  test('index') do
    # Fire the request.
    get '/api/v1/pages.json', {}, {
      'X-Auth-Key' => @account.api_key
    }
    
    assert_response :success
    assert_equal @account.pages.to_json, @response.body
  end
  test('show') do
    # Fire the request.
    get "/api/v1/pages/#{@page.id}.json", {}, {
      'X-Auth-Key' => @account.api_key
    }
    
    # Ensure HTTP 200.
    assert_response :success
    assert_equal @page.to_json, response.body
  end
  test('create') do
    # Fire the request.
    post '/api/v1/pages.json', {
      'page' => {
        'account_id' => @account.id,
        'name' => 'Maurycy',
        'title' => 'Hello, world!',
        'template_id' => @template.id,
        'description' => 'This is a nice page!',
        'indexable' => '0'
      }
    }, { 'X-Auth-Key' => @account.api_key }
    
    # Ensure new page.
    assert @account.pages.reload.any?
    assert_equal 2, @account.pages.size
    
    # Ensure correct page.
    page = @account.pages.first
    
    assert_equal 'Maurycy', page.name
    assert_equal 'Hello, world!', page.title
    assert_equal @template, page.template
    assert_equal 'This is a nice page!', page.description
    assert ! page.indexable?
    
    # Ensure HTTP 200.
    assert_response :success
    assert_equal page.to_json, @response.body
  end
  test('destroy') do
    # Fire the request.
    delete "/api/v1/pages/#{@page.id}.json", {}, {
      'X-Auth-Key' => @account.api_key
    }
    
    # Ensure no page.
    assert_nil Page.find_by_id(@page.id)
    
    # Ensure HTTP 200.
    assert_response :success
    assert_equal({}.to_json, response.body)
  end
end