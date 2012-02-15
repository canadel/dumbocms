module Cms
  module Value
    extend ActiveSupport::Concern
    
    included do
      @@value_prefix = 'value_'
      cattr_reader :value_prefix
      
      before_save do
        # return true unless self.new_record?
        
        self.class.columns.each do |col|
          name = col.name
          next unless defined_value?(name)
          write_attribute(col, value_value(name))
        end
        
        true
      end
    end
    
    module InstanceMethods
      protected
        def defined_value?(column)
          respond_to?(self.class.value_method(column))
        end
        
        def value_value(column)
          defined_value?(column) ? send(self.class.value_method(column)) : nil
        end
    end
    
    module ClassMethods
      def define_value(col, v)
        # return true if self.methods.include?(value_method(col))
        
        define_default(col, v)
        validates col, presence: true
        
        if v.is_a?(Proc)
          define_method(value_method(col), v)
        else
          define_cattr(value_method(col), v)
        end
        
        true
      end
      
        def value_method(column)
          [ value_prefix, column ].join.to_sym
        end
    end
    
  end
end