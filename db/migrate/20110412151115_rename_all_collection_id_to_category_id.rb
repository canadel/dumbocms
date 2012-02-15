class RenameAllCollectionIdToCategoryId < ActiveRecord::Migration
  def self.up
    rename_column :documents, :collection_id, :category_id
  end

  def self.down
    rename_column :documents, :category_id, :collection_id
  end
end