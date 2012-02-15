class ChangeDocumentsContentToText < ActiveRecord::Migration
  def self.up
    # change_column :documents, :content, :text, :limit => 65.kilobytes
  end

  def self.down
    # change_column :documents, :content, :binary
  end
end