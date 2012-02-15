require File.expand_path('../../../test_helper', __FILE__)

class Liquid::HtmlFiltersTest < ActiveSupport::TestCase
  def setup
    @document = create(:document, {
      :template => create(:template)
    })
  end
  
  test('link_to') { assert_liquid 'link_to', @document }
  test('link_to title') { assert_liquid 'link_to_title', @document }
end
