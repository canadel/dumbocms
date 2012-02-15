class AddDocumentsContentHash < ActiveRecord::Migration
  def self.up
    add_column :documents, :hash, :string
  end

  def self.down
    remove_column :documents, :hash
  end
end