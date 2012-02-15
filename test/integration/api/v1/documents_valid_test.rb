require File.dirname(__FILE__) + '/../../../test_helper'

class Api::V1::DocumentsValidTest < ActionDispatch::IntegrationTest

  def setup
    @document = FactoryGirl.create(:document)
    @page = @document.page
    @account = @page.account
  end
  
  test('setup') do
    assert @account.api_key.present?
  end
  test('index') do
    get "/api/v1/pages/#{@page.id}/documents.json", {}, auth_key
    
    assert_response :success
    assert_equal @page.documents.to_json, response.body
  end
  test('show') do
    get("/api/v1/pages/#{@page.id}/documents/#{@document.id}.json",
      {},
      auth_key
    )
    
    assert_response :success
    assert_equal @document.to_json, response.body
  end
  test('destroy') do
    delete("/api/v1/pages/#{@page.id}/documents/#{@document.id}.json",
      {},
      auth_key
    )
    
    assert_response :success
    assert_equal({}.to_json, response.body)
    
    assert_nil Document.find_by_id(@document.id)
  end
  test('update') do
    params = ({}).tap do |ret|
      ret['document'] = {
        'content' => 'Boards of Canada'
      }
    end
    
    put("/api/v1/pages/#{@page.id}/documents/#{@document.id}.json",
      params,
      auth_key
    )
    
    assert_response :success
    assert_equal({}.to_json, response.body)
    
    assert_equal 'Boards of Canada', @document.reload.content
  end
  test('create') do
    params = ({}).tap do |ret|
      ret['document'] = {
        'page_id' => @page.id,
        'title' => 'Music is Math',
        'content' => 'Boards of Canada'
      }
    end
    
    post("/api/v1/pages/#{@page.id}/documents.json", params, auth_key)
    
    doc = @page.documents.reload.first
    assert_equal 'Music is Math', doc.title
    assert_equal 'Boards of Canada', doc.content
    
    assert_response :success
    assert_equal doc.to_json, response.body
  end

  protected
    def auth_key
      { 'X-Auth-Key' => @account.api_key }
    end
end