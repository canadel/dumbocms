class RemoveDocumentsGlobal < ActiveRecord::Migration
  def self.up
    remove_column :documents, :global
  end

  def self.down
    add_column :documents, :global, :boolean
  end
end
