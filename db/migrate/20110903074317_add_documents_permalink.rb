class AddDocumentsPermalink < ActiveRecord::Migration
  def self.up
    add_column :documents, :permalink_id, :integer
  end

  def self.down
    remove_column :documents, :permalink_id
  end
end