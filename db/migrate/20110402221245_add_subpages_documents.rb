class AddSubpagesDocuments < ActiveRecord::Migration
  def self.up
    add_column :subpages, :documents, :string
  end

  def self.down
    remove_column :subpages, :documents
  end
end