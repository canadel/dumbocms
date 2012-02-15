class AddDocumentsEditedAt < ActiveRecord::Migration
  def self.up
    add_column :documents, :edited_at, :datetime
  end

  def self.down
    remove_column :documents, :edited_at
  end
end