class MigratePagesFeed < ActiveRecord::Migration
  def self.up
    Page.all.each do |pg|
      pg.atom = pg.rss = pg.feed?
      pg.save(:validate => false)
    end
  end

  def self.down
  end
end
