class RemoveServices < ActiveRecord::Migration
  def self.up
    drop_table :services
  end

  def self.down
  end
end
