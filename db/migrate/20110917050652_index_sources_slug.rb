class IndexSourcesSlug < ActiveRecord::Migration
  def self.up
    add_index :resources, :slug
  end

  def self.down
    remove_index :resources, :slug
  end
end