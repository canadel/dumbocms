class DropDocumentsContentType < ActiveRecord::Migration
  def self.up
    remove_column :documents, :content_type
  end

  def self.down
    add_column :documents, :content_type, :string
  end
end
