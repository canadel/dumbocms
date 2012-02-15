class AddDocumentsPageId < ActiveRecord::Migration
  def self.up
    add_column :documents, :page_id, :integer
  end

  def self.down
    remove_column :documents, :page_id
  end
end