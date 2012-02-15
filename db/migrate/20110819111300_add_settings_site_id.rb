class AddSettingsSiteId < ActiveRecord::Migration
  def self.up
    add_column :settings, :site_id, :integer
  end

  def self.down
    remove_column :settings, :site_id
  end
end