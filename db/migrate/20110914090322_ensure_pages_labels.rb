# A somewhat hacky migration that ensures that all pages on the production
# have a label assigned.
class EnsurePagesLabels < ActiveRecord::Migration
  def self.up
    Page.all.each do |page|
      page.update_attribute(:label, page.name)
    end
  end

  def self.down
  end
end
