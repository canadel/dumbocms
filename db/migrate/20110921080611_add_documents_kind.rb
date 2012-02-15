class AddDocumentsKind < ActiveRecord::Migration
  def self.up
    add_column :documents, :kind, :string
  end

  def self.down
    remove_column :documents, :kind
  end
end