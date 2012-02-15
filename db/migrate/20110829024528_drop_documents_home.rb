class DropDocumentsHome < ActiveRecord::Migration
  def self.up
    remove_column :documents, :home
  end

  def self.down
    add_column :documents, :home, :boolean
  end
end
