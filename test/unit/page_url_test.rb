require 'test_helper'

class PageUrlTest < ActiveSupport::TestCase
  def setup
    @domain = FactoryGirl.build(:domain) # FIXME: switch to #stub ?
    @page = FactoryGirl.create(:page) # FIXME #build possible?
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