class AddDocumentsToken < ActiveRecord::Migration
  def self.up
    add_column :documents, :token, :string
  end

  def self.down
    remove_column :documents, :token
  end
end