class AddCompanyIdToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :company_id, :integer
  end

  def self.down
    remove_column :accounts, :company_id
  end
end
