class DropPermalinksManual < ActiveRecord::Migration
  def self.up
    remove_column :permalinks, :manual
  end

  def self.down
    add_column :permalinks, :manual, :boolean
  end
end
