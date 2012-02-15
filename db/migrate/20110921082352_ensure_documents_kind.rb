class EnsureDocumentsKind < ActiveRecord::Migration
  def self.up
    Document.all.each do |doc|
      doc.update_attribute(:kind, Document.default_kind)
    end
  end

  def self.down
  end
end
