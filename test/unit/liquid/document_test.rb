require File.expand_path('../../../test_helper', __FILE__)
require 'time'

class Liquid::DocumentTest < ActiveSupport::TestCase
  def setup
    @page = create(:page, {
      :permalinks => '/%slug%'
    })
    
    @document = create(:document, {
      :template => create(:template),
      :content => 'hello, world',
      :slug => 'hello-world-hey',
      :latitude => 40.714728,
      :longitude => -73.998672,
      :kind => 'profile',
      :published_at => Time.parse("Sun Oct 02 04:10:19 +0200 2011"),
      :language => 'de',
      :description => 'description is set',
      :title => 'title',
      :page => @page
    })
    
    @domain = create(:domain, {
      :page => @page,
      :name => 'domain.de'
    })
    
    @category = create(:category, {
      :name => 'primary category',
      :position => 100,
      :page => @page
    })
    
    @document.categories << create(:category, {
      :name => 'runway',
      :position => 5,
      :page => @page
    })
    @document.categories << create(:category, {
      :name => 'backstage',
      :position => 10,
      :page => @page
    })
    @document.categories << create(:category, {
      :name => 'backstreet',
      :position => 10,
      :page => @page
    })
    
    @document.category = @category
    @document.save!
  end
  
  test('document') do
    assert_liquid 'document', @document
  end
  
  # TODO blank values
end