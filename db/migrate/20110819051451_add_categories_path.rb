class AddCategoriesPath < ActiveRecord::Migration
  def self.up
    add_column :categories, :path, :string
  end

  def self.down
    remove_column :categories, :path
  end
end