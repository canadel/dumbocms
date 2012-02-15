class Permalink < ActiveRecord::Base
  include Cms::Base

  define_parent :document
  define_cattr :frontpage_path, '/'
  define_default :custom, false
  define_matching %w{path}
  define_name :path
  
  validates :path, length: { maximum: 2047 } # 2048 - 1 FIXME RFC

  # default_scope custom().latest().alphabetically()
  default_scope latest().alphabetically()

  before_save do
    return true if self.path.blank?
    return true if self.path =~ /^\//
    
    # Ensure / suffix in URLs.
    self.path = ['/', self.path].join
    true
  end
  
  delegate :page, to: :document
  delegate :preferred_domain, to: :page
  
  # Return the URL, xor nil if hidden document.
  def url
    return nil if page.hidden?

    [ self.preferred_domain.url, self.path.gsub(/^\//, '') ].join # facets
  end
end
