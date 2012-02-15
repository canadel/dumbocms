class RenameDocumentsContentHtml < ActiveRecord::Migration
  def self.up
    rename_column :documents, :content_html, :raw
  end

  def self.down
    rename_column :documents, :raw, :content_html
  end
end