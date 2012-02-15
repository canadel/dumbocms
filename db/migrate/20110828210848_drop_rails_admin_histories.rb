class DropRailsAdminHistories < ActiveRecord::Migration
  def self.up
    drop_table :rails_admin_histories
  end

  def self.down
  end
end
