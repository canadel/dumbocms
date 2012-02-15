class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.integer :page_id
      t.integer :external_id
      t.string :permalinks
      t.string :name
      t.string :slug
      t.timestamps
    end
  end

  def self.down
    drop_table :categories
  end
end
