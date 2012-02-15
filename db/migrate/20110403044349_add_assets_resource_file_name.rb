class AddAssetsResourceFileName < ActiveRecord::Migration
  def self.up
    add_column :assets, :resource_file_name, :string
  end

  def self.down
    remove_column :assets, :resource_file_name
  end
end