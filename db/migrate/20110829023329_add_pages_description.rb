class AddPagesDescription < ActiveRecord::Migration
  def self.up
    add_column :pages, :description, :string
  end

  def self.down
    remove_column :pages, :description
  end
end