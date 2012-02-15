class DropPageIdFromResources < ActiveRecord::Migration
  def self.up
    remove_column :resources, :page_id
  end

  def self.down
    add_column :resources, :page_id, :integer
  end
end
