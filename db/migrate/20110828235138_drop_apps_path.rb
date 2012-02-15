class DropAppsPath < ActiveRecord::Migration
  def self.up
    remove_column :apps, :path
  end

  def self.down
    add_column :apps, :path, :string
  end
end
