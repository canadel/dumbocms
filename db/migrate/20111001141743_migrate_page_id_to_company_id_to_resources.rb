class MigratePageIdToCompanyIdToResources < ActiveRecord::Migration
  def self.up
    Resource.class_eval do
      belongs_to :page
    end

    company = Company.first
    
    Account.all.each do |account|
      next unless account.company.nil?
      account.update_attribute(:company_id, company.id)
    end
    
    Resource.all.each do |resource|
      company = resource.page.account.company
      resource.update_attribute(:company_id, company.id)
      puts resource.reload.company.id
    end
  end

  def self.down
  end
end
