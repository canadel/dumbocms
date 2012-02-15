class AddSubpagesContentId < ActiveRecord::Migration
  def self.up
    add_column :subpages, :content_id, :integer
  end

  def self.down
    remove_column :subpages, :content_id
  end
end