# {The Sitemap protocol}[http://www.sitemaps.org/protocol.php]
xml.instruct!
xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do
  xml.url do
    xml.loc         @page.url
    xml.lastmod     @page.updated_at # FIXME: last_modified_at
    xml.changefreq  "hourly" # FIXME
  end
  
  #--
  # FIXME it should iterate over published documents, or so
  #++
  @page.documents.each do |doc|
    xml.url do
      xml.loc(doc.url)
      xml.lastmod(
        doc.last_modified_at.utc.strftime("%Y-%m-%dT%H:%M:%S+00:00")
      )
      xml.changefreq("hourly") # FIXME
    end
  end
end