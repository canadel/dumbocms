class AddDocumentsLang < ActiveRecord::Migration
  def self.up
    add_column :documents, :lang, :string
  end

  def self.down
    remove_column :documents, :lang
  end
end