class AddBulkImportsPaperclip < ActiveRecord::Migration
  def self.up
    add_column :bulk_imports, :csv_file_name, :string
    add_column :bulk_imports, :csv_file_content_type, :string
    add_column :bulk_imports, :csv_file_size, :integer
    add_column :bulk_imports, :csv_updated_at, :datetime
  end

  def self.down
    remove_column :bulk_imports, :csv_updated_at
    remove_column :bulk_imports, :csv_file_size
    remove_column :bulk_imports, :csv_file_content_type
    remove_column :bulk_imports, :csv_file_name
  end
end