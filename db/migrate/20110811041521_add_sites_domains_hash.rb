class AddSitesDomainsHash < ActiveRecord::Migration
  def self.up
    add_column :pages, :domain_names_hash, :string
  end

  def self.down
    remove_column :pages, :domain_names_hash
  end
end