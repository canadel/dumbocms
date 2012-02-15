class AddBulkImportsPageIds < ActiveRecord::Migration
  def self.up
    add_column :bulk_imports, :page_ids, :text
  end

  def self.down
    remove_column :bulk_imports, :page_ids
  end
end