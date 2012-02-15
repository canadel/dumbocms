class AddCollectionsIndexable < ActiveRecord::Migration
  def self.up
    add_column :collections, :searchable, :boolean
  end

  def self.down
    remove_column :collections, :searchable
  end
end