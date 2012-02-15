class RemoveDocumentsRaw < ActiveRecord::Migration
  def self.up
    remove_column :documents, :raw
  end

  def self.down
    add_column :documents, :raw, :text
  end
end
