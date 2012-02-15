require File.expand_path('../../test_helper', __FILE__)

class PageOgpTest < ActiveSupport::TestCase
  def setup
    @stub = build(:page)
  end
  
  test('setup') do
    assert @stub.ogp?
  end
end