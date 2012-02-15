class RenameDocumentsPageIdToSiteId < ActiveRecord::Migration
  def self.up
    remove_column :documents, :page_id
    add_column :documents, :site_id, :integer
  end

  def self.down
  end
end