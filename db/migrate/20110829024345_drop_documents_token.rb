class DropDocumentsToken < ActiveRecord::Migration
  def self.up
    remove_column :documents, :token
  end

  def self.down
    add_column :documents, :token, :string
  end
end
