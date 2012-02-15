class AddDocumentsPublished < ActiveRecord::Migration
  def self.up
    add_column :documents, :published, :boolean
    add_column :documents, :published_at, :boolean
  end

  def self.down
    remove_column :documents, :published_at
    remove_column :documents, :published
  end
end