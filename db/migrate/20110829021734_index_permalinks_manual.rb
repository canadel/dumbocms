class IndexPermalinksManual < ActiveRecord::Migration
  def self.up
    add_index :permalinks, :manual
  end

  def self.down
    remove_index :permalinks, :manual
  end
end