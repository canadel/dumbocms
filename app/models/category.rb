class Category < ActiveRecord::Base
  include Cms::Base

  define_parent :page
  define_propagate :permalinks, :documents, :permalink!
  define_external_id on: :page
  define_liquid_attributes %w{
    external_id name slug position parent documents categories
  }, { categories: :subcategories }
  define_matching %w{name slug external_id}
  define_nested
  define_name :name
  define_slug scope: :page, from: :name
  define_import %w{name slug page_id permalinks parent_id}
  define_default :position, 100
  
  has_and_belongs_to_many :documents

  default_scope ordered().alphabetically()
  
  class << self
    # Import the category.  If it does exist, updates the attributes.
    def import!(q)
      find_or_initialize_by_slug(q.delete(:slug)).tap do |category|
        category.attributes = q
        category.save # FIXME necessary?
      end
    end
  end
  
  def primary?(document)
    document.reload.primary_category == self # SQL
  end
  
  alias_method :primary_category?, :primary?
  
  #--
  # FIXME: Bind with Liquid or import somehow.
  #++
  def as_json(options = {})
    super((options || {}).merge({
      only: [
        'id',
        'name',
        'slug',
        'page_id'
      ]
    }))
  end
end
