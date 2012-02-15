class AddCategoriesAdvancedIndexable < ActiveRecord::Migration
  def self.up
    add_column :categories, :advanced_indexable, :boolean
  end

  def self.down
    remove_column :categories, :advanced_indexable
  end
end