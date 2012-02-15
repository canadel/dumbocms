class Company < ActiveRecord::Base
  include Cms::Base
  
  define_name :name, uniqueness: true
  define_parent :plan
  define_has_many %w{accounts}, dependent: :restrict
  define_has_many %w{resources}, dependent: :destroy
  define_has_many %w{templates pages}, through: :accounts
  define_timezone :timezone
  define_default :timezone, 'Europe/Berlin'
  
  default_scope alphabetically()
end
