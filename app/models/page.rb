class Page < ActiveRecord::Base
  include Cms::Base
  include Cms::Geo
  
  define_cattr :development_domain, Rails.configuration.dumbocms.hostname
  define_parent %w{account domain template}
  define_propagate :permalinks, :documents, :permalink!
  define_default %w{atom rss sitemap indexable ogp}, true
  define_default :georss, lambda { self.rss }
  define_default :published_at, lambda { Time.now }
  define_value :http_server, Rails.configuration.dumbocms.http_server
  define_value :permalinks, Rails.configuration.dumbocms.permalinks
  define_value :robots_txt, Rails.configuration.dumbocms.robots_txt
  define_external_id :on => :account
  define_name
  define_import %w{
    domain_name template_id permalinks name title description
    default_language sitemap atom rss robots_txt
    google_analytics_tracking_code redirect_to name
  }
  define_liquid_attributes %w{
    external_id description google_analytics_tracking_code name title
    latitude longitude environment url visible_documents domains categories
    frontpage preferred_domain snippets resources
  }, { :visible_documents => :documents }
  define_has_many %w{categories domains documents snippets},
    :extend => Cms::Association::Array
  define_has_many %w{documents_permalinks},
    :through => :documents, :source => :permalinks
  define_timezone :timezone
  define_default :timezone, lambda { self.account.try(:timezone) || 'Europe/Berlin' }
  
  validates :template, :associated => true
  validates :template_id, :presence => true, :numericality => { :greater_than => 0 }
  
  delegate :company, :to => :account
  delegate :resources, :to => :company
  delegate :not_found, :to => :documents, :allow_nil => true
  
  default_scope latest()
  
  def visible_documents # FIXME !!!
    documents.assigned()
  end

  after_save do
    return true if self.domain.nil?
    return true if self.domain.page_id == self.id

    # FIXME: It seems to reveal rather ugly design.
    self.domain.page = self
    self.domain.save
    true
  end
  
  class << self
    def import!(attrs)
      domain_name = attrs.delete(:domain_name)
      domain = Domain.find_by_name(domain_name) # FIXME

      if domain.nil?
        page = Page.new(attrs)
        page.save
        return page unless page.valid? # FIXME

        # Domain does not exist. Create it, and create the site.
        if domain_name.present?
          domain = Domain.create(:name => domain_name, :page => page)
          return domain unless domain.valid? # FIXME
        end

        page.update_attributes(:domain => domain)
        return page
      else
        page = domain.page
        page.update_attributes(attrs)
        
        return page
      end
    end
  end
  
  def production?; Rails.configuration.dumbocms.production == true; end
  def development?; !production?; end
  def environment; production? ? 'production' : 'development'; end

  # Return the preferred domain.  First if none explicitly set.
  def preferred_domain; domain || domains.first; end
  def preferred_domain?; !preferred_domain.nil?; end
  def hidden?; preferred_domain.nil?; end
  
  # Return true if page should not be indexed by robots.
  def noindex?; development? || !indexable? || !published?; end
  
  # FIXME !!! It should not be URL !!! It breaks the Liquid!!!
  def url
    return nil if redirect_to.blank? && hidden?
    return preferred_domain.url if redirect_to.blank?

    redirect_to !~ /^http/ ? "http://#{redirect_to}/" : redirect_to
  end
  
  # Return the frontpage, xor stub if none.
  def frontpage
    documents.frontpage || Document.stub(:page => self, :slug => 'frontpage')
  end

  #--
  # FIXME: Bind with Liquid or import somehow.
  #++
  def as_json(options = {})
    super((options || {}).merge({
      :only => [
        'account_id',
        'name',
        'title',
        'template_id',
        'description',
        'indexable'
      ]
    }))
  end
  
  alias_method :application_template, :template # FIXME
  alias_method :env, :environment
end
