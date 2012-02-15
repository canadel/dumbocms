require File.expand_path('../../test_helper', __FILE__)

class PermalinkTest < ActiveSupport::TestCase
  def setup
    @permalink = build(:permalink)
  end

  test("should create") { create(:permalink) }
  
  # Ensure that correct patches do match.
  test "should return matching" do
    link = create(:permalink, :path => '/foo')
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
