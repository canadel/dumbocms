class CreateRedirections < ActiveRecord::Migration
  def self.up
    create_table :redirections do |t|
      t.integer :page_id
      t.string :path
      t.string :destination
      t.integer :http_code
      t.timestamps
    end
  end

  def self.down
    drop_table :redirections
  end
end
