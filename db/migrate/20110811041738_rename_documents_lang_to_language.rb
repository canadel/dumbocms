class RenameDocumentsLangToLanguage < ActiveRecord::Migration
  def self.up
    rename_column :documents, :lang, :language
  end

  def self.down
    rename_column :documents, :language, :lang
  end
end