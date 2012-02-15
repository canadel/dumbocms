class AddRedirectionsAgain < ActiveRecord::Migration
  def self.up
    create_table :redirections, :force => true do |t|
      t.integer :account_id
      t.timestamps
    end
  end

  def self.down
    drop_table :redirections
  end
end