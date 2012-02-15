class AddPagesDocumentsExternalId < ActiveRecord::Migration
  def self.up
    add_column :pages, :documents_external_id, :integer
  end

  def self.down
    remove_column :pages, :documents_external_id
  end
end