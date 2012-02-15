module Cms
  module Nested
    extend ActiveSupport::Concern
  
    module ClassMethods
      
      def define_nested
        klass = self.table_name.singularize.camelcase
        kids = self.table_name.to_sym
        
        belongs_to :parent, class_name: klass, foreign_key: "parent_id"
        has_many kids, foreign_key: "parent_id"
        
        scope :root, where(parent_id: nil)
      end
    end
  end
end