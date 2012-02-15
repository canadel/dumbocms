class AddPagesAdvanced < ActiveRecord::Migration
  def self.up
    add_column :pages, :sitemap, :boolean
    add_column :pages, :feed, :boolean

    Page.update_all ['feed = ?', true]
    Page.update_all ['sitemap = ?', true]
  end

  def self.down
    remove_column :pages, :feed
    remove_column :pages, :sitemap
  end
end