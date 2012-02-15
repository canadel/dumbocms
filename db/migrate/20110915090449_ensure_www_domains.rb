class EnsureWwwDomains < ActiveRecord::Migration
  def self.up
    Domain.all.each do |dm|
      suffixed = "www.#{dm.name}"
      
      next if dm.name =~ /^www\./
      next unless Domain.find_by_name(suffixed).nil?
      
      dm.page.domains.create!(:name => suffixed)
    end
  end

  def self.down
  end
end
