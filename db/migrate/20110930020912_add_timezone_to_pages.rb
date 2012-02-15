class AddTimezoneToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :timezone, :string
  end

  def self.down
    remove_column :pages, :timezone
  end
end
