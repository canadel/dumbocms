module Cms
  module Default
    extend ActiveSupport::Concern
    included do
      @@default_prefix = 'default_'
      cattr_reader :default_prefix
      
      after_initialize do
        return true unless self.new_record?
        
        self.class.columns.each do |col|
          name = col.name
          next unless defined_default?(name)
          next if send("#{name}_changed?")
          
          self.send("#{name}=", default_value(name))
          # write_attribute(name, default_value(name))
        end
        
        true
      end
    end
    
    module InstanceMethods
      protected
        def defined_default?(column)
          respond_to?(self.class.default_method(column))
        end
        
        def default_value(column)
          defined_default?(column) ? send(self.class.default_method(column)) : nil
        end
    end
    
    module ClassMethods
      def define_default(cols, v)
        # return true if self.methods.include?(default_method(col))
        
        cols = [cols] unless cols.is_a?(Array)
        cols = cols.map(&:to_sym)
        cols.each do |col|
          if v.is_a?(Proc)
            define_method(default_method(col), &v)
          else
            define_cattr(default_method(col), v)
          end
        end
        
        true
      end
      
        def default_method(column)
          [ default_prefix, column ].join.to_sym
        end
    end
    
  end
end
