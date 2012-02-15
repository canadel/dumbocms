class PropagateCompanyIdToAccounts < ActiveRecord::Migration
  def self.up
    cp = Company.create(:name => 'Goldman Sachs', :plan => Plan.first)
    
    Account.update_all ["company_id = ?", cp.id]
  end

  def self.down
  end
end
