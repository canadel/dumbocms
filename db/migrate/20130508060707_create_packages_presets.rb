class CreatePackagesPresets < ActiveRecord::Migration
  def self.up
    create_table :packages_presets, :id => false do |t|
      t.references :package
      t.references :preset
    end
  end

  def self.down
    drop_table :packages_presets
  end
end
