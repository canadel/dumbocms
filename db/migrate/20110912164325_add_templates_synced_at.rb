class AddTemplatesSyncedAt < ActiveRecord::Migration
  def self.up
    add_column :templates, :synced_at, :datetime
  end

  def self.down
    remove_column :templates, :synced_at
  end
end