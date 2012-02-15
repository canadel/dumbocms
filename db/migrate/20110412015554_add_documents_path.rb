class AddDocumentsPath < ActiveRecord::Migration
  def self.up
    add_column :documents, :path, :string
  end

  def self.down
    remove_column :documents, :path
  end
end