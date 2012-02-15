class DropPages < ActiveRecord::Migration
  def self.up
    drop_table :pages
  end

  def self.down
  end
end
