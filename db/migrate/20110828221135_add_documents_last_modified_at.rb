class AddDocumentsLastModifiedAt < ActiveRecord::Migration
  def self.up
    add_column :documents, :last_modified_at, :datetime
  end

  def self.down
    remove_column :documents, :last_modified_at
  end
end