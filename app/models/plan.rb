class Plan < ActiveRecord::Base
  include Cms::Base
  include Cms::Geo
  
  define_name :name, :uniqueness => true
  define_default %w{domains_limit pages_limit templates_limit documents_limit}, 1000
  define_default :storage_limit, 1.gigabyte.to_i
  define_default :users_limit, 50
  define_default :trial_length, 10.years.to_i
  define_default :trial_credit_card, false
  define_default :billing_day_of_month, 1
  define_default :billing_price, 50
  define_has_many %w{companies}, :dependent => :restrict

  default_scope alphabetically()
end
