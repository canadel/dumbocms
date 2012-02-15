class AddDocumentsPathIndex < ActiveRecord::Migration
  def self.up
    add_index :documents, :path
  end

  def self.down
    remove_index :documents, :path
  end
end