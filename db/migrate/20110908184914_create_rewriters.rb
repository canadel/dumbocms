class CreateRewriters < ActiveRecord::Migration
  def self.up
    create_table :rewriters do |t|
      t.string :match
      t.string :pattern
      t.string :replacement
      t.integer :position
      t.timestamps
    end
  end

  def self.down
    drop_table :rewriters
  end
end
