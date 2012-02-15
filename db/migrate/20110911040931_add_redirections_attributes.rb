class AddRedirectionsAttributes < ActiveRecord::Migration
  def self.up
    add_column :redirections, :page_id, :integer
    add_column :redirections, :domain_id, :integer
  end

  def self.down
    remove_column :redirections, :domain_id
    remove_column :redirections, :page_id
  end
end