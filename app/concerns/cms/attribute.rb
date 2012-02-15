module Cms
  module Attribute
    extend ActiveSupport::Concern
  
    module ClassMethods
      
      def define_attribute(name, options={})
        options = options.symbolize_keys
        options.data.inherits
      end
    end
  end
end