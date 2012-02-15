class CreateTemplates < ActiveRecord::Migration
  def self.up
    create_table :templates do |t|
      t.string :slug
      t.text :content
      t.integer :site_id
      t.timestamps
    end
  end

  def self.down
    drop_table :templates
  end
end
