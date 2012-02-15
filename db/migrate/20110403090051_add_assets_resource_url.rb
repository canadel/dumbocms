class AddAssetsResourceUrl < ActiveRecord::Migration
  def self.up
    add_column :assets, :resource_url, :string
  end

  def self.down
    remove_column :assets, :resource_url
  end
end