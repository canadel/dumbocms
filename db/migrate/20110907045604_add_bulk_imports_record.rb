class AddBulkImportsRecord < ActiveRecord::Migration
  def self.up
    add_column :bulk_imports, :record, :string
  end

  def self.down
    remove_column :bulk_imports, :record
  end
end