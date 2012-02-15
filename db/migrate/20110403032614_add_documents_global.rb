class AddDocumentsGlobal < ActiveRecord::Migration
  def self.up
    add_column :documents, :global, :boolean
  end

  def self.down
    remove_column :documents, :global
  end
end