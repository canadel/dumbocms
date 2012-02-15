class DropDocumentsSearchifyHash < ActiveRecord::Migration
  def self.up
    remove_column :documents, :searchify_hash
  end

  def self.down
    add_column :documents, :searchify_hash, :string
  end
end
