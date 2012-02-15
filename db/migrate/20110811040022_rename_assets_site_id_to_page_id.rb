class RenameAssetsSiteIdToPageId < ActiveRecord::Migration
  def self.up
    rename_column :assets, :site_id, :page_id
  end

  def self.down
    rename_column :assets, :page_id, :site_id
  end
end