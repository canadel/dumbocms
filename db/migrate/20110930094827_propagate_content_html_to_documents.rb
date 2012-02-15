class PropagateContentHtmlToDocuments < ActiveRecord::Migration # FIXME shit
  def self.up
    Document.all.each do |doc|
      content = doc.content
      doc.update_attributes(:content => 'foo')
      doc.update_attributes(:content => content)
      doc.reload
      puts doc.content_html
    end
  end

  def self.down
  end
end
