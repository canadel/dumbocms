class DropTemplatesPage < ActiveRecord::Migration
  def self.up
    remove_column :templates, :page_id
  end

  def self.down
    add_column :templates, :page_id, :integer
  end
end
