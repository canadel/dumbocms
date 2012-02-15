class DropEdgesDomainId < ActiveRecord::Migration
  def self.up
    remove_column :edges, :domain_id
  end

  def self.down
    add_column :edges, :domain_id, :integer
  end
end
