class Resource < ActiveRecord::Base
  include Cms::Base
  
  define_parent :company
  define_liquid_attributes %w{name slug url}
  define_matching %w{slug name}
  define_name :name
  define_slug :scope => :company, :from => :name
  
  mount_uploader :resource, ResourceUploader

  default_scope latest()

  def url
    case Rails.env.to_sym
    when :test
      "http://c748752.r52.cf2.rackcdn.com/assets/#{name}"
    else
      resource.try(:url) # FIXME delegate-alike
    end
  end
end
