require File.dirname(__FILE__) + '/../../test_helper'
require 'time'

class Liquid::ResourceTest < ActiveSupport::TestCase
  def setup
    @page = FactoryGirl.create(:page, {
      :permalinks => '/%slug%'
    })
    
    @resource = FactoryGirl.create(:resource, {
      :company => @page.account.company,
      :name => 'test-name.jpg',
      :slug => 'test-name'
    })
    
    @document = FactoryGirl.create(:document, {
      :page => @page,
      :template => FactoryGirl.create(:template)
    })
  end
  
  test('resource') do
    assert_liquid 'resource', @document
  end
  
  # TODO blank values
end