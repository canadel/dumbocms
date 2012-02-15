class RenameTemplatesSiteIdToPageId < ActiveRecord::Migration
  def self.up
    rename_column :templates, :site_id, :page_id
  end

  def self.down
    rename_column :templates, :page_id, :site_id
  end
end