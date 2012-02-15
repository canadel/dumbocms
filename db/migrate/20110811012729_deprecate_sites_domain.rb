class DeprecateSitesDomain < ActiveRecord::Migration
  def self.up
    rename_column :sites, :domain, :deprecated_domain
  end

  def self.down
    rename_column :sites, :deprecated_domain, :domain
  end
end