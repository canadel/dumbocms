class AddClientsSlug < ActiveRecord::Migration
  def self.up
    add_column :clients, :slug, :string
  end

  def self.down
    remove_column :clients, :slug
  end
end