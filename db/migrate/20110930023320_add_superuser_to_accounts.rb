class AddSuperuserToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :super_user, :boolean
  end

  def self.down
    remove_column :accounts, :super_user
  end
end
