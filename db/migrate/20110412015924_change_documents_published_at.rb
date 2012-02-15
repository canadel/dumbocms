class ChangeDocumentsPublishedAt < ActiveRecord::Migration
  def self.up
    change_column :documents, :published_at, :datetime
  end

  def self.down
    change_column :documents, :published_at, :string
  end
end