class RenameCategoriesAdvancedAttributes < ActiveRecord::Migration
  def self.up
    rename_column :categories, :advanced_feed, :feed
    rename_column :categories, :advanced_indexable, :indexable
  end

  def self.down
    rename_column :categories, :indexable, :advanced_indexable
    rename_column :categories, :feed, :advanced_feed
  end
end