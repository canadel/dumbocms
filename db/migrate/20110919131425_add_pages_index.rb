class AddPagesIndex < ActiveRecord::Migration
  def self.up
    add_column :pages, :indexable, :boolean
    
    Page.reset_column_information
    Page.update_all ["indexable = ?", true]
  end

  def self.down
    remove_column :pages, :indexable
  end
end