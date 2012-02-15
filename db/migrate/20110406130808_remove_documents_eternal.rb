class RemoveDocumentsEternal < ActiveRecord::Migration
  def self.up
    remove_column :documents, :eternal
  end

  def self.down
  end
end
