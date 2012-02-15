class RemoveCategoriesFeed < ActiveRecord::Migration
  def self.up
    remove_column :categories, :feed
  end

  def self.down
    add_column :categories, :feed, :boolean
  end
end
