xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    # TODO xml.title @page.title
    # TODO xml.description @page.description
    xml.link rss_url

    @documents.each do |doc|
      xml.item do
        xml.title doc.title
        xml.description doc.description if doc.description.present?
        xml.pubDate doc.published_at.to_s(:rfc822)
        xml.link doc.url
        xml.guid doc.url
        xml.content doc.content
      end
    end
  end
end