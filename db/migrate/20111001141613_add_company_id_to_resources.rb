class AddCompanyIdToResources < ActiveRecord::Migration
  def self.up
    add_column :resources, :company_id, :integer
  end

  def self.down
    remove_column :resources, :company_id
  end
end
