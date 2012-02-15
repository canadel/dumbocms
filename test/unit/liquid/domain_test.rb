require File.expand_path('../../../test_helper', __FILE__)
require 'time'

class Liquid::DomainTest < ActiveSupport::TestCase
  def setup
    @page = create(:page, {
      :permalinks => '/%slug%'
    })
    
    @domain = create(:domain, {
      :page => @page,
      :name => 'domain.de'
    })
    
    @document = create(:document, {
      :page => @page.reload,
      :template => create(:template)
    })
    
    @document.save!
    @page.save!
  end
  
  test('domain') do
    assert_liquid 'domain', @document
  end
  
  # TODO blank values
end