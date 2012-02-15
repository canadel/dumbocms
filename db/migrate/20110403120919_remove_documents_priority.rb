class RemoveDocumentsPriority < ActiveRecord::Migration
  def self.up
    remove_column :documents, :priority
  end

  def self.down
    add_column :documents, :priority, :integer
  end
end
