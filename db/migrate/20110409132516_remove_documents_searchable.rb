class RemoveDocumentsSearchable < ActiveRecord::Migration
  def self.up
    remove_column :documents, :searchable
  end

  def self.down
    add_column :documents, :searchable, :boolean
  end
end
