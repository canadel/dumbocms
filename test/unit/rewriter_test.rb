require File.expand_path('../../test_helper', __FILE__)

class RewriterTest < ActiveSupport::TestCase
  
  def setup
    @rewriter = build(:rewriter)
  end
  
  test("create") { create(:rewriter) }
  test("create position") do
    assert create(:rewriter).position == 100
  end
end
