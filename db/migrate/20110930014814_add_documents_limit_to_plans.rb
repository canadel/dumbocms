class AddDocumentsLimitToPlans < ActiveRecord::Migration
  def self.up
    add_column :plans, :documents_limit, :integer
  end

  def self.down
    remove_column :plans, :documents_limit
  end
end
