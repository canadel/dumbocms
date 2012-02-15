class Site < ActiveRecord::Base
  has_many :domains
end

class Domain < ActiveRecord::Base
  belongs_to :site
  
  scope :primary, where('primary = ?', true)
end

class UpdateSitesDomainToDomainsPrimary < ActiveRecord::Migration
  def self.up
    Site.all.each do |site|
      site.domains.primary.create({
        :domain_name => site.domain
      })
    end
  end

  def self.down
  end
end
