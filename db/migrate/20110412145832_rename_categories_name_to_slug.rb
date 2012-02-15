class RenameCategoriesNameToSlug < ActiveRecord::Migration
  def self.up
    rename_column :categories, :name, :slug
  end

  def self.down
    rename_column :categories, :slug, :name
  end
end