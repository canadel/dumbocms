class AddEdgesPathIndex < ActiveRecord::Migration
  def self.up
    add_index :edges, :path
  end

  def self.down
    remove_index :edges, :path
  end
end