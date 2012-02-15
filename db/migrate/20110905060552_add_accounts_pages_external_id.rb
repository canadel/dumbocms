class AddAccountsPagesExternalId < ActiveRecord::Migration
  def self.up
    add_column :accounts, :pages_external_id, :integer
  end

  def self.down
    remove_column :accounts, :pages_external_id
  end
end