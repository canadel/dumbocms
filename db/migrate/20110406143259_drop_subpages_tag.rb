class DropSubpagesTag < ActiveRecord::Migration
  def self.up
    remove_column :subpages, :tag
  end

  def self.down
    add_column :subpages, :tag, :string
  end
end
