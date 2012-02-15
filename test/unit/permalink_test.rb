require 'test_helper'

class PermalinkTest < ActiveSupport::TestCase
  def setup
    @permalink = FactoryGirl.build(:permalink)
  end

  test("should create") { FactoryGirl.create(:permalink) }
  
  # Ensure that correct patches do match.
  test "should return matching" do
    link = FactoryGirl.create(:permalink, :path => '/foo')
    assert_equal link, Permalink.matching('/foo')
  end
  
  # Ensure that incorrect pathes do not match.
  test("should not return matching") do
    assert Permalink.matching('/x').nil?
  end
  
  # TODO unique per domain
  # TODO hidden?
  # TODO url
end
