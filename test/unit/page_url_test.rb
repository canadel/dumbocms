require File.expand_path('../../test_helper', __FILE__)

class PageUrlTest < ActiveSupport::TestCase
  def setup
    @domain = build(:domain) # FIXME: switch to #stub ?
    @page = create(:page) # FIXME #build possible?
  end
  
  # test("setup")

  test("url production hidden") do
    Rails.configuration.dumbocms.production = true
    
    @page.stubs(:hidden?).returns(true)
    @page.stubs(:preferred_domain).returns(nil)
    
    assert_equal nil, @page.url
  end
  
  test("url development hidden") do
    Rails.configuration.dumbocms.production = false
    
    @page.stubs(:hidden?).returns(true)
    @page.stubs(:preferred_domain).returns(nil)
    
    assert_equal nil, @page.url
  end

  test("url production") do
    Rails.configuration.dumbocms.production = true
    
    @page.stubs(:domain)
    @page.stubs(:preferred_domain).returns(@domain)

    @domain.name = 'gds.pl'
    @domain.stubs(:page).returns(@page)
    
    assert_equal 'http://gds.pl/', @page.url
  end

  test("url development") do
    Rails.configuration.dumbocms.production = false
    
    @page.stubs(:domain).returns(@domain)
    @page.stubs(:preferred_domain).returns(@domain)

    @domain.name = 'gds.pl'
    @domain.stubs(:page).returns(@page)
    
    assert_equal 'http://dumbocms.com/gds.pl/', @page.url
  end
end