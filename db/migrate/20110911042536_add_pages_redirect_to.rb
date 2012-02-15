class AddPagesRedirectTo < ActiveRecord::Migration
  def self.up
    add_column :pages, :redirect_to, :string
  end

  def self.down
    remove_column :pages, :redirect_to
  end
end