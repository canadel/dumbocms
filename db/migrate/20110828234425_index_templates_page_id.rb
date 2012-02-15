class IndexTemplatesPageId < ActiveRecord::Migration
  def self.up
    add_index :templates, :page_id
  end

  def self.down
    remove_index :templates, :page_id
  end
end