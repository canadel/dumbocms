class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.integer :page_id
      t.string :name
      t.string :slug
      t.text :content
      t.text :content_html
      t.string :markup
      t.timestamps
    end
  end

  def self.down
    drop_table :documents
  end
end
