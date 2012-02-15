class RemoveDocumentsPublishedAt < ActiveRecord::Migration
  def self.up
    remove_column :documents, :published_at
    remove_column :documents, :published
  end

  def self.down
    add_column :documents, :published, :boolean
    add_column :documents, :published_at, :datetime
  end
end
