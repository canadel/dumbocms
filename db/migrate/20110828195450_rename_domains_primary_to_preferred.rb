class RenameDomainsPrimaryToPreferred < ActiveRecord::Migration
  def self.up
    rename_column :domains, :primary, :preferred
  end

  def self.down
    rename_column :domains, :preferred, :primary
  end
end