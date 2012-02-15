class AddPagesServices < ActiveRecord::Migration
  def self.up
    add_column :pages, :services, :string
  end

  def self.down
    remove_column :pages, :services
  end
end