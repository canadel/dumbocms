class DropDocumentsFilename < ActiveRecord::Migration
  def self.up
    remove_column :documents, :filename
  end

  def self.down
  end
end
