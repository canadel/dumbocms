class AddDocumentsAddedAt < ActiveRecord::Migration
  def self.up
    add_column :documents, :added_at, :datetime
  end

  def self.down
    remove_column :documents, :added_at
  end
end