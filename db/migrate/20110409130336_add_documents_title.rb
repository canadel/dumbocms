class AddDocumentsTitle < ActiveRecord::Migration
  def self.up
    add_column :documents, :title, :string
  end

  def self.down
    remove_column :documents, :title
  end
end