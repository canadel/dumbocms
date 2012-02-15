require File.expand_path('../../test_helper', __FILE__)

class PageImportTest < ActiveSupport::TestCase
  def setup
    @domain = create(:domain)
    @page = @domain.page
    @template = @page.template
  end

  test("create with domain") do
    attrs = { :domain_name => '1.dupa.pl', :template_id => @template.id, :name => 'test' }
    
    page_count = Page.count
    domain_count = Domain.count
    imported = Page.import!(attrs.merge(:account_id => @page.account.id))
    
    assert_equal(page_count + 1, Page.count, 'Should create a page.')
    assert_equal(domain_count + 1, Domain.count, 'Should create a domain.')
    
    assert(imported.is_a?(Page), 'Should be a Page.')
    assert(imported.valid?, 'Should be valid.')
    assert(! imported.id.nil?, 'Should create.')
    assert(! imported.preferred_domain.nil?, 'Should set the domain.')
    assert_equal(1, imported.domains.size, 'Should set all domains.')
    assert_equal('1.dupa.pl',
      imported.preferred_domain.name,
      'Should set the correct domain.')
  end
  test("create without domain") do
    attrs = { :domain_name => @domain.name, :template_id => @template.id }
    
    domain_count = Domain.count
    imported = Page.import!(attrs.merge(:account_id => @page.account.id))
    
    assert_equal(domain_count + 0,
      Domain.count,
      'Should not create a domain.')
    
    assert(imported.is_a?(Page), 'Should be a Page.')
    assert(imported.valid?, 'Should be valid.')
    assert(! imported.id.nil?, 'Should create.')
    assert(! imported.preferred_domain.nil?, 'Should set the domain.')
    assert_equal(1, imported.domains.size, 'Should set all domains.')
    assert_equal(@domain.name,
      imported.preferred_domain.name,
      'Should set the correct domain.')
  end
  test("create erroenous") do
    attrs = { :domain_name => @domain.name, :template_id => 'foo' }
    
    domain_count = Domain.count
    imported = Page.import!(attrs.merge(:account_id => @page.account.id))
    
    assert_equal(domain_count + 0,
      Domain.count,
      'Should not create a domain.')
    
    assert(imported.is_a?(Page), 'Should be a Page.')
    assert(! imported.valid?, 'Should not be valid.')
  end
  
  test("update with domain") do
    custom_domain = create(:domain, { :page => @page })
    attrs = {
      :domain_name => custom_domain.name,
      :template_id => @template.id
    }
    
    domain_count = Domain.count
    imported = Page.import!(attrs.merge(:account_id => @page.account.id))
    
    assert(imported.is_a?(Page), 'Should be a Page.')
    assert(imported.valid?, 'Should be valid.')
    assert(! imported.id.nil?, 'Should create.') # FIXME
    assert_equal(2, imported.domains.size, 'Should set all domains.')
  end
  test("update without domain") do
    custom_template = create(:template)
    attrs = {
      :domain_name => @domain.name,
      :template_id => custom_template.id
    }
    
    domain_count = Domain.count
    imported = Page.import!(attrs.merge(:account_id => @page.account.id))
    
    assert(imported.is_a?(Page), 'Should be a Page.')
    assert(imported.valid?, 'Should be valid.')
    assert(! imported.id.nil?, 'Should create.')
    assert(! imported.preferred_domain.nil?, 'Should set the domain.')
    assert_equal(1, imported.domains.size, 'Should set all domains.')
    assert_equal(@domain.name,
      imported.preferred_domain.name,
      'Should set the correct domain.')
    assert_equal(custom_template.id,
      imported.template.id,
      'Should change the template.')
  end
  test("do not update preferred domain") do
    custom = create(:domain, :page => @page)
    assert(! custom.preferred?, 'Should not be preferred.')
    
    attrs = {
      :domain_name => custom.name,
      :redirect_to => 'http://twitter.com/'
    }
    
    imported = Page.import!(attrs.merge(:account_id => @page.account_id))
    
    assert(imported.is_a?(Page), 'Should be a Page.')
    assert(imported.valid?, 'Should be valid.')
    assert(imported.preferred_domain != custom, 'Should leave preferred.')
  end
end
