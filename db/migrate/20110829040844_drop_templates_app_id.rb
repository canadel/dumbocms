class DropTemplatesAppId < ActiveRecord::Migration
  def self.up
    remove_column :templates, :app_id
  end

  def self.down
    add_column :templates, :app_id, :integer
  end
end
