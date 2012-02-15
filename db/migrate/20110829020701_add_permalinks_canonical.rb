class AddPermalinksCanonical < ActiveRecord::Migration
  def self.up
    add_column :permalinks, :canonical, :boolean
  end

  def self.down
    remove_column :permalinks, :canonical
  end
end