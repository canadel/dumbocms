class RenameEdgesToPermalinks < ActiveRecord::Migration
  def self.up
    rename_table :edges, :permalinks
  end

  def self.down
    rename_table :permalinks, :edges
  end
end