class AddMarkupToDocuments < ActiveRecord::Migration
  def self.up
    add_column :documents, :markup, :string
  end

  def self.down
    remove_column :documents, :markup
  end
end
