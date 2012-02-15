class IndexPermalinksCanonical < ActiveRecord::Migration
  def self.up
    add_index :permalinks, :canonical
  end

  def self.down
    remove_index :permalinks, :canonical
  end
end