require File.expand_path('../../test_helper', __FILE__)

class AdminTest < ActionDispatch::IntegrationTest

  def setup
    @account = create(:account, {
      :role => 'owner',
      :super_user => true,
      :email => "dumbo@dumbocms.com",
      :password => 'dupa123',
      :password_confirmation => 'dupa123'
    })
    
    @auth = ActionController::HttpAuthentication::Basic
    @enc = @auth.encode_credentials('dumbo@dumbocms.com', 'dupa123')
  end
  
  test('authorization') do
    get '/admin'
    assert_response :unauthorized
  end
  
  test('dashboard') do
    get('/admin', nil, 'HTTP_AUTHORIZATION' => @enc)
    assert_response :success
  end
  test('pages') do
    get('/admin/pages', nil, 'HTTP_AUTHORIZATION' => @enc)
    assert_response :success
  end
  test('documents') do
    get('/admin/documents', nil, 'HTTP_AUTHORIZATION' => @enc)
    assert_response :success
  end
  test('domains') do
    get('/admin/domains', nil, 'HTTP_AUTHORIZATION' => @enc)
    assert_response :success
  end
  test('accounts') do
    get('/admin/accounts', nil, 'HTTP_AUTHORIZATION' => @enc)
    assert_response :success
  end
  test('bulk imports') do
    get('/admin/bulk_imports', nil, 'HTTP_AUTHORIZATION' => @enc)
    assert_response :success
  end
  test('categories') do
    get('/admin/categories', nil, 'HTTP_AUTHORIZATION' => @enc)
    assert_response :success
  end
  
  test('create document') do
    params = { "model_name"=>"documents", "_save"=>"", "document" => {
      "slug"=>"abc123",
      "template_id"=>"",
      "title"=>"lara",
      "page_id"=>create(:page).id,
      "language"=>"",
      "category_id"=>"",
      "content"=>"abc123",
      "category_ids"=>[""],
      "path"=>"",
      "published_at"=>"September 14, 2011 07:32",
      "description"=>""
    }}

    post('/admin/documents', params, 'HTTP_AUTHORIZATION' => @enc)
    assert_response 302
  end
end