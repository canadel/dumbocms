require File.expand_path('../../test_helper', __FILE__)

class DocumentGeoTest < ActiveSupport::TestCase
  def setup
    @stub = build(:document)
  end
  
  test("setup") do
    assert @stub.longitude.nil?
    assert @stub.latitude.nil?
  end
  test("geo? false") do
    assert_equal false, @stub.geo?
    assert_equal false, @stub.coordinates?
    
    @stub.latitude = 52.229676
    assert_equal false, @stub.geo?
    assert_equal false, @stub.coordinates?
  end
  test("geo? true") do
    @stub.latitude = 52.229676
    @stub.longitude = 21.012229
    
    assert_equal true, @stub.geo?
    assert_equal true, @stub.coordinates?
  end
  
  test('geo empty') do
    assert_equal nil, @stub.geo
    assert_equal nil, @stub.coordinates
  end
  test('geo') do
    @stub.latitude = 52.229676
    @stub.longitude = 21.012229
    
    assert_equal [52.229676, 21.012229], @stub.geo
    assert_equal [52.229676, 21.012229], @stub.coordinates
  end
end