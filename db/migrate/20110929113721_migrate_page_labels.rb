class MigratePageLabels < ActiveRecord::Migration
  def self.up
    Page.all.each do |page|
      page.update_attributes(:name => page.label)
    end
  end

  def self.down
  end
end