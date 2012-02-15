class DropEdgesPriority < ActiveRecord::Migration
  def self.up
    remove_column :edges, :priority
  end

  def self.down
    add_column :edges, :priority, :integer
  end
end
