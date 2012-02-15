class RenameCustomersToAccounts < ActiveRecord::Migration
  def self.up
    rename_table :customers, :accounts
  end

  def self.down
    rename_table :accounts, :customers
  end
end