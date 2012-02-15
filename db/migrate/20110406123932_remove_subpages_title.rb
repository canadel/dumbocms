class RemoveSubpagesTitle < ActiveRecord::Migration
  def self.up
    remove_column :subpages, :title
  end

  def self.down
    add_column :subpages, :title, :string
  end
end
