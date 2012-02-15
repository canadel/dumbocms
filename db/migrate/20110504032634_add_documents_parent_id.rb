class AddDocumentsParentId < ActiveRecord::Migration
  def self.up
    add_column :documents, :parent_id, :integer
  end

  def self.down
    remove_column :documents, :parent_id
  end
end