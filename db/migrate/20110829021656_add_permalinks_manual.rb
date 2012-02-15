class AddPermalinksManual < ActiveRecord::Migration
  def self.up
    add_column :permalinks, :manual, :boolean
  end

  def self.down
    remove_column :permalinks, :manual
  end
end