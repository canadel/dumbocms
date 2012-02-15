class AddBulkImportsDomainIds < ActiveRecord::Migration
  def self.up
    add_column :bulk_imports, :domain_ids, :text
  end

  def self.down
    remove_column :bulk_imports, :domain_ids
  end
end