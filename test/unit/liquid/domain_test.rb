require File.dirname(__FILE__) + '/../../test_helper'
require 'time'

class Liquid::DomainTest < ActiveSupport::TestCase
  def setup
    @page = FactoryGirl.create(:page, {
      :permalinks => '/%slug%'
    })
    
    @domain = FactoryGirl.create(:domain, {
      :page => @page,
      :name => 'domain.de'
    })
    
    @document = FactoryGirl.create(:document, {
      :page => @page.reload,
      :template => FactoryGirl.create(:template)
    })
    
    @document.save!
    @page.save!
  end
  
  test('domain') do
    assert_liquid 'domain', @document
  end
  
  # TODO blank values
end