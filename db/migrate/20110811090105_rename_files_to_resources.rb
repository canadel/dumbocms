class RenameFilesToResources < ActiveRecord::Migration
  def self.up
    rename_table :files, :resources rescue nil
  end

  def self.down
    rename_table :resources, :files
  end
end