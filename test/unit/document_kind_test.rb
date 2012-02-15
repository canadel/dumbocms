require 'test_helper'

class DocumentKindTest < ActiveSupport::TestCase
  def setup
    @stub = FactoryGirl.build(:document)
  end
  
  test('setup') do
    assert ! @stub.kind.blank?
  end
  test('create') do
    assert FactoryGirl.create(:document).valid?
  end
  test('default_kind') do
    # As per http://developers.facebook.com/docs/opengraph/#types it should
    # default to article.
    assert_equal 'article', @stub.kind
  end
  test('validates presence') do
    @stub.kind = nil
    assert ! @stub.valid?
  end
  test('validates inclusion') do
    @stub.kind = 'dupa'
    assert ! @stub.valid?
  end
end