require File.dirname(__FILE__) + '/../test_helper'

class PageTest < ActiveSupport::TestCase
  def setup
    @domain = FactoryGirl.create(:domain)
    @page = @domain.page
  end
  
  test("setup") do
    assert(@domain.valid?, 'Domain should be valid.')
    assert(@page.valid?, 'Page should be valid.')
    assert_not_nil(@page.preferred_domain, 'Preferred domain should be set.')
  end
  
  test("should create") { FactoryGirl.create(:page) }
  test("to_s") { assert_equal @page.name, @page.to_s }
  test("names") { assert_equal [].push(@domain.name), @page.domains.names }

  # Ensure that pages without domains are hidden.
  test("hidden?") { assert FactoryGirl.create(:page).hidden? }
  test("not hidden?") { assert ! @page.hidden? }
  
  test("environment production") do
    Rails.configuration.dumbocms.production = true
    
    assert_equal 'production', @page.environment
    assert_equal 'production', @page.env
  end
  
  test("environment development") do
    Rails.configuration.dumbocms.production = false
    
    assert_equal 'development', @page.environment
    assert_equal 'development', @page.env
  end
  
  # Ensure no preferred domain if none linked.
  test("preferred_domain nil") do
    assert FactoryGirl.create(:page).preferred_domain.nil?
  end
  
  # Ensure preffered domain is first added, if none explicitly marked.
  test("preferred_domain first") do
    assert_equal @domain, @page.preferred_domain
  end
  
  # Ensure preferred_domain can be explicitly marked.
  test("preferred_domain") do
    @page.domain = FactoryGirl.create(:domain, { :page => @page })

    assert_equal @page.domain, @page.preferred_domain
  end


  # Ensure that external_id is set.
  test("set external_id") do
    account = FactoryGirl.create(:account)
    pages = FactoryGirl.create_list(:page, 3, { :account => account })

    assert_equal [1, 2, 3], pages.map(&:external_id)
  end
  
  # Ensure that each account maintains external_id on its own.
  test("set external_id per account") do
    pages = FactoryGirl.create_list(:page, 3)

    assert_equal [1, 1, 1], pages.map(&:external_id)
  end
  
  # Ensure that external_id always incremented, even if some destroyed.
  test("increment external_id") do
    account = FactoryGirl.create(:account)
    pages = FactoryGirl.create_list(:page, 3, { :account => account })
    account.pages.destroy_all
    pages = FactoryGirl.create_list(:page, 3, { :account => account })
    
    assert_equal [4, 5, 6], pages.map(&:external_id)
  end
  
  test("initialize permalinks") do
    assert ! FactoryGirl.build(:page).permalinks.blank?
  end
  test("create permalinks") do
    assert ! FactoryGirl.create(:page).permalinks.blank?
  end
  
  test("set_advanced") do
    page = FactoryGirl.create(:page)
    
    assert page.sitemap?
    assert page.atom?
    assert page.rss?
    assert page.georss?
  end
  test("set_robots_txt") do
    page = FactoryGirl.create(:page)
    
    assert_equal "User-Agent: *\r\nDisallow: /admin/\r\n", page.robots_txt
  end
  
  test("set_domain_page_id") do
    # Set the fixtures.
    domain = FactoryGirl.create(:domain)
    page = FactoryGirl.create(:page)
    
    # Check the fixtures.
    assert_not_equal page, domain.page
    
    # Fire.
    page.update_attribute(:domain, domain)
    page.save # FIXME
    
    # Check the fire.
    assert_equal page.id, Domain.find(domain.id).page.id
  end
  
  test("frontpage stub") do
    pg = FactoryGirl.create(:page)
    pg.documents.destroy_all # TODO required?
    assert_equal 'frontpage', pg.frontpage.slug
    assert_equal '', pg.frontpage.content.to_s
    assert_equal pg.url.to_s, pg.frontpage.url
  end
  test('frontpage') do
    pg = FactoryGirl.create(:page)
    fpg = FactoryGirl.create(:document, :page => pg, :slug => 'frontpage')
    assert_equal 'frontpage', pg.frontpage.slug
    assert_equal fpg.content, pg.frontpage.content
    assert_equal pg.url.to_s, pg.frontpage.url
    assert_equal pg.template, pg.frontpage.document_template
  end
  
  test('json') do
    pg = FactoryGirl.create(:page)
    columns = [
      'account_id', 'name', 'title', 'template_id', 'description',
      'indexable'
    ]
    assert_equal columns.sort, JSON.parse(pg.to_json).keys.sort
  end
end