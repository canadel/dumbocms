require 'test_helper'

class DispatchTest < ActionDispatch::IntegrationTest

  # TODO setup
  
  test("production frontpage preferred document_template") do
    Rails.configuration.dumbocms.production = true
    
    # Set up fixtures.
    domain = FactoryGirl.create(:domain)
    domain.update_attribute(:name, 'tanieloty.pl')
    
    page = domain.page
    page.update_attribute(:permalinks, '/%category%/%slug%')
    
    template = page.template
    template.update_attribute(:content, '{{ document.id }}')
    
    document = FactoryGirl.create(:document, {
      :page => page,
      :slug => 'frontpage'
    })
    
    # Check fixtures.
    assert domain.preferred?
    assert_equal domain, page.preferred_domain
    assert_equal document.external_id.to_s, document.render_fresh.first

    # Ensure that a production page with one document template renders the
    # frontpage document correctly.
    host!('tanieloty.pl')
    get "/"
    
    assert_response :success
    assert_equal document.external_id.to_s, @response.body
    
    # Check class variables.
    assert_equal domain, assigns(:domain)
    assert_equal '/', assigns(:path)
    assert_equal page, assigns(:page)
    assert_equal document, assigns(:document)
  end
  
  test("production custom preferred document_template") do
    Rails.configuration.dumbocms.production = true
    
    # Set up fixtures.
    domain = FactoryGirl.create(:domain)
    domain.update_attribute(:name, 'tanieloty.pl')
    
    page = domain.page
    page.update_attribute(:permalinks, '/%category%/%slug%')
    
    template = page.template
    template.update_attribute(:content, '{{ document.id }}')
    
    document = FactoryGirl.create(:document, {
      :page => page
    })
    
    # Check fixtures.
    assert domain.preferred?
    assert_equal domain, page.preferred_domain
    assert_equal document.external_id.to_s, document.render_fresh.first

    # Ensure that a production page with one document template renders the
    # frontpage document correctly.
    host!('tanieloty.pl')
    get "/#{document.slug}"
    
    assert_response :success
    assert_equal document.external_id.to_s, @response.body
    
    # Check class variables.
    assert_equal domain, assigns(:domain)
    assert_equal "/#{document.slug}", assigns(:path)
    assert_equal page, assigns(:page)
    assert_equal document, assigns(:document)
  end
  
  test("production custom preferred custom_template") do
    Rails.configuration.dumbocms.production = true
    
    # Set up fixtures.
    domain = FactoryGirl.create(:domain)
    domain.update_attribute(:name, 'tanieloty.pl')
    
    page = domain.page
    page.update_attribute(:permalinks, '/%category%/%slug%')
    
    document_template = page.template
    document_template.update_attribute(:content, '{{ document.id }}')
    
    template = FactoryGirl.create(:template, {
      :content => '{{ document.content }}'
    })
    
    document = FactoryGirl.create(:document, {
      :page => page,
      :content => 'hello, world',
      :template => template
    })
    
    # Check fixtures.
    assert domain.preferred?
    assert_equal domain, page.preferred_domain
    assert_equal "hello, world", document.render_fresh.first

    # Ensure that a production page with one document template renders the
    # frontpage document correctly.
    host!('tanieloty.pl')
    get "/#{document.slug}"
    
    assert_response :success
    assert_equal "hello, world", @response.body
    
    # Check class variables.
    assert_equal domain, assigns(:domain)
    assert_equal "/#{document.slug}", assigns(:path)
    assert_equal page, assigns(:page)
    assert_equal document, assigns(:document)
  end
  
  test("production custom domain document_template") do
    Rails.configuration.dumbocms.production = true
    
    # Set up fixtures.
    page = FactoryGirl.create(:page)
    
    domain = FactoryGirl.create(:domain, { :page => page,
      :name => 'tanieloty.pl',
    })
    another_domain = FactoryGirl.create(:domain, { :page => page,
      :name => 'www.tanieloty.pl'
    })

    page.reload # TODO required?
    page.update_attribute(:domain, domain)
    
    template = page.template
    template.update_attribute(:content, '{{ document.id }}')
    
    document = FactoryGirl.create(:document, {
      :page => page
    })
    
    # Check fixtures.
    assert   domain.preferred?
    assert ! another_domain.preferred? 
    assert_equal domain, page.preferred_domain
    assert_equal document.external_id.to_s, document.render_fresh.first

    # Ensure that a production page with one document template renders the
    # frontpage document correctly.
    host!('www.tanieloty.pl')
    
    get "/#{document.slug}"
    assert_response :redirect
    assert_redirected_to "http://tanieloty.pl/#{document.slug}"
    
    follow_redirect!
    assert_response :success
    assert_equal document.external_id.to_s, @response.body
    
    # Check class variables.
    assert_equal domain, assigns(:domain)
    assert_equal "/#{document.slug}", assigns(:path)
    assert_equal page, assigns(:page)
    assert_equal document, assigns(:document)
  end
  
  test("production custom domain custom_template") do
    Rails.configuration.dumbocms.production = true
    
    # Set up fixtures.
    page = FactoryGirl.create(:page)
    
    domain = FactoryGirl.create(:domain, { :page => page,
      :name => 'tanieloty.pl',
    })
    another_domain = FactoryGirl.create(:domain, { :page => page,
      :name => 'www.tanieloty.pl'
    })

    page.reload # TODO required?
    page.update_attribute(:domain, domain)
    
    template = FactoryGirl.create(:template, {
      :content => '{{ document.content }}'
    })
    
    document = FactoryGirl.create(:document, {
      :page => page,
      :content => 'y',
      :template => template
    })
    
    # Check fixtures.
    assert   domain.preferred?
    assert ! another_domain.preferred? 
    assert_equal domain, page.preferred_domain
    assert_equal 'y', document.render_fresh.first

    # Ensure that a production page with one document template renders the
    # frontpage document correctly.
    host!('www.tanieloty.pl')
    
    get "/#{document.slug}"
    assert_response :redirect
    assert_redirected_to "http://tanieloty.pl/#{document.slug}"
    
    follow_redirect!
    assert_response :success
    assert_equal 'y', @response.body
    
    # Check class variables.
    assert_equal domain, assigns(:domain)
    assert_equal "/#{document.slug}", assigns(:path)
    assert_equal page, assigns(:page)
    assert_equal document, assigns(:document)
  end
  
  test("production frontpage domain custom_template") do
    Rails.configuration.dumbocms.production = true
    
    # Set up fixtures.
    page = FactoryGirl.create(:page)
    
    domain = FactoryGirl.create(:domain, { :page => page,
      :name => 'tanieloty.pl',
    })
    another_domain = FactoryGirl.create(:domain, { :page => page,
      :name => 'www.tanieloty.pl'
    })

    page.reload # TODO required?
    page.update_attribute(:domain, domain)
    
    template = FactoryGirl.create(:template, {
      :content => '{{ document.content }}'
    })
    
    document = FactoryGirl.create(:document, {
      :page => page,
      :content => 'y',
      :template => template,
      :slug => 'frontpage'
    })
    
    # Check fixtures.
    assert   domain.preferred?
    assert ! another_domain.preferred? 
    assert_equal domain, page.preferred_domain
    assert_equal 'y', document.render_fresh.first

    # Ensure that a production page with one document template renders the
    # frontpage document correctly.
    host!('www.tanieloty.pl')
    
    get "/"
    assert_response :redirect
    assert_redirected_to "http://tanieloty.pl/"
    
    follow_redirect!
    assert_response :success
    assert_equal 'y', @response.body
    
    # Check class variables.
    assert_equal domain, assigns(:domain)
    assert_equal "/", assigns(:path)
    assert_equal page, assigns(:page)
    assert_equal document, assigns(:document)
  end
  
  test("development frontpage domain custom_template") do
    Rails.configuration.dumbocms.production = false
    
    # Set up fixtures.
    page = FactoryGirl.create(:page)
    
    domain = FactoryGirl.create(:domain, { :page => page,
      :name => 'tanieloty.pl',
    })
    another_domain = FactoryGirl.create(:domain, { :page => page,
      :name => 'www.tanieloty.pl'
    })

    page.reload # TODO required?
    page.update_attribute(:domain, domain)
    
    template = FactoryGirl.create(:template, {
      :content => '{{ document.content }}'
    })
    
    document = FactoryGirl.create(:document, {
      :page => page,
      :content => 'y',
      :template => template,
      :slug => 'frontpage'
    })
    
    # Check fixtures.
    assert   domain.preferred?
    assert ! another_domain.preferred? 
    assert_equal domain, page.preferred_domain
    assert_equal 'y', document.render_fresh.first

    # Ensure that a production page with one document template renders the
    # frontpage document correctly.
    host!('dumbocms.com')
    
    get "/www.tanieloty.pl/" # TODO test trailing slash
    assert_response :redirect
    assert_redirected_to "http://dumbocms.com/tanieloty.pl/"
    
    follow_redirect!
    assert_response :success
    assert_equal 'y', @response.body
    
    # Check class variables.
    assert_equal domain, assigns(:domain)
    assert_equal "/", assigns(:path)
    assert_equal page, assigns(:page)
    assert_equal document, assigns(:document)
  end
  
  test("development custom domain custom_template") do
    Rails.configuration.dumbocms.production = false
    
    # Set up fixtures.
    page = FactoryGirl.create(:page)
    
    domain = FactoryGirl.create(:domain, { :page => page,
      :name => 'tanieloty.pl',
    })
    another_domain = FactoryGirl.create(:domain, { :page => page,
      :name => 'www.tanieloty.pl'
    })

    page.reload # TODO required?
    page.update_attribute(:domain, domain)
    
    template = FactoryGirl.create(:template, {
      :content => '{{ document.content }}'
    })
    
    document = FactoryGirl.create(:document, {
      :page => page,
      :content => 'y',
      :template => template,
    })
    
    # Check fixtures.
    assert   domain.preferred?
    assert ! another_domain.preferred? 
    assert_equal domain, page.preferred_domain
    assert_equal 'y', document.render_fresh.first

    # Ensure that a production page with one document template renders the
    # frontpage document correctly.
    host!('dumbocms.com')
    
    get "/www.tanieloty.pl/#{document.slug}" # TODO test trailing slash
    assert_response :redirect
    assert_redirected_to "http://dumbocms.com/tanieloty.pl/#{document.slug}"
    
    follow_redirect!
    assert_response :success
    assert_equal 'y', @response.body
    
    # Check class variables.
    assert_equal domain, assigns(:domain)
    assert_equal "/#{document.slug}", assigns(:path)
    assert_equal page, assigns(:page)
    assert_equal document, assigns(:document)
  end
  
  test("production no documents preferred") do
    Rails.configuration.dumbocms.production = true
    
    # Set up fixtures.
    page = FactoryGirl.create(:page)

    domain = FactoryGirl.create(:domain, { :page => page,
      :name => 'tanieloty.pl',
    })

    template = FactoryGirl.create(:template, {
      :content => 'hey, {{ document.content }}'
    })
    
    page.update_attribute(:domain, domain)
    page.update_attribute(:template, template)
    page.reload # TODO required?

    # Check fixtures.
    assert domain.preferred?
    assert page.documents.empty?
    assert_equal domain, page.preferred_domain

    host!(page.preferred_domain.name)

    get "/"
    assert_response :success
    assert_equal 'hey, ', @response.body

    # Check class variables.
    assert_equal domain, assigns(:domain)
    assert_equal "/", assigns(:path)
    assert_equal page, assigns(:page)
    assert assigns(:document).is_a?(Document)
  end
  
  test('stub frontpage on root URL on production') do
    dom = FactoryGirl.create(:domain, :name => 'a.pl')
    pg = dom.page
    pg.template.update_attribute(:content, '{{ document.content }}')
    assert pg.documents.empty?
    
    host!(dom.name)
    get '/'
    assert_response :success
    assert_equal '', @response.body
  end
  test('stub frontpage on custom URLs on production') do
    dom = FactoryGirl.create(:domain, :name => 'a.pl')
    pg = dom.page
    pg.template.update_attribute(:content, '{{ document.content }}')
    assert pg.documents.empty?
    doc = FactoryGirl.create(:document, {
      :page => pg,
      :content => 'miau',
      :slug => 'test'
    })
    assert pg.reload.documents.any?
    assert_not_nil doc.path

    host!(dom.name)
    get doc.path
    assert_response :success
    assert_equal 'miau', @response.body
  end
  test('stub frontpage on root URL on development') do
    dom = FactoryGirl.create(:domain, :name => 'a.pl')
    pg = dom.page
    pg.template.update_attribute(:content, '{{ document.content }}')
    assert pg.documents.empty?
    
    host!(Rails.configuration.dumbocms.hostnamae)
    get "/#{dom.name}/"
    assert_response :success
    assert_equal '', @response.body
  end
  test('stub frontpage on custom URLs on development') do
    dom = FactoryGirl.create(:domain, :name => 'a.pl')
    pg = dom.page
    pg.template.update_attribute(:content, '{{ document.content }}')
    assert pg.documents.empty?
    doc = FactoryGirl.create(:document, {
      :page => pg,
      :content => 'miau',
      :slug => 'test'
    })
    assert pg.reload.documents.any?
    assert_not_nil doc.path
    
    host!(Rails.configuration.dumbocms.hostnamae)
    get "/#{dom.name}/#{doc.path}"
    assert_response :success
    assert_equal 'miau', @response.body
  end
  test('stub frontpage on custom URLs if no documents on production') do
    dom = FactoryGirl.create(:domain, :name => 'a.pl')
    pg = dom.page
    pg.template.update_attribute(:content, '{{ page.frontpage.url }}') # FIXME style
    assert pg.documents.empty?
    doc = FactoryGirl.create(:document, {
      :page => pg,
      :content => 'miau',
      :slug => 'test'
    })
    assert pg.reload.documents.any?
    assert_not_nil doc.path

    host!(dom.name)
    get '/'
    assert_response :success
    assert_equal pg.url, @response.body
  end
  test('stub frontpage on custom URLs if no documents on development') do
    dom = FactoryGirl.create(:domain, :name => 'a.pl')
    pg = dom.page
    pg.template.update_attribute(:content, '{{ page.frontpage.url }}') # FIXME style
    assert pg.documents.empty?
    doc = FactoryGirl.create(:document, {
      :page => pg,
      :content => 'miau',
      :slug => 'test'
    })
    assert pg.reload.documents.any?

    host!(Rails.configuration.dumbocms.hostname)
    get "/#{dom.name}/"
    assert_response :success
    assert_equal pg.url, @response.body
  end
end