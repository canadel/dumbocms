class DropResources < ActiveRecord::Migration
  def self.up
    drop_table :resources
  end

  def self.down
  end
end
