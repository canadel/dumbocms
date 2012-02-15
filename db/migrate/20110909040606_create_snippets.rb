class CreateSnippets < ActiveRecord::Migration
  def self.up
    create_table :snippets do |t|
      t.string :slug
      t.text :content
      t.integer :page_id
      t.timestamps
    end
  end

  def self.down
    drop_table :snippets
  end
end
