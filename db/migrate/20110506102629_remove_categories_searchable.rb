class RemoveCategoriesSearchable < ActiveRecord::Migration
  def self.up
    remove_column :categories, :searchable
  end

  def self.down
    add_column :categories, :searchable, :boolean
  end
end
