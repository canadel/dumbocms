class RenameTemplatesSlug < ActiveRecord::Migration
  def self.up
    rename_column :templates, :slug, :name
  end

  def self.down
    rename_column :templates, :name, :slug
  end
end