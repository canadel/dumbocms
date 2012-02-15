class AddSubpagesSlug < ActiveRecord::Migration
  def self.up
    add_column :subpages, :slug, :string
  end

  def self.down
    remove_column :subpages, :slug
  end
end