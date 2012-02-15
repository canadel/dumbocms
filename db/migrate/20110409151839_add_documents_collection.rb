class AddDocumentsCollection < ActiveRecord::Migration
  def self.up
    add_column :documents, :collection_id, :integer
  end

  def self.down
    remove_column :documents, :collection
  end
end