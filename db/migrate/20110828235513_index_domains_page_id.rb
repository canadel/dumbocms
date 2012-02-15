class IndexDomainsPageId < ActiveRecord::Migration
  def self.up
    add_index :domains, :page_id
  end

  def self.down
    remove_index :domains, :page_id
  end
end