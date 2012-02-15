module Cms
  module Selector
    extend ActiveSupport::Concern
    
    module ClassMethods

      def define_enum(kolumn, keys, options={})
        kolumn = kolumn.to_sym
        kolumn_list = kolumn.to_s.pluralize.to_sym
        kolumn_enum = [ kolumn, '_enum' ].join.to_sym
        
        values = keys.map(&:to_s).map(&:humanize)
        
        define_cattr kolumn_list, keys
        define_cattr kolumn_enum, keys # FIXME Hash.zip(keys, values)
        validates kolumn, options.merge(inclusion: { in: keys })

        keys.each do |key|
          kolumn_boolean = [ key, '_', kolumn, '?' ].join.to_sym
          kolumn_scope = [ key.pluralize, '_', kolumn ].join.to_sym

          define_method(kolumn_boolean) { self.send(kolumn) == key }
          scope kolumn_scope, where(kolumn => key)
        end
        
        true
      end
      
      alias_method :define_select, :define_enum
      alias_method :define_selector, :define_enum
    end
  end
end