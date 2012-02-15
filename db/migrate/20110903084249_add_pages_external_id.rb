class AddPagesExternalId < ActiveRecord::Migration
  def self.up
    add_column :pages, :external_id, :integer
  end

  def self.down
    remove_column :pages, :external_id
  end
end