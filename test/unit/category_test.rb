require File.expand_path('../../test_helper', __FILE__)

class CategoryTest < ActiveSupport::TestCase
  def setup
    @category = create(:category)
    @stub = build(:category)
  end

  test("setup") do
    assert_not_nil @category.name
  end

  test("to_s") { assert_equal @category.name, @category.to_s }
  test("create") { assert create(:category).valid? }
  
  test("external_id") do
    page = create(:page)
    categories = create_list(:category, 3, :page => page)
    
    assert_equal [1, 2, 3].sort, categories.map(&:external_id).sort
  end
  test("external_id per page") do
    categories = create_list(:category, 3)
    
    assert_equal [1, 1, 1].sort, categories.map(&:external_id).sort
  end
  
  test("to_liquid keys") do
    vars = %w{id name slug parent documents position subcategories}
    
    assert_equal vars.sort, @category.to_liquid.keys.sort
  end
  test("to_liquid values") do
    assert @category.parent.nil?
    assert @category.documents.empty?
    assert @category.categories.empty?
    
    to_liquid = @category.to_liquid
    
    assert_equal @category.external_id, to_liquid['id']
    assert_equal @category.name, to_liquid['name']
    assert_equal @category.slug, to_liquid['slug']
    assert_equal(nil.to_s, to_liquid['parent'])
    assert_equal([], to_liquid['documents'])
    assert_equal([], to_liquid['subcategories'])
  end
  test("to_liquid parent") do
    parent = create(:category)
    
    @category.update_attributes(:parent => parent)
    
    to_liquid = @category.to_liquid
    
    assert_equal parent.to_liquid, to_liquid['parent']
  end
  test("to_liquid categories") do
    names = %w{c123 b123 a123}
    categories = names.map do |name|
      create(:category, :name => name)
    end
    
    @category.categories = categories
    @category.save! # TODO: easier?
    
    to_liquid = @category.reload.to_liquid
    
    assert_equal categories.reverse, to_liquid['subcategories']
  end
  
  test("names") do
    page = create(:page)
    
    names = [
      "Vitaliy Volodymyrovych Klychko",
      "Wladimir Klitschko"
    ]
    
    categories = [] # TODO: #tap
    
    names.each do |name|
      categories << create(:category, {
        :name => name,
        :page => page
      })
    end
    
    page.reload # TODO: required?
    
    assert_equal names.sort, page.categories.names.sort
  end
  test("names alphabetically") do
    page = create(:page)
    names = %w{c123 b123 a123}
    categories = names.map do |name|
      create(:category, :name => name, :page => page)
    end
    
    page.reload # TODO: required?
    
    assert_equal names.sort, page.categories.names
  end
  
  test("matching name") do
    category = create(:category, :name => 'dumbo')
    assert_equal category, Category.matching('dumbo')
  end
  test("matching slug") do
    category = create(:category, :slug => 'dumbo')
    assert_equal category, Category.matching('dumbo')
  end
  test("matching id") do
    page = create(:page)
    category = create(:category, :page => page)
    assert_equal category, page.categories.matching(category.external_id)
  end
  test("matching nil") do
    assert_nil Category.matching('r4nd0m')
  end
  
  test("primary?") do
    document = create(:document)
    document.update_attributes({ :category => @category })
    
    assert   @category.primary?(document)
  end
  test("not primary?") do
    document = create(:document)

    assert ! @category.primary?(document)
  end
  test('json') do
    category = create(:category)
    columns = %w{name page_id slug}
    
    assert_equal columns.sort, JSON.parse(category.to_json).keys.sort
  end
end
