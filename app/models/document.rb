require 'uri'

class Document < ActiveRecord::Base # :nodoc:
  include Cms::Base
  include Cms::Geo
  
  # http://developers.facebook.com/docs/opengraph/#types
  define_cattr :ogp_types, %w{
    activity sport bar company cafe hotel restaurant cause sports_league
    sports_team band government non_profit school university actor athlete
    author director musician politician profile public_figure city country
    landmark state_province album book drink food game movie product song
    tv_show article blog website
  }
  define_cattr :custom_ogp_types, %w{comment}
  define_cattr :frontpage_slug, Rails.configuration.dumbocms.frontpage_slug
  define_cattr :not_found_slug, Rails.configuration.dumbocms.not_found_slug
  define_cattr :custom_slugs, [ frontpage_slug, not_found_slug ]
  define_cattr :hidden_slugs, [ not_found_slug ]
  define_parent :page
  define_default :kind, 'article'
  define_default :published_at, -> { Time.now }
  define_default :language, -> { self.page.try(:default_language) } # FIXME
  define_external_id on: :page
  define_selector :kind, [ custom_ogp_types, ogp_types ].flatten.freeze
  define_slug scope: :page, from: :title
  define_name :title
  define_liquid_attributes %w{
    external_id slug title content_html description url language published_at
    primary_category categories latitude longitude kind
  }, { content_html: :content, primary_category: :category }
  define_belongs_to %w{category permalink template}
  define_belongs_to %w{author}, class_name: 'Account'
  define_has_many %w{permalinks}
  define_enum :markup, ['', 'markdown', 'textile', 'sanitize'].freeze
  define_cattr :default_markup, ''
  define_default :markup, ''
  define_timezone :timezone
  define_default :timezone, -> { self.page.try(:timezone) || 'Europe/Berlin' }
  
  has_and_belongs_to_many :categories
  
  validates :template, associated: true

  scope :assigned, where("slug NOT IN (?)", custom_slugs) # FIXME: ugly
  default_scope alphabetically()
  
  before_save do
    return true if self.category.nil?
    return true if self.categories.include?(self.category)

    # FIXME: It seems to reveal rather ugly design.
    self.categories << self.category
    true
  end
  after_save do
    permalink!
    true
  end
  
  def update_content_html
    case markup
    when ''
      self.content_html = self.content
    when 'textile'
      self.content_html = RedCloth.new(self.content).to_html
    when 'sanitize'
      self.content_html = Sanitize.clean(self.content, Sanitize::Config::RESTRICTED)
    when 'markdown'
      self.content_html = BlueCloth::new(self.content).to_html
    end
  end
  
  before_save do
    self.update_content_html if content_changed?
    true
  end
  
  delegate :hidden?, to: :page
  delegate :path, to: :canonical_permalink, allow_nil: true
  
  class << self
    # Return the frontpage document.
    def frontpage
      where("slug = ?", frontpage_slug).first()
    end
    def frontpage?
      !frontpage.nil?
    end

    # Return the not_found document.
    def not_found
      where("slug = ?", not_found_slug).first()
    end
    def not_found?
      !not_found.nil?
    end
    
    # Return the stub document for the purpose of only-template pages.
    def stub(attributes={})
      page = attributes[:page] # FIXME: do not set, require the required

      Document.new(attributes.reverse_merge({
        slug: '',
        content: '',
        content_html: '',
        language: page.try(:default_language), # FIXME
        title: '',
        description: '',
        created_at: Time.now, # XXX
        updated_at: Time.now, # XXX
        category: nil,
        categories: [],
        published_at: 4.seconds.ago,
        page: page
      }))
    end
  end
  
  def published=(q)
    self.published_at = (q === true ? Time.now : nil)
  end

  # Return the document template, xor the application template.
  def document_template
    template || page.application_template
  end
  
  # Return the canonical permalink, xor the first permalink.
  def canonical_permalink
    permalink || permalinks.first
  end
  def canonical_permalink?(q)
    q == path
  end
  
  # Return the primary category.  First if none explicitly set, xor nil.
  def primary_category
    category || categories.first
  end
  def primary_category?
    !primary_category.nil?
  end

  # Return true if frontpage, xor false.
  def frontpage?
    slug == frontpage_slug
  end
  def not_found?
    slug == not_found_slug
  end
  
  def status
    not_found? ? :not_found : nil
  end

  def url
    #--
    # TODO: #stub?
    #++
    new_record? ? page.try(:url).to_s : canonical_permalink.try(:url).to_s
  end
  
  # http://codex.wordpress.org/Using_Permalinks.
  def permalink! # FIXME :autosave or so
    return true if permalinks.reload.custom.any?
    
    # FIXME
    permalink = (page.permalinks.dup rescue Rails.configuration.dumbocms.permalinks) # FIXME
    if !primary_category.nil? && primary_category.permalinks.present?
      permalink = primary_category.permalinks.dup
    end
    
    permalinks.destroy_all # FIXME manual

    if frontpage?
      permalink = Permalink.frontpage_path
      permalink.gsub!(/\/+/, '/')
      permalinks.create!(path: permalink)
    elsif not_found?
      nil
    elsif ! published?
      nil
    else
      permalink_tags.each {|tag, value|  permalink.gsub!(tag, value || '') }
      permalink.gsub!(/\/+/, '/')
      
      #--
      # FIXME
      #   1) Error:
      # test_should_create(DocumentTest):
      # ActiveRecord::RecordInvalid: Validation failed: Document is invalid
      #     app/models/document.rb:156:in `permalink!'
      #     app/models/document.rb:51:in `_callback_after_395'
      #++
      permalinks.create!(path: permalink)
    end

    true
  end
  
  def path=(q)
    return true if q.blank?
    
    self.permalinks.destroy_all
    self.permalinks << self.permalinks.custom.build.tap do |cp|
      cp.custom = true # TODO: necessary?
      cp.path = URI.parse(q).path
    end
    
    save(validate: false)
    true
  end
  
  # Render the rendered document and the content type, then return it. Note
  # that it does not rely on caching.
  def render(params={}) # FIXME: rescue
    ([]).tap do |rt|
      tp = document_template.content
      ev = Liquid::Template.parse(tp).render(self.assigns, { registers: self.registers })
      rw = page.account.rewriters.any? ? page.account.rewriters.rewrite!(ev) : ev

      rt << rw
      rt << 'text/html'
    end
  end

  # Return the variables assigned to a Liquid template.
  def assigns # FIXME: Public only because of tests.
    # TODO: registers.map(&:to_liquid)
    { 'document' => self.to_liquid, 'page' => self.page.to_liquid }
  end
  
  def last_modified_at
    updated_at
  end
  
  def as_json(options = {})
    super((options || {}).merge({
      only: [
        'id',
        'title',
        'content',
        'page_id',
        'slug',
        'language',
        'published_at',
        'template_id',
        'description',
        'kind',
        'markup',
        'timezone'
      ]
    }))
  end  
  
  alias_method :canonical?, :canonical_permalink?
  alias_method :render_fresh, :render

  if table_exists?
    alias_method :publish?, :published?
    alias_method :publish=, :published=
  end

  protected
    # Return the registers assigned to a Liquid template.
    def registers
      { 'document' => self, 'page' => self.page }
    end
  
    # Return permalink tags.  http://codex.wordpress.org/Using_Permalinks
    def permalink_tags
      {
        '%year%' => self.published_at.year.to_s,
        '%month%' => self.published_at.strftime("%m").to_s,
        '%day%' => self.published_at.strftime('%d').to_s,
        '%second%' => self.published_at.strftime('%S').to_s,
        '%id%' => self.external_id.to_s,
        '%slug%' => self.slug.to_s,
        '%language%' => self.language.to_s,
        '%category%' => self.primary_category.try(:slug).to_s,
        '%categories%' => self.categories.map(&:slug).join("/").to_s # FIXME
      }
    end
end
