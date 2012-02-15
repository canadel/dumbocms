require 'test_helper'

class DocumentSlugTest < ActiveSupport::TestCase
  def setup
    @stub = Factory.build(:document)
    @document = FactoryGirl.create(:document)
  end

  test("setup") do
    assert_not_nil @stub.slug
    assert_not_nil @document.slug
    
    assert @stub.valid?
    assert @document.valid?
  end
  
  test("title") do
    doc = FactoryGirl.create(:document, {
      :title => 'Lunch is for wimps',
      :slug => nil
    })
    
    assert_equal 'Lunch is for wimps', doc.title
    assert_equal 'lunch-is-for-wimps', doc.slug
  end
  test("unique") do
    pg = FactoryGirl.create(:page)
    
    first, last = FactoryGirl.create_list(:document, 2, {
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
    first, last = FactoryGirl.create_list(:document, 2, {
      :title => 'Lunch is for wimps',
      :slug => nil
    })
    
    assert_equal 'Lunch is for wimps', first.title
    assert_equal 'lunch-is-for-wimps', first.slug

    assert_equal 'Lunch is for wimps', last.title
    assert_equal 'lunch-is-for-wimps', last.slug
  end
  
  test("explicite") do
    doc = FactoryGirl.create(:document, :slug => 'just-a-slug')
    
    assert_equal 'just-a-slug', doc.slug
  end
  
  test("validates presence") do
    @stub.attributes = { :slug => nil, :title => nil }
    
    assert @stub.invalid?
  end
end
