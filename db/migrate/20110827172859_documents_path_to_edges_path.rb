class DocumentsPathToEdgesPath < ActiveRecord::Migration
  def self.up
    Document.all.each do |doc|
      doc.edges.create({
        :path => doc.path
      })
    end
  end

  def self.down
  end
end
