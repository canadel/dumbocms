class CleanupPages < ActiveRecord::Migration
  def self.up
    remove_column :pages, :deprecated_domain
    remove_column :pages, :domain_names_hash
    remove_column :pages, :path
  end

  def self.down
    add_column :pages, :path, :string
    add_column :pages, :domain_names_hash, :string
    add_column :pages, :deprecated_domain, :string
  end
end
