class DropSettings < ActiveRecord::Migration
  def self.up
    drop_table :settings
  end

  def self.down
  end
end
