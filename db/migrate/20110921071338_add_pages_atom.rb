class AddPagesAtom < ActiveRecord::Migration
  def self.up
    add_column :pages, :atom, :boolean
  end

  def self.down
    remove_column :pages, :atom
  end
end