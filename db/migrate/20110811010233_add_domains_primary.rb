class AddDomainsPrimary < ActiveRecord::Migration
  def self.up
    add_column :domains, :primary, :boolean
  end

  def self.down
    remove_column :domains, :primary
  end
end