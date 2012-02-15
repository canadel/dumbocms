module ResourceFilters #:nodoc:
  include CmsFilters
  
  # Returns the url for a resource.
  #
  # Please see http://wiki.shopify.com/Asset_url for reference.
  # 
  # ==== Examples
  #   {{ 'shop.css' | asset_url }}
  #   # => 'http://c748753.r53.cf2.rackcdn.com/assets/shop.css'
  def resource_url(input)
    page = @context.registers['page']

    return nil if input.blank?
    return nil if page.blank? # logger.error
    
    resource = page.account.company.resources.matching(input)
    resource.nil? ? nil.to_s : resource.url
  end
  alias_method :asset_url, :resource_url
end