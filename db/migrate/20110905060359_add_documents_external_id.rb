class AddDocumentsExternalId < ActiveRecord::Migration
  def self.up
    add_column :documents, :external_id, :integer
  end

  def self.down
    remove_column :documents, :external_id
  end
end