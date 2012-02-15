class RenameDocumentsHashToDocumentsContentHash < ActiveRecord::Migration
  def self.up
    rename_column :documents, :hash, :content_hash
  end

  def self.down
    rename_column :documents, :content_hash, :hash
  end
end