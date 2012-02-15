class DropDocumentsPath < ActiveRecord::Migration
  def self.up
    remove_column :documents, :path
  end

  def self.down
    add_column :documents, :path, :string
  end
end
