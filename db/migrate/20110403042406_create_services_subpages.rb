class CreateServicesSubpages < ActiveRecord::Migration
  def self.up
    create_table :services_subpages, :id => false do |t|
      t.integer :service_id
      t.integer :subpage_id
      t.timestamps
    end
  end

  def self.down
    drop_table :services_subpages
  end
end