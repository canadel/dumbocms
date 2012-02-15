# A somewhat hacky migration that adds a default permalinks to all pages
# on the production.
class EnsurePagesPermalinks < ActiveRecord::Migration
  def self.up
    default = Rails.configuration.dumbocms.permalinks
    
    Page.all.each do |page|
      next if page.permalinks.present?
      
      page.update_attribute(:permalinks, default)
      page.reload
      
      raise(NotImplemented) if page.permalinks.blank?
    end
  end

  def self.down
  end
end
