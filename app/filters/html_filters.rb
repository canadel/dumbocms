module HtmlFilters #:nodoc:
  include CmsFilters

  # http://wiki.shopify.com/Img_tag
  def img_tag(url, alt=nil)
    options = ({}).tap do |opts|
      opts[:alt] = alt.to_s unless alt.blank?
      opts[:src] = url.to_s unless url.blank?
    end
    
    tag('img', options)
  end

  # http://wiki.shopify.com/Script_tag
  #--
  # TODO: copy from Rails
  #++
  def script_tag(url)
    "<script src=\"#{url.to_s}\" type=\"text/javascript\"></script>".html_safe # FIXME style
  end
  # alias_method :javascript_include_tag, :script_tag # TODO: add more params
  
  # http://wiki.shopify.com/Stylesheet_tag
  def stylesheet_tag(url)
    options = ({}).tap do |opts|
      opts[:href] = url.to_s unless url.blank?
      opts[:rel] = 'stylesheet'
      opts[:type] = 'text/css'
      opts[:media] = 'all'
    end
    
    tag('link', options)
  end
  # alias_method :stylesheet_link_tag, :stylesheet_tag # TODO: add more params
end