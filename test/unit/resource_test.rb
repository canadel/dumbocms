require 'test_helper'

class ResourceTest < ActiveSupport::TestCase
  def setup
    @resource = FactoryGirl.create(:resource)
  end
  test('setup') do
    assert   @resource.valid?
    assert ! @resource.url.nil?
    assert ! @resource.slug.nil?
    assert ! @resource.name.nil?
  end
  
  test('matching slug') do
    assert_equal @resource, Resource.matching(@resource.slug)
  end
  test('matching name') do
    assert_equal @resource, Resource.matching(@resource.name)
  end
  test('matching wrong') do
    assert_equal nil, Resource.matching('foo')
  end
  test('matching nil') do
    assert_equal nil, Resource.matching(nil)
  end
end
