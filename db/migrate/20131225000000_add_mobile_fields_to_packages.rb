class AddMobileFieldsToPackages < ActiveRecord::Migration
  def self.up
    add_column :packages, :mobile, :boolean
    add_column :packages, :mobile_package_id, :integer
  end

  def self.down
    remove_column :packages, :mobile
    remove_column :packages, :mobile_id
  end
end
