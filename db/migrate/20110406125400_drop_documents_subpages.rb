class DropDocumentsSubpages < ActiveRecord::Migration
  def self.up
    drop_table :documents_subpages
  end

  def self.down
    # TODO
  end
end
