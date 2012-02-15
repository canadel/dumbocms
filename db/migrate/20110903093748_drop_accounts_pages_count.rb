class DropAccountsPagesCount < ActiveRecord::Migration
  def self.up
    remove_column :accounts, :pages_count
  end

  def self.down
  end
end
