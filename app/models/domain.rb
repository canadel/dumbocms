require 'facets/string'

class Domain < ActiveRecord::Base
  include Cms::Base

  define_parent :page
  define_liquid_attributes %w{name}
  define_matching %w{name}
  define_name :name, uniqueness: true
  define_import %w{page_id name wildcard}
  define_strips %w{name}
  define_default :wildcard, true

  validates :page, associated: true
  validates :page_id, numericality: { greater_than: 0 }
  
  default_scope alphabetically()
  
  class << self
    # Import the domain.  If it does exist, updates the attributes.
    def import!(attrs)
      find_or_initialize_by_name(attrs.delete(:name)).tap do |domain|
        domain.attributes = attrs
        domain.save
      end
    end
    
    # Return the stub domain.
    def stub(page, name)
      Domain.new(page: page, page_id: page.id, name: name)
    end
    
    def matching_wildcard(q)
      return nil if q.nil?
      
      ret = matching(q)
      return ret unless ret.nil?
      
      ar = q.split(".")
      return nil if ar.size == 2
      
      ret = matching(ar[1..-1].join("."))
      return nil if ret.nil?
      return nil unless ret.wildcard?
      
      stub(ret.page, q)
    end
  end

  def preferred?
    page.preferred_domain == self
  end
  
  # Return the scheme with the host (e.g. 'http://www.bild.de/').
  def scheme_with_host(domain=nil)
    ['http://', domain || self.name, '/'].join("")
  end

  # Return the URL, depending on the environment.
  def url
    send("url_#{page.env}")
  end
  
  def url_development # FIXME use a Ruby lib
    [ 'http://', page.development_domain, '/', self.name, '/' ].join("")
  end
  
  #--
  # FIXME: Bind with Liquid or import somehow.
  #++
  def as_json(options = {})
    super((options || {}).merge({
      only: [
        'id',
        'name',
        'wildcard',
        'page_id'
      ]
    }))
  end
  
  alias_method :url_production, :scheme_with_host
end
