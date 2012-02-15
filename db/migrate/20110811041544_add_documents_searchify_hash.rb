class AddDocumentsSearchifyHash < ActiveRecord::Migration
  def self.up
    add_column :documents, :searchify_hash, :string
  end

  def self.down
    remove_column :documents, :searchify_hash
  end
end