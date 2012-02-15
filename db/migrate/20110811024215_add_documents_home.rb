class AddDocumentsHome < ActiveRecord::Migration
  def self.up
    add_column :documents, :home, :boolean
  end

  def self.down
    remove_column :documents, :home
  end
end