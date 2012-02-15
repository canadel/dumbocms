class AddDomainsIndices < ActiveRecord::Migration
  def self.up
    add_index :domains, :domain_name
  end

  def self.down
    remove_index :domains, :domain_name
  end
end