class RemoveCarrierwave < ActiveRecord::Migration
  def self.up
    remove_column :assets, :resource
    remove_column :assets, :resource_file_name
  end

  def self.down
    add_column :assets, :resource_file_name, :string
    add_column :assets, :resource, :string
  end
end
