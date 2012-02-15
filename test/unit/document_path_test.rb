require 'test_helper'

class DocumentPathTest < ActiveSupport::TestCase
  def setup; true; end
  
  test("nil") do
    doc = FactoryGirl.create(:document, :path => nil)
    doc.reload
    
    assert_equal 1, doc.permalinks.size
    assert_equal 0, doc.permalinks.custom.size
  end
  test("create") do
    doc = FactoryGirl.create(:document, :path => '/security')
    doc.reload
    
    assert_equal(1, doc.permalinks.size)
    assert_equal(1, doc.permalinks.custom.size)
    assert_equal('/security', doc.path)
  end
  test("update") do
    doc = FactoryGirl.create(:document)
    doc.update_attributes(:path => '/foo')
    doc.reload
    
    assert_equal(1, doc.permalinks.size)
    assert_equal(1, doc.permalinks.custom.size)
    assert_equal('/foo', doc.path)
  end
  test("update url") do
    doc = FactoryGirl.create(:document)
    doc.update_attributes(:path => 'http://onet.pl/foo')
    doc.reload
    
    assert_equal(1, doc.permalinks.size)
    assert_equal(1, doc.permalinks.custom.size)
    assert_equal('/foo', doc.path)
  end
  test("update url relative") do
    doc = FactoryGirl.create(:document)
    doc.update_attributes(:path => 'foo')
    doc.reload
    
    assert_equal(1, doc.permalinks.size)
    assert_equal(1, doc.permalinks.custom.size)
    assert_equal('/foo', doc.path)
  end
end
