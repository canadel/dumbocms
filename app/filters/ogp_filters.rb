#--
# TODO empty title
# TODO handle hash in liquid
#++
module OgpFilters #:nodoc:
  include CmsFilters
  
  def ogp_title(input=nil)
    f = Cms::Fitler.new(:ogp_title)
    f['input'] = input.is_a?(Hash) ? input['title'].to_s : input.to_s
    f.render!
  end
  
  def ogp_type(input=nil)
    f = Cms::Fitler.new(:ogp_type)
    f['input'] = input.is_a?(Hash) ? input['kind'].to_s : input.to_s
    f.render!
  end
  
  def ogp_url(input=nil)
    f = Cms::Fitler.new(:ogp_url)
    f['input'] = input.is_a?(Hash) ? input['url'].to_s : input.to_s
    f.render!
  end
  
  def ogp_latitude(input=nil)
    f = Cms::Fitler.new(:ogp_latitude)
    f['input'] = input.is_a?(Hash) ? input['latitude'].to_s : input.to_s
    f.render!
  end

  def ogp_longitude(input=nil)
    f = Cms::Fitler.new(:ogp_longitude)
    f['input'] = input.is_a?(Hash) ? input['longitude'].to_s : input.to_s
    f.render!
  end
  
  alias_method :ogp_meta_title, :ogp_title
  alias_method :ogp_meta_type, :ogp_type
  alias_method :ogp_meta_url, :ogp_url
  alias_method :ogp_meta_latitude, :ogp_latitude
  alias_method :ogp_meta_longitude, :ogp_longitude
  
  def ogp_meta_tags(document=nil)
    page = @context.registers['page']
    if page.blank?
      logger.error("page.blank?")
      return nil # Not designer's failure.
    end

    document ||= @context.registers['document'].to_liquid
    if document.blank?
      logger.error("document.blank?")
      return nil # Not designer's failure.
    end

    # Nothing to do if Open Graph is disabled.
    unless page.ogp?
      logger.error("Filter ogp_meta_tags page '#{page.to_s}' with Open Graph disabled") # FIXME style
      return nil # Not designer's failure.
    end
    
    ret = []
    ret << "<meta property=\"og:title\" content=\"#{document['title']}\" />"
    ret << "<meta property=\"og:type\" content=\"#{document['kind']}\" />"
    ret << "<meta property=\"og:url\" content=\"#{document['url']}\" />"
    
    lat, lng = document['latitude'], document['longitude']
    
    if lat.present? && lng.present?
      ret << "<meta property=\"og:latitude\" content=\"#{document['latitude']}\" />" # FIXME style
      ret << "<meta property=\"og:longitude\" content=\"#{document['longitude']}\" />" # FIXME style
    end
      
    ret.join("\n").html_safe
  end
end