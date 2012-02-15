class ChangeSitesCustomerIdToAccountId < ActiveRecord::Migration
  def self.up
    rename_column :sites, :customer_id, :account_id
  end

  def self.down
    rename_column :sites, :account_id, :customer_id
  end
end