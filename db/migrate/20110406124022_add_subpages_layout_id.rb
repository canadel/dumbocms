class AddSubpagesLayoutId < ActiveRecord::Migration
  def self.up
    add_column :subpages, :layout_id, :integer
  end

  def self.down
    remove_column :subpages, :layout_id
  end
end