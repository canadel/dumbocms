class AddAccountsPagesCount < ActiveRecord::Migration
  def self.up
    add_column :accounts, :pages_count, :integer
  end

  def self.down
    remove_column :accounts, :pages_count
  end
end