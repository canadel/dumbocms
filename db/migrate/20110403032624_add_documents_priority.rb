class AddDocumentsPriority < ActiveRecord::Migration
  def self.up
    add_column :documents, :priority, :integer
  end

  def self.down
    remove_column :documents, :priority
  end
end