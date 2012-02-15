class AddRewritersAccountId < ActiveRecord::Migration
  def self.up
    add_column :rewriters, :account_id, :integer
  end

  def self.down
    remove_column :rewriters, :account_id
  end
end