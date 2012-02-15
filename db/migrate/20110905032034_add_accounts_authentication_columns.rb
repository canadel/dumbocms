class AddAccountsAuthenticationColumns < ActiveRecord::Migration
  def self.up
    add_column :accounts, :admin, :boolean rescue nil
    add_column :accounts, :crypted_password, :string rescue nil
  end

  def self.down
    remove_column :accounts, :crypted_password
    remove_column :accounts, :admin
  end
end