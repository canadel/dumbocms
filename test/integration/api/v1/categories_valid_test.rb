require File.dirname(__FILE__) + '/../../../test_helper'

class Api::V1::CategoriesValidTest < ActionDispatch::IntegrationTest
  
  def setup
    @account = FactoryGirl.create(:account)
    @page = FactoryGirl.create(:page, {
      :account => @account
    })
    @category = FactoryGirl.create(:category, {
      :page => @page
    })
  end
  test('setup') do
    assert @account.api_key.present?
    assert_equal [ @category ], @page.categories.reload
  end
  test('index') do
    # Fire the request.
    get "/api/v1/pages/#{@page.id}/categories.json", {}, {
      'X-Auth-Key' => @account.api_key
    }
    
    # Ensure HTTP 200.
    assert_response :success
    assert_equal [ @category ].to_json, @response.body
  end
  test('show') do
    # Fire the request.
    get "/api/v1/pages/#{@page.id}/categories/#{@category.id}.json", {}, {
      'X-Auth-Key' => @account.api_key
    }
    
    # Ensure HTTP 200.
    assert_response :success
    assert_equal @category.to_json, @response.body
  end
  test('update') do
    # Fire the request.
    put "/api/v1/pages/#{@page.id}/categories/#{@category.id}.json", {
      'category' => {
        'name' => '37signals'
      }
    }, { 'X-Auth-Key' => @account.api_key }
    
    # Ensure HTTP 200.
    assert_response :success
    assert_equal({}.to_json, @response.body)
    
    # Ensure correct category.
    category = @page.categories.reload.first

    assert_equal @page, category.page
    assert_equal @category.id, category.id
    
    assert category.slug.present?
    assert_equal '37signals', category.name
  end
  test('create') do
    # Fire the request.
    post "/api/v1/pages/#{@page.id}/categories.json", {
      'category' => {
        'name' => 'an example'
      }
    }, { 'X-Auth-Key' => @account.api_key }
    
    # Ensure new category.
    assert @page.categories.reload.any?
    assert_equal 2, @page.categories.size

    # Ensure correct category.
    category = @page.categories.first

    assert_equal @page, category.page
    assert_equal 'an example', category.name
    assert_equal 'an-example', category.slug
    
    # Ensure HTTP 200.
    assert_response :success
    assert_equal category.to_json, @response.body
  end
  test('destroy') do
    # Fire the request.
    delete "/api/v1/pages/#{@page.id}/categories/#{@category.id}.json", {}, {
      'X-Auth-Key' => @account.api_key
    }
    
    # Ensure no category.
    assert @page.categories.reload.empty?
    assert_nil Category.find_by_id(@category.id)
    
    # Ensure HTTP 200.
    assert_response :success
    assert_equal({}.to_json, @response.body)
  end
end