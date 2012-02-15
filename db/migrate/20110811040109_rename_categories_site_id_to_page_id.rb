class RenameCategoriesSiteIdToPageId < ActiveRecord::Migration
  def self.up
    rename_column :categories, :site_id, :page_id
  end

  def self.down
    rename_column :categories, :page_id, :site_id
  end
end