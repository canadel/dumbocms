require 'test_helper'

class BulkImportTest < ActiveSupport::TestCase
  
  test("create") { assert FactoryGirl.create(:bulk_import).valid? }
  test("process!") { assert BulkImport.process! }
  
  test("blank ignored") do
    account = FactoryGirl.create(:account)
    
    csv = []
    csv << ["a", "Name", "c"].join(",")
    csv << "" * 15
    csv.join("\n")
    
    path = File.dirname(__FILE__) + '/../tmp/bulk_import.csv'
    File.open(path, 'w') {|f| f.write(csv.join("\n")) }
    
    import_attributes = {
      :account => account,
      :csv => File.new(path),
      :record => 'page'
    }
    import = FactoryGirl.create(:bulk_import, import_attributes)
    
    BulkImport.process!
    
    import.reload
    assert(import.state == 'success', 'Should be success.')
    assert(import.output.blank?)
  end
end
