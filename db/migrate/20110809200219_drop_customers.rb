class DropCustomers < ActiveRecord::Migration
  def self.up
    drop_table :customers
  end

  def self.down
  end
end
