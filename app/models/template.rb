class Template < ActiveRecord::Base
  include Cms::Base
  
  define_parent :account
  define_name :name, :uniqueness => { :scope => :account_id }
  define_default :synced_at, lambda { Time.now }
  define_has_many %w{documents pages}, :dependent => :restrict
  define_default :synced_at, lambda { Time.now }
  define_cattr :extensions, %w{.liquid .html}

  has_paper_trail :ignore => :synced_at

  default_scope latest()

  before_destroy do
    if File.exists?(path)
      File.rm_f(path)
      logger.error "#{path} existed"
    end
    
    true
  end
  
  before_save do
    self.synced_at = Time.now if content_changed?
    true
  end

  def path
    File.expand_path(name, account.templates_path)
  end
  
  #--
  # FIXME: Bind with Liquid or import somehow.
  #++
  def as_json(options = {})
    super((options || {}).merge({
      :only => [
        'name',
        'account_id',
        'content'
      ]
    }))
  end
end