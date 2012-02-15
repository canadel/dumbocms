class AddSubpagesDetails < ActiveRecord::Migration
  def self.up
    add_column :subpages, :published, :boolean
    add_column :subpages, :processing, :boolean
    add_column :subpages, :published_at, :datetime
  end

  def self.down
    remove_column :subpages, :published_at
    remove_column :subpages, :processing
    remove_column :subpages, :published
  end
end