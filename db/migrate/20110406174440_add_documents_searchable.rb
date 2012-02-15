class AddDocumentsSearchable < ActiveRecord::Migration
  def self.up
    add_column :documents, :searchable, :boolean
  end

  def self.down
    remove_column :documents, :searchable
  end
end