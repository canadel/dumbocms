class AddTemplatesAccountId < ActiveRecord::Migration
  def self.up
    add_column :templates, :account_id, :integer
  end

  def self.down
    remove_column :templates, :account_id
  end
end