class DropDocumentsCategoryId < ActiveRecord::Migration
  def self.up
    remove_column :documents, :category_id
  end

  def self.down
    add_column :documents, :category_id, :integer
  end
end
