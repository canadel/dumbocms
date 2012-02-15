class PropagateAgainMarkupToDocuments < ActiveRecord::Migration
  def self.up
    Document.update_all(:markup => '')
  end

  def self.down
  end
end
