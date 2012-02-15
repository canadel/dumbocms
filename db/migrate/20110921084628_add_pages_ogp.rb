class AddPagesOgp < ActiveRecord::Migration
  def self.up
    add_column :pages, :ogp, :boolean
  end

  def self.down
    remove_column :pages, :ogp
  end
end