class DestroyAccountsAdmin < ActiveRecord::Migration
  def self.up
    Account.all.each do |account|
      if account.admin?
        account.role = 'admin'
      else
        account.role = 'customer'
      end
    end
    
    remove_column :accounts, :admin
  end

  def self.down
    add_column :accounts, :admin, :boolean
  end
end
