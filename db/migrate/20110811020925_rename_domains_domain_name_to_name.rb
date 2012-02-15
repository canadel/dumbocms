class RenameDomainsDomainNameToName < ActiveRecord::Migration
  def self.up
    rename_column :domains, :domain_name, :name
  end

  def self.down
    rename_column :domains, :name, :domain_name
  end
end