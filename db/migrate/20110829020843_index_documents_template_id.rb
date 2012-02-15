class IndexDocumentsTemplateId < ActiveRecord::Migration
  def self.up
    add_index :documents, :template_id
  end

  def self.down
    remove_index :documents, :template_id
  end
end