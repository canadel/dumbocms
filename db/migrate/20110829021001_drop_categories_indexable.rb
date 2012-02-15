class DropCategoriesIndexable < ActiveRecord::Migration
  def self.up
    remove_column :categories, :indexable
  end

  def self.down
    add_column :categories, :indexable, :boolean
  end
end
