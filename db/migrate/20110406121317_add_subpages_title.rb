class AddSubpagesTitle < ActiveRecord::Migration
  def self.up
    add_column :subpages, :title, :string
  end

  def self.down
    remove_column :subpages, :title
  end
end