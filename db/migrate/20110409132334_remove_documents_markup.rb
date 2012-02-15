class RemoveDocumentsMarkup < ActiveRecord::Migration
  def self.up
    remove_column :documents, :markup
  end

  def self.down
    add_column :documents, :markup, :string
  end
end
