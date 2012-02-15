class IndexDomainsPreferred < ActiveRecord::Migration
  def self.up
    add_index :domains, :preferred
  end

  def self.down
    remove_index :domains, :preferred
  end
end