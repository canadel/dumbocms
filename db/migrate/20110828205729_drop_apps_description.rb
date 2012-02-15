class DropAppsDescription < ActiveRecord::Migration
  def self.up
    remove_column :apps, :description
  end

  def self.down
    add_column :apps, :description, :string
  end
end
