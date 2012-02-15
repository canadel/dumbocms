class AddCategoriesAdvancedFeed < ActiveRecord::Migration
  def self.up
    add_column :categories, :advanced_feed, :boolean
  end

  def self.down
    remove_column :categories, :advanced_feed
  end
end