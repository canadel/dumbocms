class IndexCategories < ActiveRecord::Migration
  def self.up
    add_index :categories, :slug
    add_index :categories, :page_id
    add_index :categories, :template_id
  end

  def self.down
    remove_index :categories, :template_id
    remove_index :categories, :page_id
    remove_index :categories, :slug
  end
end