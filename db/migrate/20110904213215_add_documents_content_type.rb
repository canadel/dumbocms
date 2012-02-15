class AddDocumentsContentType < ActiveRecord::Migration
  def self.up
    add_column :documents, :content_type, :string
  end

  def self.down
    remove_column :documents, :content_type
  end
end