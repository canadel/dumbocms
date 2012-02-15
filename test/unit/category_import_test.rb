require 'test_helper'

class CategoryImportTest < ActiveSupport::TestCase
  def setup
    @page = FactoryGirl.create(:page)
  end

  test("import create") do
    q = {
      :slug => 'catwalk',
      :name => 'Cat Walk',
      :page_id => @page.id
    }
    
    imported = Category.import!(q)

    assert   imported.valid?
    assert ! imported.id.nil?
    assert_equal 'catwalk', imported.slug
    assert_equal 'Cat Walk', imported.name
    assert_equal @page.id, imported.page_id
  end
  test("import update") do
    category = FactoryGirl.create(:category, :slug => 'catwalk')
    
    q = {
      :slug => 'catwalk',
      :name => 'Rocket Science',
      :page_id => @page.id
    }
    
    imported = Category.import!(q)
    
    assert   imported.valid?
    assert ! imported.id.nil?
    assert_equal 'catwalk', imported.slug
    assert_equal 'Rocket Science', imported.name
    assert_equal @page.id, imported.page_id
  end
end
