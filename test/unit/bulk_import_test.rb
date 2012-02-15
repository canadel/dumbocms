require File.expand_path('../../test_helper', __FILE__)

class BulkImportTest < ActiveSupport::TestCase
  
  test("create") { assert create(:bulk_import).valid? }
  test("process!") { assert BulkImport.process! }
  
  test("blank ignored") do
    account = create(:account)
    
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
    import = create(:bulk_import, import_attributes)
    
    BulkImport.process!
    
    import.reload
    assert(import.state == 'success', 'Should be success.')
    assert(import.output.blank?)
  end
end
