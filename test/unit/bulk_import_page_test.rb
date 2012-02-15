require File.dirname(__FILE__) + '/../test_helper'

class BulkImportPageTest < ActiveSupport::TestCase
  
  def setup
    @headers = ["Name", "Domain name", "Template ID"]
    @opts = { :headers => @headers, :write_headers => true }
    @path = File.dirname(__FILE__) + '/../tmp/bulk_import_page.csv'
    
    FasterCSV.open(@path, "w", @opts) {|csv| true } # FIXME hack

    @domain = FactoryGirl.create(:domain)
    @page = @domain.page
    @account = @page.account
        
    @import_attributes = {
      :account => @account,
      :csv => File.new(@path),
      :record => 'page'
    }
  end
  
  def teardown
    FileUtils.rm(@path) rescue nil
  end
  
  # test("setup") { assert ! File.exists?(@path) }
  
  test("create") do
    domain_names = []
    
    FasterCSV.open(@path, "w", @opts) do |csv|
      10.times do |n|
        name = "'#{n}.crap.pl'\""
        domain_names << name
        csv << [name, name, @page.template_id]
      end # FIXME seq
    end
    
    @import = FactoryGirl.create(:bulk_import, @import_attributes)
    assert_difference('Page.count', 10) do
      assert_difference('Domain.count', 10) do
        BulkImport.process!
      end
    end
    
    @import.reload
    
    assert_equal 'success', @import.state
  end
  test("create erroneous") do
    FasterCSV.open(@path, "w", @opts) do |csv|
      10.times do |n|
        csv << ["#{n}.crap.pl", "#{n}.crap.pl", 'foo']
      end
    end
    
    @import = FactoryGirl.create(:bulk_import, @import_attributes)
    assert_difference('Page.count', 0) { BulkImport.process! }
    
    @import.reload
    
    assert_equal 'failure', @import.state
  end
  test("create some erroneous") do
    FasterCSV.open(@path, "w", @opts) do |csv|
      5.times {|n| csv << ["#{n}.crap.pl", "#{n}.crap.pl", @page.template_id] }
      5.times {|n| csv << ["#{n}.crap.pl", "#{n}.crap.pl", 'foo'] }
    end
    
    @import = FactoryGirl.create(:bulk_import, @import_attributes)
    assert_difference('Domain.count', 5) { BulkImport.process! }

    @import.reload

    assert_equal 'failure', @import.state
  end
  
  test("update") do
    nt = FactoryGirl.create(:template)
    
    pages = []
    
    3.times do
      page = FactoryGirl.create(:page, {
        :template => FactoryGirl.create(:template)
      })
      
      domain = FactoryGirl.create(:domain, :page_id => page.id)
      page.update_attribute(:domain_id, domain.id)
      page.reload
      pages << page
    end
    
    FasterCSV.open(@path, "w", @opts) do |csv|
      pages.each do |page|
        csv << [page.preferred_domain.name, page.preferred_domain.name, nt.id]
      end
    end
    
    @import = FactoryGirl.create(:bulk_import, @import_attributes)
    
    assert_difference('Page.count', 0) do
      assert_difference('Template.count', 0) do
        BulkImport.process!
      end
    end
    
    @import.reload
    
    assert_equal 'success', @import.state, 'b'
    assert_equal [nt.id], pages.map(&:reload).map(&:template_id).uniq, 'c'
  end
  test("update erroneous") do
    pages = FactoryGirl.create_list(:page, 10, {
      :template => FactoryGirl.create(:template),
      :domain => FactoryGirl.create(:domain)
    })
    
    FasterCSV.open(@path, "w", @opts) do |csv|
      pages.each do |page|
        csv << [page.preferred_domain.name, 'foo']
      end
    end
    
    @import = FactoryGirl.create(:bulk_import, @import_attributes)
    
    assert_difference('Page.count', 0) do
      assert_difference('Template.count', 0) do
        BulkImport.process!
      end
    end

    @import.reload
    
    pages.each {|page| page.reload}
    
    assert_equal 'failure', @import.state
  end
  test("update some erroneous") do
    nt = FactoryGirl.create(:template)
    pages = []
    
    5.times do
      page = FactoryGirl.create(:page, {
        :template => FactoryGirl.create(:template)
      })
      
      domain = FactoryGirl.create(:domain, :page_id => page.id)
      page.update_attribute(:domain_id, domain.id)
      page.reload
      pages << page
    end
        
    FasterCSV.open(@path, "w", @opts) do |csv|
      pages.each do |page|
        csv << [page.preferred_domain.name, page.preferred_domain.name, nt.id]
      end
      
      5.times {|n| csv << ["#{n}.scierwo.pl", "#{n}.scierwo.pl", 'foo']}
    end
    
    @import = FactoryGirl.create(:bulk_import, @import_attributes)
    
    assert_difference('Page.count', 0) do
      assert_difference('Template.count', 0) do
        BulkImport.process!
      end
    end

    @import.reload
    
    pages.each {|page| page.reload}
    
    assert_equal 'failure', @import.state
    assert_equal [nt.id], pages.map(&:template_id).uniq
  end
  
  # TODO test("create update")
  # TODO test("create update erroneous")
end
