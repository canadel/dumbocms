class AddPagesHttpServer < ActiveRecord::Migration
  def self.up
    add_column :pages, :http_server, :string
  end

  def self.down
    remove_column :pages, :http_server
  end
end