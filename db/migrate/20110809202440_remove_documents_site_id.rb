class RemoveDocumentsSiteId < ActiveRecord::Migration
  def self.up
    remove_column :documents, :site_id
  end

  def self.down
    add_column :documents, :site_id, :integer
  end
end
