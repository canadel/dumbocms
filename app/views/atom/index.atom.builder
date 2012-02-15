atom_feed do |f|
  f.title(@page.title)
  f.updated(@page.documents.latest.first.published_at)

  @documents.each do |doc|
    f.entry(doc, :url => doc.url) do |en|
      en.title(doc.title)
      en.content(doc.content, :type => 'html')
    end
  end
end