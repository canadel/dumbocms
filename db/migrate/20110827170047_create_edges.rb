class CreateEdges < ActiveRecord::Migration
  def self.up
    create_table :edges do |t|
      t.string :path
      t.integer :domain_id
      t.integer :document_id
      t.integer :priority
      t.timestamps
    end
  end

  def self.down
    drop_table :edges
  end
end
