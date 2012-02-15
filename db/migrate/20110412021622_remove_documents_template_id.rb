class RemoveDocumentsTemplateId < ActiveRecord::Migration
  def self.up
    remove_column :documents, :template_id
  end

  def self.down
    add_column :documents, :template_id, :string
  end
end
