require File.dirname(__FILE__) + '/../../test_helper'
require 'time'

class Liquid::CategoryTest < ActiveSupport::TestCase
  def setup
    @page = FactoryGirl.create(:page, {
      :permalinks => '/%slug%'
    })
    
    @domain = FactoryGirl.create(:domain, {
      :page => @page,
      :name => 'domain.de'
    })
    
    @document = FactoryGirl.create(:document, {
      :page => @page,
      :template => FactoryGirl.create(:template),
      :title => 'Document that is rendered right now',
      :published_at => Time.parse('2011-10-02 03:01:29 UTC'),
      :slug => 'document-that-is-rendered-right-now'
    })
    
    @category = FactoryGirl.create(:category, {
      :name => 'Kategory',
      :slug => 'kategory',
      :position => 10,
      :page => @page
    })
    
    @category.categories << FactoryGirl.create(:category, {
      :name => 'Ccc Subcategory with position 5',
      :slug => 'ccc-subcategory-with-position-5',
      :position => 5,
      :page => @page,
      :parent => @category
    })
    @category.categories << FactoryGirl.create(:category, {
      :name => 'Bbb Subcategory with position 10',
      :position => 10,
      :page => @page,
      :parent => @category
    })
    @category.categories << FactoryGirl.create(:category, {
      :name => 'Aaa Subcategory with position 20',
      :position => 20,
      :page => @page,
      :parent => @category
    })
    
    @category.parent = FactoryGirl.create(:category, {
      :name => 'Parent category with position 30',
      :position => 30,
      :page => @page
    })
    
    @document.category = @category
    @document.save!
    
    @category.documents << FactoryGirl.create(:document, {
      :title => "Document 1 that belongs to a given category",
      :slug => 'document-1-that-belongs-to-a-given-category',
      :published_at => Time.parse('2011-10-02 03:26:29 UTC'),
      :page => @page
    })
    @category.documents << FactoryGirl.create(:document, {
      :title => "Document 2 that belongs to a given category",
      :slug => 'document-2-that-belongs-to-a-given-category',
      :published_at => Time.parse('2011-10-02 03:16:29 UTC'),
      :page => @page
    })
    @category.documents << FactoryGirl.create(:document, {
      :title => "Document 3 that belongs to a given category",
      :slug => 'document-3-that-belongs-to-a-given-category',
      :published_at => Time.parse('2011-10-02 03:10:29 UTC'),
      :page => @page
    })
    
    @category.save!
  end
  
  test('category') do
    assert_liquid 'category', @document
  end
  
  # TODO blank values
end