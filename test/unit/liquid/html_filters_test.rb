require File.expand_path('../../../test_helper', __FILE__)

class Liquid::HtmlFiltersTest < ActiveSupport::TestCase
  def setup
    @document = create(:document, {
      :template => create(:template)
    })
  end
  
  test('img_tag') { assert_liquid 'img_tag', @document }
  test('img_tag alt') { assert_liquid 'img_tag_alt', @document }
  test('stylesheet_tag') { assert_liquid 'stylesheet_tag', @document }
  test('script_tag') { assert_liquid 'script_tag', @document }
end
