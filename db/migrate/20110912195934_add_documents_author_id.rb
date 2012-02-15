class AddDocumentsAuthorId < ActiveRecord::Migration
  def self.up
    add_column :documents, :author_id, :integer
  end

  def self.down
    remove_column :documents, :author_id
  end
end