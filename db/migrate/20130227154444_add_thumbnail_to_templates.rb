class AddThumbnailToTemplates < ActiveRecord::Migration
  def self.up
    add_column :templates, :thumbnail, :string
    add_column :templates, :published, :boolean
  end
  
  def self.down
    remove_column :templates, :thumbnail
    remove_column :templates, :published
  end
end
