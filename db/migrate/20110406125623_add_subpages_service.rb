class AddSubpagesService < ActiveRecord::Migration
  def self.up
    add_column :subpages, :service_id, :integer
  end

  def self.down
    remove_column :subpages, :service_id
  end
end