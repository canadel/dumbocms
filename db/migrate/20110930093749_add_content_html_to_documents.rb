class AddContentHtmlToDocuments < ActiveRecord::Migration
  def self.up
    add_column :documents, :content_html, :text
  end

  def self.down
    remove_column :documents, :content_html
  end
end
