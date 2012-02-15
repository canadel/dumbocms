class RemoveDocumentsServices < ActiveRecord::Migration
  def self.up
    remove_column :pages, :services
  end

  def self.down
    add_column :pages, :services, :string
  end
end
