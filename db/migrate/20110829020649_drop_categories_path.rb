class DropCategoriesPath < ActiveRecord::Migration
  def self.up
    remove_column :categories, :path
  end

  def self.down
    add_column :categories, :path, :string
  end
end
