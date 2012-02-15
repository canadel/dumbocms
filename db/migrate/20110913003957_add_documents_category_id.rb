class AddDocumentsCategoryId < ActiveRecord::Migration
  def self.up
    add_column :documents, :category_id, :integer
  end

  def self.down
    remove_column :documents, :category_id
  end
end