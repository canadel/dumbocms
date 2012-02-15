class DropDocumentsParentId < ActiveRecord::Migration
  def self.up
    remove_column :documents, :parent_id
  end

  def self.down
    add_column :documents, :parent_id, :integer
  end
end
