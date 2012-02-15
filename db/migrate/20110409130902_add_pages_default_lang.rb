class AddPagesDefaultLang < ActiveRecord::Migration
  def self.up
    add_column :pages, :default_lang, :string
  end

  def self.down
    remove_column :pages, :default_lang
  end
end