require File.expand_path('../../../test_helper', __FILE__)

class Liquid::ResourceFiltersTest < ActiveSupport::TestCase
  def setup
    @document = create(:document, {
      :template => create(:template)
    })
    @resource = create(:resource, {
      :company => @document.page.account.company
    })
  end
  
  test('asset_url slug') { assert_liquid 'asset_url_slug', @document }
  test('asset_url name') { assert_liquid 'asset_url_name', @document }
  test('asset_url wrong') { assert_liquid 'asset_url_wrong', @document }
end
