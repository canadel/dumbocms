class EnsureDocumentsPermalinks < ActiveRecord::Migration
  def self.up
    Document.all.each do |doc|
      doc.permalink!
      doc.save!
    end
  end

  def self.down
  end
end
