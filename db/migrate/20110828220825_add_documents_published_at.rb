class AddDocumentsPublishedAt < ActiveRecord::Migration
  def self.up
    add_column :documents, :published_at, :datetime
  end

  def self.down
    remove_column :documents, :published_at
  end
end