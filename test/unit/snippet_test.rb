require 'test_helper'

class SnippetTest < ActiveSupport::TestCase
  test("create") { assert FactoryGirl.create(:snippet).valid? }
end
