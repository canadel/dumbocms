class AddPagesPermalinks < ActiveRecord::Migration
  def self.up
    add_column :pages, :permalinks, :string
  end

  def self.down
    remove_column :pages, :permalinks
  end
end