require 'test_helper'

class RewriterTest < ActiveSupport::TestCase
  
  def setup
    @rewriter = FactoryGirl.build(:rewriter)
  end
  
  test("create") { FactoryGirl.create(:rewriter) }
  test("create position") do
    assert FactoryGirl.create(:rewriter).position == 100
  end
end
