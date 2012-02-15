class RenameDomainsSiteIdPageId < ActiveRecord::Migration
  def self.up
    rename_column :domains, :site_id, :page_id
  end

  def self.down
    rename_column :domains, :page_id, :site_id
  end
end