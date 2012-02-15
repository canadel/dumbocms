require 'test_helper'

class DomainImportTest < ActiveSupport::TestCase
  def setup
    @domain = FactoryGirl.create(:domain)
    @page = @domain.page
  end

  test("create") do
    attrs = { :name => 'goof', :page_id => @page.id }
    
    imported = Domain.import!(attrs)

    # assert(imported.new_record?, 'Should be a new record.')
    assert(imported.valid?, 'Should be valid.')
    assert(imported.name.present?, 'Should set the name.')
    assert_equal('goof', imported.name, 'Should set the name correctly.')
    assert_equal(@page, imported.page, 'Should set the page correctly.')
    assert_equal(imported, Domain.find_by_name('goof'), 'Should create.')
  end
  test("update") do
    pg, name = FactoryGirl.create(:page), @domain.name
    attrs = { :name => @domain.name, :page_id => pg.id }
    
    imported = Domain.import!(attrs)
    
    assert(imported.name.present?, 'Should set the name.')
    assert_equal(name, imported.name, 'Should set the name correctly.')
    assert_equal(pg, imported.page, 'Should set the page correctly.')
    assert_equal(Domain.find_by_name(name), imported, 'Should create.')
  end
  test("create erroneous") do
    attrs = { :name => 'foof', :page_id => 'foo' }
    
    imported = Domain.import!(attrs)

    assert(imported.name.present?, 'Should set the name.')
    assert(imported.page.nil?, 'Should not assign the page.')
    assert(! imported.valid?, 'Should be invalid.')
    assert(Domain.find_by_name('foof').nil?, 'Should not create.')
    assert_equal('foof', imported.name, 'Should set the name correctly.')
  end
  test("update erroneous") do
    name = @domain.name
    attrs = { :name => @domain.name, :page_id => 'foo' }
    
    imported = Domain.import!(attrs)
    
    assert(imported.name.present?, 'Should set the name.')
    assert(imported.page.nil?, 'Should not assign the page.')
    assert(! imported.valid?, 'Should be invalid.')
    assert(Domain.find_by_name('foof').nil?, 'Should not create.')
    assert_equal(name, imported.name, 'Should set the name correctly.')
  end
end
