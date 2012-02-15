class AddClientsEmail < ActiveRecord::Migration
  def self.up
    add_column :clients, :email, :string
  end

  def self.down
    remove_column :clients, :email
  end
end