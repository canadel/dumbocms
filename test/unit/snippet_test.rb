require File.expand_path('../../test_helper', __FILE__)

class SnippetTest < ActiveSupport::TestCase
  test("create") { assert create(:snippet).valid? }
end
