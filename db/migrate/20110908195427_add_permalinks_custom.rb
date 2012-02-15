class AddPermalinksCustom < ActiveRecord::Migration
  def self.up
    add_column :permalinks, :custom, :boolean
  end

  def self.down
    remove_column :permalinks, :custom
  end
end