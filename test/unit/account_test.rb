require File.expand_path('../../test_helper', __FILE__)

class AccountTest < ActiveSupport::TestCase
  def setup
    # Ensure we do not create mess everywhere.
    @templates_path = File.expand_path('../../tmp/templates/', __FILE__)
    @templates_path = "#{@templates_path}/" # FIXME
    Rails.configuration.dumbocms.templates_path = @templates_path
    
    @account = build(:account)
  end
  
  test("should create") { build(:account) }

  test("set_role") { assert create(:account).owner_role? }
  test("role_enum") { assert Account.role_enum.any? }
  
  test("owner") do
    assert build(:account, :role => 'owner').owner_role?
  end
  
  test("synced_templates_at") do
    assert ! create(:account).synced_templates_at.nil?
  end
  test("sync! empty") do
    assert_equal true, Account.sync!
  end
  test("sync!") do
    ac = create(:account)
    assert_equal true, Account.sync!
  end
end