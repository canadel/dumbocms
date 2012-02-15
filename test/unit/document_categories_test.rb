require File.expand_path('../../test_helper', __FILE__)

class DocumentCategoriesTest < ActiveSupport::TestCase
  def setup
    @stub = build(:document)
    @document = create(:document)
  end
  
  test("setup") do
    assert @document.category.nil?
    assert @document.categories.empty?
  end
  
  test("explicite primary_category") do
    category = create(:category)
    
    @document.category = category
    @document.save! # TODO: required?
    
    assert_equal category, @document.primary_category
  end
  test("implicite primary_category") do
    category = create(:category)
    
    @document.categories << category
    @document.save! # TODO: required?
    
    assert_equal category, @document.primary_category
  end
  test("explicite primary_category?") do
    @document.category = create(:category)
    @document.save! # TODO: required?
    
    assert @document.primary_category?
  end
  test("implicite primary_category?") do
    @document.categories << create(:category)
    @document.save! # TODO: required?
    
    assert @document.primary_category?
  end
  test("not primary_category?") do
    assert_equal false, @document.primary_category?
  end
  
  test("primary_category categories") do
    category = create(:category)
    
    @document.category = category
    @document.save! # TODO: required?
    
    assert_equal [category], @document.categories
  end
  
  test("permalinks create") do
    @document.update_attributes({
      :category => create(:category, :permalinks => '/%id%')
    })
    @document.permalink! # TODO: required?
    
    assert_equal "/#{@document.external_id}", @document.path
  end
  test("permalinks update") do
    @document.update_attributes({
      :category => create(:category)
    })
    @document.category.update_attributes(:permalinks => '/%year%')
    @document.permalink! # TODO: required?
    
    assert_equal "/#{@document.published_at.year}", @document.path
  end
end
