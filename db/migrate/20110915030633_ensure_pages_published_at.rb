class EnsurePagesPublishedAt < ActiveRecord::Migration
  def self.up
    Page.update_all ['published_at = ?', Time.now]
  end

  def self.down
    Page.update_all ['published_at = ?', nil]
  end
end