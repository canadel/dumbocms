class DropFiles < ActiveRecord::Migration
  def self.up
    drop_table :files
  end

  def self.down
  end
end
