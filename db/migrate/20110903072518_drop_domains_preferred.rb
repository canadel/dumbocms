class DropDomainsPreferred < ActiveRecord::Migration
  def self.up
    remove_column :domains, :preferred
  end

  def self.down
    add_column :domains, :preferred, :boolean
  end
end
