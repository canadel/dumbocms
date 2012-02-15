class SetAccountsSyncedTemplatesAt < ActiveRecord::Migration
  def self.up
    Account.update_all ['synced_templates_at = ?', Time.now]
  end

  def self.down
  end
end
