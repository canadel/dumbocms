class AddSubpagesTag < ActiveRecord::Migration
  def self.up
    add_column :subpages, :tag, :string
  end

  def self.down
    remove_column :subpages, :tag
  end
end