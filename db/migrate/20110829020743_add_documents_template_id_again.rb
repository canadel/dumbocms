class AddDocumentsTemplateIdAgain < ActiveRecord::Migration
  def self.up
    add_column :documents, :template_id, :integer
  end

  def self.down
    remove_column :documents, :template_id
  end
end