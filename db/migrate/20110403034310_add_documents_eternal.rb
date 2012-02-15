class AddDocumentsEternal < ActiveRecord::Migration
  def self.up
    add_column :documents, :eternal, :boolean
  end

  def self.down
    remove_column :documents, :eternal
  end
end