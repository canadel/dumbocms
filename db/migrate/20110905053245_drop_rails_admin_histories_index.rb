class DropRailsAdminHistoriesIndex < ActiveRecord::Migration
  def self.up
    remove_index(:rails_admin_histories, [:item, :table, :month, :year])
  end

  def self.down
  end
end