class AddDocumentsTemplateId < ActiveRecord::Migration
  def self.up
    add_column :documents, :template_id, :string
  end

  def self.down
    remove_column :documents, :template_id
  end
end