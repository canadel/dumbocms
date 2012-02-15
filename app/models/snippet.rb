class Snippet < ActiveRecord::Base
  include Cms::Base
  
  define_parent :page
  define_liquid_attributes %w{slug content}
  define_slug :scope => :page
  define_name :slug
  
  default_scope alphabetically()
end
