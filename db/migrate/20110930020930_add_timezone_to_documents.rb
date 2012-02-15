class AddTimezoneToDocuments < ActiveRecord::Migration
  def self.up
    add_column :documents, :timezone, :string
  end

  def self.down
    remove_column :documents, :timezone
  end
end
