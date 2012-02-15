class MigrateDomainTitles < ActiveRecord::Migration # TODO rename
  def self.up
    Document.all.each do |doc|
      doc.update_attributes(:title => doc.slug)
    end
  end

  def self.down
  end
end
