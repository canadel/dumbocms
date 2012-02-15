class AddWildcardToDomains < ActiveRecord::Migration
  def self.up
    add_column :domains, :wildcard, :boolean
  end

  def self.down
    remove_column :domains, :wildcard
  end
end
