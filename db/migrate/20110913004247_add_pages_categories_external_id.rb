class AddPagesCategoriesExternalId < ActiveRecord::Migration
  def self.up
    add_column :pages, :categories_external_id, :integer
  end

  def self.down
    remove_column :pages, :categories_external_id
  end
end