require File.dirname(__FILE__) + '/../../test_helper'

class Liquid::HtmlFiltersTest < ActiveSupport::TestCase
  def setup
    @document = FactoryGirl.create(:document, {
      :template => FactoryGirl.create(:template)
    })
  end
  
  test('img_tag') { assert_liquid 'img_tag', @document }
  test('img_tag alt') { assert_liquid 'img_tag_alt', @document }
  test('stylesheet_tag') { assert_liquid 'stylesheet_tag', @document }
  test('script_tag') { assert_liquid 'script_tag', @document }
end
