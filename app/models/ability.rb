class Ability
  include CanCan::Ability

  def initialize(account)
    # Reject explicitly.
    return if account.nil?
    
    # Grant the access to RailsAdmin explicitly.
    can :access, :rails_admin
    
    if account.super_user?
      # Super users are able to manage everything.
      can :manage, :all
    else
      case account.role
      when 'owner'
        company_ids = [ account.company.id ] # FIXME
        account_ids = account.company.account_ids
        page_ids = account.company.page_ids
        
        can :manage, Account,
          :company => { :id => company_ids },
          :super_user => false
        
        per_account = [ Page, Template, BulkImport ]
        per_account.each do |klass|
          can :manage, klass, :account => { :id => account_ids }
        end
        
        per_page = [ Document, Domain, Category, Resource ]
        per_page.each do |klass|
          can :manage, klass, :page => { :id => page_ids }
        end
      when 'designer'
        # TODO
      when 'writer'
        # TODO
      end
    end
    
    true
  end
end