class AddSitesDefaultLanguage < ActiveRecord::Migration
  def self.up
    add_column :sites, :default_language, :string
  end

  def self.down
    remove_column :sites, :default_language
  end
end