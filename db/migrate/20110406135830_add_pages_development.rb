class AddPagesDevelopment < ActiveRecord::Migration
  def self.up
    add_column :pages, :production, :boolean
  end

  def self.down
    remove_column :pages, :production
  end
end