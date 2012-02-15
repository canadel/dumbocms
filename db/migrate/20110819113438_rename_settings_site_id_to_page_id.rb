class RenameSettingsSiteIdToPageId < ActiveRecord::Migration
  def self.up
    rename_column :settings, :site_id, :page_id
  end

  def self.down
    rename_column :settings, :page_id, :site_id
  end
end