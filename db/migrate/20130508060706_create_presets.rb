class CreatePresets < ActiveRecord::Migration
  def self.up
    create_table :presets do |t|
      t.string     :slug
      t.string     :title
      t.text       :content
      t.references :template
      t.timestamps
    end
  end

  def self.down
    drop_table :presets
  end
end
