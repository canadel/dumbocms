class IndexAccountsApiKey < ActiveRecord::Migration
  def self.up
    add_index :accounts, :api_key
  end

  def self.down
    remove_index :accounts, :api_key
  end
end