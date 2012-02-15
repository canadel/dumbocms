class DropPermalinksCanonical < ActiveRecord::Migration
  def self.up
    remove_column :permalinks, :canonical
  end

  def self.down
    add_column :permalinks, :canonical, :boolean
  end
end