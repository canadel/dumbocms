require File.dirname(__FILE__) + '/../test_helper'

class BulkImportDomainTest < ActiveSupport::TestCase
  
  def setup
    @headers = ["Page ID", "Name"]
    @opts = { :headers => @headers, :write_headers => true }
    @path = File.dirname(__FILE__) + '/../tmp/bulk_import_domain.csv'
    
    FasterCSV.open(@path, "w", @opts) {|csv| true } # FIXME hack

    @page = FactoryGirl.create(:page)
    @account = @page.account
        
    @import_attributes = {
      :account => @account,
      :csv => File.new(@path),
      :record => 'domain'
    }
  end
  
  def teardown
    FileUtils.rm(@path) rescue nil
  end
  
  # test("setup") { assert ! File.exists?(@path) }
  
  test("create") do
    FasterCSV.open(@path, "w", @opts) do |csv|
      10.times do |n|
        csv << [@page.id, "#{n}.crap.pl"]
      end # FIXME seq
    end
    
    @import = FactoryGirl.create(:bulk_import, @import_attributes)
    assert_difference('Domain.count', 10) { BulkImport.process! }
    
    @import.reload
    
    assert_equal 'success', @import.state
    assert_equal 10, @page.domains.size
  end
  test("create erroneous") do
    FasterCSV.open(@path, "w", @opts) do |csv|
      10.times { csv << ['foo', "#{rand(666)}.crap.pl"] }
    end
    
    @import = FactoryGirl.create(:bulk_import, @import_attributes)
    assert_difference('Domain.count', 0) { BulkImport.process! }
    
    @import.reload
    
    assert_equal 'failure', @import.state
    assert_equal 0, @page.domains.size
  end
  test("create some erroneous") do
    FasterCSV.open(@path, "w", @opts) do |csv|
      5.times { csv << [@page.id, "#{rand(666)}.crap.pl"] }
      5.times { csv << ['foo', "#{rand(666)}.crap.pl"] }
    end
    
    @import = FactoryGirl.create(:bulk_import, @import_attributes)
    assert_difference('Domain.count', 5) { BulkImport.process! }

    @import.reload

    assert_equal 'failure', @import.state
    assert_equal 5, @page.domains.size
  end
  
  test("update") do
    domains = FactoryGirl.create_list(:domain, 10, { :page => @page })
    new_page = FactoryGirl.create(:page, { :account => @account })

    FasterCSV.open(@path, "w", @opts) do |csv|
      domains.each {|domain| csv << [new_page.id, domain.name]}
    end
    
    @import = FactoryGirl.create(:bulk_import, @import_attributes)
    assert_difference('Domain.count', 0) { BulkImport.process! }

    @import.reload
    @page.reload
    new_page.reload
    
    assert_equal 'success', @import.state
    assert_equal 10, new_page.domains.size
  end
  test("update erroneous") do
    domains = FactoryGirl.create_list(:domain, 10, { :page => @page })

    FasterCSV.open(@path, "w", @opts) do |csv|
      domains.each {|domain| csv << ['foo', domain.name]}
    end
    
    @import = FactoryGirl.create(:bulk_import, @import_attributes)
    assert_difference('Domain.count', 0) { BulkImport.process! }

    @import.reload
    
    assert_equal 'failure', @import.state
    assert_equal 10, @page.domains.size
  end
  test("update some erroneous") do
    domains = FactoryGirl.create_list(:domain, 10, { :page => @page })
    new_page = FactoryGirl.create(:page, { :account => @account })

    FasterCSV.open(@path, "w", @opts) do |csv|
      domains.each_with_index do |domain, n|
        csv << [(n.odd? ? new_page.id : 'foo'), domain.name]
      end
    end
    
    @import = FactoryGirl.create(:bulk_import, @import_attributes)
    assert_difference('Domain.count', 0) { BulkImport.process! }

    @import.reload
    
    assert_equal 'failure', @import.state
    # assert_equal 10, @page.domains.size
    # assert_equal 2, @page.domains.map(&:id).uniq.size
    # assert_equal [new_page.id, @page.id], @page.domains.map(&:id).uniq
  end
  
  test("create update") do
    domains = FactoryGirl.create_list(:domain, 5, { :page => @page })
    new_page = FactoryGirl.create(:page, { :account => @account })

    FasterCSV.open(@path, "w", @opts) do |csv|
      domains.each {|domain| csv << [new_page.id, domain.name]}
      5.times {|n| csv << [@page.id, "#{n}.fiut.pl"]}
    end
    
    @import = FactoryGirl.create(:bulk_import, @import_attributes)
    assert_difference('Domain.count', 5) { BulkImport.process! }

    @import.reload
    
    assert_equal 'success', @import.state
    # assert_equal 10, @page.domains.size
    # assert_equal 2, @page.domains.map(&:id).uniq.size
    # assert_equal [new_page.id, @page.id], @page.domains.map(&:id).uniq
  end
  
  # TODO test("create update erroneous")
end
