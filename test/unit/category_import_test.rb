require File.expand_path('../../test_helper', __FILE__)

class CategoryImportTest < ActiveSupport::TestCase
  def setup
    @page = create(:page)
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
    category = create(:category, :slug => 'catwalk')
    
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
