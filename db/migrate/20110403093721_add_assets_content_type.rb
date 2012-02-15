class AddAssetsContentType < ActiveRecord::Migration
  def self.up
    add_column :assets, :content_type, :string
  end

  def self.down
    remove_column :assets, :content_type
  end
end