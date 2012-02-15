class DropDomainsWildcard < ActiveRecord::Migration
  def self.up
    remove_column :domains, :wildcard
  end

  def self.down
    add_column :domains, :wildcard, :boolean
  end
end
