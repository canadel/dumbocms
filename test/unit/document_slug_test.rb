require File.expand_path('../../test_helper', __FILE__)

class DocumentSlugTest < ActiveSupport::TestCase
  def setup
    @stub = build(:document)
    @document = create(:document)
  end

  test("setup") do
    assert_not_nil @stub.slug
    assert_not_nil @document.slug
    
    assert @stub.valid?
    assert @document.valid?
  end
  
  test("title") do
    doc = create(:document, {
      :title => 'Lunch is for wimps',
      :slug => nil
    })
    
    assert_equal 'Lunch is for wimps', doc.title
    assert_equal 'lunch-is-for-wimps', doc.slug
  end
  test("unique") do
    pg = create(:page)
    
    first, last = create_list(:document, 2, {
      :title => 'Lunch is for wimps',
      :slug => nil,
      :page => pg
    })
    
    assert_equal 'Lunch is for wimps', first.title
    assert_equal 'lunch-is-for-wimps', first.slug

    assert_equal 'Lunch is for wimps', last.title
    assert_equal 'lunch-is-for-wimps-2', last.slug
  end
  test("unique scope page") do
    first, last = create_list(:document, 2, {
      :title => 'Lunch is for wimps',
      :slug => nil
    })
    
    assert_equal 'Lunch is for wimps', first.title
    assert_equal 'lunch-is-for-wimps', first.slug

    assert_equal 'Lunch is for wimps', last.title
    assert_equal 'lunch-is-for-wimps', last.slug
  end
  
  test("explicite") do
    doc = create(:document, :slug => 'just-a-slug')
    
    assert_equal 'just-a-slug', doc.slug
  end
  
  test("validates presence") do
    @stub.attributes = { :slug => nil, :title => nil }
    
    assert @stub.invalid?
  end
end
