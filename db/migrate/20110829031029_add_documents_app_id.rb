class AddDocumentsAppId < ActiveRecord::Migration
  def self.up
    add_column :documents, :app_id, :integer
  end

  def self.down
    remove_column :documents, :app_id
  end
end