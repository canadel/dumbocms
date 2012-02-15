class AddPagesDomainId < ActiveRecord::Migration
  def self.up
    add_column :pages, :domain_id, :integer
  end

  def self.down
    remove_column :pages, :domain_id
  end
end