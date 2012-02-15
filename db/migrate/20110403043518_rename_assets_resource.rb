class RenameAssetsResource < ActiveRecord::Migration
  def self.up
    rename_column :assets, :static_file, :resource
  end

  def self.down
    rename_column :assets, :resource, :static_file
  end
end