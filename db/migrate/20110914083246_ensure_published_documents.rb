# A somewhat hacky migration that ensures that all documents on the
# production are published.
class EnsurePublishedDocuments < ActiveRecord::Migration
  def self.up
    Document.all.each do |document|
      document.update_attribute(:published_at, document.updated_at)
    end
  end

  def self.down
  end
end
