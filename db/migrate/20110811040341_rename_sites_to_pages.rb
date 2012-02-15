class RenameSitesToPages < ActiveRecord::Migration
  def self.up
    rename_table :sites, :pages
  end

  def self.down
    rename_table :pages, :sites
  end
end