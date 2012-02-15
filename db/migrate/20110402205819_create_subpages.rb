class CreateSubpages < ActiveRecord::Migration
  def self.up
    create_table :subpages do |t|
      t.string :page_id
      t.string :path
      t.timestamps
    end
  end

  def self.down
    drop_table :subpages
  end
end
