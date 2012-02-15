class AddSitesProduction < ActiveRecord::Migration
  def self.up
    add_column :sites, :production, :boolean
  end

  def self.down
    remove_column :sites, :production
  end
end