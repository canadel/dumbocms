class RenameCollectionsToCategories < ActiveRecord::Migration
  def self.up
    rename_table :collections, :categories
  end

  def self.down
    rename_table :categories, :collections
  end
end