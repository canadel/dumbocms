class AddPagesLabel < ActiveRecord::Migration
  def self.up
    add_column :pages, :label, :string
  end

  def self.down
    remove_column :pages, :label
  end
end