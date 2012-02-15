require 'active_support/concern'
require 'facets/hash'
require 'facets/string'

require 'cms/association'
require 'cms/attribute'
require 'cms/belongs_to'
require 'cms/cattr'
require 'cms/default'
require 'cms/external_id'
require 'cms/has_many'
require 'cms/geo'
require 'cms/gsub'
require 'cms/import'
require 'cms/liquid_attributes'
require 'cms/matching'
require 'cms/name'
require 'cms/nested'
require 'cms/parent'
require 'cms/propagate'
require 'cms/scopes'
require 'cms/send_many'
require 'cms/selector'
require 'cms/serialize'
require 'cms/slug'
require 'cms/state'
require 'cms/strip'
require 'cms/timezone'
require 'cms/trail'
require 'cms/value'

#--
#
# This is the API I would love to have:
#
# polak do
#   selekt :role, %w{admin customer partner}
#   defolt :role, 'customer'
#   defolt :api_key, -> { SecureRandom.hex(16) }
#   defolt :synced_templates_at, -> { Time.now }
#   nejm :email, uniqueness: true
# end
#++
module Cms
  module Base
    extend ActiveSupport::Concern

    include Cms::Association
    include Cms::Attribute
    include Cms::BelongsTo
    include Cms::Cattr
    include Cms::Default
    include Cms::ExternalId
    include Cms::HasMany
    include Cms::Geo
    include Cms::Gsub
    include Cms::Import
    include Cms::LiquidAttributes
    include Cms::Matching
    include Cms::Name
    include Cms::Nested
    include Cms::Parent
    include Cms::Propagate
    include Cms::Scopes
    include Cms::Selector
    include Cms::Slug
    include Cms::SendMany
    include Cms::Serialize
    include Cms::State
    include Cms::Strip
    include Cms::Timezone
    include Cms::Trail
    include Cms::Value
  end
end