class SetTemplatesSyncedAt < ActiveRecord::Migration
  def self.up
    Template.update_all ['synced_at = ?', Time.now]
  end

  def self.down
  end
end
