class IndexDocumentsSlug < ActiveRecord::Migration
  def self.up
    add_index :documents, :slug
  end

  def self.down
    remove_index :documents, :slug
  end
end