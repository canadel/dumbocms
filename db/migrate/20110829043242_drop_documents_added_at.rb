class DropDocumentsAddedAt < ActiveRecord::Migration
  def self.up
    remove_column :documents, :added_at
  end

  def self.down
    add_column :documents, :added_at, :datetime
  end
end
