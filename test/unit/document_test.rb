require File.dirname(__FILE__) + '/../test_helper'

class DocumentTest < ActiveSupport::TestCase
  def setup
    @document = Factory.build(:document)
  end
  
  test("should create") { Factory.create(:document) }
  
  test("to_s title") do
    @document.slug, @document.title = 'slug', 'title'
    assert_equal 'title', @document.to_s
  end

  test("stub") { Document.stub }
  test("stub default_language") do
    page = FactoryGirl.build(:page)
    page.default_language = 'fr'
    
    stub = Document.stub(:page => page, :language => page.default_language)
    
    assert_equal page, stub.page
    assert_equal 'fr', stub.language
  end
  test('stub slug') do
    stub = Document.stub(:slug => 'frontpage')
    assert_equal 'frontpage', stub.slug
  end
  
  # test "should return hidden if page is hidden"
  # test "should return hidden if page is not hidden but no permalinks"
  # test "should not return hidden"
  
  test('json') do
    doc = FactoryGirl.create(:document)
    columns = %w{
      title content page_id slug language published_at template_id
      description kind markup timezone
    }
    
    assert_equal columns.sort, JSON.parse(doc.to_json).keys.sort
  end
end
