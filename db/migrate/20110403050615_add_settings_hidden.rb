class AddSettingsHidden < ActiveRecord::Migration
  def self.up
    add_column :settings, :hidden, :boolean
  end

  def self.down
    remove_column :settings, :hidden
  end
end