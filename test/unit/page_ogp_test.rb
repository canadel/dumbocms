require 'test_helper'

class PageOgpTest < ActiveSupport::TestCase
  def setup
    @stub = FactoryGirl.build(:page)
  end
  
  test('setup') do
    assert @stub.ogp?
  end
end