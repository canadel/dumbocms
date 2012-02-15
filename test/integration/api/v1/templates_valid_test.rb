require File.expand_path('../../../../test_helper', __FILE__)

class Api::V1::TemplatesValidTest < ActionDispatch::IntegrationTest

  def setup
    @account = create(:account)
    @template = create(:template, {
      :account => @account
    })
  end
  test('setup') do
    assert @account.api_key.present?
    assert_equal @account, @template.account
    assert_equal [ @template ], @account.templates.reload
  end
  test('index') do
    # Fire the request.
    get '/api/v1/templates.json', {}, {
      'X-Auth-Key' => @account.api_key
    }
    
    # Ensure HTTP 200.
    assert_response :success
    assert_equal [ @template ].to_json, @response.body
  end
  test('create') do
    # Fire the request.
    post '/api/v1/templates.json', {
      'template' => {
        'name' => 'an example',
        'content' => 'poof',
        'account_id' => @account.id
      }
    }, { 'X-Auth-Key' => @account.api_key }
    
    # Ensure new template.
    assert @account.templates.reload.any?
    assert_equal 2, @account.templates.size

    # Ensure correct template.
    template = @account.templates.last

    assert_equal @account, template.account
    assert_equal 'poof', template.content
    assert_equal 'an example', template.name
    
    # Ensure HTTP 200.
    assert_response :success
    assert_equal template.to_json, @response.body
  end
  test('update') do
    # Fire the request.
    put "/api/v1/templates/#{@template.id}.json", {
      'template' => {
        'name' => 'Steve Jobs',
        'content' => 'why not?',
        'account_id' => @account.id
      }
    }, { 'X-Auth-Key' => @account.api_key }
    
    # Ensure no new template.
    assert @account.templates.reload.any?
    assert_equal 1, @account.templates.size
    
    # Ensure updated template.
    @template.reload
    
    assert_equal @account, @template.account
    assert_equal 'why not?', @template.content
    assert_equal 'Steve Jobs', @template.name
    
    # Ensure HTTP 200.
    assert_response :success
    assert_equal({}.to_json, @response.body)
  end
  test('show') do
    # Fire the request.
    get "/api/v1/templates/#{@template.id}.json", {}, {
      'X-Auth-Key' => @account.api_key
    }
    
    # Ensure HTTP 200.
    assert_response :success
    assert_equal @template.to_json, response.body
  end
end