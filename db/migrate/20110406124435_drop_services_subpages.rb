class DropServicesSubpages < ActiveRecord::Migration
  def self.up
    drop_table :services_subpages
  end

  def self.down
    # TODO
  end
end
