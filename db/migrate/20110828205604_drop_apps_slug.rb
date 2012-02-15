class DropAppsSlug < ActiveRecord::Migration
  def self.up
    remove_column :apps, :slug
  end

  def self.down
    add_column :apps, :slug, :string
  end
end
