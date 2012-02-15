class AddResourcesPageId < ActiveRecord::Migration
  def self.up
    add_column :resources, :page_id, :integer
  end

  def self.down
    remove_column :resources, :page_id
  end
end