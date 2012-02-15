class AddSubpagesContentType2 < ActiveRecord::Migration
  def self.up
    add_column :subpages, :content_type, :string
  end

  def self.down
    remove_column :subpages, :content_type
  end
end