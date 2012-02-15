class RenameAssetsToFiles < ActiveRecord::Migration
  def self.up
    rename_table :assets, :files
  end

  def self.down
    rename_table :files, :assets
  end
end