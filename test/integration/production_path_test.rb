require File.expand_path('../../test_helper', __FILE__)

class ProductionPathTest < ActionDispatch::IntegrationTest

  # TODO other than frontpage
  # TODO normalization (301, how to handle errors and such?)
  
  def setup
    Rails.configuration.dumbocms.production = true

    # Set up a liberal template.
    @template = create(:template, {
      :content => '{{ document.content }}'
    })
    
    # Set up a page with a single domain, and few documents.
    @single_page = create(:page, {
      :template => @template
    })
    @single_domain = create(:domain, :page => @single_page)
    @single_page.documents = create_list(:document, 3, {
      :page => @single_page,
      :content => SecureRandom.hex(16)
    })
    @single_frontpage = create(:document, {
      :page => @single_page.reload,
      :slug => 'frontpage',
      :content => SecureRandom.hex(16)
    })
    
    # TODO required?
    @single_page.reload
    @single_page.save
    
    # Set up a page with many domains, and few documents.
    @many_page = create(:page, {
      :template => @template
    })
    @many_domain = create(:domain, :page => @many_page)
    @many_page.domains = create_list(:domain, 3, {
      :page => @many_page
    })
    @many_page.documents = create_list(:document, 3, {
      :page => @many_page,
      :content => SecureRandom.hex(16)
    })
    @many_frontpage = create(:document, {
      :page => @many_page.reload,
      :slug => 'frontpage',
      :content => SecureRandom.hex(16)
    })

    # TODO required?
    @many_page.reload
    @many_page.save
  end
  
  test("single setup") do
    assert @single_page.domains.any?
    assert_equal 1, @single_page.domains.size
    assert_equal @single_domain, @single_page.preferred_domain
  end
  
  test("many setup") do
    assert @many_page.domains.any?
    assert_equal 3, @many_page.domains.size
    # TODO: assert_equal @many_domain, @many_page.preferred_domain
  end
  
  test("single preferred frontpage one") do
    host!(@single_page.preferred_domain.name)
    
    get '/'
    assert_response :success
    assert_equal @single_frontpage.content, @response.body
    assert_equal @single_frontpage, assigns(:document)
  end
  test("single preferred frontpage two") do
    host!(@single_page.preferred_domain.name)
    
    get '//'
    assert_response :success
    assert_equal @single_frontpage.content, @response.body
    assert_equal @single_frontpage, assigns(:document)
  end
  test("single preferred frontpage three") do
    host!(@single_page.preferred_domain.name)
    
    get '///'
    assert_response :success
    assert_equal @single_frontpage.content, @response.body
    assert_equal @single_frontpage, assigns(:document)
  end
  
  
  test("many preferred frontpage one") do
    host!(@many_page.preferred_domain.name)
    
    get '/'
    assert_response :success
    assert_equal @many_frontpage.content, @response.body
    assert_equal @many_frontpage, assigns(:document)
  end
  test("many preferred frontpage two") do
    host!(@many_page.preferred_domain.name)
    
    get '//'
    assert_response :success
    assert_equal @many_frontpage.content, @response.body
    assert_equal @many_frontpage, assigns(:document)
  end
  test("many preferred frontpage three") do
    host!(@many_page.preferred_domain.name)
    
    get '///'
    assert_response :success
    assert_equal @many_frontpage.content, @response.body
    assert_equal @many_frontpage, assigns(:document)
  end
  
  test("many custom frontpage one") do
    host!(@many_page.domains.last.name)
    
    get '/'
    assert_response :redirect
    follow_redirect!
    
    assert_response :success
    assert_equal @many_frontpage.content, @response.body
    assert_equal @many_frontpage, assigns(:document)
  end
  test("many custom frontpage two") do
    host!(@many_page.domains.last.name)
    
    get '//'
    assert_response :redirect
    follow_redirect!
    
    assert_response :success
    assert_equal @many_frontpage.content, @response.body
    assert_equal @many_frontpage, assigns(:document)
  end
  test("many custom frontpage three") do
    host!(@many_page.domains.last.name)
    
    get '///'
    assert_response :redirect
    follow_redirect!
    
    assert_response :success
    assert_equal @many_frontpage.content, @response.body
    assert_equal @many_frontpage, assigns(:document)
  end
end