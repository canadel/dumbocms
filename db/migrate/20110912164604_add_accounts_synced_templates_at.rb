class AddAccountsSyncedTemplatesAt < ActiveRecord::Migration
  def self.up
    add_column :accounts, :synced_templates_at, :datetime
  end

  def self.down
    remove_column :accounts, :synced_templates_at
  end
end