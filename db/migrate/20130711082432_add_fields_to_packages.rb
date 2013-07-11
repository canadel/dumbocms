class AddFieldsToPackages < ActiveRecord::Migration
  def self.up
    add_column :packages, :label, :string
    add_column :packages, :description, :string
    add_column :packages, :thumbnail, :string
    add_column :packages, :position, :integer
    add_column :packages, :published, :boolean
  end

  def self.down
    remove_column :packages, :label
    remove_column :packages, :description
    remove_column :packages, :thumbnail
    remove_column :packages, :position
    remove_column :packages, :published
  end
end
