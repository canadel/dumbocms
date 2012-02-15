class AddAccountsRole < ActiveRecord::Migration
  def self.up
    add_column :accounts, :role, :string
  end

  def self.down
    remove_column :accounts, :role
  end
end