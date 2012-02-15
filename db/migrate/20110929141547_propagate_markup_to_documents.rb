class PropagateMarkupToDocuments < ActiveRecord::Migration
  def self.up
    Document.all.each do |doc|
      doc.update_attributes(:markup => Document.default_markup)
      puts doc.markup
    end
  end

  def self.down
  end
end
