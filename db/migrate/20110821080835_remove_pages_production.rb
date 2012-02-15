class RemovePagesProduction < ActiveRecord::Migration
  def self.up
    remove_column :pages, :production
  end

  def self.down
    add_column :pages, :production, :boolean
  end
end
