class IndexPagesAccountId < ActiveRecord::Migration
  def self.up
    add_index :pages, :account_id
  end

  def self.down
    remove_index :pages, :account_id
  end
end