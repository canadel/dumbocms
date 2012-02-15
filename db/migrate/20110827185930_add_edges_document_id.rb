class AddEdgesDocumentId < ActiveRecord::Migration
  def self.up
    add_index :edges, :document_id
  end

  def self.down
    remove_index :edges, :document_id
  end
end