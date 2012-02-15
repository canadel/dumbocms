class DropMigrationsAgain < ActiveRecord::Migration
  def self.up
    drop_table :redirections
  end

  def self.down
  end
end
