require File.expand_path('../../../test_helper', __FILE__)
require 'time'

class Liquid::ResourceTest < ActiveSupport::TestCase
  def setup
    @page = create(:page, {
      :permalinks => '/%slug%'
    })
    
    @resource = create(:resource, {
      :company => @page.account.company,
      :name => 'test-name.jpg',
      :slug => 'test-name'
    })
    
    @document = create(:document, {
      :page => @page,
      :template => create(:template)
    })
  end
  
  test('resource') do
    assert_liquid 'resource', @document
  end
  
  # TODO blank values
end