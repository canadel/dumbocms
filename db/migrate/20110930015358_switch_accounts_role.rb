class SwitchAccountsRole < ActiveRecord::Migration
  def self.up
    add_column :accounts, :plan_id, :integer
    
    plan = Plan.create!(:name => "God's Plan")
    
    Account.reset_column_information
    Account.update_all(:plan_id => plan.id)
    Account.update_all(:role => Account.default_role)
  end

  def self.down
    remove_column :accounts, :plan_id
  end
end