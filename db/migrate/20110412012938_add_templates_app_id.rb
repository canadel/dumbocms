class AddTemplatesAppId < ActiveRecord::Migration
  def self.up
    add_column :templates, :app_id, :integer
  end

  def self.down
    remove_column :templates, :app_id
  end
end