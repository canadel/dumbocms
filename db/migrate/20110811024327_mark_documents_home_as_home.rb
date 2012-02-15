class MarkDocumentsHomeAsHome < ActiveRecord::Migration
  def self.up
    Document.all.each do |doc|
      doc.update_attribute(:home, true) if doc.slug == 'home'
    end
  end

  def self.down
  end
end
