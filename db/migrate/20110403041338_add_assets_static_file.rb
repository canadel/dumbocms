class AddAssetsStaticFile < ActiveRecord::Migration
  def self.up
    add_column :assets, :static_file, :string
  end

  def self.down
    remove_column :assets, :static_file
  end
end