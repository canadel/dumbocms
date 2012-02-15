class DropSubpagesSecondTime < ActiveRecord::Migration
  def self.up
    drop_table :subpages
  end

  def self.down
  end
end
