class AddCollectionsTemplateId < ActiveRecord::Migration
  def self.up
    add_column :collections, :template_id, :integer
  end

  def self.down
    remove_column :collections, :template_id
  end
end