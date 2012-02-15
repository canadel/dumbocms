module UrlFilters #:nodoc:
  include CmsFilters
  
  # A link_to filter creates a link (<a href="...>) for the given
  # parameters. The first parameter is the linkname, the second where the
  # link goes. A third parameter "title" is optional but not needed in most
  # cases.
  #
  # Please see http://wiki.shopify.com/Link_to for reference.
  # 
  # ==== Examples
  #   {{ 'Dumbo' | link_to: 'http://dumbocms.com/' }}
  #   # => <a href="http://dumbocms.com/">Dumbo</a>
  #
  #   {{ 'Dumbo' | link_to: 'http://dumbocms.com/', 'DumboCMS' }}
  #   # => <a href="http://dumbocms.com/" title="DumboCMS">Dumbo</a>
  #
  #   <ul>
  #   {% for doc in page.documents %}
  #      <li>{{ doc.title | link_to: doc.url }}</li>
  #   {% endfor %}
  #   </ul>
  def link_to(link, url, title=nil)
    options = ({}).tap do |opts|
      opts[:href] = url.to_s unless url.blank?
      opts[:title] = title.to_s unless title.blank?
    end
    
    tag_options = tag_options(options)
    
     "<a#{tag_options}>#{ERB::Util.html_escape(link || url)}</a>".html_safe
  end
end