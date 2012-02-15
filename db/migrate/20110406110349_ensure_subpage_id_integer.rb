class EnsureSubpageIdInteger < ActiveRecord::Migration
  def self.up
    remove_column :subpages, :page_id
    add_column :subpages, :page_id, :integer
  end

  def self.down
    remove_column :subpages, :page_id
    add_column :subpages, :page_id, :string
  end
end