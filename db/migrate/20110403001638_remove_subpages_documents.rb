class RemoveSubpagesDocuments < ActiveRecord::Migration
  def self.up
    remove_column :subpages, :documents
  end

  def self.down
    add_column :subpages, :documents, :string
  end
end