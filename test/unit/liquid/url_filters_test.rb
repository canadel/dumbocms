require File.dirname(__FILE__) + '/../../test_helper'

class Liquid::HtmlFiltersTest < ActiveSupport::TestCase
  def setup
    @document = FactoryGirl.create(:document, {
      :template => FactoryGirl.create(:template)
    })
  end
  
  test('link_to') { assert_liquid 'link_to', @document }
  test('link_to title') { assert_liquid 'link_to_title', @document }
end
