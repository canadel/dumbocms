class CreateBulkImports < ActiveRecord::Migration
  def self.up
    create_table :bulk_imports do |t|
      t.integer :account_id
      t.string :state
      t.text :output
      t.timestamps
    end
  end

  def self.down
    drop_table :bulk_imports
  end
end
