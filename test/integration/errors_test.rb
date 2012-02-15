require 'test_helper'

class ErrorsTest < ActionDispatch::IntegrationTest

  # TODO setup
  
  test("unknown domain") do
    host!('unknown.domain.abc123')
    
    get '/'
    assert_response :not_found
    assert_match /There is no such domain/, @response.body
  end
  
  test("unknown path custom not_found") do
    Rails.configuration.dumbocms.production = true
    
    domain = FactoryGirl.create(:domain)

    page = domain.page
    page.documents = FactoryGirl.create_list(:document, 1, {
      :slug => Document.not_found_slug,
      :content => 'Custom Not Found',
      :page => page
    })
    page.save # TODO required?
    
    template = page.template
    template.update_attribute(:content, '{{ document.content }}')
    
    host!(domain.name)
    assert(domain.preferred?)
    
    get '/unknown-path'
    assert_response :not_found
    assert_equal 'Custom Not Found', @response.body
  end
  
  test("unknown path production") do
    Rails.configuration.dumbocms.production = true
    
    domain = FactoryGirl.create(:domain)
    
    page = domain.page
    
    document = FactoryGirl.create(:document, :page => page)
    
    assert(domain.preferred?)

    # Fire.
    host!(domain.name)
    get '/unknown-path'

    # Assert the fire.
    assert(page.production?, "Page should stay in production.")
    assert_response(:not_found, "Path should be not found.")
    assert_match(/Not Found/, @response.body, "Error should output.")
  end
  
  test("unknown path development") do
    Rails.configuration.dumbocms.production = false
    
    # Set the fixtures.
    domain = FactoryGirl.create(:domain)
    page = domain.page
    document = FactoryGirl.create(:document, :page => page)
    
    # Assert the fixtures.
    assert(domain.preferred?, "Domain should be preferred.")
    assert(page.development?, "Page should be in development.")
    
    # Fire.
    host!(domain.name)
    get("/#{domain.name}/unknown-path")
    
    # Assert the fire.
    assert(page.development?, "Page should stay in development.")
    assert_response(:not_found, "Path should be not found.")
    assert_match(/error message/, @response.body, "Error should output.")
  end
end