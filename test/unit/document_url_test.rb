require 'test_helper'

class DocumentUrlTest < ActiveSupport::TestCase
  def setup
    # TODO
  end

  test("url production") do
    Rails.configuration.dumbocms.production = true
    
    doc = FactoryGirl.create(:document)
    
    page = doc.page
    page.update_attribute(:permalinks, '/%id%')
    
    domain = FactoryGirl.create(:domain, :page => page)
    domain.update_attribute(:name, 'bilety.net.pl')

    doc.permalink! # FIXME
    
    assert_equal "http://bilety.net.pl/#{doc.external_id}", doc.url
  end
  
  test("url development") do
    Rails.configuration.dumbocms.production = false
    
    doc = FactoryGirl.create(:document)
    
    page = doc.page
    page.update_attribute(:permalinks, '/%id%')
    
    domain = FactoryGirl.create(:domain, :page => page)
    domain.update_attribute(:name, 'bilety.net.pl')

    doc.permalink! # FIXME
    
    assert_equal "http://dumbocms.com/bilety.net.pl/#{doc.external_id}", doc.url
  end

  test("url frontpage production") do
    Rails.configuration.dumbocms.production = true
    
    doc = FactoryGirl.create(:document, :slug => 'frontpage')
    
    page = doc.page
    
    domain = FactoryGirl.create(:domain, :page => page)
    domain.update_attribute(:name, 'bilety.net.pl')
    
    assert_equal 'http://bilety.net.pl/', doc.url
  end
  
  test("url frontpage development") do
    Rails.configuration.dumbocms.production = false
    
    doc = FactoryGirl.create(:document, :slug => 'frontpage')
    
    page = doc.page
    
    domain = FactoryGirl.create(:domain, :page => page)
    domain.update_attribute(:name, 'bilety.net.pl')
    
    assert_equal 'http://dumbocms.com/bilety.net.pl/', doc.url
  end
end
