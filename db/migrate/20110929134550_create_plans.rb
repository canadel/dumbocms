class CreatePlans < ActiveRecord::Migration
  def self.up
    create_table :plans do |t|
      t.string :name
      t.integer :domains_limit
      t.integer :pages_limit
      t.integer :storage_limit
      t.integer :users_limit
      t.integer :templates_limit

      t.timestamps
    end
  end

  def self.down
    drop_table :plans
  end
end
