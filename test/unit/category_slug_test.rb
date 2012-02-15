require File.expand_path('../../test_helper', __FILE__)

class CategorySlugTest < ActiveSupport::TestCase
  def setup
    @stub = build(:category)
    @category = create(:category)
  end

  test("setup") do
    assert_not_nil @stub.slug
    assert_not_nil @category.slug
    
    assert @stub.valid?
    assert @category.valid?
  end
  
  test("name") do
    cat = create(:category, {
      :name => 'Lunch is for wimps',
      :slug => nil
    })
    
    assert_equal 'Lunch is for wimps', cat.name
    assert_equal 'lunch-is-for-wimps', cat.slug
  end
  test("unique") do
    pg = create(:page)
    
    first, last = create_list(:category, 2, {
      :name => 'Lunch is for wimps',
      :slug => nil,
      :page => pg
    })
    
    assert_equal 'Lunch is for wimps', first.name
    assert_equal 'lunch-is-for-wimps', first.slug

    assert_equal 'Lunch is for wimps', last.name
    assert_equal 'lunch-is-for-wimps-2', last.slug
  end
  test("unique scope page") do
    first, last = create_list(:category, 2, {
      :name => 'Lunch is for wimps',
      :slug => nil
    })
    
    assert_equal 'Lunch is for wimps', first.name
    assert_equal 'lunch-is-for-wimps', first.slug

    assert_equal 'Lunch is for wimps', last.name
    assert_equal 'lunch-is-for-wimps', last.slug
  end
  
  test("explicite") do
    cat = create(:category, :slug => 'just-a-slug')
    
    assert_equal 'just-a-slug', cat.slug
  end
  
  test("validates presence") do
    @stub.attributes = { :slug => nil, :name => nil }
    
    assert @stub.invalid?
  end
end
