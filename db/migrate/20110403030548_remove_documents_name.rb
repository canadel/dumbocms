class RemoveDocumentsName < ActiveRecord::Migration
  def self.up
    remove_column :documents, :name
  end

  def self.down
    add_column :documents, :name, :string
  end
end
