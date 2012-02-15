class AddTimezoneToCompanies < ActiveRecord::Migration
  def self.up
    add_column :companies, :timezone, :string
  end

  def self.down
    remove_column :companies, :timezone
  end
end
