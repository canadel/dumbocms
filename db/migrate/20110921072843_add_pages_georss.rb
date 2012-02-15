class AddPagesGeorss < ActiveRecord::Migration
  def self.up
    add_column :pages, :georss, :boolean
    
    Page.reset_column_information
    Page.all.each do |pg|
      pg.georss = pg.rss?
      pg.save(:validate => false)
    end
  end

  def self.down
    remove_column :pages, :georss
  end
end