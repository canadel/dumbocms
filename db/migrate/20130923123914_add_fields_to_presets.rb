class AddFieldsToPresets < ActiveRecord::Migration
  def self.up
    add_column :presets, :category_id, :integer
    add_column :presets, :latitude, :decimal
    add_column :presets, :longitude, :decimal
  end

  def self.down
    remove_column :presets, :category_id
    remove_column :presets, :latitude
    remove_column :presets, :longitude
  end
end
