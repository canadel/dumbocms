class AddPagesRss < ActiveRecord::Migration
  def self.up
    add_column :pages, :rss, :boolean
  end

  def self.down
    remove_column :pages, :rss
  end
end