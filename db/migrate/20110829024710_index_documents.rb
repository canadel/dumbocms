class IndexDocuments < ActiveRecord::Migration
  def self.up
    add_index :documents, :parent_id
    add_index :documents, :category_id
  end

  def self.down
    remove_index :documents, :category_id
    remove_index :documents, :parent_id
  end
end